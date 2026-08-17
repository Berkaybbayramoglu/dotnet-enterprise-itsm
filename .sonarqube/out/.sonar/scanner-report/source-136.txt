using ItsTool.Application.DTOs;
using ItsTool.Domain.Entities.Project;
using ItsTool.Infrastructure.Data;
using ItsTool.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class ProjectServiceTests : TestBase
{
    private readonly Repository<Project> _repository;
    private readonly ProjectService _service;

    public ProjectServiceTests()
    {
        _repository = new Repository<Project>(_context);
        _service = new ProjectService(_repository, _context);
    }

    [Fact]
    public async Task CreateAsync_ShouldCreateProject()
    {
        var dto = new CreateProjectDto("App", "APP", null);
        var result = await _service.CreateAsync(dto);

        Assert.NotNull(result);
        Assert.Equal("App", result.Name);
        Assert.Equal("APP", result.ProjectKey);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdateProject()
    {
        var proj = new Project { Name = "Old", ProjectKey = "OLD" };
        _context.Projects.Add(proj);
        await _context.SaveChangesAsync();

        var dto = new UpdateProjectDto("New", "NEW", null, true);
        await _service.UpdateAsync(proj.Id, dto);

        var updated = await _context.Projects.FindAsync(proj.Id);
        Assert.Equal("New", updated!.Name);
        Assert.Equal("NEW", updated.ProjectKey);
    }

    [Fact]
    public async Task DeleteAsync_ShouldSoftDeleteProject()
    {
        var proj = new Project { Name = "ToDelete", ProjectKey = "TD" };
        _context.Projects.Add(proj);
        await _context.SaveChangesAsync();

        await _service.DeleteAsync(proj.Id);

        var deleted = await _context.Projects.FindAsync(proj.Id);
        Assert.True(deleted!.IsDeleted);
        Assert.NotNull(deleted.DeletedAt);
    }
}
