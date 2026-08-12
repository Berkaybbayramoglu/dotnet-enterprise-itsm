using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.Ticket;

public class TicketType : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public int ProjectId { get; set; }
    public string? Description { get; set; }
    public string? Icon { get; set; }
    public string? ColorHex { get; set; }
    public bool IsSystemDefault { get; set; }
}
