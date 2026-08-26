namespace ItsTool.Domain.Common;
public interface ISoftDelete {
    bool IsDeleted { get; set; }
    System.DateTime? DeletedAt { get; set; }
}
