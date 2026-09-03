using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize(Policy = "RequirePermission:config.manage")]
public class WorkflowController : ControllerBase
{
    private readonly IWorkflowService _service;

    public WorkflowController(IWorkflowService service)
    {
        _service = service;
    }

    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<WorkflowDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetWorkflows([FromQuery] int? projectId)
    {
        return Ok(await _service.GetWorkflowsAsync(projectId));
    }

    [HttpPost]
    [ProducesResponseType(typeof(WorkflowDto), StatusCodes.Status201Created)]
    public async Task<IActionResult> CreateWorkflow([FromBody] CreateWorkflowDto dto)
    {
        var result = await _service.CreateWorkflowAsync(dto);
        return CreatedAtAction(nameof(GetWorkflows), new { id = result.Id }, result);
    }

    [HttpPut("{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> UpdateWorkflow(int id, [FromBody] UpdateWorkflowDto dto)
    {
        try { await _service.UpdateWorkflowAsync(id, dto); return NoContent(); }
        catch (KeyNotFoundException) { return NotFound(); }
    }

    [HttpDelete("{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> DeleteWorkflow(int id)
    {
        await _service.DeleteWorkflowAsync(id); return NoContent();
    }

    [HttpGet("{workflowId}/transitions")]
    [ProducesResponseType(typeof(IEnumerable<WorkflowTransitionDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetTransitions(int workflowId)
    {
        return Ok(await _service.GetTransitionsByWorkflowIdAsync(workflowId));
    }

    [HttpPost("transitions")]
    [ProducesResponseType(typeof(WorkflowTransitionDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> CreateTransition([FromBody] CreateWorkflowTransitionDto dto)
    {
        try
        {
            var result = await _service.CreateTransitionAsync(dto);
            return CreatedAtAction(nameof(GetWorkflows), new { id = result.Id }, result);
        }
        catch (InvalidOperationException ex) { return BadRequest(new { error = ex.Message }); }
    }

    [HttpPut("transitions/{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> UpdateTransition(int id, [FromBody] UpdateWorkflowTransitionDto dto)
    {
        try { await _service.UpdateTransitionAsync(id, dto); return NoContent(); }
        catch (KeyNotFoundException) { return NotFound(); }
        catch (InvalidOperationException ex) { return BadRequest(new { error = ex.Message }); }
    }

    [HttpDelete("transitions/{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> DeleteTransition(int id)
    {
        await _service.DeleteTransitionAsync(id); return NoContent();
    }
}
