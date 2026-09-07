using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class GroupsController : CrudControllerBase<GroupDto>
{
    private readonly IGroupService _service;

    
    [HttpDelete("{id}")]
    [Authorize(Policy = "RequirePermission:admin.manage")]
    public new async Task<IActionResult> Delete(int id)
    {
        return await base.Delete(id);
    }

    public GroupsController(IGroupService service)
    {
        _service = service;
    }

    protected override Task<IEnumerable<GroupDto>> GetAllEntitiesAsync() => _service.GetAllAsync();
    protected override Task<GroupDto?> GetEntityByIdAsync(int id) => _service.GetByIdAsync(id);
    protected override Task DeleteEntityAsync(int id) => _service.DeleteAsync(id);

    [HttpPost]
    [Authorize(Policy = "RequirePermission:admin.manage")]
    [ProducesResponseType(StatusCodes.Status201Created)]
    public async Task<IActionResult> Create([FromBody] CreateGroupDto dto)
    {
        var created = await _service.CreateAsync(dto);
        return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
    }

    [HttpPut("{id}")]
    [Authorize(Policy = "RequirePermission:admin.manage")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Update(int id, [FromBody] UpdateGroupDto dto)
    {
        try
        {
            await _service.UpdateAsync(id, dto);
            return NoContent();
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }

    [HttpPost("{id}/members/{userId}")]
    [Authorize(Policy = "RequirePermission:admin.manage")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> AddMember(int id, int userId)
    {
        await _service.AddMemberAsync(id, userId);
        return NoContent();
    }

    [HttpDelete("{id}/members/{userId}")]
    [Authorize(Policy = "RequirePermission:admin.manage")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> RemoveMember(int id, int userId)
    {
        await _service.RemoveMemberAsync(id, userId);
        return NoContent();
    }
}
