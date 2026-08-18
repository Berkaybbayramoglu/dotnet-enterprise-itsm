using System;
using System.Threading.Tasks;

namespace ItsTool.Application.Interfaces;

public interface ISlaEngine
{
    Task AttachSlaToTicketAsync(int ticketId);
    Task ProcessTicketStatusChangeAsync(int ticketId, int oldStatusId, int newStatusId);
    Task ProcessTicketCommentAsync(int ticketId, bool isInternal);
    Task CheckBreachesAsync(DateTime nowUtc);
}
