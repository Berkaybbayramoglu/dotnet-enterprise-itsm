using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.Infrastructure.Services;

public class GroupService : IGroupService
{
    private readonly IRepository<Group> _repository;
    private readonly ItsToolDbContext _context;
    private readonly Microsoft.AspNetCore.Http.IHttpContextAccessor _httpContextAccessor;

    public GroupService(IRepository<Group> repository, ItsToolDbContext context, Microsoft.AspNetCore.Http.IHttpContextAccessor httpContextAccessor)
    {
        _repository = repository;
        _context = context;
        _httpContextAccessor = httpContextAccessor;
    }

    public async Task<IEnumerable<GroupDto>> GetAllAsync()
    {
        var groups = await _repository.GetAllAsync();
        return groups.Select(g => new GroupDto(g.Id, g.Name, g.IsActive, g.DepartmentId ?? 0));
    }

    public async Task<GroupDto?> GetByIdAsync(int id)
    {
        var group = await _repository.GetByIdAsync(id);
        if (group == null) return null;
        return new GroupDto(group.Id, group.Name, group.IsActive, group.DepartmentId ?? 0);
    }

    public async Task<GroupDto> CreateAsync(CreateGroupDto dto)
    {
        var group = new Group
        {
            Name = dto.Name,
            DepartmentId = dto.DepartmentId
        };
        await _repository.AddAsync(group);
        return new GroupDto(group.Id, group.Name, group.IsActive, group.DepartmentId ?? 0);
    }

    public async Task UpdateAsync(int id, UpdateGroupDto dto)
    {
        var group = await _repository.GetByIdAsync(id);
        if (group == null) throw new KeyNotFoundException("Group not found");
        
        if (group.DepartmentId != dto.DepartmentId)
        {
            var oldDept = group.DepartmentId.HasValue 
                ? await _context.Departments.FirstOrDefaultAsync(d => d.Id == group.DepartmentId) 
                : null;
            var newDept = dto.DepartmentId != 0 
                ? await _context.Departments.FirstOrDefaultAsync(d => d.Id == dto.DepartmentId) 
                : null;
                
            var currentUserId = _httpContextAccessor.HttpContext?.User?.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value ?? "0";
            
            _context.SystemAuditLogs.Add(new ItsTool.Domain.Entities.SystemAuditLog
            {
                EntityType = "Group",
                EntityId = group.Id.ToString(),
                EntityName = group.Name,
                Action = "Moved",
                FieldName = "DepartmentId",
                OldValue = oldDept?.Name ?? "None",
                NewValue = newDept?.Name ?? "None",
                CreatedBy = currentUserId
            });
        }
        
        group.Name = dto.Name;
        group.IsActive = dto.IsActive;
        group.DepartmentId = dto.DepartmentId;
        await _repository.UpdateAsync(group);
    }

    public async Task DeleteAsync(int id)
    {
        var assignments = await _context.TicketAssignments.Where(a => a.AssignedGroupId == id && !a.IsDeleted).ToListAsync();
        foreach (var assignment in assignments)
        {
            assignment.IsDeleted = true;
            assignment.IsActive = false;
        }
        await _context.SaveChangesAsync();
        await _repository.DeleteAsync(id);
    }

    public async Task AddMemberAsync(int groupId, int userId)
    {
        var exists = await _context.GroupMembers.AnyAsync(gm => gm.GroupId == groupId && gm.UserId == userId);
        if (!exists)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Id == userId);
            var group = await _context.Groups.FirstOrDefaultAsync(g => g.Id == groupId);
            
            _context.GroupMembers.Add(new GroupMember { GroupId = groupId, UserId = userId });
            
            if (user != null && group != null)
            {
                var currentUserId = _httpContextAccessor.HttpContext?.User?.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value ?? "0";
                _context.SystemAuditLogs.Add(new ItsTool.Domain.Entities.SystemAuditLog
                {
                    EntityType = "Group",
                    EntityId = group.Id.ToString(),
                    EntityName = group.Name,
                    Action = "MemberAdded",
                    FieldName = "Members",
                    OldValue = "-",
                    NewValue = user.Username,
                    CreatedBy = currentUserId
                });
            }
            
            await _context.SaveChangesAsync();
        }
    }

    public async Task RemoveMemberAsync(int groupId, int userId)
    {
        var member = await _context.GroupMembers.FirstOrDefaultAsync(gm => gm.GroupId == groupId && gm.UserId == userId);
        if (member != null)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Id == userId);
            var group = await _context.Groups.FirstOrDefaultAsync(g => g.Id == groupId);

            _context.GroupMembers.Remove(member);
            
            if (user != null && group != null)
            {
                var currentUserId = _httpContextAccessor.HttpContext?.User?.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value ?? "0";
                _context.SystemAuditLogs.Add(new ItsTool.Domain.Entities.SystemAuditLog
                {
                    EntityType = "Group",
                    EntityId = group.Id.ToString(),
                    EntityName = group.Name,
                    Action = "MemberRemoved",
                    FieldName = "Members",
                    OldValue = user.Username,
                    NewValue = "-",
                    CreatedBy = currentUserId
                });
            }
            
            await _context.SaveChangesAsync();
        }
    }
}
