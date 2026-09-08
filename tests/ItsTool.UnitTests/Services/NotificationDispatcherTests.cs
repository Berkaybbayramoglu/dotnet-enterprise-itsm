using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Services;
using Microsoft.Extensions.Configuration;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class NotificationDispatcherTests : TestBase
{
    private readonly Mock<IWebhookDispatcher> _webhookDispatcherMock = new();
    private readonly Mock<ISignalRPusher> _signalRPusherMock = new();
    private readonly Mock<IEmailQueue> _emailQueueMock = new();
    private readonly Mock<IEmailTemplateService> _templateServiceMock = new();
    private readonly Mock<IConfiguration> _configMock = new();
    private readonly Mock<IAiAgentDispatcher> _aiAgentDispatcherMock = new();

    private readonly NotificationDispatcher _dispatcher;

    public NotificationDispatcherTests() : base()
    {
        _templateServiceMock.Setup(t => t.GenerateEmailBody(It.IsAny<string>(), It.IsAny<Dictionary<string, string>>()))
            .Returns("<p>Test Email</p>");

        _dispatcher = new NotificationDispatcher(
            _context,
            _webhookDispatcherMock.Object,
            _signalRPusherMock.Object,
            _emailQueueMock.Object,
            _templateServiceMock.Object,
            _configMock.Object,
            _aiAgentDispatcherMock.Object
        );

        SeedData();
    }

    private void SeedData()
    {
        _context.Users.Add(new User { Id = 1, Username = "requester", Email = "req@test.com", FirstName = "Req", LastName = "User", PasswordHash = "h" });
        _context.Users.Add(new User { Id = 2, Username = "agent", Email = "agent@test.com", FirstName = "Agent", LastName = "User", PasswordHash = "h" });
        _context.Users.Add(new User { Id = 3, Username = "mentioned", Email = "mentioned@test.com", FirstName = "Mention", LastName = "User", PasswordHash = "h" });

        var ticket = new Ticket
        {
            Id = 1,
            TicketNumber = "T-1",
            Title = "Test Notification Ticket",
            RequesterUserId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            CreatedAt = DateTime.UtcNow
        };
        _context.Tickets.Add(ticket);

        _context.TicketAssignments.Add(new TicketAssignment
        {
            TicketId = 1,
            AssignedUserId = 2,
            IsActive = true
        });

        _context.SaveChanges();
    }

    [Theory]
    [InlineData("ticket.created")]
    [InlineData("ticket.assigned")]
    [InlineData("comment.added")]
    [InlineData("status.changed")]
    [InlineData("ticket.reopened")]
    [InlineData("sla.breached")]
    public async Task DispatchEventAsync_DispatchesExpectedEvents(string eventKey)
    {
        await _dispatcher.DispatchEventAsync(eventKey, ticketId: 1, triggerUserId: 1);

        _aiAgentDispatcherMock.Verify(a => a.DispatchAsync(eventKey, It.IsAny<Ticket>()), Times.Once);
        _webhookDispatcherMock.Verify(w => w.DispatchEventAsync(eventKey, It.IsAny<object>()), Times.Once);
    }

    [Fact]
    public async Task DispatchEventAsync_CommentMention_CreatesMentionNotification()
    {
        await _dispatcher.DispatchEventAsync("comment.mention", ticketId: 1, triggerUserId: 1, additionalContext: "3|comment123");

        var notifications = _context.Notifications.Where(n => n.UserId == 3).ToList();
        Assert.NotEmpty(notifications);
    }

    [Fact]
    public async Task DispatchEventAsync_WhenTicketNotFound_DoesNothing()
    {
        await _dispatcher.DispatchEventAsync("ticket.created", ticketId: 9999);

        _aiAgentDispatcherMock.Verify(a => a.DispatchAsync(It.IsAny<string>(), It.IsAny<Ticket>()), Times.Never);
    }
}
