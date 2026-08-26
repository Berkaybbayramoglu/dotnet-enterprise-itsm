namespace ItsTool.Domain.Common;
public interface IAuditable {
    System.DateTime CreatedAt { get; set; }
    string? CreatedBy { get; set; }
    System.DateTime? UpdatedAt { get; set; }
    string? UpdatedBy { get; set; }
}
