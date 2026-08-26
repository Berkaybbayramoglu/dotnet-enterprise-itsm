using System;
using ItsTool.Domain.Common;
using ItsTool.Domain.Entities.Ticket;

namespace ItsTool.Domain.Entities.SLA;

public class TicketSla : BaseEntity
{
    public int TicketId { get; set; }
    public DateTime? FirstResponseDueAt { get; set; }
    public DateTime? ResolutionDueAt { get; set; }
    
    public DateTime? PausedAt { get; set; }
    public int TotalPausedMinutes { get; set; }
    
    public DateTime? FirstResponseMetAt { get; set; }
    public DateTime? ResolutionMetAt { get; set; }
    
    public bool FirstResponseWarned { get; set; }
    public bool FirstResponseBreached { get; set; }
    public bool ResolutionWarned { get; set; }
    public bool ResolutionBreached { get; set; }
    
    public DateTime? EscalatedAt { get; set; } // Phase 11: SLA Escalation idempotency

    public virtual Ticket.Ticket? Ticket { get; set; }
}
