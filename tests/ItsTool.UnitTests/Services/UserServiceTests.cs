using ItsTool.Application.DTOs;
using ItsTool.Domain.Entities.Auth;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Infrastructure.Data;
using ItsTool.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class UserServiceTests : TestBase
{
    private readonly Repository<User> _repository;
    private readonly UserService _service;

    public UserServiceTests()
    {
        _repository = new Repository<User>(_context);
        _service = new UserService(_repository, _context, new Moq.Mock<Microsoft.AspNetCore.Http.IHttpContextAccessor>().Object);
    }

    [Fact]
    public async Task CreateAsync_ShouldCreateUser()
    {
        var dto = new CreateUserDto("john", "j@j.com", "John", "Doe", "pass", 1, null);
        var result = await _service.CreateAsync(dto);

        Assert.NotNull(result);
        Assert.Equal("john", result.Username);
        Assert.Equal("j@j.com", result.Email);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdateUser()
    {
        var user = new User { Username = "old", Email = "old@j.com", FirstName = "a", LastName = "b", PasswordHash = "c" };
        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        var dto = new UpdateUserDto("new@j.com", "NewA", "NewB", true, 2, null);
        await _service.UpdateAsync(user.Id, dto);

        var updated = await _context.Users.FindAsync(user.Id);
        Assert.Equal("new@j.com", updated!.Email);
        Assert.Equal("NewA", updated.FirstName);
    }

    [Fact]
    public async Task AssignRoleAsync_ShouldAssignRole()
    {
        var user = new User { Username = "u", Email = "e", FirstName = "a", LastName = "b", PasswordHash = "c" };
        var role = new Role { Name = "Admin" };
        _context.Users.Add(user);
        _context.Roles.Add(role);
        await _context.SaveChangesAsync();

        await _service.AssignRoleAsync(user.Id, role.Id);

        var assigned = await _context.UserRoles.FirstOrDefaultAsync(ur => ur.UserId == user.Id && ur.RoleId == role.Id);
        Assert.NotNull(assigned);
    }
}
