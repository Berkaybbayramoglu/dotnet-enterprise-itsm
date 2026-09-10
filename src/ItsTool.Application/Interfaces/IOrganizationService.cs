using ItsTool.Application.DTOs;

namespace ItsTool.Application.Interfaces;

public interface IDepartmentService
{
    Task<IEnumerable<DepartmentDto>> GetAllAsync();
    Task<DepartmentDto?> GetByIdAsync(int id);
    Task<DepartmentDto> CreateAsync(CreateDepartmentDto dto);
    Task UpdateAsync(int id, UpdateDepartmentDto dto);
    Task DeleteAsync(int id);
}

public interface IGroupService
{
    Task<IEnumerable<GroupDto>> GetAllAsync();
    Task<GroupDto?> GetByIdAsync(int id);
    Task<GroupDto> CreateAsync(CreateGroupDto dto);
    Task UpdateAsync(int id, UpdateGroupDto dto);
    Task DeleteAsync(int id);
    Task AddMemberAsync(int groupId, int userId);
    Task RemoveMemberAsync(int groupId, int userId);
}

public interface IUserService
{
    Task<IEnumerable<UserDto>> GetAllAsync();
    Task<UserDto?> GetByIdAsync(int id);
    Task<UserDto> CreateAsync(CreateUserDto dto);
    Task UpdateAsync(int id, UpdateUserDto dto);
    Task DeleteAsync(int id);
    Task AssignRoleAsync(int userId, int roleId);
    Task RevokeRoleAsync(int userId, int roleId);
    Task AddPermissionOverrideAsync(int userId, int permissionId, bool isGranted);
    Task RemovePermissionOverrideAsync(int userId, int permissionId);
    Task ResetPasswordAsync(int userId, string newPassword);
}

public interface IProjectService
{
    Task<IEnumerable<ProjectDto>> GetAllAsync();
    Task<ProjectDto?> GetByIdAsync(int id);
    Task<ProjectDto> CreateAsync(CreateProjectDto dto);
    Task UpdateAsync(int id, UpdateProjectDto dto);
    Task DeleteAsync(int id);
    Task AddMemberAsync(int projectId, int userId);
    Task RemoveMemberAsync(int projectId, int userId);
}

public interface IRoleService
{
    Task<IEnumerable<RoleDto>> GetAllAsync();
    Task<RoleDto?> GetByIdAsync(int id);
    Task<RoleDto> CreateAsync(CreateRoleDto dto);
    Task UpdateAsync(int id, UpdateRoleDto dto);
    Task DeleteAsync(int id);
    Task AssignPermissionAsync(int roleId, int permissionId);
    Task RevokePermissionAsync(int roleId, int permissionId);
}
