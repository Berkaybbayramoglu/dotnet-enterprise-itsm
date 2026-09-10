using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class UsersController : ControllerBase
{
    private readonly IUserService _service;

    public UsersController(IUserService service)
    {
        _service = service;
    }

    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<UserDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetAll()
    {
        var users = await _service.GetAllAsync();
        
        bool isAdmin = User.HasClaim("permission", "admin.manage") || User.IsInRole("SuperAdmin");
        if (!isAdmin)
        {
            users = users.Select(u => u with { 
                Email = "", 
                RoleIds = System.Array.Empty<int>(), 
                PermissionOverrides = new Dictionary<int, bool>() 
            });
        }
        
        return Ok(users);
    }

    [HttpGet("{id}")]
    [ProducesResponseType(typeof(UserDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetById(int id)
    {
        var user = await _service.GetByIdAsync(id);
        if (user == null) return NotFound();
        bool isAdmin = User.HasClaim("permission", "admin.manage") || User.IsInRole("SuperAdmin");
        if (!isAdmin)
        {
            user = user with { 
                Email = "", 
                RoleIds = System.Array.Empty<int>(), 
                PermissionOverrides = new Dictionary<int, bool>() 
            };
        }
        
        return Ok(user);
    }

    [HttpPost]
    [Authorize(Policy = "RequirePermission:admin.manage")]
    [ProducesResponseType(typeof(UserDto), StatusCodes.Status201Created)]
    public async Task<IActionResult> Create([FromBody] CreateUserDto dto)
    {
        var created = await _service.CreateAsync(dto);
        return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
    }

    [HttpPut("{id}")]
    [Authorize(Policy = "RequirePermission:admin.manage")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Update(int id, [FromBody] UpdateUserDto dto)
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

    [HttpDelete("{id}")]
    [Authorize(Policy = "RequirePermission:admin.manage")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(int id)
    {
        try
        {
            await _service.DeleteAsync(id);
            return NoContent();
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }

    [HttpPost("{id}/roles/{roleId}")]
    [Authorize(Policy = "RequirePermission:admin.manage")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> AssignRole(int id, int roleId)
    {
        await _service.AssignRoleAsync(id, roleId);
        return NoContent();
    }

    [HttpDelete("{id}/roles/{roleId}")]
    [Authorize(Policy = "RequirePermission:admin.manage")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> RevokeRole(int id, int roleId)
    {
        await _service.RevokeRoleAsync(id, roleId);
        return NoContent();
    }

    [HttpPost("{id}/permissions/{permissionId}")]
    [Authorize(Policy = "RequirePermission:admin.manage")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> SetPermissionOverride(int id, int permissionId, [FromQuery] bool isGranted)
    {
        await _service.AddPermissionOverrideAsync(id, permissionId, isGranted);
        return NoContent();
    }

    [HttpDelete("{id}/permissions/{permissionId}")]
    [Authorize(Policy = "RequirePermission:admin.manage")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> RemovePermissionOverride(int id, int permissionId)
    {
        await _service.RemovePermissionOverrideAsync(id, permissionId);
        return NoContent();
    }

    [HttpPost("{id}/reset-password")]
    [Authorize(Policy = "RequirePermission:admin.manage")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> ResetPassword(int id, [FromBody] ResetPasswordDto dto)
    {
        if (string.IsNullOrWhiteSpace(dto.NewPassword))
            return BadRequest(new { message = "Yeni şifre boş olamaz." });

        try
        {
            await _service.ResetPasswordAsync(id, dto.NewPassword);
            return NoContent();
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }
}
