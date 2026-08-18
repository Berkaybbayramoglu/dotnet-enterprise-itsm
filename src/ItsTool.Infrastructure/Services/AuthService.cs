using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace ItsTool.Infrastructure.Services;

public class AuthService : IAuthService
{
    private readonly ItsToolDbContext _context;
    private readonly ITokenService _tokenService;
    private readonly IPermissionCalculator _permissionCalculator;
    private readonly IConfiguration _configuration;

    public AuthService(
        ItsToolDbContext context, 
        ITokenService tokenService, 
        IPermissionCalculator permissionCalculator,
        IConfiguration configuration)
    {
        _context = context;
        _tokenService = tokenService;
        _permissionCalculator = permissionCalculator;
        _configuration = configuration;
    }

    public async Task<AuthResponseDto> LoginAsync(LoginRequestDto request)
    {

        var user = await _context.Users
            .FirstOrDefaultAsync(u => 
                (u.Username.Equals(request.Username, StringComparison.OrdinalIgnoreCase) || 
                 u.Email.Equals(request.Username, StringComparison.OrdinalIgnoreCase)) && 
                u.IsActive && !u.IsDeleted);

        if (user == null || !BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash))
        {
            throw new UnauthorizedAccessException("Invalid credentials.");
        }

        var roles = await _context.UserRoles
            .Where(ur => ur.UserId == user.Id && ur.Role != null && ur.Role.IsActive)
            .Select(ur => ur.Role!.Name)
            .ToListAsync();

        var permissions = await _permissionCalculator.CalculateEffectivePermissionsAsync(user.Id);

        var token = _tokenService.GenerateToken(user.Id, user.Username, roles, permissions);

        var expiryMinutes = double.Parse(_configuration["Jwt:ExpiryMinutes"] ?? "120");

        return new AuthResponseDto(
            Token: token,
            ExpiresAt: DateTime.UtcNow.AddMinutes(expiryMinutes),
            Username: user.Username,
            Roles: roles,
            Permissions: permissions
        );
    }

    public async Task<MeResponseDto> GetMeAsync(int userId)
    {
        var user = await _context.Users
            .FirstOrDefaultAsync(u => u.Id == userId && u.IsActive && !u.IsDeleted);

        if (user == null)
            throw new UnauthorizedAccessException("User not found.");

        var roles = await _context.UserRoles
            .Where(ur => ur.UserId == user.Id && ur.Role != null && ur.Role.IsActive)
            .Select(ur => ur.Role!.Name)
            .ToListAsync();

        var groups = await _context.GroupMembers
            .Where(gm => gm.UserId == user.Id && gm.Group != null && gm.Group.IsActive)
            .Select(gm => gm.Group!.Name)
            .ToListAsync();

        var permissions = await _permissionCalculator.CalculateEffectivePermissionsAsync(user.Id);

        return new MeResponseDto(
            Id: user.Id,
            Username: user.Username,
            Email: user.Email,
            Groups: groups,
            Roles: roles,
            Permissions: permissions
        );
    }
}
