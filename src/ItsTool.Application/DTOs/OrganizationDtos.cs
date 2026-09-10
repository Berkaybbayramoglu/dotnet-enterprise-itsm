namespace ItsTool.Application.DTOs;

public record DepartmentDto(int Id, string Name, string? Description, bool IsActive, string? Color);
public record CreateDepartmentDto(string Name, string? Description, string? Color);
public record UpdateDepartmentDto(string Name, string? Description, bool IsActive, string? Color);

public record GroupDto(int Id, string Name, bool IsActive, int DepartmentId);
public record CreateGroupDto(string Name, int DepartmentId);
public record UpdateGroupDto(string Name, bool IsActive, int DepartmentId);

public record UserDto(int Id, string Username, string Email, string FirstName, string LastName, bool IsActive, int? DepartmentId, int[] RoleIds, Dictionary<int, bool> PermissionOverrides, string? ProfilePhoto, int[] GroupIds, DateTime CreatedAt);
public record CreateUserDto(string Username, string Email, string FirstName, string LastName, string Password, int? DepartmentId, string? ProfilePhoto, int[]? GroupIds);
public record UpdateUserDto(string Email, string FirstName, string LastName, bool IsActive, int? DepartmentId, string? ProfilePhoto, int[]? GroupIds, string? Password = null);
public record ResetPasswordDto(string NewPassword);

public record ProjectDto(int Id, string Name, string ProjectKey, string? Description, string Status);
public record CreateProjectDto(string Name, string ProjectKey, string? Description);
public record UpdateProjectDto(string Name, string ProjectKey, string? Description, string Status);

public record RoleDto(int Id, string Name, string? Description, bool IsActive, string[]? Permissions);
public record CreateRoleDto(string Name, string? Description, string[]? Permissions);
public record UpdateRoleDto(string Name, string? Description, bool IsActive, string[]? Permissions);

public record PermissionDto(int Id, string Name, string Key, string? Description);
public record CreatePermissionDto(string Name, string Key, string? Description);
public record UpdatePermissionDto(string Name, string Key, string? Description);
