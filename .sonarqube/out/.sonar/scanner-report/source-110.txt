using ItsTool.Application.Interfaces;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.Infrastructure.Services;

public class PermissionCalculator : IPermissionCalculator
{
    private readonly ItsToolDbContext _context;

    public PermissionCalculator(ItsToolDbContext context)
    {
        _context = context;
    }

    public async Task<HashSet<string>> CalculateEffectivePermissionsAsync(int userId)
    {
        var permissions = new HashSet<string>();

        // 1. Kullanıcının doğrudan rollerinden gelen yetkiler
        var userRolePerms = await _context.UserRoles
            .Where(ur => ur.UserId == userId && ur.Role != null && ur.Role.IsActive)
            .Join(_context.RolePermissions, 
                  ur => ur.RoleId, 
                  rp => rp.RoleId, 
                  (ur, rp) => rp.Permission)
            .Where(p => p != null && p.IsActive)
            .Select(p => p!.Key)
            .ToListAsync();
            
        foreach (var p in userRolePerms)
        {
            permissions.Add(p);
        }

        // 2. Kullanıcının dahil olduğu grupların rollerinden gelen yetkiler
        var groupRolePerms = await _context.GroupMembers
            .Where(gm => gm.UserId == userId)
            .Join(_context.GroupRoles, 
                  gm => gm.GroupId, 
                  gr => gr.GroupId, 
                  (gm, gr) => gr.RoleId)
            .Join(_context.RolePermissions, 
                  roleId => roleId, 
                  rp => rp.RoleId, 
                  (roleId, rp) => rp.Permission)
            .Where(p => p != null && p.IsActive)
            .Select(p => p!.Key)
            .ToListAsync();
            
        foreach (var p in groupRolePerms)
        {
            permissions.Add(p);
        }

        // 3. UserPermissionOverride tablosundaki spesifik yetkiler
        var overrides = await _context.UserPermissionOverrides
            .Include(o => o.Permission)
            .Where(o => o.UserId == userId && o.IsGranted && o.Permission != null && o.Permission.IsActive)
            .Select(o => o.Permission!.Key)
            .ToListAsync();

        foreach (var p in overrides)
        {
            permissions.Add(p);
        }

        return permissions;
    }
}
