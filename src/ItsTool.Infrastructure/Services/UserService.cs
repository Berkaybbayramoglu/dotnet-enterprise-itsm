using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Auth;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.Infrastructure.Services;

public class UserService : IUserService
{
    private readonly IRepository<User> _repository;
    private readonly ItsToolDbContext _context;
    private readonly Microsoft.AspNetCore.Http.IHttpContextAccessor _httpContextAccessor;

    public UserService(IRepository<User> repository, ItsToolDbContext context, Microsoft.AspNetCore.Http.IHttpContextAccessor httpContextAccessor)
    {
        _repository = repository;
        _context = context;
        _httpContextAccessor = httpContextAccessor;
    }

    public async Task<IEnumerable<UserDto>> GetAllAsync()
    {
        var users = await _context.Users.Where(u => !u.IsDeleted).Include(u => u.UserRoles).Include(u => u.PermissionOverrides).Include(u => u.GroupMemberships).ToListAsync();
        return users.Select(u => new UserDto(
            u.Id, u.Username, u.Email, u.FirstName, u.LastName, u.IsActive, u.DepartmentId,
            u.UserRoles.Select(ur => ur.RoleId).ToArray(),
            u.PermissionOverrides.ToDictionary(po => po.PermissionId, po => po.IsGranted),
            u.ProfilePhoto,
            u.GroupMemberships.Select(gm => gm.GroupId).ToArray(),
            u.CreatedAt
        ));
    }

    public async Task<UserDto?> GetByIdAsync(int id)
    {
        var user = await _context.Users.Where(u => !u.IsDeleted).Include(u => u.UserRoles).Include(u => u.PermissionOverrides).Include(u => u.GroupMemberships).FirstOrDefaultAsync(u => u.Id == id);
        if (user == null) return null;
        return new UserDto(
            user.Id, user.Username, user.Email, user.FirstName, user.LastName, user.IsActive, user.DepartmentId,
            user.UserRoles.Select(ur => ur.RoleId).ToArray(),
            user.PermissionOverrides.ToDictionary(po => po.PermissionId, po => po.IsGranted),
            user.ProfilePhoto,
            user.GroupMemberships.Select(gm => gm.GroupId).ToArray(),
            user.CreatedAt
        );
    }

    public async Task<UserDto> CreateAsync(CreateUserDto dto)
    {
        var user = new User
        {
            Username = dto.Username,
            Email = dto.Email,
            FirstName = dto.FirstName,
            LastName = dto.LastName,
            PasswordHash = BCrypt.Net.BCrypt.HashPassword(dto.Password),
            DepartmentId = dto.DepartmentId,
            ProfilePhoto = dto.ProfilePhoto
        };
        
        if (dto.GroupIds != null && dto.GroupIds.Length > 0)
        {
            foreach (var groupId in dto.GroupIds)
            {
                user.GroupMemberships.Add(new GroupMember { GroupId = groupId });
            }
        }
        
        await _repository.AddAsync(user);
        return new UserDto(user.Id, user.Username, user.Email, user.FirstName, user.LastName, user.IsActive, user.DepartmentId, Array.Empty<int>(), new Dictionary<int, bool>(), user.ProfilePhoto, user.GroupMemberships.Select(g => g.GroupId).ToArray(), user.CreatedAt);
    }

    public async Task UpdateAsync(int id, UpdateUserDto dto)
    {
        var user = await _context.Users.Include(u => u.GroupMemberships).FirstOrDefaultAsync(u => u.Id == id);
        if (user == null) throw new KeyNotFoundException("User not found");
        
        user.Email = dto.Email;
        user.FirstName = dto.FirstName;
        user.LastName = dto.LastName;
        user.IsActive = dto.IsActive;
        user.DepartmentId = dto.DepartmentId;
        
        if (user.ProfilePhoto != dto.ProfilePhoto)
        {
            var oldPhotoStr = string.IsNullOrEmpty(user.ProfilePhoto) ? "None" : "Photo Present";
            var newPhotoStr = string.IsNullOrEmpty(dto.ProfilePhoto) ? "None" : "Photo Present";
            
            var currentUserId = _httpContextAccessor.HttpContext?.User?.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value ?? "0";
            
            _context.SystemAuditLogs.Add(new ItsTool.Domain.Entities.SystemAuditLog
            {
                EntityType = "User",
                EntityId = user.Id.ToString(),
                EntityName = user.Username,
                Action = "ProfilePhotoUpdated",
                FieldName = "ProfilePhoto",
                OldValue = oldPhotoStr,
                NewValue = newPhotoStr,
                CreatedBy = currentUserId
            });
        }
        
        user.ProfilePhoto = dto.ProfilePhoto;
        
        if (dto.GroupIds != null)
        {
            var existingGroupIds = user.GroupMemberships.Select(g => g.GroupId).ToList();
            var newGroupIds = dto.GroupIds.ToList();
            
            var added = newGroupIds.Except(existingGroupIds).ToList();
            var removed = existingGroupIds.Except(newGroupIds).ToList();

            if (added.Count > 0 || removed.Count > 0)
            {
                var allGroupIds = existingGroupIds.Union(newGroupIds).Distinct().ToList();
                var groups = await _context.Groups.Where(g => allGroupIds.Contains(g.Id)).ToDictionaryAsync(g => g.Id, g => g.Name);

                var oldGroupNames = string.Join(", ", existingGroupIds.Select(id => groups.TryGetValue(id, out var name) ? name : id.ToString()));
                var newGroupNames = string.Join(", ", newGroupIds.Select(id => groups.TryGetValue(id, out var name) ? name : id.ToString()));

                var currentUserId = _httpContextAccessor.HttpContext?.User?.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value ?? "0";

                _context.SystemAuditLogs.Add(new ItsTool.Domain.Entities.SystemAuditLog
                {
                    EntityType = "User",
                    EntityId = user.Id.ToString(),
                    EntityName = user.Username,
                    Action = "Updated",
                    FieldName = "GroupMemberships",
                    OldValue = string.IsNullOrEmpty(oldGroupNames) ? "-" : oldGroupNames,
                    NewValue = string.IsNullOrEmpty(newGroupNames) ? "-" : newGroupNames,
                    CreatedBy = currentUserId
                });
            }

            var toRemove = user.GroupMemberships.Where(g => !newGroupIds.Contains(g.GroupId)).ToList();
            foreach (var rm in toRemove) user.GroupMemberships.Remove(rm);
            
            var toAdd = newGroupIds.Where(gid => !existingGroupIds.Contains(gid)).ToList();
            foreach (var addId in toAdd)
            {
                user.GroupMemberships.Add(new GroupMember { GroupId = addId });
            }
        }
        
        await _context.SaveChangesAsync();
    }

    public async Task DeleteAsync(int id)
    {
        await _repository.DeleteAsync(id);
    }

    public async Task AssignRoleAsync(int userId, int roleId)
    {
        var exists = await _context.UserRoles.AnyAsync(ur => ur.UserId == userId && ur.RoleId == roleId);
        if (!exists)
        {
            _context.UserRoles.Add(new UserRole { UserId = userId, RoleId = roleId });
            await _context.SaveChangesAsync();
        }
    }

    public async Task RevokeRoleAsync(int userId, int roleId)
    {
        var ur = await _context.UserRoles.FirstOrDefaultAsync(x => x.UserId == userId && x.RoleId == roleId);
        if (ur != null)
        {
            _context.UserRoles.Remove(ur);
            await _context.SaveChangesAsync();
        }
    }

    public async Task AddPermissionOverrideAsync(int userId, int permissionId, bool isGranted)
    {
        var over = await _context.UserPermissionOverrides
            .FirstOrDefaultAsync(o => o.UserId == userId && o.PermissionId == permissionId);
            
        if (over != null)
        {
            over.IsGranted = isGranted;
        }
        else
        {
            _context.UserPermissionOverrides.Add(new UserPermissionOverride
            {
                UserId = userId,
                PermissionId = permissionId,
                IsGranted = isGranted
            });
        }
        await _context.SaveChangesAsync();
    }
}
