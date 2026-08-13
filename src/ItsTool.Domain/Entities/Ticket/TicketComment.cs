using ItsTool.Domain.Common;
using ItsTool.Domain.Entities.Organization;

namespace ItsTool.Domain.Entities.Ticket;

public class TicketComment : BaseEntity
{
    public int TicketId { get; set; }
    public int AuthorUserId { get; set; }
    public string Content { get; set; } = string.Empty;
    public bool IsInternal { get; set; }

    public virtual Ticket? Ticket { get; set; }
    public virtual User? AuthorUser { get; set; }
}
