using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize(Policy = "RequirePermission:admin.manage")]
public class RolesController : CrudControllerBase<RoleDto, CreateRoleDto, UpdateRoleDto>
{
    private readonly IRoleService _service;

    public RolesController(IRoleService service)
    {
        _service = service;
    }

    protected override Task<IEnumerable<RoleDto>> GetAllEntitiesAsync() => _service.GetAllAsync();
    protected override Task<RoleDto?> GetEntityByIdAsync(int id) => _service.GetByIdAsync(id);
    protected override Task<RoleDto> CreateEntityAsync(CreateRoleDto dto) => _service.CreateAsync(dto);
    protected override Task UpdateEntityAsync(int id, UpdateRoleDto dto) => _service.UpdateAsync(id, dto);
    protected override Task DeleteEntityAsync(int id) => _service.DeleteAsync(id);
    protected override int GetEntityId(RoleDto dto) => dto.Id;

}
