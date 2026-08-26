using ItsTool.Domain.Common;
using ItsTool.Domain.Entities.Organization;
namespace ItsTool.Domain.Entities.Auth;
public class GroupRole : BaseEntity {
    public int GroupId { get; set; }
    public int RoleId { get; set; }
    public virtual Group? Group { get; set; }
    public virtual Role? Role { get; set; }
}
