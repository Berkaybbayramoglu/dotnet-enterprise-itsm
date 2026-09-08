using System.Collections.Generic;
using System.Threading.Tasks;
using ItsTool.API.Controllers;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Controllers;

public class RolesControllerTests
{
    private readonly Mock<IRoleService> _serviceMock;
    private readonly RolesController _controller;

    public RolesControllerTests()
    {
        _serviceMock = new Mock<IRoleService>();
        _controller = new RolesController(_serviceMock.Object);
    }

    [Fact]
    public async Task GetAll_ShouldReturnAllRoles()
    {
        var list = new List<RoleDto> { new(1, "Admin", "Admin role", true, new[] { "all" }) };
        _serviceMock.Setup(s => s.GetAllAsync()).ReturnsAsync(list);

        var result = await _controller.GetAll();

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(list, okResult.Value);
    }

    [Fact]
    public async Task GetById_ShouldReturnOk_WhenFound()
    {
        var role = new RoleDto(1, "Admin", "Admin role", true, new[] { "all" });
        _serviceMock.Setup(s => s.GetByIdAsync(1)).ReturnsAsync(role);

        var result = await _controller.GetById(1);

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(role, okResult.Value);
    }

    [Fact]
    public async Task GetById_ShouldReturnNotFound_WhenMissing()
    {
        _serviceMock.Setup(s => s.GetByIdAsync(99)).ReturnsAsync((RoleDto?)null);

        var result = await _controller.GetById(99);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task Create_ShouldReturnCreatedAtAction()
    {
        var createDto = new CreateRoleDto("Manager", "Manager role", null);
        var created = new RoleDto(2, "Manager", "Manager role", true, null);
        _serviceMock.Setup(s => s.CreateAsync(createDto)).ReturnsAsync(created);

        var result = await _controller.Create(createDto);

        var createdResult = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(created, createdResult.Value);
    }

    [Fact]
    public async Task Update_ShouldReturnNoContent_WhenSuccessful()
    {
        var updateDto = new UpdateRoleDto("Lead", "Lead role", true, null);
        _serviceMock.Setup(s => s.UpdateAsync(1, updateDto)).Returns(Task.CompletedTask);

        var result = await _controller.Update(1, updateDto);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task Update_ShouldReturnNotFound_WhenNotFound()
    {
        var updateDto = new UpdateRoleDto("Lead", "Lead role", true, null);
        _serviceMock.Setup(s => s.UpdateAsync(99, updateDto)).ThrowsAsync(new KeyNotFoundException());

        var result = await _controller.Update(99, updateDto);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task Delete_ShouldReturnNoContent()
    {
        _serviceMock.Setup(s => s.DeleteAsync(1)).Returns(Task.CompletedTask);

        var result = await _controller.Delete(1);

        Assert.IsType<NoContentResult>(result);
    }
}
