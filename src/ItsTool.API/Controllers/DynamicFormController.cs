using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize(Policy = "RequirePermission:config.manage")]
public class DynamicFormController : ControllerBase
{
    private readonly IDynamicFormService _service;

    public DynamicFormController(IDynamicFormService service)
    {
        _service = service;
    }

    [HttpGet("definitions")]
    [ProducesResponseType(typeof(IEnumerable<FieldDefinitionDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetDefinitions() => Ok(await _service.GetFieldDefinitionsAsync());

    [HttpPost("definitions")]
    [ProducesResponseType(typeof(FieldDefinitionDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> CreateDefinition([FromBody] CreateFieldDefinitionDto dto)
    {
        try { var result = await _service.CreateFieldDefinitionAsync(dto); return CreatedAtAction(nameof(GetDefinitions), new { id = result.Id }, result); }
        catch (InvalidOperationException ex) { return BadRequest(new { error = ex.Message }); }
    }

    [HttpPut("definitions/{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> UpdateDefinition(int id, [FromBody] UpdateFieldDefinitionDto dto)
    {
        try { await _service.UpdateFieldDefinitionAsync(id, dto); return NoContent(); }
        catch (KeyNotFoundException) { return NotFound(); }
        catch (InvalidOperationException ex) { return BadRequest(new { error = ex.Message }); }
    }

    [HttpDelete("definitions/{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> DeleteDefinition(int id)
    {
        await _service.DeleteFieldDefinitionAsync(id); return NoContent();
    }

    [HttpGet("definitions/{id}/options")]
    [ProducesResponseType(typeof(IEnumerable<FieldOptionDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetOptions(int id) => Ok(await _service.GetFieldOptionsAsync(id));

    [HttpPost("options")]
    [ProducesResponseType(typeof(FieldOptionDto), StatusCodes.Status201Created)]
    public async Task<IActionResult> CreateOption([FromBody] CreateFieldOptionDto dto)
    {
        var result = await _service.CreateFieldOptionAsync(dto);
        return CreatedAtAction(nameof(GetDefinitions), new { id = result.Id }, result);
    }

    [HttpPut("options/{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> UpdateOption(int id, [FromBody] UpdateFieldOptionDto dto)
    {
        try { await _service.UpdateFieldOptionAsync(id, dto); return NoContent(); }
        catch (KeyNotFoundException) { return NotFound(); }
    }

    [HttpDelete("options/{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> DeleteOption(int id)
    {
        await _service.DeleteFieldOptionAsync(id); return NoContent();
    }

    [HttpGet("placements")]
    [ProducesResponseType(typeof(IEnumerable<FormFieldPlacementDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetPlacements([FromQuery] int? projectId, [FromQuery] int? categoryId, [FromQuery] int? ticketTypeId)
    {
        return Ok(await _service.GetPlacementsAsync(projectId, categoryId, ticketTypeId));
    }

    [HttpPost("placements")]
    [ProducesResponseType(typeof(FormFieldPlacementDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> CreatePlacement([FromBody] CreateFormFieldPlacementDto dto)
    {
        try { var result = await _service.CreatePlacementAsync(dto); return CreatedAtAction(nameof(GetDefinitions), new { id = result.Id }, result); }
        catch (InvalidOperationException ex) { return BadRequest(new { error = ex.Message }); }
    }

    [HttpPut("placements/{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> UpdatePlacement(int id, [FromBody] UpdateFormFieldPlacementDto dto)
    {
        try { await _service.UpdatePlacementAsync(id, dto); return NoContent(); }
        catch (KeyNotFoundException) { return NotFound(); }
        catch (InvalidOperationException ex) { return BadRequest(new { error = ex.Message }); }
    }

    [HttpDelete("placements/{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> DeletePlacement(int id)
    {
        await _service.DeletePlacementAsync(id); return NoContent();
    }
}
