using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;
using ItsTool.API.Hubs;
using ItsTool.API.Security;
using ItsTool.API.Services;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Data;
using ItsTool.Infrastructure.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class AdditionalCoverageTests
{
    private static ItsToolDbContext CreateDbContext(string dbName)
    {
        var options = new DbContextOptionsBuilder<ItsToolDbContext>()
            .UseInMemoryDatabase(databaseName: dbName)
            .Options;
        return new ItsToolDbContext(options);
    }

    [Fact]
    public async Task InMemoryEmailQueue_ShouldQueueAndDequeueCorrectly()
    {
        var queue = new InMemoryEmailQueue();
        var email = new EmailMessage { To = "test@example.com", Subject = "Subject", Body = "Body", IsHtml = true };

        await queue.QueueEmailAsync(email);
        using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(2));
        var dequeued = await queue.DequeueEmailAsync(cts.Token);

        Assert.NotNull(dequeued);
        Assert.Equal("test@example.com", dequeued.To);
        Assert.Equal("Subject", dequeued.Subject);
        Assert.Equal("Body", dequeued.Body);
    }

    [Fact]
    public async Task InMemoryEmailQueue_ShouldThrowOnNullMessage()
    {
        var queue = new InMemoryEmailQueue();
        await Assert.ThrowsAsync<ArgumentNullException>(() => queue.QueueEmailAsync(null!).AsTask());
    }

    [Fact]
    public async Task StubEmailService_ShouldCompleteSuccessfully()
    {
        var stub = new StubEmailService();
        var ex = await Record.ExceptionAsync(() => stub.SendEmailAsync("admin@itsm.com", "Test", "<p>Hello</p>"));
        Assert.Null(ex);
    }

    [Fact]
    public void EmailTemplateService_ShouldGenerateFallbackBody_WhenFileMissing()
    {
        var loggerMock = new Mock<ILogger<EmailTemplateService>>();
        var service = new EmailTemplateService(loggerMock.Object);

        var data = new Dictionary<string, string>
        {
            { "EventName", "Bilet Oluşturuldu" },
            { "Context", "Yeni bir talep alındı." },
            { "AppUrl", "http://localhost:5246" },
            { "TicketNumber", "TICK-101" }
        };

        var html = service.GenerateEmailBody("ticket.created", data);

        Assert.Contains("Bilet Oluşturuldu", html);
        Assert.Contains("TICK-101", html);
        Assert.Contains("http://localhost:5246", html);
    }

    [Fact]
    public void EmailTemplateService_ShouldHandleUnknownEvent_AndException()
    {
        var loggerMock = new Mock<ILogger<EmailTemplateService>>();
        var service = new EmailTemplateService(loggerMock.Object);

        var data = new Dictionary<string, string>
        {
            { "EventName", "Custom Unknown" },
            { "Context", "Context details" },
            { "AppUrl", "http://localhost:5246" },
            { "TicketNumber", "TICK-999" }
        };

        // 1. Unknown event -> fallback
        var html1 = service.GenerateEmailBody("non_existent_event_999", data);
        Assert.Contains("Custom Unknown", html1);
        Assert.Contains("TICK-999", html1);

        // 2. Invalid character -> throws ArgumentException, caught by catch block
        var html2 = service.GenerateEmailBody("invalid\0name", data);
        Assert.Contains("Custom Unknown", html2);
        Assert.Contains("TICK-999", html2);
    }

    [Fact]
    public async Task SystemAuditService_ShouldLogEntityChange()
    {
        var db = CreateDbContext("AuditServiceDb");
        var httpContext = new DefaultHttpContext();
        var claims = new[] { new Claim(ClaimTypes.NameIdentifier, "42") };
        httpContext.User = new ClaimsPrincipal(new ClaimsIdentity(claims));

        var accessorMock = new Mock<IHttpContextAccessor>();
        accessorMock.Setup(a => a.HttpContext).Returns(httpContext);

        var service = new SystemAuditService(db, accessorMock.Object);

        await service.LogAuditAsync("Ticket", "Bilet-101", "101", "Update", "Status", "Open", "Resolved");

        var log = await db.SystemAuditLogs.FirstOrDefaultAsync(l => l.EntityId == "101");
        Assert.NotNull(log);
        Assert.Equal("Ticket", log.EntityType);
        Assert.Equal("Update", log.Action);
        Assert.Equal("42", log.CreatedBy);
        Assert.Equal("Open", log.OldValue);
        Assert.Equal("Resolved", log.NewValue);
    }

    [Fact]
    public async Task SignalRPusher_ShouldPushToUserGroup()
    {
        var hubClientsMock = new Mock<IHubClients>();
        var clientProxyMock = new Mock<IClientProxy>();
        hubClientsMock.Setup(h => h.Group("User_10")).Returns(clientProxyMock.Object);

        var hubContextMock = new Mock<IHubContext<NotificationHub>>();
        hubContextMock.Setup(h => h.Clients).Returns(hubClientsMock.Object);

        var pusher = new SignalRPusher(hubContextMock.Object);

        await pusher.PushNotificationAsync(10, new { Text = "Notification" });

        clientProxyMock.Verify(c => c.SendCoreAsync("ReceiveNotification", It.IsAny<object[]>(), default), Times.Once);
    }

    [Fact]
    public async Task PermissionAuthorizationHandler_ShouldSucceed_WhenUserHasClaim()
    {
        var requirement = new PermissionRequirement("ticket.view");
        var claims = new[] { new Claim("permission", "ticket.view") };
        var user = new ClaimsPrincipal(new ClaimsIdentity(claims));
        var context = new AuthorizationHandlerContext(new[] { requirement }, user, null);

        var handler = new PermissionAuthorizationHandler();
        await handler.HandleAsync(context);

        Assert.True(context.HasSucceeded);
    }

    [Fact]
    public async Task PermissionAuthorizationHandler_ShouldNotSucceed_WhenUserLacksClaim()
    {
        var requirement = new PermissionRequirement("ticket.delete");
        var claims = new[] { new Claim("permission", "ticket.view") };
        var user = new ClaimsPrincipal(new ClaimsIdentity(claims));
        var context = new AuthorizationHandlerContext(new[] { requirement }, user, null);

        var handler = new PermissionAuthorizationHandler();
        await handler.HandleAsync(context);

        Assert.False(context.HasSucceeded);
    }

    [Fact]
    public async Task AssignmentEngine_ShouldAssignTicket_WhenRuleMatches()
    {
        var db = CreateDbContext("AssignmentEngineDb");
        var rule = new AssignmentRule
        {
            Id = 1,
            Name = "Critical Tickets to Tier2",
            TargetGroupId = 5,
            SortOrder = 1,
            IsActive = true,
            PriorityId = 1
        };
        db.AssignmentRules.Add(rule);
        await db.SaveChangesAsync();

        var ticket = new Ticket
        {
            Id = 55,
            Title = "Network Outage",
            PriorityId = 1,
            RequesterUserId = 3
        };

        var engine = new AssignmentEngine(db);
        await engine.AssignTicketAsync(ticket);

        Assert.Single(ticket.Assignments);
        Assert.Equal(5, ticket.Assignments.First().AssignedGroupId);
    }
}
