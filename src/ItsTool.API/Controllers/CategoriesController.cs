using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize(Policy = "RequirePermission:admin.manage")]
public class CategoriesController : CrudControllerBase<CategoryDto>
{
    private readonly ICatalogService _service;

    public CategoriesController(ICatalogService service)
    {
        _service = service;
    }

    protected override Task<IEnumerable<CategoryDto>> GetAllEntitiesAsync() => _service.GetCategoriesAsync();
    protected override Task<CategoryDto?> GetEntityByIdAsync(int id) => _service.GetCategoryByIdAsync(id);
    protected override Task DeleteEntityAsync(int id) => _service.DeleteCategoryAsync(id);

    [HttpPost]
    [ProducesResponseType(StatusCodes.Status201Created)]
    public async Task<IActionResult> Create([FromBody] CreateCategoryDto dto)
    {
        var created = await _service.CreateCategoryAsync(dto);
        return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
    }

    [HttpPut("{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Update(int id, [FromBody] UpdateCategoryDto dto)
    {
        try
        {
            await _service.UpdateCategoryAsync(id, dto);
            return NoContent();
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }

}
