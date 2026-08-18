using System;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Domain.Entities.Notification;
using ItsTool.Infrastructure.Data;
using ItsTool.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class NotificationServiceTests : TestBase
{
    private readonly NotificationService _service;

    public NotificationServiceTests() : base()
    {
        _service = new NotificationService(_context);
    }

    [Fact]
    public async Task GetUserNotificationsAsync_ShouldReturnOnlyUserNotifications()
    {
        _context.Notifications.Add(new Notification { UserId = 1, Title = "A", Message = "A" });
        _context.Notifications.Add(new Notification { UserId = 2, Title = "B", Message = "B" });
        await _context.SaveChangesAsync();

        var notifs = await _service.GetUserNotificationsAsync(1);
        
        Assert.Single(notifs);
        Assert.Equal("A", notifs.First().Title);
    }

    [Fact]
    public async Task MarkAsReadAsync_ShouldMarkSpecificNotification()
    {
        var n = new Notification { UserId = 1, Title = "A", Message = "A", IsRead = false };
        _context.Notifications.Add(n);
        await _context.SaveChangesAsync();

        await _service.MarkAsReadAsync(n.Id, 1);
        
        var dbN = await _context.Notifications.FirstAsync();
        Assert.True(dbN.IsRead);
    }

    [Fact]
    public async Task MarkAllAsReadAsync_ShouldMarkAllForUser()
    {
        _context.Notifications.Add(new Notification { UserId = 1, Title = "A", Message = "A", IsRead = false });
        _context.Notifications.Add(new Notification { UserId = 1, Title = "B", Message = "B", IsRead = false });
        _context.Notifications.Add(new Notification { UserId = 2, Title = "C", Message = "C", IsRead = false });
        await _context.SaveChangesAsync();

        await _service.MarkAllAsReadAsync(1);
        
        var user1Notifs = await _context.Notifications.Where(n => n.UserId == 1).ToListAsync();
        Assert.All(user1Notifs, n => Assert.True(n.IsRead));

        var user2Notifs = await _context.Notifications.Where(n => n.UserId == 2).ToListAsync();
        Assert.All(user2Notifs, n => Assert.False(n.IsRead));
    }
}
