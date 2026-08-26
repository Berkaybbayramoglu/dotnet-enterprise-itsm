using ItsTool.Domain.Common;
using System.Collections.Generic;
namespace ItsTool.Domain.Entities.Organization;
public class Department : BaseEntity {
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public virtual ICollection<Group> Groups { get; set; } = new List<Group>();
    public virtual ICollection<User> Users { get; set; } = new List<User>();
}
