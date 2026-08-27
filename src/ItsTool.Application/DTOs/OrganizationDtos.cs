namespace ItsTool.Application.DTOs;

public record DepartmentDto(int Id, string Name, string? Description, bool IsActive);
public record CreateDepartmentDto(string Name, string? Description);
public record UpdateDepartmentDto(string Name, string? Description, bool IsActive);

public record GroupDto(int Id, string Name, bool IsActive, int DepartmentId);
public record CreateGroupDto(string Name, int DepartmentId);
public record UpdateGroupDto(string Name, bool IsActive, int DepartmentId);

public record UserDto(int Id, string Username, string Email, string FirstName, string LastName, bool IsActive, int? DepartmentId, int[] RoleIds, Dictionary<int, bool> PermissionOverrides, string? ProfilePhoto);
public record CreateUserDto(string Username, string Email, string FirstName, string LastName, string Password, int? DepartmentId, string? ProfilePhoto);
public record UpdateUserDto(string Email, string FirstName, string LastName, bool IsActive, int? DepartmentId, string? ProfilePhoto);

public record ProjectDto(int Id, string Name, string ProjectKey, string? Description, string Status);
public record CreateProjectDto(string Name, string ProjectKey, string? Description);
public record UpdateProjectDto(string Name, string ProjectKey, string? Description, string Status);

public record RoleDto(int Id, string Name, string? Description, bool IsActive);
public record CreateRoleDto(string Name, string? Description);
public record UpdateRoleDto(string Name, string? Description, bool IsActive);
