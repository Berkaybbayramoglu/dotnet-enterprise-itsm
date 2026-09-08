using System.Collections.Generic;
using System.Security.Claims;
using System.Threading.Tasks;
using ItsTool.API.Controllers;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Controllers;

public class UsersControllerTests
{
    private readonly Mock<IUserService> _serviceMock;
    private readonly UsersController _controller;

    public UsersControllerTests()
    {
        _serviceMock = new Mock<IUserService>();
        _controller = new UsersController(_serviceMock.Object);

        var user = new ClaimsPrincipal(new ClaimsIdentity(new[]
        {
            new Claim(ClaimTypes.Role, "SuperAdmin"),
            new Claim("permission", "admin.manage")
        }, "mock"));

        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = user }
        };
    }

    [Fact]
    public async Task GetAll_AsAdmin_ShouldReturnFullUserDtos()
    {
        var list = new List<UserDto> { new(1, "admin", "admin@test.com", "Super", "Admin", true, null, new[] { 1 }, new Dictionary<int, bool>(), null, new int[0], DateTime.UtcNow) };
        _serviceMock.Setup(s => s.GetAllAsync()).ReturnsAsync(list);

        var result = await _controller.GetAll();

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(list, ok.Value);
    }

    [Fact]
    public async Task GetAll_AsNonAdmin_ShouldMaskSensitiveData()
    {
        var user = new ClaimsPrincipal(new ClaimsIdentity(new[]
        {
            new Claim(ClaimTypes.Role, "User")
        }, "mock"));

        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = user }
        };

        var list = new List<UserDto> { new(1, "admin", "admin@test.com", "Super", "Admin", true, null, new[] { 1 }, new Dictionary<int, bool>(), null, new int[0], DateTime.UtcNow) };
        _serviceMock.Setup(s => s.GetAllAsync()).ReturnsAsync(list);

        var result = await _controller.GetAll();

        var ok = Assert.IsType<OkObjectResult>(result);
        var users = Assert.IsAssignableFrom<IEnumerable<UserDto>>(ok.Value);
        Assert.All(users, u => Assert.Empty(u.Email));
    }

    [Fact]
    public async Task GetById_ShouldReturnOk_WhenFound()
    {
        var userDto = new UserDto(1, "admin", "admin@test.com", "Super", "Admin", true, null, new[] { 1 }, new Dictionary<int, bool>(), null, new int[0], DateTime.UtcNow);
        _serviceMock.Setup(s => s.GetByIdAsync(1)).ReturnsAsync(userDto);

        var result = await _controller.GetById(1);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(userDto, ok.Value);
    }

    [Fact]
    public async Task GetById_ShouldReturnNotFound_WhenMissing()
    {
        _serviceMock.Setup(s => s.GetByIdAsync(99)).ReturnsAsync((UserDto?)null);

        var result = await _controller.GetById(99);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task Create_ShouldReturnCreatedAtAction()
    {
        var createDto = new CreateUserDto("newuser", "new@test.com", "First", "Last", "password123", null, null, null);
        var created = new UserDto(2, "newuser", "new@test.com", "First", "Last", true, null, new int[0], new Dictionary<int, bool>(), null, new int[0], DateTime.UtcNow);
        _serviceMock.Setup(s => s.CreateAsync(createDto)).ReturnsAsync(created);

        var result = await _controller.Create(createDto);

        var createdResult = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(created, createdResult.Value);
    }

    [Fact]
    public async Task Update_ShouldReturnNoContent_WhenSuccessful()
    {
        var updateDto = new UpdateUserDto("new@test.com", "First", "Last", true, null, null, null);
        _serviceMock.Setup(s => s.UpdateAsync(1, updateDto)).Returns(Task.CompletedTask);

        var result = await _controller.Update(1, updateDto);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task Update_ShouldReturnNotFound_WhenMissing()
    {
        var updateDto = new UpdateUserDto("new@test.com", "First", "Last", true, null, null, null);
        _serviceMock.Setup(s => s.UpdateAsync(99, updateDto)).ThrowsAsync(new KeyNotFoundException());

        var result = await _controller.Update(99, updateDto);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task Delete_ShouldReturnNoContent_WhenSuccessful()
    {
        _serviceMock.Setup(s => s.DeleteAsync(1)).Returns(Task.CompletedTask);

        var result = await _controller.Delete(1);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task Delete_ShouldReturnNotFound_WhenMissing()
    {
        _serviceMock.Setup(s => s.DeleteAsync(99)).ThrowsAsync(new KeyNotFoundException());

        var result = await _controller.Delete(99);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task AssignRole_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.AssignRoleAsync(1, 2)).Returns(Task.CompletedTask);

        var result = await _controller.AssignRole(1, 2);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task RevokeRole_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.RevokeRoleAsync(1, 2)).Returns(Task.CompletedTask);

        var result = await _controller.RevokeRole(1, 2);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task SetPermissionOverride_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.AddPermissionOverrideAsync(1, 5, true)).Returns(Task.CompletedTask);

        var result = await _controller.SetPermissionOverride(1, 5, true);

        Assert.IsType<NoContentResult>(result);
    }
}
