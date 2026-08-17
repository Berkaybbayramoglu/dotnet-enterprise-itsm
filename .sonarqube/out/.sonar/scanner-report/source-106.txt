using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Notification;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.Infrastructure.Services;

public class NotificationDispatcher : INotificationDispatcher
{
    private readonly ItsToolDbContext _context;
    private readonly IEmailService _emailService;
    private readonly IWebhookDispatcher _webhookDispatcher;

    public NotificationDispatcher(ItsToolDbContext context, IEmailService emailService, IWebhookDispatcher webhookDispatcher)
    {
        _context = context;
        _emailService = emailService;
        _webhookDispatcher = webhookDispatcher;
    }

    public async Task DispatchEventAsync(string eventKey, int ticketId, int? triggerUserId = null, string? additionalContext = null)
    {
        var rules = await _context.NotificationRules
            .Where(r => r.EventKey == eventKey && r.IsActive && !r.IsDeleted)
            .ToListAsync();

        if (!rules.Any()) return;

        var ticket = await _context.Tickets
            .FirstOrDefaultAsync(t => t.Id == ticketId && !t.IsDeleted);

        if (ticket == null) return;

        var targetUserIds = new System.Collections.Generic.HashSet<int>();

        foreach (var rule in rules)
        {
            switch (rule.TargetRole.ToLower())
            {
                case "requester":
                    targetUserIds.Add(ticket.RequesterUserId);
                    break;
                case "assignee":
                    if (ticket.AssignedUserId.HasValue)
                        targetUserIds.Add(ticket.AssignedUserId.Value);
                    break;
                case "project_member":
                    var members = await _context.ProjectMembers
                        .Where(pm => pm.ProjectId == ticket.ProjectId && !pm.IsDeleted)
                        .ToListAsync();
                    foreach (var m in members)
                    {
                        targetUserIds.Add(m.UserId);
                    }
                    break;
            }
        }

        // Do not notify the person who triggered the event
        if (triggerUserId.HasValue)
        {
            targetUserIds.Remove(triggerUserId.Value);
        }

        foreach (var targetId in targetUserIds)
        {
            // Duplicate prevention
            var exists = await _context.Notifications.AnyAsync(n => 
                n.UserId == targetId && 
                n.RelatedEntityId == ticketId && 
                n.RelatedEntityType == "Ticket" && 
                n.Title == eventKey &&
                !n.IsDeleted);

            // Wait, for comment.added, we might want to notify them multiple times?
            // "duplicate bildirim yok (aynı olay+aynı kullanıcı tek bildirim)" -> The prompt says same event + same user = single notification.
            // If they want exactly one notification per event type per ticket, we do this:
            if (!exists)
            {
                _context.Notifications.Add(new Notification
                {
                    UserId = targetId,
                    Title = eventKey,
                    Message = additionalContext ?? $"Event {eventKey} occurred on Ticket {ticket.TicketNumber}",
                    RelatedEntityId = ticketId,
                    RelatedEntityType = "Ticket"
                });

                if (eventKey == "ticket.assigned" || eventKey == "sla.breach")
                {
                    var u = await _context.Users.FindAsync(targetId);
                    if (u != null)
                    {
                        await _emailService.SendEmailAsync(u.Email, $"ITSM Notification: {eventKey}", additionalContext ?? $"Event {eventKey} on {ticket.TicketNumber}");
                    }
                }
            }
        }

        await _context.SaveChangesAsync();
        
        // Dispatch to Webhooks
        await _webhookDispatcher.DispatchEventAsync(eventKey, new { ticketId = ticketId, triggerUserId = triggerUserId, context = additionalContext });
    }
}
