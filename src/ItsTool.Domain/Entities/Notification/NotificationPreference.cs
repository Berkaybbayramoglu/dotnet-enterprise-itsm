using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.Notification;

public class NotificationPreference : BaseEntity
{
    public int UserId { get; set; }
    public string Category { get; set; } = string.Empty;
    public bool EmailEnabled { get; set; } = true;
    
    // Navigation
    public virtual Organization.User? User { get; set; }
}
