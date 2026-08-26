using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize(Policy = "RequirePermission:admin.manage")]
public class GroupsController : CrudControllerBase<GroupDto, CreateGroupDto, UpdateGroupDto>
{
    private readonly IGroupService _service;

    public GroupsController(IGroupService service)
    {
        _service = service;
    }

    protected override Task<IEnumerable<GroupDto>> GetAllEntitiesAsync() => _service.GetAllAsync();
    protected override Task<GroupDto?> GetEntityByIdAsync(int id) => _service.GetByIdAsync(id);
    protected override Task<GroupDto> CreateEntityAsync(CreateGroupDto dto) => _service.CreateAsync(dto);
    protected override Task UpdateEntityAsync(int id, UpdateGroupDto dto) => _service.UpdateAsync(id, dto);
    protected override Task DeleteEntityAsync(int id) => _service.DeleteAsync(id);
    protected override int GetEntityId(GroupDto dto) => dto.Id;

    [HttpPost("{id}/members/{userId}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> AddMember(int id, int userId)
    {
        await _service.AddMemberAsync(id, userId);
        return NoContent();
    }

    [HttpDelete("{id}/members/{userId}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> RemoveMember(int id, int userId)
    {
        await _service.RemoveMemberAsync(id, userId);
        return NoContent();
    }
}
