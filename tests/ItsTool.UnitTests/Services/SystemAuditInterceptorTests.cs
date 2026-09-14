using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Threading.Tasks;
using ItsTool.Domain.Entities;
using ItsTool.Domain.Entities.Auth;
using ItsTool.Domain.Entities.Config;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Domain.Entities.Project;
using ItsTool.Domain.Entities.SLA;
using ItsTool.Domain.Entities.Ticket;
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

    [Fact]
    public void SaveChanges_Synchronous_GeneratesAuditLogs()
    {
        var dept = new Department { Name = "Sync Department", IsActive = true };
        _context.Departments.Add(dept);
        _context.SaveChanges();

        dept.Name = "Sync Department Updated";
        _context.SaveChanges();

        var logs = _context.SystemAuditLogs.ToList();
        Assert.Contains(logs, l => l.Action == "Created" && l.EntityType == "Department");
        Assert.Contains(logs, l => l.Action == "Updated" && l.NewValue == "Sync Department Updated");
    }

    [Fact]
    public async Task SaveChangesAsync_OnRestore_GeneratesRestoredLog()
    {
        var group = new Group { Name = "Restored Group", IsActive = true, IsDeleted = true };
        _context.Groups.Add(group);
        await _context.SaveChangesAsync();

        group.IsDeleted = false;
        await _context.SaveChangesAsync();

        var logs = await _context.SystemAuditLogs.ToListAsync();
        Assert.Contains(logs, l => l.Action == "Restored" && l.EntityType == "Group");
    }

    [Fact]
    public async Task SaveChangesAsync_OnHardDelete_GeneratesDeletedLog()
    {
        var dept = new Department { Name = "Hard Delete Dept", IsActive = true };
        _context.Departments.Add(dept);
        await _context.SaveChangesAsync();

        _context.Departments.Remove(dept);
        await _context.SaveChangesAsync();

        var logs = await _context.SystemAuditLogs.ToListAsync();
        Assert.Contains(logs, l => l.Action == "Deleted" && l.EntityType == "Department");
    }

    [Fact]
    public async Task SaveChangesAsync_OnUserAndSlaAndRole_CapturesSpecificSummaries()
    {
        var user = new User
        {
            Username = "johndoe",
            FirstName = "John",
            LastName = "Doe",
            Email = "john.doe@example.com",
            PasswordHash = "hash123",
            IsActive = true
        };
        _context.Users.Add(user);

        var sla = new SlaPolicy
        {
            Name = "P1 Critical Policy",
            Description = "SLA policy description",
            IsActive = true
        };
        _context.SlaPolicies.Add(sla);

        var role = new Role
        {
            Name = "Security Auditor",
            Description = "Audits system actions",
            IsActive = true
        };
        _context.Roles.Add(role);

        var cat = new Category
        {
            Name = "Network Hardware",
            Description = "Routers and switches",
            IsActive = true
        };
        _context.Categories.Add(cat);

        await _context.SaveChangesAsync();

        var logs = await _context.SystemAuditLogs.ToListAsync();
        Assert.Contains(logs, l => l.EntityType == "User" && l.EntityName == "johndoe");
        Assert.Contains(logs, l => l.EntityType == "SlaPolicy" && l.EntityName.Contains("P1 Critical Policy"));
        Assert.Contains(logs, l => l.EntityType == "Role" && l.EntityName.Contains("Security Auditor"));
        Assert.Contains(logs, l => l.EntityType == "Category" && l.EntityName.Contains("Network Hardware"));

        // Update user
        user.FirstName = "Jonathan";
        await _context.SaveChangesAsync();
        Assert.Contains(await _context.SystemAuditLogs.ToListAsync(), l => l.EntityType == "User" && l.Action == "Updated" && l.NewValue == "Jonathan");
    }

    [Fact]
    public async Task SaveChangesAsync_OnGroupMember_CapturesMemberNames()
    {
        var user = new User
        {
            FirstName = "Member",
            LastName = "One",
            Email = "member1@example.com",
            PasswordHash = "hash"
        };
        var group = new Group { Name = "Support Group" };
        _context.Users.Add(user);
        _context.Groups.Add(group);
        await _context.SaveChangesAsync();

        var member = new GroupMember
        {
            UserId = user.Id,
            GroupId = group.Id
        };
        _context.GroupMembers.Add(member);
        await _context.SaveChangesAsync();

        var logs = await _context.SystemAuditLogs.ToListAsync();
        Assert.Contains(logs, l => l.EntityType == "GroupMember" && l.Action == "Created");
    }

    [Fact]
    public async Task SaveChangesAsync_OnSkippedEntities_DoesNotGenerateAuditLogs()
    {
        var ticket = new Ticket
        {
            TicketNumber = "SKIP-1",
            Title = "Skipped Ticket",
            Description = "Desc",
            RequesterUserId = 1,
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1
        };
        _context.Tickets.Add(ticket);

        var auditLog = new SystemAuditLog
        {
            Action = "Custom",
            EntityType = "Manual",
            EntityId = "1",
            CreatedAt = DateTime.UtcNow
        };
        _context.SystemAuditLogs.Add(auditLog);

        await _context.SaveChangesAsync();

        var logs = await _context.SystemAuditLogs.ToListAsync();
        Assert.DoesNotContain(logs, l => l.EntityType == "Ticket");
    }

    [Fact]
    public async Task SaveChangesAsync_WithoutHttpContext_FallsBackToSystemDefaults()
    {
        var mockAccessor = new Mock<IHttpContextAccessor>();
        mockAccessor.Setup(h => h.HttpContext).Returns((HttpContext)null!);

        var interceptor = new SystemAuditInterceptor(mockAccessor.Object);
        var options = new DbContextOptionsBuilder<ItsToolDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .AddInterceptors(interceptor)
            .Options;

        using var ctx = new ItsToolDbContext(options);
        ctx.Departments.Add(new Department { Name = "Default Dept" });
        await ctx.SaveChangesAsync();

        var log = await ctx.SystemAuditLogs.FirstOrDefaultAsync(l => l.EntityName == "Default Dept");
        Assert.NotNull(log);
        Assert.Equal("system", log.CreatedBy);
    }

    public void Dispose()
    {
        _context.Database.EnsureDeleted();
        _context.Dispose();
        GC.SuppressFinalize(this);
    }
}
