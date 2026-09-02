using ItsTool.Domain.Common;
using ItsTool.Domain.Entities.Project;
using ItsTool.Domain.Entities.Ticket;

namespace ItsTool.Domain.Entities.Organization;

public class AssignmentRule : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public int? ProjectId { get; set; }
    public int? CategoryId { get; set; }
    public int? TicketTypeId { get; set; }
    public int? PriorityId { get; set; }
    public int? TargetGroupId { get; set; }
    public int? TargetUserId { get; set; }
    public int SortOrder { get; set; }


    // Navigation properties for validation and loading
    public virtual Project.Project? Project { get; set; }
    public virtual Category? Category { get; set; }
    public virtual TicketType? TicketType { get; set; }
    public virtual Priority? Priority { get; set; }
    public virtual Group? TargetGroup { get; set; }
    public virtual User? TargetUser { get; set; }
}
