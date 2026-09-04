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
        var roles = await _context.Roles
            .Include(r => r.RolePermissions)
                .ThenInclude(rp => rp.Permission)
            .ToListAsync();
            
        return roles.Select(r => new RoleDto(
            r.Id, 
            r.Name, 
            r.Description, 
            r.IsActive, 
            r.RolePermissions.Select(rp => rp.Permission!.Key).ToArray()
        ));
    }

    public async Task<RoleDto?> GetByIdAsync(int id)
    {
        var r = await _context.Roles
            .Include(r => r.RolePermissions)
                .ThenInclude(rp => rp.Permission)
            .FirstOrDefaultAsync(x => x.Id == id);
            
        if (r == null) return null;
        return new RoleDto(
            r.Id, 
            r.Name, 
            r.Description, 
            r.IsActive, 
            r.RolePermissions.Select(rp => rp.Permission!.Key).ToArray()
        );
    }

    public async Task<RoleDto> CreateAsync(CreateRoleDto dto)
    {
        var r = new Role { Name = dto.Name, Description = dto.Description };
        await _repository.AddAsync(r);
        
        if (dto.Permissions != null && dto.Permissions.Length > 0)
        {
            var pIds = await _context.Permissions
                .Where(p => dto.Permissions.Contains(p.Key))
                .Select(p => p.Id)
                .ToListAsync();
                
            foreach (var pId in pIds)
            {
                _context.RolePermissions.Add(new RolePermission { RoleId = r.Id, PermissionId = pId });
            }
            await _context.SaveChangesAsync();
        }
        
        return new RoleDto(r.Id, r.Name, r.Description, r.IsActive, dto.Permissions ?? Array.Empty<string>());
    }

    public async Task UpdateAsync(int id, UpdateRoleDto dto)
    {
        var r = await _context.Roles
            .Include(r => r.RolePermissions)
                .ThenInclude(rp => rp.Permission)
            .FirstOrDefaultAsync(x => x.Id == id);
            
        if (r == null) throw new KeyNotFoundException("Role not found");
        
        r.Name = dto.Name;
        r.Description = dto.Description;
        r.IsActive = dto.IsActive;
        
        if (dto.Permissions != null)
        {
            var dbPerms = await _context.Permissions.ToListAsync();
            var targetKeys = dto.Permissions;
            
            // Remove permissions not in targetKeys
            var toRemove = r.RolePermissions.Where(rp => !targetKeys.Contains(rp.Permission!.Key)).ToList();
            foreach (var rm in toRemove)
            {
                _context.RolePermissions.Remove(rm);
            }
            
            // Add new permissions
            var currentKeys = r.RolePermissions.Select(rp => rp.Permission!.Key).ToList();
            var newKeys = targetKeys.Except(currentKeys).ToList();
            var newIds = dbPerms.Where(p => newKeys.Contains(p.Key)).Select(p => p.Id).ToList();
            
            foreach (var nId in newIds)
            {
                _context.RolePermissions.Add(new RolePermission { RoleId = r.Id, PermissionId = nId });
            }
        }
        
        await _context.SaveChangesAsync();
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
