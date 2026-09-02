using ItsTool.Domain.Common;
using ItsTool.Domain.Entities.Organization;

namespace ItsTool.Domain.Entities.Ticket;

public class TicketAttachment : BaseEntity
{
    public int TicketId { get; set; }
    public string FileName { get; set; } = string.Empty;
    public string FilePath { get; set; } = string.Empty;
    public long FileSize { get; set; }
    public string ContentType { get; set; } = string.Empty;
    public int UploadedByUserId { get; set; }

    public virtual Ticket? Ticket { get; set; }
    public virtual User? UploadedByUser { get; set; }
}
