using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize(Policy = "RequirePermission:admin.manage")]
public class CategoriesController : CrudControllerBase<CategoryDto, CreateCategoryDto, UpdateCategoryDto>
{
    private readonly ICatalogService _service;

    public CategoriesController(ICatalogService service)
    {
        _service = service;
    }

    protected override Task<IEnumerable<CategoryDto>> GetAllEntitiesAsync() => _service.GetCategoriesAsync();
    protected override Task<CategoryDto?> GetEntityByIdAsync(int id) => _service.GetCategoryByIdAsync(id);
    protected override Task<CategoryDto> CreateEntityAsync(CreateCategoryDto dto) => _service.CreateCategoryAsync(dto);
    protected override Task UpdateEntityAsync(int id, UpdateCategoryDto dto) => _service.UpdateCategoryAsync(id, dto);
    protected override Task DeleteEntityAsync(int id) => _service.DeleteCategoryAsync(id);
    protected override int GetEntityId(CategoryDto dto) => dto.Id;

}
