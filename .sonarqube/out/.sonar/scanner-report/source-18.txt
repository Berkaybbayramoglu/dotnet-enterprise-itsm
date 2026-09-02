using ItsTool.Domain.Common;
using System;

namespace ItsTool.Domain.Entities.Notification;

public class Notification : BaseEntity
{
    public int UserId { get; set; }
    public string Type { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string Body { get; set; } = string.Empty;
    public string EntityType { get; set; } = string.Empty;
    public int EntityId { get; set; }
    public string Priority { get; set; } = "Normal";
    public bool IsRead { get; set; }
    
    // Navigation
    public virtual Organization.User? User { get; set; }
}
