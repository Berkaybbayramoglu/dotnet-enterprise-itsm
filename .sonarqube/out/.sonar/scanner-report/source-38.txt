using ItsTool.Domain.Common;
namespace ItsTool.Domain.Entities.Ticket;
public class TicketHistory : BaseEntity {
    public int TicketId { get; set; }
    public string FieldName { get; set; } = string.Empty;
    public string? OldValue { get; set; }
    public string? NewValue { get; set; }
    public string Action { get; set; } = string.Empty;
    public virtual Ticket? Ticket { get; set; }
}
