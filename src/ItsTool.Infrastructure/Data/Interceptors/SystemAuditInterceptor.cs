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
            // Skip auditing the audit log itself or history logs to prevent recursion/noise
            if (entry.Entity is SystemAuditLog || entry.Entity.GetType().Name.Contains("History") || entry.Entity.GetType().Name.Contains("Comment")) 
                continue;

            var entityType = entry.Entity.GetType().Name;
            var entityName = GetEntityName(entry, context);
            var entityId = entry.Entity.Id.ToString();

            if (entry.State == EntityState.Added)
            {
                logsToAdd.Add(new SystemAuditLog
                {
                    EntityType = entityType,
                    EntityName = entityName,
                    EntityId = entityId,
                    Action = "Created",
                    NewValue = entityType == "GroupMember" ? entityName : null,
                    CreatedBy = userId,
                    CreatedAt = now
                });
            }
            else if (entry.State == EntityState.Deleted)
            {
                logsToAdd.Add(new SystemAuditLog
                {
                    EntityType = entityType,
                    EntityName = entityName,
                    EntityId = entityId,
                    Action = "Deleted",
                    OldValue = entityType == "GroupMember" ? entityName : null,
                    CreatedBy = userId,
                    CreatedAt = now
                });
            }
            else if (entry.State == EntityState.Modified)
            {
                // Detailed property tracking for Modified
                var modifiedProperties = entry.Properties.Where(p => p.IsModified).ToList();

                // If it's a soft delete, log it as Deleted
                if (modifiedProperties.Any(p => p.Metadata.Name == "IsDeleted") && entry.Entity.IsDeleted)
                {
                    logsToAdd.Add(new SystemAuditLog
                    {
                        EntityType = entityType,
                        EntityName = entityName,
                        EntityId = entityId,
                        Action = "Deleted",
                        CreatedBy = userId,
                        CreatedAt = now
                    });
                    continue;
                }

                foreach (var prop in modifiedProperties)
                {
                    string propName = prop.Metadata.Name;
                    if (propName == "UpdatedAt" || propName == "CreatedAt" || propName == "DeletedAt") 
                        continue;

                    var original = prop.OriginalValue?.ToString();
                    var current = prop.CurrentValue?.ToString();

                    if (original != current)
                    {
                        logsToAdd.Add(new SystemAuditLog
                        {
                            EntityType = entityType,
                            EntityName = entityName,
                            EntityId = entityId,
                            Action = "Updated",
                            FieldName = propName,
                            OldValue = original ?? "none",
                            NewValue = current ?? "none",
                            CreatedBy = userId,
                            CreatedAt = now
                        });
                    }
                }
            }
        }

        if (logsToAdd.Any())
        {
            context.Set<SystemAuditLog>().AddRange(logsToAdd);
        }
    }

    private string GetEntityName(Microsoft.EntityFrameworkCore.ChangeTracking.EntityEntry entry, DbContext? context)
    {
        if (entry.Entity.GetType().Name.Contains("GroupMember"))
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

        // Try to find a Name property, Title property, or just fallback to Type
        var nameProp = entry.Properties.FirstOrDefault(p => p.Metadata.Name == "Name" || p.Metadata.Name == "Title" || p.Metadata.Name == "Username");
        if (nameProp != null && nameProp.CurrentValue != null)
        {
            return nameProp.CurrentValue.ToString()!;
        }
        return entry.Entity.GetType().Name;
    }
}
