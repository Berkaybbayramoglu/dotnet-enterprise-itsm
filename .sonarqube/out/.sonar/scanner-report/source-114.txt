using System.Collections.Generic;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;

namespace ItsTool.Application.Interfaces;

public interface INotificationService
{
    Task<IEnumerable<NotificationDto>> GetUserNotificationsAsync(int userId);
    Task MarkAsReadAsync(int notificationId, int userId);
    Task MarkAllAsReadAsync(int userId);
    Task DeleteNotificationAsync(int notificationId, int userId);
    Task DeleteAllNotificationsAsync(int userId);
}
