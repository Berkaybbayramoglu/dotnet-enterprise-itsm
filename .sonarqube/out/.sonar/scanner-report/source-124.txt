using System.Threading.Tasks;

namespace ItsTool.Application.Interfaces;

public interface IWebhookDispatcher
{
    Task DispatchEventAsync(string eventKey, object payload);
}
