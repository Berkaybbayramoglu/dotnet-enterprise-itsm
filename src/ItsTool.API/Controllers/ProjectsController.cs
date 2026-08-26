using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize(Policy = "RequirePermission:admin.manage")]
public class ProjectsController : CrudControllerBase<ProjectDto, CreateProjectDto, UpdateProjectDto>
{
    private readonly IProjectService _service;

    public ProjectsController(IProjectService service)
    {
        _service = service;
    }

    protected override Task<IEnumerable<ProjectDto>> GetAllEntitiesAsync() => _service.GetAllAsync();
    protected override Task<ProjectDto?> GetEntityByIdAsync(int id) => _service.GetByIdAsync(id);
    protected override Task<ProjectDto> CreateEntityAsync(CreateProjectDto dto) => _service.CreateAsync(dto);
    protected override Task UpdateEntityAsync(int id, UpdateProjectDto dto) => _service.UpdateAsync(id, dto);
    protected override Task DeleteEntityAsync(int id) => _service.DeleteAsync(id);
    protected override int GetEntityId(ProjectDto dto) => dto.Id;

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
