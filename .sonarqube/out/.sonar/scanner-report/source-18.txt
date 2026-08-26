using ItsTool.Domain.Common;
using ItsTool.Domain.Entities.Organization;

namespace ItsTool.Domain.Entities.Config;

public class SavedFilter : BaseEntity
{
    public int UserId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string QueryJson { get; set; } = string.Empty;

    public virtual User? User { get; set; }
}
