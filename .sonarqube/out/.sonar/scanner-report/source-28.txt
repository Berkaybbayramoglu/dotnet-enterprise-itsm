using ItsTool.Domain.Common;

namespace ItsTool.Domain.Entities.Ticket;

public class Category : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public int ProjectId { get; set; }
    public int? ParentCategoryId { get; set; }
    public string? Description { get; set; }
    public int? DefaultAssigneeGroupId { get; set; }
}
