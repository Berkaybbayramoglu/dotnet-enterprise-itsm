using ItsTool.Domain.Common;
using System.Collections.Generic;
namespace ItsTool.Domain.Entities.Organization;
public class Group : BaseEntity {
    public string Name { get; set; } = string.Empty;
    public int? DepartmentId { get; set; }
    public virtual Department? Department { get; set; }
    public virtual ICollection<GroupMember> Members { get; set; } = new List<GroupMember>();
}
