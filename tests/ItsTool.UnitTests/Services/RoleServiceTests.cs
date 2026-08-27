using ItsTool.Application.DTOs;
using ItsTool.Domain.Entities.Auth;
using ItsTool.Infrastructure.Data;
using ItsTool.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class RoleServiceTests : TestBase
{
    private readonly Repository<Role> _repository;
    private readonly RoleService _service;

    public RoleServiceTests()
    {
        _repository = new Repository<Role>(_context);
        _service = new RoleService(_repository, _context);
    }

    [Fact]
    public async Task CreateAsync_ShouldCreateRole()
    {
        var dto = new CreateRoleDto("Manager", "Desc");
        var result = await _service.CreateAsync(dto);

        Assert.NotNull(result);
        Assert.Equal("Manager", result.Name);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdateRole()
    {
        var role = new Role { Name = "Old" };
        _context.Roles.Add(role);
        await _context.SaveChangesAsync();

        var dto = new UpdateRoleDto("New", "Desc", true);
        await _service.UpdateAsync(role.Id, dto);

        var updated = await _context.Roles.FindAsync(role.Id);
        Assert.Equal("New", updated!.Name);
    }

    [Fact]
    public async Task AssignPermissionAsync_ShouldAssignPermission()
    {
        var role = new Role { Name = "R1" };
        var perm = new Permission { Name = "P1", Key = "p1" };
        _context.Roles.Add(role);
        _context.Permissions.Add(perm);
        await _context.SaveChangesAsync();

        await _service.AssignPermissionAsync(role.Id, perm.Id);

        var assigned = await _context.RolePermissions.FirstOrDefaultAsync(rp => rp.RoleId == role.Id && rp.PermissionId == perm.Id);
        Assert.NotNull(assigned);
    }
}
