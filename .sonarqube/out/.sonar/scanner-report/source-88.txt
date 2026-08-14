using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Auth;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.Infrastructure.Services;

public class RoleService : IRoleService
{
    private readonly IRepository<Role> _repository;
    private readonly ItsToolDbContext _context;

    public RoleService(IRepository<Role> repository, ItsToolDbContext context)
    {
        _repository = repository;
        _context = context;
    }

    public async Task<IEnumerable<RoleDto>> GetAllAsync()
    {
        var roles = await _repository.GetAllAsync();
        return roles.Select(r => new RoleDto(r.Id, r.Name, r.IsActive));
    }

    public async Task<RoleDto?> GetByIdAsync(int id)
    {
        var r = await _repository.GetByIdAsync(id);
        if (r == null) return null;
        return new RoleDto(r.Id, r.Name, r.IsActive);
    }

    public async Task<RoleDto> CreateAsync(CreateRoleDto dto)
    {
        var r = new Role { Name = dto.Name };
        await _repository.AddAsync(r);
        return new RoleDto(r.Id, r.Name, r.IsActive);
    }

    public async Task UpdateAsync(int id, UpdateRoleDto dto)
    {
        var r = await _repository.GetByIdAsync(id);
        if (r == null) throw new KeyNotFoundException("Role not found");
        
        r.Name = dto.Name;
        r.IsActive = dto.IsActive;
        await _repository.UpdateAsync(r);
    }

    public async Task DeleteAsync(int id)
    {
        await _repository.DeleteAsync(id);
    }

    public async Task AssignPermissionAsync(int roleId, int permissionId)
    {
        var exists = await _context.RolePermissions.AnyAsync(rp => rp.RoleId == roleId && rp.PermissionId == permissionId);
        if (!exists)
        {
            _context.RolePermissions.Add(new RolePermission { RoleId = roleId, PermissionId = permissionId });
            await _context.SaveChangesAsync();
        }
    }

    public async Task RevokePermissionAsync(int roleId, int permissionId)
    {
        var rp = await _context.RolePermissions.FirstOrDefaultAsync(x => x.RoleId == roleId && x.PermissionId == permissionId);
        if (rp != null)
        {
            _context.RolePermissions.Remove(rp);
            await _context.SaveChangesAsync();
        }
    }
}
