using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Project;
using ItsTool.Domain.Enums;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.Infrastructure.Services;

public class ProjectService : IProjectService
{
    private readonly IRepository<Project> _repository;
    private readonly ItsToolDbContext _context;

    public ProjectService(IRepository<Project> repository, ItsToolDbContext context)
    {
        _repository = repository;
        _context = context;
    }

    public async Task<IEnumerable<ProjectDto>> GetAllAsync()
    {
        var projects = await _repository.GetAllAsync();
        return projects.Select(p => new ProjectDto(p.Id, p.Name, p.ProjectKey, p.Description, p.Status.ToString()));
    }

    public async Task<ProjectDto?> GetByIdAsync(int id)
    {
        var p = await _repository.GetByIdAsync(id);
        if (p == null) return null;
        return new ProjectDto(p.Id, p.Name, p.ProjectKey, p.Description, p.Status.ToString());
    }

    public async Task<ProjectDto> CreateAsync(CreateProjectDto dto)
    {
        var p = new Project
        {
            Name = dto.Name,
            ProjectKey = dto.ProjectKey,
            Description = dto.Description,
            Status = ProjectStatus.Active
        };
        await _repository.AddAsync(p);
        return new ProjectDto(p.Id, p.Name, p.ProjectKey, p.Description, p.Status.ToString());
    }

    public async Task UpdateAsync(int id, UpdateProjectDto dto)
    {
        var p = await _repository.GetByIdAsync(id);
        if (p == null) throw new KeyNotFoundException("Project not found");
        
        p.Name = dto.Name;
        p.ProjectKey = dto.ProjectKey;
        p.Description = dto.Description;

        if (Enum.TryParse<ProjectStatus>(dto.Status, true, out var status))
        {
            p.Status = status;
        }

        await _repository.UpdateAsync(p);
    }

    public async Task DeleteAsync(int id)
    {
        await _repository.DeleteAsync(id);
    }

    public async Task AddMemberAsync(int projectId, int userId)
    {
        var exists = await _context.ProjectMembers.AnyAsync(pm => pm.ProjectId == projectId && pm.UserId == userId);
        if (!exists)
        {
            _context.ProjectMembers.Add(new ProjectMember { ProjectId = projectId, UserId = userId });
            await _context.SaveChangesAsync();
        }
    }

    public async Task RemoveMemberAsync(int projectId, int userId)
    {
        var pm = await _context.ProjectMembers.FirstOrDefaultAsync(x => x.ProjectId == projectId && x.UserId == userId);
        if (pm != null)
        {
            _context.ProjectMembers.Remove(pm);
            await _context.SaveChangesAsync();
        }
    }
}
