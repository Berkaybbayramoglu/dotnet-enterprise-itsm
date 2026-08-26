using ItsTool.Domain.Common;
using ItsTool.Domain.Entities.Organization;
namespace ItsTool.Domain.Entities.Auth;
public class UserPermissionOverride : BaseEntity {
    public int UserId { get; set; }
    public int PermissionId { get; set; }
    public bool IsGranted { get; set; }
    public virtual User? User { get; set; }
    public virtual Permission? Permission { get; set; }
}
