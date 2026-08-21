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

    public UserService(IRepository<User> repository, ItsToolDbContext context)
    {
        _repository = repository;
        _context = context;
    }

    public async Task<IEnumerable<UserDto>> GetAllAsync()
    {
        var users = await _context.Users.Include(u => u.UserRoles).Include(u => u.PermissionOverrides).ToListAsync();
        return users.Select(u => new UserDto(
            u.Id, u.Username, u.Email, u.FirstName, u.LastName, u.IsActive, u.DepartmentId,
            u.UserRoles.Select(ur => ur.RoleId).ToArray(),
            u.PermissionOverrides.ToDictionary(po => po.PermissionId, po => po.IsGranted)
        ));
    }

    public async Task<UserDto?> GetByIdAsync(int id)
    {
        var user = await _context.Users.Include(u => u.UserRoles).Include(u => u.PermissionOverrides).FirstOrDefaultAsync(u => u.Id == id);
        if (user == null) return null;
        return new UserDto(
            user.Id, user.Username, user.Email, user.FirstName, user.LastName, user.IsActive, user.DepartmentId,
            user.UserRoles.Select(ur => ur.RoleId).ToArray(),
            user.PermissionOverrides.ToDictionary(po => po.PermissionId, po => po.IsGranted)
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
            DepartmentId = dto.DepartmentId
        };
        await _repository.AddAsync(user);
        return new UserDto(user.Id, user.Username, user.Email, user.FirstName, user.LastName, user.IsActive, user.DepartmentId, Array.Empty<int>(), new Dictionary<int, bool>());
    }

    public async Task UpdateAsync(int id, UpdateUserDto dto)
    {
        var user = await _repository.GetByIdAsync(id);
        if (user == null) throw new KeyNotFoundException("User not found");
        
        user.Email = dto.Email;
        user.FirstName = dto.FirstName;
        user.LastName = dto.LastName;
        user.IsActive = dto.IsActive;
        user.DepartmentId = dto.DepartmentId;
        await _repository.UpdateAsync(user);
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
