using System.Threading.Tasks;
using ItsTool.Application.Interfaces;
using ItsTool.API.Hubs;
using Microsoft.AspNetCore.SignalR;

namespace ItsTool.API.Services;

public class SignalRPusher : ISignalRPusher
{
    private readonly IHubContext<NotificationHub> _hubContext;
    
    public SignalRPusher(IHubContext<NotificationHub> hubContext)
    {
        _hubContext = hubContext;
    }
    
    public async Task PushNotificationAsync(int userId, object payload)
    {
        await _hubContext.Clients.Group($"User_{userId}").SendAsync("ReceiveNotification", payload);
    }
}
