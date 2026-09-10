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
    [ProducesResponseType(typeof(IEnumerable<SlaPolicyDetailDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetPolicies([FromQuery] int? projectId)
    {
        return Ok(await _service.GetPoliciesAsync(projectId));
    }

    [HttpGet("policies/{id}")]
    [ProducesResponseType(typeof(SlaPolicyDetailDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetPolicyById(int id)
    {
        var res = await _service.GetPolicyByIdAsync(id);
        if (res == null) return NotFound();
        return Ok(res);
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
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> DeletePolicy(int id)
    {
        try
        {
            await _service.DeletePolicyAsync(id);
            return NoContent();
        }
        catch (System.InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpPost("policies/{id}/restore")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> RestorePolicy(int id)
    {
        try
        {
            await _service.RestorePolicyAsync(id);
            return NoContent();
        }
        catch (System.Collections.Generic.KeyNotFoundException)
        {
            return NotFound();
        }
    }

    [HttpGet("policies/deleted")]
    [ProducesResponseType(typeof(IEnumerable<SlaPolicyDetailDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetDeletedPolicies()
    {
        return Ok(await _service.GetDeletedPoliciesAsync());
    }

    [HttpGet("policies/{id}/targets")]
    [ProducesResponseType(typeof(IEnumerable<SlaTargetDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetTargets(int id)
    {
        return Ok(await _service.GetTargetsAsync(id));
    }

    [HttpPut("policies/{id}/targets/batch")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> BatchUpdateTargets(int id, [FromBody] BatchUpdateSlaTargetsDto dto)
    {
        try
        {
            await _service.BatchUpdateTargetsAsync(id, dto);
            return NoContent();
        }
        catch (System.Collections.Generic.KeyNotFoundException)
        {
            return NotFound();
        }
    }

    [HttpPost("targets")]
    [ProducesResponseType(typeof(SlaTargetDto), StatusCodes.Status201Created)]
    public async Task<IActionResult> CreateTarget([FromBody] CreateSlaTargetDto dto)
    {
        var res = await _service.CreateTargetAsync(dto);
        return CreatedAtAction(nameof(GetPolicies), new { id = res.Id }, res);
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
