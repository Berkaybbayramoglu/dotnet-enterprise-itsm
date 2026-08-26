using ItsTool.Domain.Common;
namespace ItsTool.Domain.Entities.Auth;
public class Permission : BaseEntity {
    public string Name { get; set; } = string.Empty;
    public string Key { get; set; } = string.Empty;
}
