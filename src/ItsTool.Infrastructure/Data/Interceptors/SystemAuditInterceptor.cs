using ItsTool.Domain.Common;
using ItsTool.Domain.Entities;
using ItsTool.Domain.Entities.Config;
using ItsTool.Domain.Entities.Auth;
using ItsTool.Domain.Entities.KnowledgeBase;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Domain.Entities.SLA;
using ItsTool.Domain.Entities.Project;
using ItsTool.Domain.Entities.Ticket;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using System.Security.Claims;

namespace ItsTool.Infrastructure.Data.Interceptors;

public class SystemAuditInterceptor : SaveChangesInterceptor
{
    private readonly IHttpContextAccessor _httpContextAccessor;
    private bool _isSavingAuditLogs = false;
    private readonly List<(SystemAuditLog Log, BaseEntity Entity)> _pendingAddedLogs = new();

    public SystemAuditInterceptor(IHttpContextAccessor httpContextAccessor)
    {
        _httpContextAccessor = httpContextAccessor;
    }

    public override InterceptionResult<int> SavingChanges(DbContextEventData eventData, InterceptionResult<int> result)
    {
        if (!_isSavingAuditLogs)
        {
            GenerateAuditLogs(eventData.Context);
        }
        return base.SavingChanges(eventData, result);
    }

    public override ValueTask<InterceptionResult<int>> SavingChangesAsync(DbContextEventData eventData, InterceptionResult<int> result, CancellationToken cancellationToken = default)
    {
        if (!_isSavingAuditLogs)
        {
            GenerateAuditLogs(eventData.Context);
        }
        return base.SavingChangesAsync(eventData, result, cancellationToken);
    }

    public override int SavedChanges(SaveChangesCompletedEventData eventData, int result)
    {
        if (!_isSavingAuditLogs && _pendingAddedLogs.Count > 0 && eventData.Context != null)
        {
            try
            {
                _isSavingAuditLogs = true;
                foreach (var (log, entity) in _pendingAddedLogs)
                {
                    log.EntityId = entity.Id.ToString();
                    eventData.Context.Set<SystemAuditLog>().Add(log);
                }
                eventData.Context.SaveChanges();
            }
            finally
            {
                _pendingAddedLogs.Clear();
                _isSavingAuditLogs = false;
            }
        }
        return base.SavedChanges(eventData, result);
    }

    public override async ValueTask<int> SavedChangesAsync(SaveChangesCompletedEventData eventData, int result, CancellationToken cancellationToken = default)
    {
        if (!_isSavingAuditLogs && _pendingAddedLogs.Count > 0 && eventData.Context != null)
        {
            try
            {
                _isSavingAuditLogs = true;
                foreach (var (log, entity) in _pendingAddedLogs)
                {
                    log.EntityId = entity.Id.ToString();
                    eventData.Context.Set<SystemAuditLog>().Add(log);
                }
                await eventData.Context.SaveChangesAsync(cancellationToken);
            }
            finally
            {
                _pendingAddedLogs.Clear();
                _isSavingAuditLogs = false;
            }
        }
        return await base.SavedChangesAsync(eventData, result, cancellationToken);
    }

    internal static bool ShouldSkipAudit(object entity)
    {
        if (entity is SystemAuditLog) return true;
        var name = entity.GetType().Name;

        if (name == "Ticket" ||
            name == "TicketSla" ||
            name == "ProjectSequence" ||
            name == "RolePermission" ||
            name == "UserRole" ||
            name == "GroupRole" ||
            name == "WorkflowTransition" ||
            name == "BusinessHour" ||
            name == "FormFieldPlacement" ||
            name == "SlaTarget" ||
            name == "TicketFieldValue" ||
            name == "TicketAttachment" ||
            name == "TicketWatcher" ||
            name == "TicketAssignment" ||
            name == "RefreshToken")
        {
            return true;
        }

        return name.Contains("History") || name.Contains("Comment") || name.Contains("Notification") || name.Contains("Preference");
    }

    internal static bool TryProcessSoftDeleteOrRestore(
        Microsoft.EntityFrameworkCore.ChangeTracking.EntityEntry<BaseEntity> entry,
        List<SystemAuditLog> logs,
        List<Microsoft.EntityFrameworkCore.ChangeTracking.PropertyEntry> modifiedProperties,
        AuditEntityContext ctx)
    {
        var isDeletedProp = modifiedProperties.FirstOrDefault(p => p.Metadata.Name == "IsDeleted");
        if (isDeletedProp == null) return false;

        var isNowDeleted = entry.Entity.IsDeleted;
        var wasDeleted = (bool)(isDeletedProp.OriginalValue ?? false);
        var fieldLabel = ctx.EntityType == "SlaPolicy" ? "SLA Politikası" : "Kayıt Durumu";

        if (isNowDeleted && !wasDeleted)
        {
            var summary = GetEntitySummary(entry, ctx.Context);
            logs.Add(SystemAuditInterceptor.CreateAuditLog(new AuditLogEntry(
                ctx.EntityType, ctx.EntityName, ctx.EntityId, "Deleted", fieldLabel, summary, "Silindi (Soft Deleted)", ctx.UserId, ctx.Now)));
            return true;
        }

        if (!isNowDeleted && wasDeleted)
        {
            var summary = GetEntitySummary(entry, ctx.Context);
            logs.Add(SystemAuditInterceptor.CreateAuditLog(new AuditLogEntry(
                ctx.EntityType, ctx.EntityName, ctx.EntityId, "Restored", fieldLabel, "Silindi (Soft Deleted)", $"Aktif / Geri Alındı ({summary})", ctx.UserId, ctx.Now)));
            return true;
        }

        return false;
    }

    internal static void ProcessModifiedEntity(Microsoft.EntityFrameworkCore.ChangeTracking.EntityEntry<BaseEntity> entry, List<SystemAuditLog> logs, AuditEntityContext ctx)
    {
        var modifiedProperties = entry.Properties.Where(p => p.IsModified).ToList();
        if (TryProcessSoftDeleteOrRestore(entry, logs, modifiedProperties, ctx))
        {
            return;
        }

        foreach (var prop in modifiedProperties)
        {
            string propName = prop.Metadata.Name;
            if (propName == "UpdatedAt" || propName == "CreatedAt" || propName == "DeletedAt") continue;
            if (propName == "PasswordHash" || propName == "SecurityStamp" || propName == "ConcurrencyStamp" || propName == "ViewCount") continue;

            var original = prop.OriginalValue?.ToString();
            var current = prop.CurrentValue?.ToString();

            if (original != current)
            {
                logs.Add(SystemAuditInterceptor.CreateAuditLog(new AuditLogEntry(ctx.EntityType, ctx.EntityName, ctx.EntityId, "Updated", propName, original ?? "none", current ?? "none", ctx.UserId, ctx.Now)));
            }
        }
    }

    public sealed record AuditEntityContext(DbContext? Context, string EntityType, string EntityName, string EntityId, string UserId, DateTime Now);
    public sealed record AuditLogEntry(string EntityType, string EntityName, string EntityId, string Action, string? FieldName, string? OldValue, string? NewValue, string UserId, DateTime Now);

    private static SystemAuditLog CreateAuditLog(AuditLogEntry entry)
    {
        return new SystemAuditLog
        {
            EntityType = entry.EntityType,
            EntityName = entry.EntityName,
            EntityId = entry.EntityId,
            Action = entry.Action,
            FieldName = entry.FieldName,
            OldValue = entry.OldValue,
            NewValue = entry.NewValue,
            CreatedBy = entry.UserId,
            CreatedAt = entry.Now
        };
    }

    private void GenerateAuditLogs(DbContext? context)
    {
        if (context == null) return;

        var userId = _httpContextAccessor.HttpContext?.User?.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "system";
        var now = DateTime.UtcNow;

        var entries = context.ChangeTracker.Entries<BaseEntity>()
            .Where(e => e.State == EntityState.Modified || e.State == EntityState.Added || e.State == EntityState.Deleted)
            .ToList();

        var logsToAdd = new List<SystemAuditLog>();

        _pendingAddedLogs.Clear();
        foreach (var entry in entries)
        {
            if (SystemAuditInterceptor.ShouldSkipAudit(entry.Entity)) continue;
            ProcessEntry(entry, context, userId, now, logsToAdd);
        }
        if (logsToAdd.Count > 0)
        {
            context.Set<SystemAuditLog>().AddRange(logsToAdd);
        }
    }

    private void ProcessEntry(Microsoft.EntityFrameworkCore.ChangeTracking.EntityEntry<BaseEntity> entry, DbContext context, string userId, DateTime now, List<SystemAuditLog> logsToAdd)
    {
        var entityType = entry.Entity.GetType().Name;
        var entityName = SystemAuditInterceptor.GetEntityName(entry, context);
        var entityId = entry.Entity.Id.ToString();
        var isGroupMember = entityType == "GroupMember";

        if (entry.State == EntityState.Added)
        {
            var summary = GetEntitySummary(entry, context);
            var log = CreateAuditLog(new AuditLogEntry(
                entityType, 
                entityName, 
                "0", 
                "Created", 
                "Yeni Kayıt", 
                "-", 
                summary, 
                userId, 
                now));
            _pendingAddedLogs.Add((log, entry.Entity));
        }
        else if (entry.State == EntityState.Deleted)
        {
            var summary = GetEntitySummary(entry, context);
            var fieldLabel = entityType == "SlaPolicy" ? "SLA Politikası" : "Kayıt Durumu";
            logsToAdd.Add(SystemAuditInterceptor.CreateAuditLog(new AuditLogEntry(
                entityType, 
                entityName, 
                entityId, 
                "Deleted", 
                fieldLabel, 
                isGroupMember ? entityName : summary, 
                "Kalıcı Silindi", 
                userId, 
                now)));
        }
        else if (entry.State == EntityState.Modified)
        {
            SystemAuditInterceptor.ProcessModifiedEntity(entry, logsToAdd, new AuditEntityContext(context, entityType, entityName, entityId, userId, now));
        }
    }

    internal static string GetEntitySummary(Microsoft.EntityFrameworkCore.ChangeTracking.EntityEntry entry, DbContext? context)
    {
        try
        {
            if (entry.Entity.GetType().Name == "GroupMember")
            {
                return GetGroupMemberName(entry, context);
            }

            return GetSpecificEntitySummary(entry.Entity, context) ?? GetGeneralPropertiesSummary(entry);
        }
        catch
        {
            return entry.Entity.GetType().Name;
        }
    }

    internal static string? GetSpecificEntitySummary(object entity, DbContext? context)
    {
        return entity switch
        {
            SlaPolicy sla => GetSlaSummary(sla, context),
            User u => GetUserSummary(u),
            Project p => GetProjectSummary(p),
            Category c => $"Kategori: {c.Name}" + (string.IsNullOrWhiteSpace(c.Description) ? "" : $" | Açıklama: {c.Description}"),
            Department d => $"Departman: {d.Name}" + (string.IsNullOrWhiteSpace(d.Description) ? "" : $" | Açıklama: {d.Description}") + (d.ManagerUserId.HasValue ? $" | Yönetici ID: {d.ManagerUserId}" : ""),
            Group g => $"Grup: {g.Name}" + (g.DepartmentId.HasValue ? $" | Departman ID: {g.DepartmentId}" : ""),
            Role r => $"Rol: {r.Name}" + (string.IsNullOrWhiteSpace(r.Description) ? "" : $" | Açıklama: {r.Description}"),
            KnowledgeArticle ka => $"Makale: {ka.Title} | Kategori #{ka.CategoryId} | Durum: {ka.Status}",
            AssignmentRule ar => $"Atama Kuralı: {ar.Name} | Sıra: {ar.SortOrder}",
            WebhookSubscription ws => $"Webhook: {ws.Url} | Olaylar: {ws.EventsCsv}",
            _ => null
        };
    }

    internal static string GetUserSummary(User u)
    {
        var fullName = $"{u.FirstName} {u.LastName}".Trim();
        var displayName = string.IsNullOrWhiteSpace(fullName) ? u.Username : fullName;
        var dept = u.DepartmentId.HasValue ? u.DepartmentId.Value.ToString() : "Yok";
        return $"Kullanıcı: {displayName} (@{u.Username}, {u.Email}) | Departman ID: {dept}";
    }

    internal static string GetProjectSummary(Project p)
    {
        var desc = string.IsNullOrWhiteSpace(p.Description) ? "" : $" | Açıklama: {p.Description}";
        return $"Proje: {p.Name} (Anahtar: {p.ProjectKey}) | Durum: {p.Status}{desc}";
    }

    internal static string GetSlaSummary(SlaPolicy sla, DbContext? context)
    {
        string projectName = "Genel Sistem";
        if (sla.ProjectId.HasValue && context != null)
        {
            var proj = context.Set<Project>().Local.FirstOrDefault(p => p.Id == sla.ProjectId.Value)
                       ?? context.Set<Project>().FirstOrDefault(p => p.Id == sla.ProjectId.Value);
            projectName = proj != null ? proj.Name : $"Proje #{sla.ProjectId.Value}";
        }

        string targetsSummary = "";
        if (context != null)
        {
            var targets = context.Set<SlaTarget>()
                .Where(t => t.SlaPolicyId == sla.Id)
                .ToList();
            if (targets.Count > 0)
            {
                var priorities = context.Set<Priority>().ToList();
                var targetDescriptions = targets.Select(t =>
                {
                    var prioName = priorities.FirstOrDefault(pr => pr.Id == t.PriorityId)?.Name ?? $"Öncelik {t.PriorityId}";
                    return $"{prioName}: Yanıt {t.FirstResponseMinutes}dk / Çözüm {t.ResolutionMinutes}dk";
                });
                targetsSummary = " | Hedefler: [" + string.Join(", ", targetDescriptions) + "]";
            }
        }

        var desc = string.IsNullOrWhiteSpace(sla.Description) ? "" : $" | Açıklama: {sla.Description}";
        var esc = sla.EscalateOnBreach ? " | Eskalasyon: Açık" : " | Eskalasyon: Kapalı";
        return $"Politika: {sla.Name} | Kapsam: {projectName}{esc}{desc}{targetsSummary}";
    }

    internal static string GetGeneralPropertiesSummary(Microsoft.EntityFrameworkCore.ChangeTracking.EntityEntry entry)
    {
        var props = entry.Properties
            .Where(p => p.Metadata.Name != "Id" && 
                        p.Metadata.Name != "CreatedAt" && 
                        p.Metadata.Name != "UpdatedAt" && 
                        p.Metadata.Name != "DeletedAt" && 
                        p.Metadata.Name != "IsDeleted" && 
                        p.Metadata.Name != "PasswordHash" &&
                        p.Metadata.Name != "SecurityStamp" &&
                        p.Metadata.Name != "ConcurrencyStamp" &&
                        p.Metadata.Name != "Secret")
            .Select(p => $"{p.Metadata.Name}: {p.OriginalValue ?? p.CurrentValue}")
            .Where(s => !s.EndsWith(": ") && !s.EndsWith(": null"))
            .Take(6);
        
        var joined = string.Join(" | ", props);
        return string.IsNullOrWhiteSpace(joined) ? entry.Entity.GetType().Name : joined;
    }

    internal static string GetEntityName(Microsoft.EntityFrameworkCore.ChangeTracking.EntityEntry entry, DbContext? context)
    {
        if (entry.Entity.GetType().Name.Contains("GroupMember"))
            return SystemAuditInterceptor.GetGroupMemberName(entry, context);

        var nameProp = entry.Properties.FirstOrDefault(p => p.Metadata.Name == "Name" || p.Metadata.Name == "Title" || p.Metadata.Name == "Username" || p.Metadata.Name == "Url");
        if (nameProp != null && nameProp.CurrentValue != null)
        {
            return nameProp.CurrentValue.ToString()!;
        }
        return entry.Entity.GetType().Name;
    }

    internal static string GetGroupMemberName(Microsoft.EntityFrameworkCore.ChangeTracking.EntityEntry entry, DbContext? context)
    {
        try 
        {
            var uidProp = entry.Property("UserId");
            var gidProp = entry.Property("GroupId");
            var uid = (entry.State == Microsoft.EntityFrameworkCore.EntityState.Added ? uidProp.CurrentValue : uidProp.OriginalValue)?.ToString();
            var gid = (entry.State == Microsoft.EntityFrameworkCore.EntityState.Added ? gidProp.CurrentValue : gidProp.OriginalValue)?.ToString();

            string uName = uid ?? "?";
            string gName = gid ?? "?";

            if (context != null && uid != null && int.TryParse(uid, out int userId))
            {
                var u = context.Set<User>().Local.FirstOrDefault(x => x.Id == userId) ?? context.Set<User>().FirstOrDefault(x => x.Id == userId);
                if (u != null) uName = u.Username ?? uName;
            }
            if (context != null && gid != null && int.TryParse(gid, out int groupId))
            {
                var g = context.Set<Group>().Local.FirstOrDefault(x => x.Id == groupId) ?? context.Set<Group>().FirstOrDefault(x => x.Id == groupId);
                if (g != null) gName = g.Name ?? gName;
            }
            return $"User: {uName} -> Group: {gName}";
        }
        catch (Exception ex)
        {
            return $"GroupMember (Err: {ex.Message})";
        }
    }
}
