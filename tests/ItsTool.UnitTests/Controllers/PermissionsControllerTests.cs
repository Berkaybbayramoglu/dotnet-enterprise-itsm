using System.Collections.Generic;
using System.Security.Claims;
using System.Threading.Tasks;
using ItsTool.API.Controllers;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Auth;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Controllers;

public class PermissionsControllerTests : TestBase
{
    private readonly Mock<IPermissionCalculator> _permCalcMock;
    private readonly PermissionsController _controller;

    public PermissionsControllerTests() : base()
    {
        _permCalcMock = new Mock<IPermissionCalculator>();
        _controller = new PermissionsController(_context, _permCalcMock.Object);

        var user = new ClaimsPrincipal(new ClaimsIdentity(new[]
        {
            new Claim(ClaimTypes.NameIdentifier, "1")
        }, "mock"));

        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = user }
        };
    }

    [Fact]
    public async Task GetAll_ShouldReturnAllPermissions()
    {
        _context.Permissions.Add(new Permission { Id = 1, Name = "View Tickets", Key = "ticket.view" });
        await _context.SaveChangesAsync();

        var result = await _controller.GetAll();

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.NotNull(ok.Value);
    }

    [Fact]
    public async Task GetById_ShouldReturnOk_WhenFound()
    {
        _context.Permissions.Add(new Permission { Id = 2, Name = "Edit Tickets", Key = "ticket.edit" });
        await _context.SaveChangesAsync();

        var result = await _controller.GetById(2);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.NotNull(ok.Value);
    }

    [Fact]
    public async Task GetById_ShouldReturnNotFound_WhenMissing()
    {
        var result = await _controller.GetById(99);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task Create_ShouldReturnOk_WhenUserHasAdminManage()
    {
        _permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(1))
            .ReturnsAsync(new HashSet<string> { "admin.manage" });

        var dto = new CreatePermissionDto("Manage Users", "user.manage", "Description");
        var result = await _controller.Create(dto);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.NotNull(ok.Value);
    }

    [Fact]
    public async Task Create_ShouldReturnForbid_WhenUserLacksPermission()
    {
        _permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(1))
            .ReturnsAsync(new HashSet<string>());

        var dto = new CreatePermissionDto("Manage Users", "user.manage", "Description");
        var result = await _controller.Create(dto);

        Assert.IsType<ForbidResult>(result);
    }

    [Fact]
    public async Task Update_ShouldReturnOk_WhenValid()
    {
        _permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(1))
            .ReturnsAsync(new HashSet<string> { "admin.manage" });

        _context.Permissions.Add(new Permission { Id = 3, Name = "Old", Key = "old.key" });
        await _context.SaveChangesAsync();

        var dto = new UpdatePermissionDto("Updated", "updated.key", "Desc");
        var result = await _controller.Update(3, dto);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.NotNull(ok.Value);
    }

    [Fact]
    public async Task Update_ShouldReturnNotFound_WhenMissing()
    {
        _permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(1))
            .ReturnsAsync(new HashSet<string> { "admin.manage" });

        var dto = new UpdatePermissionDto("Updated", "updated.key", "Desc");
        var result = await _controller.Update(99, dto);

        Assert.IsType<NotFoundResult>(result);
    }

    [Fact]
    public async Task Delete_ShouldReturnNoContent_WhenValid()
    {
        _permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(1))
            .ReturnsAsync(new HashSet<string> { "admin.manage" });

        _context.Permissions.Add(new Permission { Id = 4, Name = "To Delete", Key = "del.key" });
        await _context.SaveChangesAsync();

        var result = await _controller.Delete(4);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task Delete_ShouldReturnNotFound_WhenMissing()
    {
        _permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(1))
            .ReturnsAsync(new HashSet<string> { "admin.manage" });

        var result = await _controller.Delete(99);

        Assert.IsType<NotFoundResult>(result);
    }
}
