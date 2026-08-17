using System;
using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.Config;

public class WebhookSubscription : BaseEntity
{
    public string Url { get; set; } = string.Empty;
    public string EventsCsv { get; set; } = string.Empty; // Comma separated events
    public string Secret { get; set; } = string.Empty; // For HMAC-SHA256
    public bool IsActive { get; set; } = true;
}
