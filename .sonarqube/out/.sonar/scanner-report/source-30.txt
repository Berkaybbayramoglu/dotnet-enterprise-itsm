using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.Ticket;

public class Status : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public int ProjectId { get; set; }
    public bool IsClosedStatus { get; set; } = false;
    public string? ColorHex { get; set; }
    public int SortOrder { get; set; }
    public bool IsSystemDefault { get; set; }
}
