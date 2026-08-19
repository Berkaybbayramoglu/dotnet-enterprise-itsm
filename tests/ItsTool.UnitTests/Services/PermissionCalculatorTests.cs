using ItsTool.Application.Constants;
using ItsTool.Domain.Entities.Auth;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Infrastructure.Data;
using ItsTool.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class PermissionCalculatorTests : TestBase
{
    private readonly PermissionCalculator _calculator;

    public PermissionCalculatorTests() : base()
    {
        _calculator = new PermissionCalculator(_context);
    }

    [Fact]
    public async Task CalculateEffectivePermissionsAsync_ShouldReturnUnionOfAllPermissions()
    {
        // Arrange
        var user = new User { Username = "testuser", Email = "test@test.com", PasswordHash = "hash" };
        _context.Users.Add(user);
        
        var perm1 = new Permission { Name = "Perm1", Key = "perm1" };
        var perm2 = new Permission { Name = "Perm2", Key = "perm2" };
        var perm3 = new Permission { Name = "Perm3", Key = "perm3" };
        _context.Permissions.AddRange(perm1, perm2, perm3);
        
        var role = new Role { Name = "Role1" };
        _context.Roles.Add(role);
        
        var group = new Group { Name = "Group1" };
        _context.Groups.Add(group);
        
        await _context.SaveChangesAsync();
        
        // 1. Role Perm
        _context.UserRoles.Add(new UserRole { UserId = user.Id, RoleId = role.Id });
        _context.RolePermissions.Add(new RolePermission { RoleId = role.Id, PermissionId = perm1.Id });
        
        // 2. Group Perm
        _context.GroupMembers.Add(new GroupMember { UserId = user.Id, GroupId = group.Id });
        var groupRole = new Role { Name = "GroupRole" };
        _context.Roles.Add(groupRole);
        await _context.SaveChangesAsync();
        _context.GroupRoles.Add(new GroupRole { GroupId = group.Id, RoleId = groupRole.Id });
        _context.RolePermissions.Add(new RolePermission { RoleId = groupRole.Id, PermissionId = perm2.Id });
        
        // 3. User Override Perm
        _context.UserPermissionOverrides.Add(new UserPermissionOverride { UserId = user.Id, PermissionId = perm3.Id, IsGranted = true });
        
        await _context.SaveChangesAsync();

        // Act
        var result = await _calculator.CalculateEffectivePermissionsAsync(user.Id);

        // Assert
        Assert.Equal(3, result.Count);
        Assert.Contains("perm1", result);
        Assert.Contains("perm2", result);
        Assert.Contains("perm3", result);
    }

    [Fact]
    public async Task CalculateEffectivePermissionsAsync_UsersInSameGroup_CanHaveDifferentOverrides()
    {
        // Arrange
        var group = new Group { Name = "Group1" };
        _context.Groups.Add(group);
        
        var role = new Role { Name = "GroupRole" };
        _context.Roles.Add(role);
        
        var permGroup = new Permission { Name = "GroupPerm", Key = "group.perm" };
        var permOverride = new Permission { Name = "OverridePerm", Key = "override.perm" };
        _context.Permissions.AddRange(permGroup, permOverride);
        
        var user1 = new User { Username = "user1", Email = "u1@test.com", PasswordHash = "hash" };
        var user2 = new User { Username = "user2", Email = "u2@test.com", PasswordHash = "hash" };
        _context.Users.AddRange(user1, user2);
        
        await _context.SaveChangesAsync();
        
        _context.GroupRoles.Add(new GroupRole { GroupId = group.Id, RoleId = role.Id });
        _context.RolePermissions.Add(new RolePermission { RoleId = role.Id, PermissionId = permGroup.Id });
        
        _context.GroupMembers.Add(new GroupMember { UserId = user1.Id, GroupId = group.Id });
        _context.GroupMembers.Add(new GroupMember { UserId = user2.Id, GroupId = group.Id });
        
        // Only User2 gets the override
        _context.UserPermissionOverrides.Add(new UserPermissionOverride { UserId = user2.Id, PermissionId = permOverride.Id, IsGranted = true });
        
        await _context.SaveChangesAsync();

        // Act
        var resultUser1 = await _calculator.CalculateEffectivePermissionsAsync(user1.Id);
        var resultUser2 = await _calculator.CalculateEffectivePermissionsAsync(user2.Id);

        // Assert
        Assert.Single(resultUser1);
        Assert.Contains("group.perm", resultUser1);
        
        Assert.Equal(2, resultUser2.Count);
        Assert.Contains("group.perm", resultUser2);
        Assert.Contains("override.perm", resultUser2);
    }

    [Fact]
    public async Task CalculateEffectivePermissionsAsync_ShouldIgnoreSoftDeletedEntities()
    {
        // Arrange
        var user = new User { Username = "deltest", Email = "del@test.com", PasswordHash = "hash" };
        _context.Users.Add(user);
        
        var perm1 = new Permission { Name = "ActivePerm", Key = "active.perm" };
        var perm2 = new Permission { Name = "DeletedPerm", Key = "deleted.perm", IsDeleted = true };
        _context.Permissions.AddRange(perm1, perm2);
        
        var role1 = new Role { Name = "ActiveRole" };
        var role2 = new Role { Name = "DeletedRole", IsDeleted = true };
        _context.Roles.AddRange(role1, role2);
        
        await _context.SaveChangesAsync();
        
        // Active role + Active perm -> SHOULD return
        _context.UserRoles.Add(new UserRole { UserId = user.Id, RoleId = role1.Id });
        _context.RolePermissions.Add(new RolePermission { RoleId = role1.Id, PermissionId = perm1.Id });
        
        // Active role + Deleted perm -> SHOULD NOT return
        _context.RolePermissions.Add(new RolePermission { RoleId = role1.Id, PermissionId = perm2.Id });

        // Deleted role + Active perm -> SHOULD NOT return
        _context.UserRoles.Add(new UserRole { UserId = user.Id, RoleId = role2.Id });
        _context.RolePermissions.Add(new RolePermission { RoleId = role2.Id, PermissionId = perm1.Id });
        
        // Deleted user role association -> SHOULD NOT return
        var role3 = new Role { Name = "Role3" };
        _context.Roles.Add(role3);
        await _context.SaveChangesAsync();
        
        _context.UserRoles.Add(new UserRole { UserId = user.Id, RoleId = role3.Id, IsDeleted = true });
        _context.RolePermissions.Add(new RolePermission { RoleId = role3.Id, PermissionId = perm1.Id });

        await _context.SaveChangesAsync();

        // Act
        var result = await _calculator.CalculateEffectivePermissionsAsync(user.Id);

        // Assert
        Assert.Single(result);
        Assert.Contains("active.perm", result);
        Assert.DoesNotContain("deleted.perm", result);
    }
}
