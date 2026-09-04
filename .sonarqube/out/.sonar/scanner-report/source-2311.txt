import re

with open("src/ItsTool.Infrastructure/Data/Interceptors/SystemAuditInterceptor.cs", "r") as f:
    text = f.read()

# 1. ShouldSkipAudit -> static
text = text.replace("private bool ShouldSkipAudit(object entity)", "private static bool ShouldSkipAudit(object entity)")
text = text.replace("if (ShouldSkipAudit(entry.Entity))", "if (SystemAuditInterceptor.ShouldSkipAudit(entry.Entity))")

# 2. GetEntityName -> static and refactored
get_entity_name_orig = """    private string GetEntityName(Microsoft.EntityFrameworkCore.ChangeTracking.EntityEntry entry, DbContext? context)
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
    }"""

get_entity_name_new = """    private static string GetEntityName(Microsoft.EntityFrameworkCore.ChangeTracking.EntityEntry entry, DbContext? context)
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
    }"""

text = text.replace(get_entity_name_orig, get_entity_name_new)

# 3. CreateAuditLog -> static and record
create_audit_orig = """    private SystemAuditLog CreateAuditLog(string entityType, string entityName, string entityId, string action, string? fieldName, string? oldValue, string? newValue, string userId, DateTime now)
    {
        return new SystemAuditLog
        {
            EntityType = entityType,
            EntityName = entityName,
            EntityId = entityId,
            Action = action,
            FieldName = fieldName,
            OldValue = oldValue,
            NewValue = newValue,
            CreatedBy = userId,
            CreatedAt = now
        };
    }"""

create_audit_new = """    public sealed record AuditLogEntry(string EntityType, string EntityName, string EntityId, string Action, string? FieldName, string? OldValue, string? NewValue, string UserId, DateTime Now);

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
    }"""
text = text.replace(create_audit_orig, create_audit_new)

# Modify CreateAuditLog callers
text = text.replace('CreateAuditLog(entityType, entityName, entityId, "Deleted", null, null, null, userId, now)', 
                    'SystemAuditInterceptor.CreateAuditLog(new AuditLogEntry(entityType, entityName, entityId, "Deleted", null, null, null, userId, now))')

text = text.replace('CreateAuditLog(entityType, entityName, entityId, "Updated", propName, original ?? "none", current ?? "none", userId, now)', 
                    'SystemAuditInterceptor.CreateAuditLog(new AuditLogEntry(entityType, entityName, entityId, "Updated", propName, original ?? "none", current ?? "none", userId, now))')

text = text.replace('CreateAuditLog(entityType, entityName, entityId, "Created", null, null, isGroupMember ? entityName : null, userId, now)',
                    'SystemAuditInterceptor.CreateAuditLog(new AuditLogEntry(entityType, entityName, entityId, "Created", null, null, isGroupMember ? entityName : null, userId, now))')

text = text.replace('CreateAuditLog(entityType, entityName, entityId, "Deleted", null, isGroupMember ? entityName : null, null, userId, now)',
                    'SystemAuditInterceptor.CreateAuditLog(new AuditLogEntry(entityType, entityName, entityId, "Deleted", null, isGroupMember ? entityName : null, null, userId, now))')

# 4. GenerateAuditLogs complexity
gen_audit_orig = """        foreach (var entry in entries)
        {
            if (SystemAuditInterceptor.ShouldSkipAudit(entry.Entity)) continue;

            var entityType = entry.Entity.GetType().Name;
            var entityName = GetEntityName(entry, context);
            var entityId = entry.Entity.Id.ToString();
            
            var isGroupMember = entityType == "GroupMember";

            if (entry.State == EntityState.Added)
                logsToAdd.Add(SystemAuditInterceptor.CreateAuditLog(new AuditLogEntry(entityType, entityName, entityId, "Created", null, null, isGroupMember ? entityName : null, userId, now)));
            else if (entry.State == EntityState.Deleted)
                logsToAdd.Add(SystemAuditInterceptor.CreateAuditLog(new AuditLogEntry(entityType, entityName, entityId, "Deleted", null, isGroupMember ? entityName : null, null, userId, now)));
            else if (entry.State == EntityState.Modified)
                ProcessModifiedEntity(entry, logsToAdd, entityType, entityName, entityId, userId, now);
        }"""

gen_audit_new = """        foreach (var entry in entries)
        {
            if (SystemAuditInterceptor.ShouldSkipAudit(entry.Entity)) continue;
            ProcessEntry(entry, context, userId, now, logsToAdd);
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
    }"""
# Note: GetEntityName is replaced above, so we also need to fix `GetEntityName` call inside the original `foreach` to match what the python script finds. Wait, original is `GetEntityName(entry, context);`. We'll just string replace the whole block.
text = text.replace(gen_audit_orig, gen_audit_new)

with open("src/ItsTool.Infrastructure/Data/Interceptors/SystemAuditInterceptor.cs", "w") as f:
    f.write(text)

