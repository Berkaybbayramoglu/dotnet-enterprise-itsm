using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Threading.Tasks;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Domain.Entities.Project;
using ItsTool.Infrastructure.Data;
using ItsTool.Infrastructure.Data.Interceptors;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class SystemAuditInterceptorTests : IDisposable
{
    private readonly ItsToolDbContext _context;
    private readonly Mock<IHttpContextAccessor> _httpContextAccessorMock;

    public SystemAuditInterceptorTests()
    {
        _httpContextAccessorMock = new Mock<IHttpContextAccessor>();
        var user = new ClaimsPrincipal(new ClaimsIdentity(new[]
        {
            new Claim(ClaimTypes.NameIdentifier, "42"),
            new Claim(ClaimTypes.Name, "audit_tester")
        }, "TestAuth"));

        var httpContext = new DefaultHttpContext { User = user };
        _httpContextAccessorMock.Setup(h => h.HttpContext).Returns(httpContext);

        var interceptor = new SystemAuditInterceptor(_httpContextAccessorMock.Object);

        var options = new DbContextOptionsBuilder<ItsToolDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .AddInterceptors(interceptor)
            .Options;

        _context = new ItsToolDbContext(options);
    }

    [Fact]
    public async Task SaveChangesAsync_OnEntityCreation_GeneratesCreatedAuditLog()
    {
        var dept = new Department { Name = "Customer Success", IsActive = true };
        _context.Departments.Add(dept);
        await _context.SaveChangesAsync();

        var logs = await _context.SystemAuditLogs.ToListAsync();
        Assert.NotEmpty(logs);
        Assert.Contains(logs, l => l.Action == "Created" && l.EntityType == "Department");
    }

    [Fact]
    public async Task SaveChangesAsync_OnEntityUpdate_GeneratesUpdatedAuditLog()
    {
        var proj = new Project { Name = "Beta Project", ProjectKey = "BETA", IsActive = true };
        _context.Projects.Add(proj);
        await _context.SaveChangesAsync();

        proj.Name = "Beta Project Revised";
        await _context.SaveChangesAsync();

        var logs = await _context.SystemAuditLogs.ToListAsync();
        Assert.Contains(logs, l => l.Action == "Updated" && l.FieldName == "Name" && l.NewValue == "Beta Project Revised");
    }

    [Fact]
    public async Task SaveChangesAsync_OnSoftDelete_GeneratesDeletedAuditLog()
    {
        var group = new Group { Name = "Tier 2 Support", IsActive = true };
        _context.Groups.Add(group);
        await _context.SaveChangesAsync();

        group.IsDeleted = true;
        await _context.SaveChangesAsync();

        var logs = await _context.SystemAuditLogs.ToListAsync();
        Assert.Contains(logs, l => l.Action == "Deleted" && l.EntityType == "Group");
    }

    public void Dispose()
    {
        _context.Database.EnsureDeleted();
        _context.Dispose();
        GC.SuppressFinalize(this);
    }
}
