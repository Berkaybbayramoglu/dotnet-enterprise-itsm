using System.Threading.Tasks;
using ItsTool.Domain.Entities.Ticket;

namespace ItsTool.Application.Interfaces;

public interface IAssignmentEngine
{
    Task AssignTicketAsync(Ticket ticket);
}
