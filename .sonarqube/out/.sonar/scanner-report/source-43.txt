using ItsTool.Domain.Common;
using ItsTool.Domain.Entities.Ticket;

namespace ItsTool.Domain.Entities.Workflow;

public class Workflow : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public int? ProjectId { get; set; }
}

public class WorkflowTransition : BaseEntity
{
    public int WorkflowId { get; set; }
    public int FromStatusId { get; set; }
    public int ToStatusId { get; set; }
    public string TransitionName { get; set; } = string.Empty;
    public string? RequiredPermissionKey { get; set; }
    public int SortOrder { get; set; }

    public virtual Workflow? Workflow { get; set; }
    public virtual Status? FromStatus { get; set; }
    public virtual Status? ToStatus { get; set; }
}
