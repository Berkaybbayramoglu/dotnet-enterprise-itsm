namespace ItsTool.Application.DTOs;

public record LoginRequestDto(string Username, string Password);

public record AuthResponseDto(
    string Token, 
    DateTime ExpiresAt, 
    string Username, 
    IEnumerable<string> Roles, 
    IEnumerable<string> Permissions);

public record MeResponseDto(
    int Id, 
    string Username, 
    string Email, 
    IEnumerable<string> Groups, 
    IEnumerable<string> Roles, 
    IEnumerable<string> Permissions);
