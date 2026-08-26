using System.Threading.Tasks;

namespace ItsTool.Application.Interfaces;

public interface INotificationDispatcher
{
    Task DispatchEventAsync(string eventKey, int ticketId, int? triggerUserId = null, string? additionalContext = null);
}
