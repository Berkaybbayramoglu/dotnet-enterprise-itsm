using ItsTool.Domain.Common;
using ItsTool.Domain.Enums;

namespace ItsTool.Domain.Entities.Project;

public class Project : BaseEntity {
    public string Name { get; set; } = string.Empty;
    public string ProjectKey { get; set; } = string.Empty;
    public string? Description { get; set; }
    public int CurrentTicketSequence { get; set; } = 0;
    public ProjectStatus Status { get; set; } = ProjectStatus.Active;
}
