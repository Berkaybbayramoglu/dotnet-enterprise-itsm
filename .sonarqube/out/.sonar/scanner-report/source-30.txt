using System;
using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities;

public class SystemAuditLog : BaseEntity
{
    public string EntityType { get; set; } = string.Empty;
    public string EntityName { get; set; } = string.Empty;
    public string EntityId { get; set; } = string.Empty;
    public string Action { get; set; } = string.Empty;
    public string? FieldName { get; set; }
    public string? OldValue { get; set; }
    public string? NewValue { get; set; }
}
