namespace ItsTool.Application.DTOs;

public record LoginRequestDto(string Username, string Password);

public record AuthResponseDto(
    string Token, 
    DateTime ExpiresAt, 
    string Username, 
    IEnumerable<string> Roles, 
    IEnumerable<string> Permissions,
    bool MustChangePassword = false);

public record MeResponseDto(
    int Id, 
    string Username, 
    string Email, 
    IEnumerable<string> Groups, 
    IEnumerable<string> Roles, 
    IEnumerable<string> Permissions,
    IEnumerable<string> Overrides,
    int KbArticleCount,
    string? ProfilePhoto,
    bool MustChangePassword = false);

public record ChangePasswordRequestDto(string NewPassword, string ConfirmPassword);
