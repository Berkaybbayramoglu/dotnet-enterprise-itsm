using ItsTool.Application.DTOs;

namespace ItsTool.Application.Interfaces;

public interface ITokenService
{
    string GenerateToken(int userId, string username, IEnumerable<string> roles, IEnumerable<string> permissions);
    string GenerateToken(int userId, string username, IEnumerable<string> roles, IEnumerable<string> permissions, bool mustChangePassword);
}

public interface IAuthService
{
    Task<AuthResponseDto> LoginAsync(LoginRequestDto request);
    Task<MeResponseDto> GetMeAsync(int userId);
    Task<AuthResponseDto> RefreshTokenAsync(int userId);
    Task<AuthResponseDto> ChangePasswordAsync(int userId, ChangePasswordRequestDto request);
}
