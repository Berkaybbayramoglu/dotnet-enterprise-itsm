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

    private readonly Microsoft.AspNetCore.Http.IHttpContextAccessor _httpContextAccessor;

    public GroupServiceTests()
    {
        _repository = new Repository<Group>(_context);
        
        var mockHttpContextAccessor = new Moq.Mock<Microsoft.AspNetCore.Http.IHttpContextAccessor>();
        var context = new Microsoft.AspNetCore.Http.DefaultHttpContext();
        var claims = new System.Security.Claims.ClaimsPrincipal(new System.Security.Claims.ClaimsIdentity(new[]
        {
            new System.Security.Claims.Claim(System.Security.Claims.ClaimTypes.NameIdentifier, "99")
        }));
        context.User = claims;
        mockHttpContextAccessor.Setup(x => x.HttpContext).Returns(context);
        _httpContextAccessor = mockHttpContextAccessor.Object;
        
        _service = new GroupService(_repository, _context, _httpContextAccessor);
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

    [Fact]
    public async Task UpdateAsync_DepartmentChange_ShouldCreateAuditLog()
    {
        var dept1 = new Department { Id = 1, Name = "Dept1" };
        var dept2 = new Department { Id = 2, Name = "Dept2" };
        _context.Departments.Add(dept1);
        _context.Departments.Add(dept2);
        
        var group = new Group { Name = "AuditGroup", DepartmentId = 1 };
        _context.Groups.Add(group);
        await _context.SaveChangesAsync();

        var dto = new UpdateGroupDto("AuditGroup", true, 2);
        await _service.UpdateAsync(group.Id, dto);

        var auditLog = await _context.SystemAuditLogs.FirstOrDefaultAsync(x => x.EntityType == "Group" && x.Action == "Moved");
        Assert.NotNull(auditLog);
        
        Assert.Equal("Dept1", auditLog.OldValue);
        Assert.Equal("Dept2", auditLog.NewValue);
        Assert.Equal("99", auditLog.CreatedBy);
    }
}
