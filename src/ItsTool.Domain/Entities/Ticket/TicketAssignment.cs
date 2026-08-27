using ItsTool.Domain.Common;
using ItsTool.Domain.Entities.Organization;

namespace ItsTool.Domain.Entities.Ticket;

public class TicketAssignment : BaseEntity
{
    public int TicketId { get; set; }
    public int? AssignedUserId { get; set; }
    public int? AssignedGroupId { get; set; }
    public int? ParentAssignmentId { get; set; }
    public int AssignedByUserId { get; set; }
    public bool IsActive { get; set; } = true;

    public virtual Ticket Ticket { get; set; } = null!;
    public virtual User? AssignedUser { get; set; }
    public virtual Group? AssignedGroup { get; set; }
    public virtual TicketAssignment? ParentAssignment { get; set; }
    public virtual User AssignedByUser { get; set; } = null!;
}
