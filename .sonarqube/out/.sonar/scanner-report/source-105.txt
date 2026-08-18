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

    public GroupService(IRepository<Group> repository, ItsToolDbContext context)
    {
        _repository = repository;
        _context = context;
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
        
        group.Name = dto.Name;
        group.IsActive = dto.IsActive;
        group.DepartmentId = dto.DepartmentId;
        await _repository.UpdateAsync(group);
    }

    public async Task DeleteAsync(int id)
    {
        await _repository.DeleteAsync(id);
    }

    public async Task AddMemberAsync(int groupId, int userId)
    {
        var exists = await _context.GroupMembers.AnyAsync(gm => gm.GroupId == groupId && gm.UserId == userId);
        if (!exists)
        {
            _context.GroupMembers.Add(new GroupMember { GroupId = groupId, UserId = userId });
            await _context.SaveChangesAsync();
        }
    }

    public async Task RemoveMemberAsync(int groupId, int userId)
    {
        var member = await _context.GroupMembers.FirstOrDefaultAsync(gm => gm.GroupId == groupId && gm.UserId == userId);
        if (member != null)
        {
            _context.GroupMembers.Remove(member);
            await _context.SaveChangesAsync();
        }
    }
}
