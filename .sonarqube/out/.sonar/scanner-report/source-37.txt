using ItsTool.Domain.Common;
using ItsTool.Domain.Entities.Organization;
namespace ItsTool.Domain.Entities.Ticket;
public class Ticket : BaseEntity {
    public string TicketNumber { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public int? ProjectId { get; set; }
    public int CategoryId { get; set; }
    public int TypeId { get; set; }
    public int StatusId { get; set; }
    public int PriorityId { get; set; }
    public int RequesterUserId { get; set; }
    public virtual ICollection<TicketAssignment> Assignments { get; set; } = new List<TicketAssignment>();
    public string? ExternalMessageId { get; set; } // Phase 11: Inbound Email Dedupe
    public DateTime? EstimatedStartDate { get; set; }
    public DateTime? EstimatedEndDate { get; set; }

    public virtual Project.Project? Project { get; set; }
    public virtual Category? Category { get; set; }
    public virtual TicketType? Type { get; set; }
    public virtual Status? Status { get; set; }
    public virtual Priority? Priority { get; set; }
    public virtual User? RequesterUser { get; set; }
    public virtual SLA.TicketSla? TicketSla { get; set; }
}
