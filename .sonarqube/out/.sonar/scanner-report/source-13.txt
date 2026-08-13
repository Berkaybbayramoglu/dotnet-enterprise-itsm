using ItsTool.Domain.Common;
namespace ItsTool.Domain.Entities.Auth;
public class Role : BaseEntity {
    public string Name { get; set; } = string.Empty;
}
