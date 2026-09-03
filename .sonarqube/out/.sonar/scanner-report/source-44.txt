using ItsTool.Domain.Common;
using ItsTool.Domain.Entities.Organization;

namespace ItsTool.Domain.Entities.Ticket;

public class TicketWatcher : BaseEntity
{
    public int TicketId { get; set; }
    public int UserId { get; set; }

    public virtual Ticket? Ticket { get; set; }
    public virtual User? User { get; set; }
}
