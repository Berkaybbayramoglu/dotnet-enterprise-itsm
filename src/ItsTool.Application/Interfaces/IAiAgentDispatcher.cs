using System.Threading.Tasks;
using ItsTool.Domain.Entities.Ticket;

namespace ItsTool.Application.Interfaces;

public interface IAiAgentDispatcher
{
    Task DispatchAsync(string eventKey, Ticket ticket);
}
