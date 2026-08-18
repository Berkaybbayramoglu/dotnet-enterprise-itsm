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

        return list.Select(n => new NotificationDto(n.Id, n.UserId, n.Title, n.Message, n.IsRead, n.RelatedEntityId, n.RelatedEntityType, n.CreatedAt));
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
}
