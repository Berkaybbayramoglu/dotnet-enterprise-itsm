using ItsTool.Domain.Common;
namespace ItsTool.Domain.Entities.Organization;
public class GroupMember : BaseEntity {
    public int UserId { get; set; }
    public int GroupId { get; set; }
    public virtual User? User { get; set; }
    public virtual Group? Group { get; set; }
}
