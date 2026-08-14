namespace ItsTool.Application.DTOs;

// FieldDefinition
public record FieldDefinitionDto(int Id, string Key, string Label, string FieldType, string? ValidationRegex, bool IsActive);
public record CreateFieldDefinitionDto(string Key, string Label, string FieldType, string? ValidationRegex);
public record UpdateFieldDefinitionDto(string Key, string Label, string FieldType, string? ValidationRegex, bool IsActive);

// FieldOption
public record FieldOptionDto(int Id, int FieldDefinitionId, string Value, string Label, int SortOrder, bool IsActive);
public record CreateFieldOptionDto(int FieldDefinitionId, string Value, string Label, int SortOrder);
public record UpdateFieldOptionDto(string Value, string Label, int SortOrder, bool IsActive);

// FormFieldPlacement
public record FormFieldPlacementDto(int Id, int FieldDefinitionId, int? ProjectId, int? CategoryId, int? TicketTypeId, int SortOrder, bool IsRequired, bool IsActive);
public record CreateFormFieldPlacementDto(int FieldDefinitionId, int? ProjectId, int? CategoryId, int? TicketTypeId, int SortOrder, bool IsRequired);
public record UpdateFormFieldPlacementDto(int? ProjectId, int? CategoryId, int? TicketTypeId, int SortOrder, bool IsRequired, bool IsActive);
