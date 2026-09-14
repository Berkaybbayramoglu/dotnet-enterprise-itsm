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
    private const string PriorityNormal = "Normal";
    private const string CategoryStatusUpdates = "StatusUpdates";
    private const string EventCommentMention = "comment.mention";
    private const string CategoryMentions = "Mentions";


    private readonly ItsToolDbContext _context;
    private readonly IWebhookDispatcher _webhookDispatcher;
    private readonly ISignalRPusher _signalRPusher;
    private readonly IEmailQueue _emailQueue;
    private readonly IEmailTemplateService _templateService;
    private readonly Microsoft.Extensions.Configuration.IConfiguration _config;
    private readonly IAiAgentDispatcher _aiAgentDispatcher;

    public NotificationDispatcher(ItsToolDbContext context, IWebhookDispatcher webhookDispatcher, ISignalRPusher signalRPusher, IEmailQueue emailQueue, IEmailTemplateService templateService, Microsoft.Extensions.Configuration.IConfiguration config, IAiAgentDispatcher aiAgentDispatcher)
    {
        _context = context;
        _webhookDispatcher = webhookDispatcher;
        _signalRPusher = signalRPusher;
        _emailQueue = emailQueue;
        _templateService = templateService;
        _config = config;
        _aiAgentDispatcher = aiAgentDispatcher;
    }

    public async Task DispatchEventAsync(string eventKey, int ticketId, int? triggerUserId = null, string? additionalContext = null)
    {
        var ticket = await _context.Tickets
            .Include(t => t.Assignments)
            .FirstOrDefaultAsync(t => t.Id == ticketId && !t.IsDeleted);
        
        if (ticket == null) return;

        var recipients = await GetRecipientsForEventAsync(eventKey, ticket, triggerUserId, additionalContext);
        
        // Dispatch AI Agents regardless of recipients
        await _aiAgentDispatcher.DispatchAsync(eventKey, ticket);
        
        if (recipients.Count == 0) return;

        await ProcessNotificationsAsync(recipients, eventKey, ticket, additionalContext);
        
        // Dispatch to Webhooks
        await _webhookDispatcher.DispatchEventAsync(eventKey, new { ticketId = ticketId, triggerUserId = triggerUserId, context = additionalContext });
    }

    private sealed class ResolvedRecipient
    {
        public int UserId { get; set; }
        public bool SendEmail { get; set; }
        public string Priority { get; set; } = PriorityNormal;
        public string Category { get; set; } = CategoryStatusUpdates;
    }

    private async Task<List<ResolvedRecipient>> GetRecipientsForEventAsync(string eventKey, Ticket ticket, int? triggerUserId, string? additionalContext)
    {
        var recipients = new Dictionary<int, ResolvedRecipient>();

        Action<int, bool, string, string> add = (uid, email, prio, cat) => AddRecipient(recipients, uid, email, triggerUserId, eventKey, prio, cat);
        Func<bool, string, Task> addAssignees = (email, cat) => AddAssigneesAsync(recipients, ticket, email, cat, triggerUserId, eventKey);
        Func<bool, string, Task> addDeptManagers = (email, cat) => AddDeptManagersAsync(recipients, ticket, email, cat, triggerUserId, eventKey);

        await ApplyEventRulesAsync(eventKey, ticket, additionalContext, add, addAssignees, addDeptManagers);

        return recipients.Values.ToList();
    }

    private static void AddRecipient(Dictionary<int, ResolvedRecipient> recipients, int userId, bool email, int? triggerUserId, string eventKey, string priority = PriorityNormal, string category = CategoryStatusUpdates)
    {
        if (triggerUserId.HasValue && userId == triggerUserId.Value && eventKey != EventCommentMention) return; 
        
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

    private async Task AddAssigneesAsync(Dictionary<int, ResolvedRecipient> recipients, Ticket ticket, bool email, string cat, int? triggerUserId, string eventKey)
    {
        var assigneeIds = ticket.Assignments.Where(a => a.IsActive && a.AssignedUserId.HasValue).Select(a => a.AssignedUserId!.Value).ToList();
        foreach (var id in assigneeIds) AddRecipient(recipients, id, email, triggerUserId, eventKey, PriorityNormal, cat);
        
        var groupIds = ticket.Assignments.Where(a => a.IsActive && a.AssignedGroupId.HasValue).Select(a => a.AssignedGroupId!.Value).ToList();
        if (groupIds.Count > 0)
        {
            var members = await _context.GroupMembers.Where(gm => groupIds.Contains(gm.GroupId) && !gm.IsDeleted).Select(gm => gm.UserId).Distinct().ToListAsync();
            foreach (var mid in members) AddRecipient(recipients, mid, email, triggerUserId, eventKey, PriorityNormal, cat);
        }
    }

    private async Task AddDeptManagersAsync(Dictionary<int, ResolvedRecipient> recipients, Ticket ticket, bool email, string cat, int? triggerUserId, string eventKey)
    {
        var groupIds = ticket.Assignments.Where(a => a.IsActive && a.AssignedGroupId.HasValue).Select(a => a.AssignedGroupId!.Value).ToList();
        var managers = await GetDepartmentManagersAsync(groupIds);
        foreach(var mid in managers) AddRecipient(recipients, mid, email, triggerUserId, eventKey, PriorityNormal, cat);
    }

    private async Task ApplyEventRulesAsync(string eventKey, Ticket ticket, string? additionalContext, Action<int, bool, string, string> add, Func<bool, string, Task> addAssignees, Func<bool, string, Task> addDeptManagers)
    {
        switch (eventKey)
        {
            case "ticket.created":
                add(ticket.RequesterUserId, false, PriorityNormal, CategoryStatusUpdates);
                await addAssignees(true, "Assignments");
                break;
            case "ticket.assigned":
            case "ticket.transferred":
                await addAssignees(true, "Assignments");
                break;
            case "comment.added":
                add(ticket.RequesterUserId, false, PriorityNormal, CategoryMentions); // Use Mentions cat for comments
                await addAssignees(false, CategoryMentions);
                var participants = await _context.TicketComments.Where(c => c.TicketId == ticket.Id && !c.IsDeleted).Select(c => c.CreatedBy).Distinct().ToListAsync();
                foreach(var pid in participants) 
                {
                    if(int.TryParse(pid, out int p)) add(p, false, PriorityNormal, CategoryMentions);
                }
                break;
            case EventCommentMention:
                if (!string.IsNullOrEmpty(additionalContext) && additionalContext.Contains('|'))
                {
                    var parts = additionalContext.Split('|', 2);
                    if (int.TryParse(parts[0], out int mentionedId))
                    {
                        add(mentionedId, true, "High", CategoryMentions);
                    }
                }
                break;
            case "status.changed":
                add(ticket.RequesterUserId, false, PriorityNormal, CategoryStatusUpdates);
                await addAssignees(false, CategoryStatusUpdates);
                break;
            case "ticket.reopened":
                add(ticket.RequesterUserId, true, PriorityNormal, CategoryStatusUpdates);
                await addAssignees(true, CategoryStatusUpdates);
                break;
            case "sla.risk":
                await addAssignees(false, "Sla");
                break;
            case "sla.breached":
            case "sla.breach":
                await addAssignees(true, "Sla");
                await addDeptManagers(true, "Sla");
                break;
            case "critical.unassigned":
                await addDeptManagers(true, "Sla");
                break;
            case "survey.low":
                await addAssignees(false, CategoryStatusUpdates);
                await addDeptManagers(false, CategoryStatusUpdates);
                break;
        }
    }

    private async Task<List<int>> GetDepartmentManagersAsync(List<int> groupIds)
    {
        if (groupIds.Count == 0) return new List<int>();

        var deptIds = await _context.Groups
            .Where(g => groupIds.Contains(g.Id) && !g.IsDeleted && g.DepartmentId.HasValue)
            .Select(g => g.DepartmentId!.Value)
            .Distinct()
            .ToListAsync();

        if (deptIds.Count == 0) return new List<int>();

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

        await SaveNotificationsToDbAsync(recipients, eventKey, ticket, additionalContext);
        await SendNotificationsAsync(recipients, preferences, eventKey, ticket, additionalContext);
    }

    private async Task SaveNotificationsToDbAsync(List<ResolvedRecipient> recipients, string eventKey, Ticket ticket, string? additionalContext)
    {
        string humanReadableEvent = GetHumanReadableEventName(eventKey);
        foreach (var recipient in recipients)
        {
            string notifBody = additionalContext ?? $"#{ticket.TicketNumber} numaralı bilet";
            if (eventKey == EventCommentMention && additionalContext != null && additionalContext.Contains('|'))
            {
                var parts = additionalContext.Split('|', 2);
                notifBody = parts.Length > 1 ? parts[1] : notifBody;
            }

            var notif = new Notification
            {
                UserId = recipient.UserId,
                Type = eventKey,
                Title = humanReadableEvent,
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
    }

    private async Task SendNotificationsAsync(List<ResolvedRecipient> recipients, List<NotificationPreference> preferences, string eventKey, Ticket ticket, string? additionalContext)
    {
        foreach (var recipient in recipients)
        {
            var pref = preferences.FirstOrDefault(p => p.UserId == recipient.UserId && p.Category == recipient.Category);
            bool emailEnabled = pref?.EmailEnabled ?? true;
            
            string finalBody = additionalContext ?? $"Ticket {ticket.TicketNumber}";
            if (eventKey == EventCommentMention && additionalContext != null && additionalContext.Contains('|'))
            {
                var parts = additionalContext.Split('|');
                finalBody = parts.Length > 1 ? parts[1] : finalBody;
            }

            string humanReadableEvent = GetHumanReadableEventName(eventKey);

            if (recipient.SendEmail && emailEnabled)
            {
                await EnqueueEmailAsync(recipient.UserId, humanReadableEvent, ticket, finalBody, eventKey);
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

    private async Task EnqueueEmailAsync(int userId, string humanReadableEvent, Ticket ticket, string finalBody, string eventKey)
    {
        var u = await _context.Users.FindAsync(userId);
        if (u != null)
        {
            string baseUrl = _config["AppBaseUrl"] ?? string.Empty;
            string ticketUrl = $"{baseUrl.TrimEnd('/')}/ticket-detail.html?id={ticket.Id}";
            
            string badgeColor = "#2563eb";
            string badgeBg = "#eff6ff";
            if (eventKey.Contains("breach", StringComparison.OrdinalIgnoreCase))
            {
                badgeColor = "#dc2626";
                badgeBg = "#fef2f2";
            }
            else if (eventKey.Contains("warning", StringComparison.OrdinalIgnoreCase))
            {
                badgeColor = "#ea580c";
                badgeBg = "#fff7ed";
            }
            else if (eventKey.Contains("risk", StringComparison.OrdinalIgnoreCase))
            {
                badgeColor = "#d97706";
                badgeBg = "#fffbeb";
            }

            var priority = ticket.Priority?.Name;
            if (priority == null)
            {
                var p = await _context.Priorities.FindAsync(ticket.PriorityId);
                priority = p?.Name ?? "Normal";
            }

            var status = ticket.Status?.Name;
            if (status == null)
            {
                var s = await _context.Statuses.FindAsync(ticket.StatusId);
                status = s?.Name ?? "Açık";
            }

            var templateData = new Dictionary<string, string>
            {
                { "EventName", humanReadableEvent },
                { "TicketNumber", ticket.TicketNumber },
                { "Title", ticket.Title },
                { "Context", finalBody },
                { "AppUrl", ticketUrl },
                { "Priority", priority },
                { "Status", status },
                { "BadgeColor", badgeColor },
                { "BadgeBg", badgeBg }
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

    private static string GetHumanReadableEventName(string eventKey)
    {
        return eventKey switch
        {
            "ticket.created" => "Bilet Oluşturuldu",
            "ticket.assigned" => "Bilet Atandı",
            "ticket.transferred" => "Bilet Aktarıldı",
            "comment.added" or "ticket.comment.added" => "Yeni Yorum",
            EventCommentMention => "Etiketlendiniz",
            "status.changed" => "Bilet Durumu Değişti",
            "ticket.reopened" => "Bilet Yeniden Açıldı",
            "ticket.resolved" => "Bilet Çözüldü",
            "ticket.closed" => "Bilet Kapatıldı",
            "ticket.closed.survey" => "Memnuniyet Anketi",
            "sla.risk" => "SLA Riski",
            "sla.breached" or "sla.breach" => "SLA İhlali",
            "sla.warning" => "SLA Uyarısı",
            "critical.unassigned" => "Kritik Bilet Atanmadı",
            "survey.low" => "Düşük Anket Puanı",
            "kb.suggested" => "Yeni Makale Önerisi",
            "kb.reviewed" => "Makale İncelendi",
            _ => "Sistem Bildirimi"
        };
    }
}
