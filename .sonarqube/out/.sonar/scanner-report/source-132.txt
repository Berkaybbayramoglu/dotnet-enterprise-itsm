using ItsTool.Application.DTOs;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Infrastructure.Data;
using ItsTool.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class GroupServiceTests : TestBase
{
    private readonly Repository<Group> _repository;
    private readonly GroupService _service;

    public GroupServiceTests()
    {
        _repository = new Repository<Group>(_context);
        _service = new GroupService(_repository, _context);
    }

    [Fact]
    public async Task CreateAsync_ShouldCreateGroup()
    {
        var dto = new CreateGroupDto("Helpdesk", 1);
        var result = await _service.CreateAsync(dto);

        Assert.NotNull(result);
        Assert.Equal("Helpdesk", result.Name);
        Assert.Equal(1, result.DepartmentId);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdateGroup()
    {
        var group = new Group { Name = "OldName", DepartmentId = 1 };
        _context.Groups.Add(group);
        await _context.SaveChangesAsync();

        var dto = new UpdateGroupDto("NewName", true, 2);
        await _service.UpdateAsync(group.Id, dto);

        var updated = await _context.Groups.FindAsync(group.Id);
        Assert.Equal("NewName", updated!.Name);
        Assert.Equal(2, updated.DepartmentId);
    }

    [Fact]
    public async Task DeleteAsync_ShouldSoftDeleteGroup()
    {
        var group = new Group { Name = "ToDelete", DepartmentId = 1 };
        _context.Groups.Add(group);
        await _context.SaveChangesAsync();

        await _service.DeleteAsync(group.Id);

        var deleted = await _context.Groups.FindAsync(group.Id);
        Assert.True(deleted!.IsDeleted);
        Assert.NotNull(deleted.DeletedAt);
    }
}
