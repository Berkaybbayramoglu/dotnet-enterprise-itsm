using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using ItsTool.Infrastructure.Security;
using Microsoft.Extensions.Configuration;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class TokenServiceTests
{
    [Fact]
    public void GenerateToken_ShouldCreateValidJwtWithClaims()
    {
        // Arrange
        var inMemorySettings = new Dictionary<string, string> {
            {"Jwt:Issuer", "TestIssuer"},
            {"Jwt:Audience", "TestAudience"},
            {"Jwt:Secret", "SUPER_SECRET_LONG_KEY_MUST_BE_AT_LEAST_16_CHARS"},
            {"Jwt:ExpiryMinutes", "60"}
        };

        IConfiguration configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(inMemorySettings!)
            .Build();

        var tokenService = new TokenService(configuration);
        var roles = new List<string> { "Admin", "User" };
        var permissions = new List<string> { "ticket.create", "ticket.view" };

        // Act
        var tokenString = tokenService.GenerateToken(1, "testuser", roles, permissions);

        // Assert
        Assert.False(string.IsNullOrEmpty(tokenString));

        var handler = new JwtSecurityTokenHandler();
        var token = handler.ReadJwtToken(tokenString);

        Assert.Equal("TestIssuer", token.Issuer);
        Assert.Equal("TestAudience", token.Audiences.First());
        
        // Assert Claims
        var subClaim = token.Claims.FirstOrDefault(c => c.Type == JwtRegisteredClaimNames.Sub);
        Assert.NotNull(subClaim);
        Assert.Equal("1", subClaim.Value);
        
        var nameClaim = token.Claims.FirstOrDefault(c => c.Type == ClaimTypes.Name);
        Assert.NotNull(nameClaim);
        Assert.Equal("testuser", nameClaim.Value);

        var roleClaims = token.Claims.Where(c => c.Type == ClaimTypes.Role).Select(c => c.Value).ToList();
        Assert.Equal(2, roleClaims.Count);
        Assert.Contains("Admin", roleClaims);
        Assert.Contains("User", roleClaims);

        var permClaims = token.Claims.Where(c => c.Type == "permission").Select(c => c.Value).ToList();
        Assert.Equal(2, permClaims.Count);
        Assert.Contains("ticket.create", permClaims);
        Assert.Contains("ticket.view", permClaims);
    }
}
