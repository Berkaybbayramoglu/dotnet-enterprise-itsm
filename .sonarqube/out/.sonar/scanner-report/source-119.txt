using System.Threading.Tasks;

namespace ItsTool.Application.Interfaces;

public interface ISignalRPusher
{
    Task PushNotificationAsync(int userId, object payload);
}
