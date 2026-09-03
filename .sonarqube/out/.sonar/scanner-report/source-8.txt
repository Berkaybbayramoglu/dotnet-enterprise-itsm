namespace ItsTool.Domain.Common;
public abstract class BaseEntity : IAuditable, ISoftDelete {
    public int Id { get; set; }
    public System.DateTime CreatedAt { get; set; } = System.DateTime.UtcNow;
    public string? CreatedBy { get; set; }
    public System.DateTime? UpdatedAt { get; set; }
    public string? UpdatedBy { get; set; }
    public bool IsActive { get; set; } = true;
    public bool IsDeleted { get; set; } = false;
    public System.DateTime? DeletedAt { get; set; }
}
