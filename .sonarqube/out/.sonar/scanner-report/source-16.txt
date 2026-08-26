using ItsTool.Domain.Common;
using ItsTool.Domain.Entities.Organization;
namespace ItsTool.Domain.Entities.Auth;
public class UserRole : BaseEntity {
    public int UserId { get; set; }
    public int RoleId { get; set; }
    public virtual User? User { get; set; }
    public virtual Role? Role { get; set; }
}
