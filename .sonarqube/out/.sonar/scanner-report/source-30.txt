using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.Project;

public class ProjectSequence : BaseEntity
{
    public int? ProjectId { get; set; }
    public int CurrentValue { get; set; }

    public virtual Project? Project { get; set; }
}
