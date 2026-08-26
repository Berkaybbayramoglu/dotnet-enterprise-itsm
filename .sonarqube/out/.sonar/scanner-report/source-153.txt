using System.Threading.Tasks;
using ItsTool.Domain.Entities.Notification;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Domain.Entities.Project;
using ItsTool.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Xunit;
using ItsTool.Application.Interfaces;
using Moq;

namespace ItsTool.UnitTests.Services;

public class NotificationDispatcherTests : TestBase
{
    private readonly NotificationDispatcher _dispatcher;
    private readonly Mock<IEmailService> _mockEmailService;
    private readonly Mock<IWebhookDispatcher> _mockWebhookDispatcher;

    public NotificationDispatcherTests() : base()
    {
        _mockEmailService = new Mock<IEmailService>();
        _mockWebhookDispatcher = new Mock<IWebhookDispatcher>();
        _dispatcher = new NotificationDispatcher(_context, _mockEmailService.Object, _mockWebhookDispatcher.Object);
    }

    [Fact]
    public async Task DispatchEventAsync_ShouldNotifyRequester_IfRuleActive()
    {
        _context.NotificationRules.Add(new NotificationRule { EventKey = "ticket.created", TargetRole = "Requester", IsActive = true });
        
        var t = new Ticket { TicketNumber = "T1", RequesterUserId = 5 };
        _context.Tickets.Add(t);
        await _context.SaveChangesAsync();

        await _dispatcher.DispatchEventAsync("ticket.created", t.Id);

        var notifications = await _context.Notifications.ToListAsync();
        Assert.Single(notifications);
        Assert.Equal(5, notifications[0].UserId);
        Assert.Equal("ticket.created", notifications[0].Title);
    }

    [Fact]
    public async Task DispatchEventAsync_ShouldNotNotify_IfRuleInactive()
    {
        _context.NotificationRules.Add(new NotificationRule { EventKey = "ticket.created", TargetRole = "Requester", IsActive = false });
        
        var t = new Ticket { TicketNumber = "T1", RequesterUserId = 5 };
        _context.Tickets.Add(t);
        await _context.SaveChangesAsync();

        await _dispatcher.DispatchEventAsync("ticket.created", t.Id);

        var notifications = await _context.Notifications.ToListAsync();
        Assert.Empty(notifications);
    }

    [Fact]
    public async Task DispatchEventAsync_ShouldNotNotifyTriggerUser()
    {
        _context.NotificationRules.Add(new NotificationRule { EventKey = "ticket.comment.added", TargetRole = "Requester", IsActive = true });
        
        var t = new Ticket { TicketNumber = "T1", RequesterUserId = 5 };
        _context.Tickets.Add(t);
        await _context.SaveChangesAsync();

        // Trigger user is 5 (Requester themselves commented)
        await _dispatcher.DispatchEventAsync("ticket.comment.added", t.Id, triggerUserId: 5);

        var notifications = await _context.Notifications.ToListAsync();
        Assert.Empty(notifications); // Should not notify themselves
    }

    [Fact]
    public async Task DispatchEventAsync_ShouldNotCreateDuplicates()
    {
        _context.NotificationRules.Add(new NotificationRule { EventKey = "ticket.assigned", TargetRole = "Assignee", IsActive = true });
        
        var t = new Ticket { TicketNumber = "T1", AssignedUserId = 10 };
        _context.Tickets.Add(t);
        await _context.SaveChangesAsync();

        // First event
        await _dispatcher.DispatchEventAsync("ticket.assigned", t.Id);
        
        // Second identical event
        await _dispatcher.DispatchEventAsync("ticket.assigned", t.Id);

        var notifications = await _context.Notifications.ToListAsync();
        Assert.Single(notifications); // Should only be 1 notification due to duplicate check
    }
}
