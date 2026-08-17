using ItsTool.Domain.Common;
using ItsTool.Domain.Entities.Organization;
namespace ItsTool.Domain.Entities.Project;
public class ProjectMember : BaseEntity {
    public int ProjectId { get; set; }
    public int UserId { get; set; }
    public int? SpecificRoleId { get; set; }
    public virtual Project? Project { get; set; }
    public virtual User? User { get; set; }
}
