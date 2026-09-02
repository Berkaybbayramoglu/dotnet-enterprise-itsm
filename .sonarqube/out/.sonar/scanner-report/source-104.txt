using ItsTool.Application.DTOs;

namespace ItsTool.Application.Interfaces;

public interface ICatalogService
{
    // Category
    Task<IEnumerable<CategoryDto>> GetCategoriesAsync(int? projectId = null);
    Task<CategoryDto?> GetCategoryByIdAsync(int id);
    Task<CategoryDto> CreateCategoryAsync(CreateCategoryDto dto);
    Task UpdateCategoryAsync(int id, UpdateCategoryDto dto);
    Task DeleteCategoryAsync(int id);

    // TicketType
    Task<IEnumerable<TicketTypeDto>> GetTicketTypesAsync();
    Task<TicketTypeDto?> GetTicketTypeByIdAsync(int id);
    Task<TicketTypeDto> CreateTicketTypeAsync(CreateTicketTypeDto dto);
    Task UpdateTicketTypeAsync(int id, UpdateTicketTypeDto dto);
    Task DeleteTicketTypeAsync(int id);

    // Status
    Task<IEnumerable<StatusDto>> GetStatusesAsync();
    Task<StatusDto?> GetStatusByIdAsync(int id);
    Task<StatusDto> CreateStatusAsync(CreateStatusDto dto);
    Task UpdateStatusAsync(int id, UpdateStatusDto dto);
    Task DeleteStatusAsync(int id);

    // Priority
    Task<IEnumerable<PriorityDto>> GetPrioritiesAsync();
    Task<PriorityDto?> GetPriorityByIdAsync(int id);
    Task<PriorityDto> CreatePriorityAsync(CreatePriorityDto dto);
    Task UpdatePriorityAsync(int id, UpdatePriorityDto dto);
    Task DeletePriorityAsync(int id);
}
