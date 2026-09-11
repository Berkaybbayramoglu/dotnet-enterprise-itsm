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

    private static bool ShouldSkipAudit(object entity)
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

    private static void ProcessModifiedEntity(Microsoft.EntityFrameworkCore.ChangeTracking.EntityEntry<BaseEntity> entry, DbContext? context, List<SystemAuditLog> logs, string entityType, string entityName, string entityId, string userId, DateTime now)
    {
        var modifiedProperties = entry.Properties.Where(p => p.IsModified).ToList();
        var isDeletedProp = modifiedProperties.FirstOrDefault(p => p.Metadata.Name == "IsDeleted");
        if (isDeletedProp != null)
        {
            var isNowDeleted = entry.Entity.IsDeleted;
            var wasDeleted = (bool)(isDeletedProp.OriginalValue ?? false);

            if (isNowDeleted && !wasDeleted)
            {
                // Soft Deleted
                var summary = GetEntitySummary(entry, context);
                var fieldLabel = entityType == "SlaPolicy" ? "SLA Politikası" : "Kayıt Durumu";
                logs.Add(SystemAuditInterceptor.CreateAuditLog(new AuditLogEntry(
                    entityType, 
                    entityName, 
                    entityId, 
                    "Deleted", 
                    fieldLabel, 
                    summary, 
                    "Silindi (Soft Deleted)", 
                    userId, 
                    now)));
                return;
            }
            else if (!isNowDeleted && wasDeleted)
            {
                // Restored (Undo)
                var summary = GetEntitySummary(entry, context);
                var fieldLabel = entityType == "SlaPolicy" ? "SLA Politikası" : "Kayıt Durumu";
                logs.Add(SystemAuditInterceptor.CreateAuditLog(new AuditLogEntry(
                    entityType, 
                    entityName, 
                    entityId, 
                    "Restored", 
                    fieldLabel, 
                    "Silindi (Soft Deleted)", 
                    $"Aktif / Geri Alındı ({summary})", 
                    userId, 
                    now)));
                return;
            }
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
                logs.Add(SystemAuditInterceptor.CreateAuditLog(new AuditLogEntry(entityType, entityName, entityId, "Updated", propName, original ?? "none", current ?? "none", userId, now)));
            }
        }
    }

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
            SystemAuditInterceptor.ProcessModifiedEntity(entry, context, logsToAdd, entityType, entityName, entityId, userId, now);
        }
    }

    private static string GetEntitySummary(Microsoft.EntityFrameworkCore.ChangeTracking.EntityEntry entry, DbContext? context)
    {
        try
        {
            if (entry.Entity is SlaPolicy sla)
            {
                string projectName = "Genel Sistem";
                if (sla.ProjectId.HasValue && context != null)
                {
                    var proj = context.Set<Project>().Local.FirstOrDefault(p => p.Id == sla.ProjectId.Value)
                               ?? context.Set<Project>().FirstOrDefault(p => p.Id == sla.ProjectId.Value);
                    if (proj != null) projectName = proj.Name;
                    else projectName = $"Proje #{sla.ProjectId.Value}";
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

            if (entry.Entity is User u)
            {
                var fullName = string.IsNullOrWhiteSpace($"{u.FirstName} {u.LastName}".Trim()) ? u.Username : $"{u.FirstName} {u.LastName}".Trim();
                return $"Kullanıcı: {fullName} (@{u.Username}, {u.Email}) | Departman ID: {(u.DepartmentId.HasValue ? u.DepartmentId.Value.ToString() : "Yok")}";
            }

            if (entry.Entity is Project p)
            {
                return $"Proje: {p.Name} (Anahtar: {p.ProjectKey}) | Durum: {p.Status}{(string.IsNullOrWhiteSpace(p.Description) ? "" : $" | Açıklama: {p.Description}")}";
            }

            if (entry.Entity is Category c)
            {
                return $"Kategori: {c.Name}{(string.IsNullOrWhiteSpace(c.Description) ? "" : $" | Açıklama: {c.Description}")}";
            }

            if (entry.Entity is Department d)
            {
                return $"Departman: {d.Name}{(string.IsNullOrWhiteSpace(d.Description) ? "" : $" | Açıklama: {d.Description}")}{(d.ManagerUserId.HasValue ? $" | Yönetici ID: {d.ManagerUserId}" : "")}";
            }

            if (entry.Entity is Group g)
            {
                return $"Grup: {g.Name}{(g.DepartmentId.HasValue ? $" | Departman ID: {g.DepartmentId}" : "")}";
            }

            if (entry.Entity is Role r)
            {
                return $"Rol: {r.Name}{(string.IsNullOrWhiteSpace(r.Description) ? "" : $" | Açıklama: {r.Description}")}";
            }

            if (entry.Entity is KnowledgeArticle ka)
            {
                return $"Makale: {ka.Title} | Kategori #{ka.CategoryId} | Durum: {ka.Status}";
            }

            if (entry.Entity is AssignmentRule ar)
            {
                return $"Atama Kuralı: {ar.Name} | Sıra: {ar.SortOrder}";
            }

            if (entry.Entity is WebhookSubscription ws)
            {
                return $"Webhook: {ws.Url} | Olaylar: {ws.EventsCsv}";
            }

            if (entry.Entity.GetType().Name == "GroupMember")
            {
                return GetGroupMemberName(entry, context);
            }

            // General entity summary
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
        catch
        {
            return entry.Entity.GetType().Name;
        }
    }

    private static string GetEntityName(Microsoft.EntityFrameworkCore.ChangeTracking.EntityEntry entry, DbContext? context)
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

    private static string GetGroupMemberName(Microsoft.EntityFrameworkCore.ChangeTracking.EntityEntry entry, DbContext? context)
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
