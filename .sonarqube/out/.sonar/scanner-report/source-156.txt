using ItsTool.Application.DTOs;

namespace ItsTool.Application.Interfaces;

public interface IDynamicFormService
{
    // FieldDefinition
    Task<IEnumerable<FieldDefinitionDto>> GetFieldDefinitionsAsync();
    Task<FieldDefinitionDto?> GetFieldDefinitionByIdAsync(int id);
    Task<FieldDefinitionDto> CreateFieldDefinitionAsync(CreateFieldDefinitionDto dto);
    Task UpdateFieldDefinitionAsync(int id, UpdateFieldDefinitionDto dto);
    Task DeleteFieldDefinitionAsync(int id);

    // FieldOption
    Task<IEnumerable<FieldOptionDto>> GetFieldOptionsAsync(int fieldDefinitionId);
    Task<FieldOptionDto?> GetFieldOptionByIdAsync(int id);
    Task<FieldOptionDto> CreateFieldOptionAsync(CreateFieldOptionDto dto);
    Task UpdateFieldOptionAsync(int id, UpdateFieldOptionDto dto);
    Task DeleteFieldOptionAsync(int id);

    // FormFieldPlacement
    Task<IEnumerable<FormFieldPlacementDto>> GetPlacementsAsync(int? projectId, int? categoryId, int? ticketTypeId);
    Task<FormFieldPlacementDto?> GetPlacementByIdAsync(int id);
    Task<FormFieldPlacementDto> CreatePlacementAsync(CreateFormFieldPlacementDto dto);
    Task UpdatePlacementAsync(int id, UpdateFormFieldPlacementDto dto);
    Task DeletePlacementAsync(int id);
}
