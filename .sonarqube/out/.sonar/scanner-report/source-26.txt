using ItsTool.Domain.Common;
using System.Collections.Generic;
namespace ItsTool.Domain.Entities.Organization;
public class User : BaseEntity {
    public string Username { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string PasswordHash { get; set; } = string.Empty;
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public int? DepartmentId { get; set; }
    public virtual Department? Department { get; set; }
    public virtual ICollection<GroupMember> GroupMemberships { get; set; } = new List<GroupMember>();
}
