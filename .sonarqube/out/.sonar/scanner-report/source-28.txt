using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.Ticket;

public class Priority : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public int ProjectId { get; set; }
    public int Weight { get; set; }
    public string? ColorHex { get; set; }
    public int SortOrder { get; set; }
    public int SeverityLevel { get; set; }
}
