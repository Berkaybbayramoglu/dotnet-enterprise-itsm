using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Domain.Entities.Auth;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Infrastructure.Data;
using ItsTool.Infrastructure.Services;
using Microsoft.AspNetCore.Http;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class OrganizationExtraServicesTests : TestBase
{
    private readonly RoleService _roleService;
    private readonly GroupService _groupService;
    private readonly Mock<IHttpContextAccessor> _httpContextMock = new();

    public OrganizationExtraServicesTests() : base()
    {
        var roleRepo = new Repository<Role>(_context);
        _roleService = new RoleService(roleRepo, _context);

        var groupRepo = new Repository<Group>(_context);
        _groupService = new GroupService(groupRepo, _context, _httpContextMock.Object);

        SeedData();
    }

    private void SeedData()
    {
        _context.Departments.Add(new Department { Id = 1, Name = "Security", IsActive = true });
        _context.Permissions.Add(new Permission { Id = 1, Key = "ticket.view", Name = "View Tickets" });
        _context.Users.Add(new User { Id = 1, Username = "member1", Email = "m1@test.com", FirstName = "M1", LastName = "L1", PasswordHash = "h" });
        _context.SaveChanges();
    }

    [Fact]
    public async Task RoleService_CrudAndPermissions_WorksCorrectly()
    {
        var createDto = new CreateRoleDto("SecOps", "Security Operations", new[] { "ticket.view" });
        var created = await _roleService.CreateAsync(createDto);

        Assert.NotNull(created);
        Assert.Equal("SecOps", created.Name);

        var byId = await _roleService.GetByIdAsync(created.Id);
        Assert.NotNull(byId);
        Assert.Equal("SecOps", byId.Name);

        var allRoles = await _roleService.GetAllAsync();
        Assert.Single(allRoles);

        var updateDto = new UpdateRoleDto("SecOps Lead", "Lead Security", true, new[] { "ticket.view" });
        await _roleService.UpdateAsync(created.Id, updateDto);

        var updated = await _roleService.GetByIdAsync(created.Id);
        Assert.Equal("SecOps Lead", updated!.Name);

        await _roleService.DeleteAsync(created.Id);
        var deleted = await _context.Roles.FindAsync(created.Id);
        Assert.True(deleted!.IsDeleted);
    }

    [Fact]
    public async Task GroupService_CrudAndMembers_WorksCorrectly()
    {
        var createDto = new CreateGroupDto("SOC Team", 1);
        var created = await _groupService.CreateAsync(createDto);

        Assert.NotNull(created);
        Assert.Equal("SOC Team", created.Name);

        var byId = await _groupService.GetByIdAsync(created.Id);
        Assert.NotNull(byId);
        Assert.Equal("SOC Team", byId.Name);

        var updateDto = new UpdateGroupDto("SOC Tier 1", true, 1);
        await _groupService.UpdateAsync(created.Id, updateDto);

        var updated = await _groupService.GetByIdAsync(created.Id);
        Assert.Equal("SOC Tier 1", updated!.Name);

        // Add & remove member
        await _groupService.AddMemberAsync(created.Id, 1);
        var isMember = _context.GroupMembers.Any(gm => gm.GroupId == created.Id && gm.UserId == 1 && !gm.IsDeleted);
        Assert.True(isMember);

        await _groupService.RemoveMemberAsync(created.Id, 1);
        isMember = _context.GroupMembers.Any(gm => gm.GroupId == created.Id && gm.UserId == 1 && !gm.IsDeleted);
        Assert.False(isMember);

        await _groupService.DeleteAsync(created.Id);
        var deleted = await _context.Groups.FindAsync(created.Id);
        Assert.True(deleted!.IsDeleted);
    }
}
