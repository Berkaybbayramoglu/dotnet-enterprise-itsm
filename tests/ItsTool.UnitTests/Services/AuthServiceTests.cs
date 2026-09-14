using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Infrastructure.Data;
using ItsTool.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class AuthServiceTests : TestBase
{
    private readonly AuthService _authService;
    private readonly Mock<ITokenService> _tokenServiceMock;
    private readonly Mock<IPermissionCalculator> _permissionCalculatorMock;

    public AuthServiceTests() : base()
    {
        _tokenServiceMock = new Mock<ITokenService>();
        _permissionCalculatorMock = new Mock<IPermissionCalculator>();

        var inMemorySettings = new Dictionary<string, string> {
            {"Jwt:ExpiryMinutes", "60"}
        };
        IConfiguration configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(inMemorySettings!)
            .Build();

        _authService = new AuthService(_context, _tokenServiceMock.Object, _permissionCalculatorMock.Object, configuration);
    }

    [Fact]
    public async Task LoginAsync_ValidCredentials_ShouldReturnToken()
    {
        // Arrange
        var password = "password123";
        var passwordHash = BCrypt.Net.BCrypt.HashPassword(password);
        var user = new User { Username = "testuser", Email = "test@test.com", PasswordHash = passwordHash, IsActive = true };
        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        _permissionCalculatorMock.Setup(x => x.CalculateEffectivePermissionsAsync(user.Id))
            .ReturnsAsync(new HashSet<string> { "test.perm" });

        _tokenServiceMock.Setup(x => x.GenerateToken(user.Id, user.Username, It.IsAny<IEnumerable<string>>(), It.IsAny<IEnumerable<string>>()))
            .Returns("fake_jwt_token");

        var request = new LoginRequestDto("testuser", password);

        // Act
        var result = await _authService.LoginAsync(request);

        // Assert
        Assert.NotNull(result);
        Assert.Equal("fake_jwt_token", result.Token);
        Assert.Equal("testuser", result.Username);
        Assert.Contains("test.perm", result.Permissions);
    }

    [Fact]
    public async Task LoginAsync_InvalidPassword_ShouldThrowUnauthorizedAccessException()
    {
        // Arrange
        var passwordHash = BCrypt.Net.BCrypt.HashPassword("correctpassword");
        var user = new User { Username = "testuser", Email = "test@test.com", PasswordHash = passwordHash, IsActive = true };
        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        var request = new LoginRequestDto("testuser", "wrongpassword");

        // Act & Assert
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => _authService.LoginAsync(request));
    }

    [Fact]
    public async Task LoginAsync_InactiveUser_ShouldThrowUnauthorizedAccessException()
    {
        // Arrange
        var passwordHash = BCrypt.Net.BCrypt.HashPassword("correctpassword");
        var user = new User { Username = "inactiveuser", Email = "test@test.com", PasswordHash = passwordHash, IsActive = false };
        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        var request = new LoginRequestDto("inactiveuser", "correctpassword");

        // Act & Assert
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => _authService.LoginAsync(request));
    }
    [Fact]
    public async Task LoginAsync_ValidEmail_ShouldReturnToken()
    {
        // Arrange
        var password = "password123";
        var passwordHash = BCrypt.Net.BCrypt.HashPassword(password);
        var user = new User { Username = "testuser", Email = "test@test.com", PasswordHash = passwordHash, IsActive = true };
        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        _permissionCalculatorMock.Setup(x => x.CalculateEffectivePermissionsAsync(user.Id))
            .ReturnsAsync(new HashSet<string> { "test.perm" });

        _tokenServiceMock.Setup(x => x.GenerateToken(user.Id, user.Username, It.IsAny<IEnumerable<string>>(), It.IsAny<IEnumerable<string>>()))
            .Returns("fake_jwt_token");

        var request = new LoginRequestDto("test@test.com", password); // Login with email

        // Act
        var result = await _authService.LoginAsync(request);

        // Assert
        Assert.NotNull(result);
        Assert.Equal("fake_jwt_token", result.Token);
        Assert.Equal("testuser", result.Username);
    }

    [Fact]
    public async Task RefreshTokenAsync_ValidUser_ShouldReturnNewToken()
    {
        // Arrange
        var user = new User { Username = "refreshuser", Email = "refresh@test.com", PasswordHash = "hash", IsActive = true };
        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        _permissionCalculatorMock.Setup(x => x.CalculateEffectivePermissionsAsync(user.Id))
            .ReturnsAsync(new HashSet<string> { "ticket.view" });

        _tokenServiceMock.Setup(x => x.GenerateToken(user.Id, user.Username, It.IsAny<IEnumerable<string>>(), It.IsAny<IEnumerable<string>>()))
            .Returns("new_refreshed_token");

        // Act
        var result = await _authService.RefreshTokenAsync(user.Id);

        // Assert
        Assert.NotNull(result);
        Assert.Equal("new_refreshed_token", result.Token);
        Assert.Equal("refreshuser", result.Username);
        Assert.Contains("ticket.view", result.Permissions);
    }

    [Fact]
    public async Task RefreshTokenAsync_NonExistentUser_ShouldThrowUnauthorizedAccessException()
    {
        // Act & Assert
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => _authService.RefreshTokenAsync(9999));
    }
}
