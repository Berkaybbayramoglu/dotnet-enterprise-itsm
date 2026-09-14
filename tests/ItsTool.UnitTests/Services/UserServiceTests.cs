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

public class UserServiceTests : TestBase
{
    private readonly UserService _userService;
    private readonly Mock<IHttpContextAccessor> _httpContextAccessorMock = new();

    public UserServiceTests() : base()
    {
        var repo = new Repository<User>(_context);
        _userService = new UserService(repo, _context, _httpContextAccessorMock.Object);
        SeedData();
    }

    private void SeedData()
    {
        _context.Departments.Add(new Department { Id = 1, Name = "DevOps", IsActive = true });
        _context.Roles.Add(new Role { Id = 1, Name = "Administrator", Description = "Full access" });
        _context.Roles.Add(new Role { Id = 2, Name = "Agent", Description = "Support agent" });
        _context.Permissions.Add(new Permission { Id = 1, Key = "ticket.manage", Name = "Manage Tickets" });
        _context.SaveChanges();
    }

    [Fact]
    public async Task CreateAsync_CreatesUserWithHashedPassword()
    {
        var dto = new CreateUserDto(
            Username: "johndoe",
            Email: "john@example.com",
            FirstName: "John",
            LastName: "Doe",
            Password: "SecurePassword123!",
            DepartmentId: 1,
            ProfilePhoto: null,
            GroupIds: new[] { 1 }
        );

        var result = await _userService.CreateAsync(dto);

        Assert.NotNull(result);
        Assert.Equal("johndoe", result.Username);
        Assert.Equal("john@example.com", result.Email);
        Assert.True(result.IsActive);

        var userInDb = await _context.Users.FindAsync(result.Id);
        Assert.NotNull(userInDb);
        Assert.True(BCrypt.Net.BCrypt.Verify("SecurePassword123!", userInDb.PasswordHash));
    }

    [Fact]
    public async Task GetByIdAsync_WhenExists_ReturnsUserDto()
    {
        var user = new User
        {
            Username = "existinguser",
            Email = "existing@example.com",
            FirstName = "Existing",
            LastName = "User",
            PasswordHash = "hash",
            DepartmentId = 1,
            IsActive = true
        };
        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        var result = await _userService.GetByIdAsync(user.Id);

        Assert.NotNull(result);
        Assert.Equal("existinguser", result.Username);
    }

    [Fact]
    public async Task GetAllAsync_ReturnsAllActiveUsers()
    {
        var u1 = new User { Username = "u1", Email = "u1@test.com", FirstName = "U1", LastName = "L1", PasswordHash = "h" };
        var u2 = new User { Username = "u2", Email = "u2@test.com", FirstName = "U2", LastName = "L2", PasswordHash = "h" };
        _context.Users.AddRange(u1, u2);
        await _context.SaveChangesAsync();

        var list = await _userService.GetAllAsync();
        Assert.True(list.Count() >= 2);
    }

    [Fact]
    public async Task UpdateAsync_UpdatesUserProfile()
    {
        var user = new User
        {
            Username = "to_update",
            Email = "before@example.com",
            FirstName = "Before",
            LastName = "Name",
            PasswordHash = "hash",
            DepartmentId = 1,
            IsActive = true
        };
        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        var updateDto = new UpdateUserDto(
            Email: "after@example.com",
            FirstName: "After",
            LastName: "Name",
            IsActive: true,
            DepartmentId: 1,
            ProfilePhoto: "avatar.png",
            GroupIds: null
        );

        await _userService.UpdateAsync(user.Id, updateDto);

        var updated = await _context.Users.FindAsync(user.Id);
        Assert.Equal("after@example.com", updated!.Email);
        Assert.Equal("After", updated.FirstName);
        Assert.Equal("avatar.png", updated.ProfilePhoto);
    }

    [Fact]
    public async Task DeleteAsync_SoftDeletesUser()
    {
        var user = new User
        {
            Username = "to_delete",
            Email = "delete@example.com",
            FirstName = "Delete",
            LastName = "Me",
            PasswordHash = "hash"
        };
        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        await _userService.DeleteAsync(user.Id);

        var deleted = await _context.Users.FindAsync(user.Id);
        Assert.True(deleted!.IsDeleted);
    }

    [Fact]
    public async Task AssignRoleAndRevokeRole_ModifiesRoles()
    {
        var user = new User
        {
            Username = "roleuser",
            Email = "role@example.com",
            FirstName = "Role",
            LastName = "User",
            PasswordHash = "hash"
        };
        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        await _userService.AssignRoleAsync(user.Id, 2);
        var hasRole = _context.UserRoles.Any(ur => ur.UserId == user.Id && ur.RoleId == 2 && !ur.IsDeleted);
        Assert.True(hasRole);

        await _userService.RevokeRoleAsync(user.Id, 2);
        hasRole = _context.UserRoles.Any(ur => ur.UserId == user.Id && ur.RoleId == 2 && !ur.IsDeleted);
        Assert.False(hasRole);
    }

    [Fact]
    public async Task PermissionOverrides_Add_WorksCorrectly()
    {
        var user = new User
        {
            Username = "permuser",
            Email = "perm@example.com",
            FirstName = "Perm",
            LastName = "User",
            PasswordHash = "hash"
        };
        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        await _userService.AddPermissionOverrideAsync(user.Id, 1, isGranted: true);
        var po = _context.UserPermissionOverrides.FirstOrDefault(p => p.UserId == user.Id && p.PermissionId == 1);
        Assert.NotNull(po);
        Assert.True(po.IsGranted);
    }

    [Fact]
    public async Task ResetPasswordAsync_ShouldUpdatePasswordHashAndSetMustChangePasswordTrue()
    {
        var user = new User
        {
            Username = "resetuser",
            Email = "reset@example.com",
            FirstName = "Reset",
            LastName = "User",
            PasswordHash = BCrypt.Net.BCrypt.HashPassword("OldPassword123!"),
            MustChangePassword = false
        };
        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        await _userService.ResetPasswordAsync(user.Id, "TemporaryPass123!");

        var updatedUser = await _context.Users.FindAsync(user.Id);
        Assert.NotNull(updatedUser);
        Assert.True(updatedUser.MustChangePassword);
        Assert.True(BCrypt.Net.BCrypt.Verify("TemporaryPass123!", updatedUser.PasswordHash));
    }
}

