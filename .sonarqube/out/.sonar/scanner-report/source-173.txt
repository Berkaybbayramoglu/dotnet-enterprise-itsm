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

        // 0. SuperAdmin Check
        bool isSuperAdmin = await _context.UserRoles
            .Include(ur => ur.Role)
            .AnyAsync(ur => ur.UserId == userId && ur.Role != null && ur.Role.Name == "SuperAdmin" && ur.Role.IsActive && !ur.Role.IsDeleted && !ur.IsDeleted);

        if (isSuperAdmin)
        {
            var allPerms = await _context.Permissions
                .Where(p => p.IsActive && !p.IsDeleted)
                .Select(p => p.Key)
                .ToListAsync();
            return new HashSet<string>(allPerms);
        }

        // 1. Kullanıcının doğrudan rollerinden gelen yetkiler
        var userRolePerms = await _context.UserRoles
            .Where(ur => ur.UserId == userId && ur.Role != null && ur.Role.IsActive && !ur.Role.IsDeleted && !ur.IsDeleted)
            .Join(_context.RolePermissions, 
                  ur => ur.RoleId, 
                  rp => rp.RoleId, 
                  (ur, rp) => rp)
            .Where(rp => !rp.IsDeleted && rp.Permission != null && rp.Permission.IsActive && !rp.Permission.IsDeleted)
            .Select(rp => rp.Permission!.Key)
            .ToListAsync();
            
        foreach (var p in userRolePerms)
        {
            permissions.Add(p);
        }

        // 2. Kullanıcının dahil olduğu grupların rollerinden gelen yetkiler
        var groupRolePerms = await _context.GroupMembers
            .Where(gm => gm.UserId == userId && !gm.IsDeleted && gm.Group != null && gm.Group.IsActive && !gm.Group.IsDeleted)
            .Join(_context.GroupRoles, 
                  gm => gm.GroupId, 
                  gr => gr.GroupId, 
                  (gm, gr) => gr)
            .Where(gr => !gr.IsDeleted)
            .Join(_context.RolePermissions, 
                  gr => gr.RoleId, 
                  rp => rp.RoleId, 
                  (gr, rp) => rp)
            .Where(rp => !rp.IsDeleted && rp.Permission != null && rp.Permission.IsActive && !rp.Permission.IsDeleted)
            .Select(rp => rp.Permission!.Key)
            .ToListAsync();
            
        foreach (var p in groupRolePerms)
        {
            permissions.Add(p);
        }

        // 3. UserPermissionOverride tablosundaki spesifik yetkiler
        var overrides = await _context.UserPermissionOverrides
            .Include(o => o.Permission)
            .Where(o => o.UserId == userId && o.IsGranted && !o.IsDeleted && o.Permission != null && o.Permission.IsActive && !o.Permission.IsDeleted)
            .Select(o => o.Permission!.Key)
            .ToListAsync();

        foreach (var p in overrides)
        {
            permissions.Add(p);
        }

        return permissions;
    }
}
