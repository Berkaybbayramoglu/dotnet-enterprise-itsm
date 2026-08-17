using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.Notification;

public class NotificationRule : BaseEntity
{
    public string EventKey { get; set; } = string.Empty;
    public string TargetRole { get; set; } = string.Empty;
}

public class Notification : BaseEntity
{
    public int UserId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Message { get; set; } = string.Empty;
    public bool IsRead { get; set; }
    public int? RelatedEntityId { get; set; }
    public string? RelatedEntityType { get; set; }
}
