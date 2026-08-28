using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Notification;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.Infrastructure.Services;

public class NotificationDispatcher : INotificationDispatcher
{
    private readonly ItsToolDbContext _context;
    private readonly IWebhookDispatcher _webhookDispatcher;
    private readonly ISignalRPusher _signalRPusher;
    private readonly IEmailQueue _emailQueue;
    private readonly IEmailTemplateService _templateService;
    private readonly Microsoft.Extensions.Configuration.IConfiguration _config;

    public NotificationDispatcher(ItsToolDbContext context, IWebhookDispatcher webhookDispatcher, ISignalRPusher signalRPusher, IEmailQueue emailQueue, IEmailTemplateService templateService, Microsoft.Extensions.Configuration.IConfiguration config)
    {
        _context = context;
        _webhookDispatcher = webhookDispatcher;
        _signalRPusher = signalRPusher;
        _emailQueue = emailQueue;
        _templateService = templateService;
        _config = config;
    }

    public async Task DispatchEventAsync(string eventKey, int ticketId, int? triggerUserId = null, string? additionalContext = null)
    {
        var ticket = await _context.Tickets
            .Include(t => t.Assignments)
            .FirstOrDefaultAsync(t => t.Id == ticketId && !t.IsDeleted);
        
        if (ticket == null) return;

        var recipients = await GetRecipientsForEventAsync(eventKey, ticket, triggerUserId, additionalContext);
        if (!recipients.Any()) return;

        await ProcessNotificationsAsync(recipients, eventKey, ticket, additionalContext);
        
        // Dispatch to Webhooks
        await _webhookDispatcher.DispatchEventAsync(eventKey, new { ticketId = ticketId, triggerUserId = triggerUserId, context = additionalContext });
    }

    private class ResolvedRecipient
    {
        public int UserId { get; set; }
        public bool SendEmail { get; set; }
        public string Priority { get; set; } = "Normal";
        public string Category { get; set; } = "StatusUpdates";
    }

    private async Task<List<ResolvedRecipient>> GetRecipientsForEventAsync(string eventKey, Ticket ticket, int? triggerUserId, string? additionalContext)
    {
        var recipients = new Dictionary<int, ResolvedRecipient>();

        void Add(int userId, bool email, string priority = "Normal", string category = "StatusUpdates")
        {
            if (triggerUserId.HasValue && userId == triggerUserId.Value && eventKey != "comment.mention") return; // Don't notify the trigger user unless it's a mention
            
            if (recipients.TryGetValue(userId, out var existing))
            {
                existing.SendEmail |= email;
                if (priority == "High") existing.Priority = "High";
            }
            else
            {
                recipients[userId] = new ResolvedRecipient { UserId = userId, SendEmail = email, Priority = priority, Category = category };
            }
        }
        
        var assigneeIds = ticket.Assignments.Where(a => a.IsActive && a.AssignedUserId.HasValue).Select(a => a.AssignedUserId!.Value).ToList();
        var groupIds = ticket.Assignments.Where(a => a.IsActive && a.AssignedGroupId.HasValue).Select(a => a.AssignedGroupId!.Value).ToList();
        
        async Task AddAssignees(bool email, string cat)
        {
            foreach (var id in assigneeIds) Add(id, email, "Normal", cat);
            if (groupIds.Any())
            {
                var members = await _context.GroupMembers.Where(gm => groupIds.Contains(gm.GroupId) && !gm.IsDeleted).Select(gm => gm.UserId).Distinct().ToListAsync();
                foreach (var mid in members) Add(mid, email, "Normal", cat);
            }
        }
        
        async Task AddDeptManagers(bool email, string cat)
        {
            var managers = await GetDepartmentManagersAsync(groupIds);
            foreach(var mid in managers) Add(mid, email, "Normal", cat);
        }

        switch (eventKey)
        {
            case "ticket.created":
                Add(ticket.RequesterUserId, false, "Normal", "StatusUpdates");
                await AddAssignees(true, "Assignments");
                break;
            case "ticket.assigned":
            case "ticket.transferred":
                await AddAssignees(true, "Assignments");
                break;
            case "comment.added":
                Add(ticket.RequesterUserId, false, "Normal", "Mentions"); // Use Mentions cat for comments
                await AddAssignees(false, "Mentions");
                var participants = await _context.TicketComments.Where(c => c.TicketId == ticket.Id && !c.IsDeleted).Select(c => c.CreatedBy).Distinct().ToListAsync();
                foreach(var pid in participants) 
                {
                    if(int.TryParse(pid, out int p)) Add(p, false, "Normal", "Mentions");
                }
                break;
            case "comment.mention":
                if (!string.IsNullOrEmpty(additionalContext) && additionalContext.Contains("|"))
                {
                    var parts = additionalContext.Split('|', 2);
                    if (int.TryParse(parts[0], out int mentionedId))
                    {
                        Add(mentionedId, true, "High", "Mentions");
                    }
                }
                break;
            case "status.changed":
                Add(ticket.RequesterUserId, false, "Normal", "StatusUpdates");
                await AddAssignees(false, "StatusUpdates");
                break;
            case "ticket.reopened":
                Add(ticket.RequesterUserId, true, "Normal", "StatusUpdates");
                await AddAssignees(true, "StatusUpdates");
                break;
            case "sla.risk":
                await AddAssignees(false, "Sla");
                break;
            case "sla.breached":
                await AddAssignees(true, "Sla");
                await AddDeptManagers(true, "Sla");
                break;
            case "critical.unassigned":
                await AddDeptManagers(true, "Sla");
                break;
            case "survey.low":
                await AddAssignees(false, "StatusUpdates");
                await AddDeptManagers(false, "StatusUpdates");
                break;
        }

        return recipients.Values.ToList();
    }

    private async Task<List<int>> GetDepartmentManagersAsync(List<int> groupIds)
    {
        if (!groupIds.Any()) return new List<int>();

        var deptIds = await _context.Groups
            .Where(g => groupIds.Contains(g.Id) && !g.IsDeleted && g.DepartmentId.HasValue)
            .Select(g => g.DepartmentId!.Value)
            .Distinct()
            .ToListAsync();

        if (!deptIds.Any()) return new List<int>();

        var allGroupIdsInDepts = await _context.Groups
            .Where(g => g.DepartmentId.HasValue && deptIds.Contains(g.DepartmentId.Value) && !g.IsDeleted)
            .Select(g => g.Id)
            .ToListAsync();

        var managerRoleId = await _context.Roles.Where(r => r.Name == "Manager" && !r.IsDeleted).Select(r => r.Id).FirstOrDefaultAsync();
        if (managerRoleId == 0) return new List<int>();

        var managerUserIds = await _context.UserRoles
            .Where(ur => ur.RoleId == managerRoleId && !ur.IsDeleted)
            .Select(ur => ur.UserId)
            .ToListAsync();

        var departmentManagers = await _context.GroupMembers
            .Where(gm => allGroupIdsInDepts.Contains(gm.GroupId) && managerUserIds.Contains(gm.UserId) && !gm.IsDeleted)
            .Select(gm => gm.UserId)
            .Distinct()
            .ToListAsync();

        return departmentManagers;
    }

    private async Task ProcessNotificationsAsync(List<ResolvedRecipient> recipients, string eventKey, Ticket ticket, string? additionalContext)
    {
        var userIds = recipients.Select(r => r.UserId).ToList();
        var preferences = await _context.NotificationPreferences
            .Where(p => userIds.Contains(p.UserId) && !p.IsDeleted)
            .ToListAsync();

        foreach (var recipient in recipients)
        {
            string notifBody = additionalContext ?? $"Ticket {ticket.TicketNumber}";
            if (eventKey == "comment.mention" && additionalContext != null && additionalContext.Contains("|"))
            {
                var parts = additionalContext.Split('|', 2);
                notifBody = parts.Length > 1 ? parts[1] : notifBody;
            }

            var notif = new Notification
            {
                UserId = recipient.UserId,
                Type = eventKey,
                Title = $"Event {eventKey}",
                Body = notifBody,
                EntityType = "Ticket",
                EntityId = ticket.Id,
                Priority = recipient.Priority,
                IsRead = false,
                CreatedAt = DateTime.UtcNow
            };
            
            _context.Notifications.Add(notif);
        }

        await _context.SaveChangesAsync();

        // After saving, send emails and signalr pushes
        foreach (var recipient in recipients)
        {
            var pref = preferences.FirstOrDefault(p => p.UserId == recipient.UserId && p.Category == recipient.Category);
            bool emailEnabled = pref == null ? true : pref.EmailEnabled;
            // Calculate body text once for both Email and SignalR
            string finalBody = additionalContext ?? $"Ticket {ticket.TicketNumber}";
            if (eventKey == "comment.mention" && additionalContext != null && additionalContext.Contains("|"))
            {
                var parts = additionalContext.Split('|');
                finalBody = parts.Length > 1 ? parts[1] : finalBody;
            }

            string humanReadableEvent = eventKey switch
            {
                "ticket.created" => "New Ticket Created",
                "ticket.assigned" => "Ticket Assigned to You",
                "ticket.transferred" => "Ticket Transferred",
                "comment.added" => "New Comment on Ticket",
                "comment.mention" => "You Were Mentioned",
                "status.changed" => "Ticket Status Changed",
                "ticket.reopened" => "Ticket Reopened",
                "sla.risk" => "SLA Breach Risk",
                "sla.breached" => "SLA Breached",
                "critical.unassigned" => "Critical Ticket Unassigned",
                "survey.low" => "Low Survey Score Received",
                _ => "ITSM Notification"
            };

            if (recipient.SendEmail && emailEnabled)
            {
                var u = await _context.Users.FindAsync(recipient.UserId);
                if (u != null)
                {
                    string baseUrl = _config["AppBaseUrl"] ?? "http://localhost:5000";
                    string ticketUrl = $"{baseUrl.TrimEnd('/')}/ticket-detail.html?id={ticket.Id}";
                    
                    var templateData = new Dictionary<string, string>
                    {
                        { "EventName", humanReadableEvent },
                        { "TicketNumber", ticket.TicketNumber },
                        { "Title", ticket.Title },
                        { "Context", finalBody },
                        { "AppUrl", ticketUrl }
                    };

                    string htmlBody = _templateService.GenerateEmailBody(eventKey, templateData);

                    var emailMsg = new EmailMessage
                    {
                        To = u.Email,
                        Subject = $"{humanReadableEvent} - {ticket.TicketNumber} ({ticket.Title})",
                        Body = htmlBody,
                        IsHtml = true
                    };

                    await _emailQueue.QueueEmailAsync(emailMsg);
                }
            }
            
            await _signalRPusher.PushNotificationAsync(recipient.UserId, new {
                type = eventKey,
                title = humanReadableEvent,
                body = finalBody,
                entityId = ticket.Id,
                priority = recipient.Priority,
                createdAt = DateTime.UtcNow
            });
        }
    }
}
