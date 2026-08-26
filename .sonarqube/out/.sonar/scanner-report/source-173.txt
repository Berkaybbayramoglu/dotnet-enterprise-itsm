namespace ItsTool.Application.DTOs;

// Category
public record CategoryDto(int Id, string Name, int ProjectId, int? ParentCategoryId, string? Description, int? DefaultAssigneeGroupId, bool IsActive);
public record CreateCategoryDto(string Name, int ProjectId, int? ParentCategoryId, string? Description, int? DefaultAssigneeGroupId);
public record UpdateCategoryDto(string Name, int ProjectId, int? ParentCategoryId, string? Description, int? DefaultAssigneeGroupId, bool IsActive);

// TicketType
public record TicketTypeDto(int Id, string Name, bool IsActive);
public record CreateTicketTypeDto(string Name);
public record UpdateTicketTypeDto(string Name, bool IsActive);

// Status
public record StatusDto(int Id, string Name, string? ColorHex, int SortOrder, bool IsClosedStatus, bool IsSystemDefault, bool IsActive);
public record CreateStatusDto(string Name, string? ColorHex, int SortOrder, bool IsClosedStatus, bool IsSystemDefault);
public record UpdateStatusDto(string Name, string? ColorHex, int SortOrder, bool IsClosedStatus, bool IsSystemDefault, bool IsActive);

// Priority
public record PriorityDto(int Id, string Name, string? ColorHex, int Weight, int SeverityLevel, bool IsActive);
public record CreatePriorityDto(string Name, string? ColorHex, int Weight, int SeverityLevel);
public record UpdatePriorityDto(string Name, string? ColorHex, int Weight, int SeverityLevel, bool IsActive);
