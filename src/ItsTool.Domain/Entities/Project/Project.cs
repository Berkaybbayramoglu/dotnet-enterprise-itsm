using ItsTool.Domain.Common;
namespace ItsTool.Domain.Entities.Project;
public class Project : BaseEntity {
    public string Name { get; set; } = string.Empty;
    public string ProjectKey { get; set; } = string.Empty;
    public string? Description { get; set; }
    public int CurrentTicketSequence { get; set; } = 0;
}
