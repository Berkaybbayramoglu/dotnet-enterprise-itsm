using System;
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

public class AuthControllerTests
{
    private readonly Mock<IAuthService> _authServiceMock;
    private readonly AuthController _controller;

    public AuthControllerTests()
    {
        _authServiceMock = new Mock<IAuthService>();
        _controller = new AuthController(_authServiceMock.Object);
    }

    [Fact]
    public async Task Login_ShouldReturnOk_WhenCredentialsAreValid()
    {
        var request = new LoginRequestDto("testuser", "password123");
        var expectedResponse = new AuthResponseDto("token123", DateTime.UtcNow.AddHours(1), "testuser", new[] { "Admin" }, new[] { "ticket.view" });
        _authServiceMock.Setup(s => s.LoginAsync(request)).ReturnsAsync(expectedResponse);

        var result = await _controller.Login(request);

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(expectedResponse, okResult.Value);
    }

    [Fact]
    public async Task Login_ShouldReturnUnauthorized_WhenCredentialsAreInvalid()
    {
        var request = new LoginRequestDto("baduser", "wrongpass");
        _authServiceMock.Setup(s => s.LoginAsync(request)).ThrowsAsync(new UnauthorizedAccessException("Invalid"));

        var result = await _controller.Login(request);

        Assert.IsType<UnauthorizedObjectResult>(result);
    }

    [Fact]
    public async Task GetMe_ShouldReturnOk_WhenUserIsAuthenticated()
    {
        var meDto = new MeResponseDto(1, "testuser", "test@test.com", new[] { "IT" }, new[] { "Admin" }, new[] { "ticket.view" }, Array.Empty<string>(), 0, null);
        _authServiceMock.Setup(s => s.GetMeAsync(1)).ReturnsAsync(meDto);

        var user = new ClaimsPrincipal(new ClaimsIdentity(new[]
        {
            new Claim(ClaimTypes.NameIdentifier, "1")
        }, "mock"));

        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = user }
        };

        var result = await _controller.GetMe();

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(meDto, okResult.Value);
    }

    [Fact]
    public async Task GetMe_ShouldReturnUnauthorized_WhenClaimIsMissingOrInvalid()
    {
        var user = new ClaimsPrincipal(new ClaimsIdentity());

        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = user }
        };

        var result = await _controller.GetMe();

        Assert.IsType<UnauthorizedResult>(result);
    }

    [Fact]
    public async Task GetMe_ShouldReturnUnauthorized_WhenServiceThrowsUnauthorized()
    {
        _authServiceMock.Setup(s => s.GetMeAsync(99)).ThrowsAsync(new UnauthorizedAccessException());

        var user = new ClaimsPrincipal(new ClaimsIdentity(new[]
        {
            new Claim(ClaimTypes.NameIdentifier, "99")
        }, "mock"));

        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = user }
        };

        var result = await _controller.GetMe();

        Assert.IsType<UnauthorizedResult>(result);
    }

    [Fact]
    public async Task RefreshToken_ShouldReturnOk_WhenUserIsAuthenticated()
    {
        var authDto = new AuthResponseDto("new_token", DateTime.UtcNow.AddHours(1), "testuser", new[] { "Admin" }, new[] { "ticket.view" });
        _authServiceMock.Setup(s => s.RefreshTokenAsync(1)).ReturnsAsync(authDto);

        var user = new ClaimsPrincipal(new ClaimsIdentity(new[]
        {
            new Claim(ClaimTypes.NameIdentifier, "1")
        }, "mock"));

        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = user }
        };

        var result = await _controller.RefreshToken();

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(authDto, okResult.Value);
    }

    [Fact]
    public async Task RefreshToken_ShouldReturnUnauthorized_WhenClaimIsMissingOrInvalid()
    {
        var user = new ClaimsPrincipal(new ClaimsIdentity());

        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = user }
        };

        var result = await _controller.RefreshToken();

        Assert.IsType<UnauthorizedResult>(result);
    }

    [Fact]
    public async Task ChangePassword_ShouldReturnOk_WhenRequestIsValid()
    {
        var request = new ChangePasswordRequestDto("NewPassword123!", "NewPassword123!");
        var expectedResponse = new AuthResponseDto("new_token", DateTime.UtcNow.AddHours(1), "testuser", new[] { "Admin" }, new[] { "ticket.view" }, false);
        _authServiceMock.Setup(s => s.ChangePasswordAsync(1, request)).ReturnsAsync(expectedResponse);

        var user = new ClaimsPrincipal(new ClaimsIdentity(new[]
        {
            new Claim(ClaimTypes.NameIdentifier, "1")
        }, "mock"));

        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = user }
        };

        var result = await _controller.ChangePassword(request);

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(expectedResponse, okResult.Value);
    }

    [Fact]
    public async Task ChangePassword_ShouldReturnBadRequest_WhenServiceThrowsArgumentException()
    {
        var request = new ChangePasswordRequestDto("pass1", "pass2");
        _authServiceMock.Setup(s => s.ChangePasswordAsync(1, request)).ThrowsAsync(new ArgumentException("Girilen şifreler birbiriyle eşleşmiyor."));

        var user = new ClaimsPrincipal(new ClaimsIdentity(new[]
        {
            new Claim(ClaimTypes.NameIdentifier, "1")
        }, "mock"));

        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = user }
        };

        var result = await _controller.ChangePassword(request);

        Assert.IsType<BadRequestObjectResult>(result);
    }

    [Fact]
    public async Task ChangePassword_ShouldReturnUnauthorized_WhenClaimIsMissingOrInvalid()
    {
        var request = new ChangePasswordRequestDto("pass1", "pass1");
        var user = new ClaimsPrincipal(new ClaimsIdentity());

        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = user }
        };

        var result = await _controller.ChangePassword(request);

        Assert.IsType<UnauthorizedResult>(result);
    }
}

