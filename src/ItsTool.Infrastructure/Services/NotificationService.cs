using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.Infrastructure.Services;

public class NotificationService : INotificationService
{
    private readonly ItsToolDbContext _context;

    public NotificationService(ItsToolDbContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<NotificationDto>> GetUserNotificationsAsync(int userId)
    {
        var list = await _context.Notifications
            .Where(n => n.UserId == userId && !n.IsDeleted)
            .OrderByDescending(n => n.CreatedAt)
            .ToListAsync();

        return list.Select(n => new NotificationDto(n.Id, n.UserId, n.Type, n.Title, n.Body, n.IsRead, n.EntityId, n.EntityType, n.Priority, n.CreatedAt));
    }

    public async Task MarkAsReadAsync(int notificationId, int userId)
    {
        var notif = await _context.Notifications.FirstOrDefaultAsync(n => n.Id == notificationId && n.UserId == userId && !n.IsDeleted);
        if (notif != null && !notif.IsRead)
        {
            notif.IsRead = true;
            await _context.SaveChangesAsync();
        }
    }

    public async Task MarkAllAsReadAsync(int userId)
    {
        var unread = await _context.Notifications.Where(n => n.UserId == userId && !n.IsRead && !n.IsDeleted).ToListAsync();
        foreach (var n in unread)
        {
            n.IsRead = true;
        }
        await _context.SaveChangesAsync();
    }

    public async Task DeleteNotificationAsync(int notificationId, int userId)
    {
        var n = await _context.Notifications.FirstOrDefaultAsync(x => x.Id == notificationId && x.UserId == userId);
        if (n != null)
        {
            n.IsDeleted = true;
            await _context.SaveChangesAsync();
        }
    }

    public async Task DeleteAllNotificationsAsync(int userId)
    {
        var notifications = await _context.Notifications.Where(n => n.UserId == userId && !n.IsDeleted).ToListAsync();
        foreach (var n in notifications)
        {
            n.IsDeleted = true;
        }
        await _context.SaveChangesAsync();
    }
}
