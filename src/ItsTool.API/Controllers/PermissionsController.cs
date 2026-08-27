using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Auth;
using ItsTool.Infrastructure.Data;
using ItsTool.Infrastructure.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class PermissionsController : ControllerBase
{
    private readonly ItsToolDbContext _context;
    private readonly IPermissionCalculator _permissionCalculator;

    public PermissionsController(ItsToolDbContext context, IPermissionCalculator permissionCalculator)
    {
        _context = context;
        _permissionCalculator = permissionCalculator;
    }
    
    private async Task EnforceAdminAccessAsync(int userId)
    {
        var perms = await _permissionCalculator.CalculateEffectivePermissionsAsync(userId);
        if (!perms.Contains("admin.manage"))
            throw new UnauthorizedAccessException("Only SuperAdmins can manage permissions.");
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var perms = await _context.Permissions.Select(p => new PermissionDto(p.Id, p.Name, p.Key, p.Description)).ToListAsync();
        return Ok(perms);
    }
    
    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id)
    {
        var p = await _context.Permissions.FindAsync(id);
        if (p == null) return NotFound();
        return Ok(new PermissionDto(p.Id, p.Name, p.Key, p.Description));
    }
    
    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreatePermissionDto dto)
    {
        try
        {
            var userId = int.Parse(User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value ?? "0");
            await EnforceAdminAccessAsync(userId);
            
            var p = new Permission { Name = dto.Name, Key = dto.Key, Description = dto.Description };
            _context.Permissions.Add(p);
            await _context.SaveChangesAsync();
            return Ok(new PermissionDto(p.Id, p.Name, p.Key, p.Description));
        }
        catch (UnauthorizedAccessException ex) { return Forbid(ex.Message); }
    }
    
    [HttpPut("{id}")]
    public async Task<IActionResult> Update(int id, [FromBody] UpdatePermissionDto dto)
    {
        try
        {
            var userId = int.Parse(User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value ?? "0");
            await EnforceAdminAccessAsync(userId);
            
            var p = await _context.Permissions.FindAsync(id);
            if (p == null) return NotFound();
            
            p.Name = dto.Name;
            p.Key = dto.Key;
            p.Description = dto.Description;
            await _context.SaveChangesAsync();
            return Ok(new PermissionDto(p.Id, p.Name, p.Key, p.Description));
        }
        catch (UnauthorizedAccessException ex) { return Forbid(ex.Message); }
    }
    
    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        try
        {
            var userId = int.Parse(User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value ?? "0");
            await EnforceAdminAccessAsync(userId);
            
            var p = await _context.Permissions.FindAsync(id);
            if (p == null) return NotFound();
            
            _context.Permissions.Remove(p);
            await _context.SaveChangesAsync();
            return NoContent();
        }
        catch (UnauthorizedAccessException ex) { return Forbid(ex.Message); }
    }
}
