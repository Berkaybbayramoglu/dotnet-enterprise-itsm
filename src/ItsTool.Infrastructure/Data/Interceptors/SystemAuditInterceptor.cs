using ItsTool.Domain.Common;
using ItsTool.Domain.Entities;
using ItsTool.Domain.Entities.Config;
using ItsTool.Domain.Entities.Organization;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using System.Security.Claims;

namespace ItsTool.Infrastructure.Data.Interceptors;

public class SystemAuditInterceptor : SaveChangesInterceptor
{
    private readonly IHttpContextAccessor _httpContextAccessor;

    public SystemAuditInterceptor(IHttpContextAccessor httpContextAccessor)
    {
        _httpContextAccessor = httpContextAccessor;
    }

    public override InterceptionResult<int> SavingChanges(DbContextEventData eventData, InterceptionResult<int> result)
    {
        GenerateAuditLogs(eventData.Context);
        return base.SavingChanges(eventData, result);
    }

    public override ValueTask<InterceptionResult<int>> SavingChangesAsync(DbContextEventData eventData, InterceptionResult<int> result, CancellationToken cancellationToken = default)
    {
        GenerateAuditLogs(eventData.Context);
        return base.SavingChangesAsync(eventData, result, cancellationToken);
    }

    private static bool ShouldSkipAudit(object entity)
    {
        if (entity is SystemAuditLog) return true;
        var name = entity.GetType().Name;
        return name.Contains("History") || name.Contains("Comment") || name.Contains("Notification");
    }

    private void ProcessModifiedEntity(Microsoft.EntityFrameworkCore.ChangeTracking.EntityEntry<BaseEntity> entry, List<SystemAuditLog> logs, string entityType, string entityName, string entityId, string userId, DateTime now)
    {
        var modifiedProperties = entry.Properties.Where(p => p.IsModified).ToList();
        if (modifiedProperties.Any(p => p.Metadata.Name == "IsDeleted") && entry.Entity.IsDeleted)
        {
            logs.Add(SystemAuditInterceptor.CreateAuditLog(new AuditLogEntry(entityType, entityName, entityId, "Deleted", null, null, null, userId, now)));
            return;
        }

        foreach (var prop in modifiedProperties)
        {
            string propName = prop.Metadata.Name;
            if (propName == "UpdatedAt" || propName == "CreatedAt" || propName == "DeletedAt") continue;

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
            logsToAdd.Add(SystemAuditInterceptor.CreateAuditLog(new AuditLogEntry(entityType, entityName, entityId, "Created", null, null, isGroupMember ? entityName : null, userId, now)));
        else if (entry.State == EntityState.Deleted)
            logsToAdd.Add(SystemAuditInterceptor.CreateAuditLog(new AuditLogEntry(entityType, entityName, entityId, "Deleted", null, isGroupMember ? entityName : null, null, userId, now)));
        else if (entry.State == EntityState.Modified)
            ProcessModifiedEntity(entry, logsToAdd, entityType, entityName, entityId, userId, now);
    }

    private static string GetEntityName(Microsoft.EntityFrameworkCore.ChangeTracking.EntityEntry entry, DbContext? context)
    {
        if (entry.Entity.GetType().Name.Contains("GroupMember"))
            return SystemAuditInterceptor.GetGroupMemberName(entry, context);

        var nameProp = entry.Properties.FirstOrDefault(p => p.Metadata.Name == "Name" || p.Metadata.Name == "Title" || p.Metadata.Name == "Username");
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
