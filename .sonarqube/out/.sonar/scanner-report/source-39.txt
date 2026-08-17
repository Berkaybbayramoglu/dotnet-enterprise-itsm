using System;
using ItsTool.Domain.Common;
using ItsTool.Domain.Entities.Ticket;

namespace ItsTool.Domain.Entities.Ticket;

public class TicketSurvey : BaseEntity
{
    public int TicketId { get; set; }
    public int Rating { get; set; } // 1-5
    public string? Comment { get; set; }
    public DateTime SubmittedAt { get; set; } = DateTime.UtcNow;
    
    public virtual Ticket? Ticket { get; set; }
}
