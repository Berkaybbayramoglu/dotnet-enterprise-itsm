using System.Collections.Generic;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize(Policy = "RequirePermission:sla.manage")]
public class SlaController : ControllerBase
{
    private readonly ISlaService _service;

    public SlaController(ISlaService service)
    {
        _service = service;
    }

    [HttpGet("policies")]
    [ProducesResponseType(typeof(IEnumerable<SlaPolicyDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetPolicies([FromQuery] int? projectId)
    {
        return Ok(await _service.GetPoliciesAsync(projectId));
    }

    [HttpPost("policies")]
    [ProducesResponseType(typeof(SlaPolicyDto), StatusCodes.Status201Created)]
    public async Task<IActionResult> CreatePolicy([FromBody] CreateSlaPolicyDto dto)
    {
        var res = await _service.CreatePolicyAsync(dto);
        return CreatedAtAction(nameof(GetPolicies), new { id = res.Id }, res);
    }

    [HttpPut("policies/{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> UpdatePolicy(int id, [FromBody] UpdateSlaPolicyDto dto)
    {
        try { await _service.UpdatePolicyAsync(id, dto); return NoContent(); }
        catch (System.Collections.Generic.KeyNotFoundException) { return NotFound(); }
    }

    [HttpDelete("policies/{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> DeletePolicy(int id)
    {
        await _service.DeletePolicyAsync(id); return NoContent();
    }

    [HttpGet("policies/{id}/targets")]
    [ProducesResponseType(typeof(IEnumerable<SlaTargetDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetTargets(int id)
    {
        return Ok(await _service.GetTargetsAsync(id));
    }

    [HttpPost("targets")]
    [ProducesResponseType(typeof(SlaTargetDto), StatusCodes.Status201Created)]
    public async Task<IActionResult> CreateTarget([FromBody] CreateSlaTargetDto dto)
    {
        var res = await _service.CreateTargetAsync(dto);
        return CreatedAtAction(nameof(GetPolicies), new { id = res.Id }, res); // Note: Should probably point to GetTargets
    }

    [HttpPut("targets/{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> UpdateTarget(int id, [FromBody] UpdateSlaTargetDto dto)
    {
        try { await _service.UpdateTargetAsync(id, dto); return NoContent(); }
        catch (System.Collections.Generic.KeyNotFoundException) { return NotFound(); }
    }

    [HttpDelete("targets/{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> DeleteTarget(int id)
    {
        await _service.DeleteTargetAsync(id); return NoContent();
    }
}
