using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize(Policy = "RequirePermission:config.manage")]
public class CatalogController : ControllerBase
{
    private readonly ICatalogService _service;

    public CatalogController(ICatalogService service)
    {
        _service = service;
    }

    [HttpGet("categories")]
    [ProducesResponseType(typeof(IEnumerable<CategoryDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetCategories([FromQuery] int? projectId)
    {
        return Ok(await _service.GetCategoriesAsync(projectId));
    }

    [HttpPost("categories")]
    [ProducesResponseType(typeof(CategoryDto), StatusCodes.Status201Created)]
    public async Task<IActionResult> CreateCategory([FromBody] CreateCategoryDto dto)
    {
        var result = await _service.CreateCategoryAsync(dto);
        return CreatedAtAction(nameof(GetCategories), new { id = result.Id }, result);
    }

    [HttpPut("categories/{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> UpdateCategory(int id, [FromBody] UpdateCategoryDto dto)
    {
        try { await _service.UpdateCategoryAsync(id, dto); return NoContent(); }
        catch (KeyNotFoundException) { return NotFound(); }
    }

    [HttpDelete("categories/{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> DeleteCategory(int id)
    {
        await _service.DeleteCategoryAsync(id); return NoContent();
    }

    [HttpGet("ticket-types")]
    [ProducesResponseType(typeof(IEnumerable<TicketTypeDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetTicketTypes() => Ok(await _service.GetTicketTypesAsync());

    [HttpPost("ticket-types")]
    [ProducesResponseType(typeof(TicketTypeDto), StatusCodes.Status201Created)]
    public async Task<IActionResult> CreateTicketType([FromBody] CreateTicketTypeDto dto)
    {
        var result = await _service.CreateTicketTypeAsync(dto);
        return CreatedAtAction(nameof(GetTicketTypes), new { id = result.Id }, result);
    }

    [HttpPut("ticket-types/{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> UpdateTicketType(int id, [FromBody] UpdateTicketTypeDto dto)
    {
        try { await _service.UpdateTicketTypeAsync(id, dto); return NoContent(); }
        catch (KeyNotFoundException) { return NotFound(); }
    }

    [HttpDelete("ticket-types/{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> DeleteTicketType(int id)
    {
        await _service.DeleteTicketTypeAsync(id); return NoContent();
    }

    [HttpGet("statuses")]
    [ProducesResponseType(typeof(IEnumerable<StatusDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetStatuses() => Ok(await _service.GetStatusesAsync());

    [HttpPost("statuses")]
    [ProducesResponseType(typeof(StatusDto), StatusCodes.Status201Created)]
    public async Task<IActionResult> CreateStatus([FromBody] CreateStatusDto dto)
    {
        var result = await _service.CreateStatusAsync(dto);
        return CreatedAtAction(nameof(GetStatuses), new { id = result.Id }, result);
    }

    [HttpPut("statuses/{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> UpdateStatus(int id, [FromBody] UpdateStatusDto dto)
    {
        try { await _service.UpdateStatusAsync(id, dto); return NoContent(); }
        catch (KeyNotFoundException) { return NotFound(); }
    }

    [HttpDelete("statuses/{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> DeleteStatus(int id)
    {
        try { await _service.DeleteStatusAsync(id); return NoContent(); }
        catch (InvalidOperationException ex) { return BadRequest(new { error = ex.Message }); }
    }

    [HttpGet("priorities")]
    [ProducesResponseType(typeof(IEnumerable<PriorityDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetPriorities() => Ok(await _service.GetPrioritiesAsync());

    [HttpPost("priorities")]
    [ProducesResponseType(typeof(PriorityDto), StatusCodes.Status201Created)]
    public async Task<IActionResult> CreatePriority([FromBody] CreatePriorityDto dto)
    {
        var result = await _service.CreatePriorityAsync(dto);
        return CreatedAtAction(nameof(GetPriorities), new { id = result.Id }, result);
    }

    [HttpPut("priorities/{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> UpdatePriority(int id, [FromBody] UpdatePriorityDto dto)
    {
        try { await _service.UpdatePriorityAsync(id, dto); return NoContent(); }
        catch (KeyNotFoundException) { return NotFound(); }
    }

    [HttpDelete("priorities/{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> DeletePriority(int id)
    {
        await _service.DeletePriorityAsync(id); return NoContent();
    }
}
