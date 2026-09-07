using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.SLA;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Domain.Entities.Notification;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.Infrastructure.Services;

public class SlaEngine : ISlaEngine
{
    private readonly ItsToolDbContext _context;
    private readonly IEmailService _emailService;
    private readonly INotificationDispatcher _notificationDispatcher;

    public SlaEngine(ItsToolDbContext context, IEmailService emailService, INotificationDispatcher notificationDispatcher)
    {
        _context = context;
        _emailService = emailService;
        _notificationDispatcher = notificationDispatcher;
    }

    private async Task<DateTime> CalculateDueTimeAsync(DateTime startTimeUtc, int minutesToAdd)
    {
        var holidays = await _context.Holidays.ToListAsync();
        var businessHours = await _context.BusinessHours.ToListAsync();

        var currentTime = startTimeUtc;
        var minutesRemaining = minutesToAdd;

        while (minutesRemaining > 0)
        {
            if (!IsWorkingDay(currentTime, holidays, businessHours))
            {
                currentTime = currentTime.Date.AddDays(1);
                continue;
            }

            var bh = GetWorkingWindow(currentTime, businessHours);
            var (newTime, remaining) = ConsumeMinutesWithinDay(currentTime, minutesRemaining, bh.StartTime, bh.EndTime);
            
            currentTime = newTime;
            minutesRemaining = remaining;
        }

        return currentTime;
    }

    public static bool IsWorkingDay(DateTime date, List<Holiday> holidays, List<BusinessHour> businessHours)
    {
        if (holidays.Any(h => h.Date.Date == date.Date)) return false;
        var bh = businessHours.FirstOrDefault(b => b.DayOfWeek == date.DayOfWeek);
        return bh != null && bh.IsWorkingDay;
    }

    public static BusinessHour GetWorkingWindow(DateTime date, List<BusinessHour> businessHours)
    {
        return businessHours.First(b => b.DayOfWeek == date.DayOfWeek);
    }

    public static (DateTime newTime, int minutesRemaining) ConsumeMinutesWithinDay(DateTime currentTime, int minutesRemaining, TimeSpan startTime, TimeSpan endTime)
    {
        var currentDayTime = currentTime.TimeOfDay;

        if (currentDayTime < startTime)
        {
            return (currentTime.Date.Add(startTime), minutesRemaining);
        }
        
        if (currentDayTime >= endTime)
        {
            return (currentTime.Date.AddDays(1), minutesRemaining);
        }

        var minutesToEoD = (int)(endTime - currentDayTime).TotalMinutes;

        if (minutesRemaining <= minutesToEoD)
        {
            return (currentTime.AddMinutes(minutesRemaining), 0);
        }
        
        return (currentTime.Date.AddDays(1).Add(startTime), minutesRemaining - minutesToEoD);
    }

    public async Task AttachSlaToTicketAsync(int ticketId)
    {
        var ticket = await _context.Tickets.FindAsync(ticketId);
        if (ticket == null) return;

        var policy = await _context.SlaPolicies
            .FirstOrDefaultAsync(p => p.IsActive && (p.ProjectId == ticket.ProjectId || p.ProjectId == null));

        if (policy == null) return;

        var target = await _context.SlaTargets
            .FirstOrDefaultAsync(t => t.SlaPolicyId == policy.Id && t.PriorityId == ticket.PriorityId && 
                                      (t.TicketTypeId == ticket.TypeId || t.TicketTypeId == null));

        if (target == null) return;

        var now = DateTime.UtcNow;
        var firstResponseDue = await CalculateDueTimeAsync(now, target.FirstResponseMinutes);
        var resolutionDue = await CalculateDueTimeAsync(now, target.ResolutionMinutes);

        var sla = new TicketSla
        {
            TicketId = ticket.Id,
            FirstResponseDueAt = firstResponseDue,
            ResolutionDueAt = resolutionDue
        };

        _context.TicketSlas.Add(sla);
        await _context.SaveChangesAsync();
    }

    public async Task ProcessTicketStatusChangeAsync(int ticketId, int oldStatusId, int newStatusId)
    {
        var sla = await _context.TicketSlas.FirstOrDefaultAsync(s => s.TicketId == ticketId);
        if (sla == null) return;

        if (sla.FirstResponseMetAt == null)
            sla.FirstResponseMetAt = DateTime.UtcNow;

        var oldStatus = await _context.Statuses.FindAsync(oldStatusId);
        var newStatus = await _context.Statuses.FindAsync(newStatusId);
        if (oldStatus == null || newStatus == null) return;

        var now = DateTime.UtcNow;

        if (!oldStatus.PausesSla && newStatus.PausesSla)
        {
            ApplyPause(sla, now);
        }
        else if (oldStatus.PausesSla && !newStatus.PausesSla && sla.PausedAt.HasValue)
        {
            await ApplyResumeAsync(sla, now);
        }

        if (newStatus.IsClosedStatus && sla.ResolutionMetAt == null)
            sla.ResolutionMetAt = now;

        await _context.SaveChangesAsync();
    }

    private static void ApplyPause(TicketSla sla, DateTime now)
    {
        sla.PausedAt = now;
    }

    private async Task ApplyResumeAsync(TicketSla sla, DateTime now)
    {
        if (!sla.PausedAt.HasValue) return;

        var pausedDuration = now - sla.PausedAt.Value;
        sla.TotalPausedMinutes += (int)pausedDuration.TotalMinutes;
        
        if (sla.FirstResponseDueAt.HasValue)
            sla.FirstResponseDueAt = await CalculateDueTimeAsync(now, (int)(sla.FirstResponseDueAt.Value - sla.PausedAt.Value).TotalMinutes);

        if (sla.ResolutionDueAt.HasValue)
            sla.ResolutionDueAt = await CalculateDueTimeAsync(now, (int)(sla.ResolutionDueAt.Value - sla.PausedAt.Value).TotalMinutes);
        
        sla.PausedAt = null;
    }

    public async Task ProcessTicketCommentAsync(int ticketId, bool isInternal)
    {
        if (isInternal) return; // Only public comments count towards First Response

        var sla = await _context.TicketSlas.FirstOrDefaultAsync(s => s.TicketId == ticketId);
        if (sla != null && sla.FirstResponseMetAt == null)
        {
            sla.FirstResponseMetAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();
        }
    }

    public async Task CheckBreachesAsync(DateTime nowUtc)
    {
        var activeSlas = await _context.TicketSlas
            .Include(s => s.Ticket)
                .ThenInclude(t => t!.Assignments)
            .Where(s => s.PausedAt == null && (!s.ResolutionMetAt.HasValue || !s.FirstResponseMetAt.HasValue))
            .ToListAsync();

        foreach (var sla in activeSlas)
        {
            if (sla.Ticket == null) continue;
            var targetUserIds = sla.Ticket.Assignments
                .Where(a => a.IsActive && a.AssignedUserId.HasValue)
                .Select(a => a.AssignedUserId!.Value)
                .ToList();
            if (targetUserIds.Count == 0) targetUserIds.Add(sla.Ticket.RequesterUserId);

            await CheckFirstResponseAsync(sla, targetUserIds, nowUtc);
            await CheckResolutionAsync(sla, targetUserIds, nowUtc);
        }

        await _context.SaveChangesAsync();
    }

    private async Task CheckFirstResponseAsync(TicketSla sla, List<int> targetUserIds, DateTime nowUtc)
    {
        if (sla.FirstResponseMetAt.HasValue || !sla.FirstResponseDueAt.HasValue) return;

        var (warn, breach) = EvaluateMetric(sla.FirstResponseDueAt.Value, sla.FirstResponseWarned, sla.FirstResponseBreached, nowUtc);
        
        if (breach)
        {
            sla.FirstResponseBreached = true;
            await _notificationDispatcher.DispatchEventAsync("sla.breached", sla.TicketId, null, "İlk yanıt SLA süresi aşıldı!");
            await TryEscalateAsync(sla);
        }
        else if (warn)
        {
            sla.FirstResponseWarned = true;
            foreach (var targetUserId in targetUserIds) {
                await CreateNotificationAsync(targetUserId, sla.TicketId, "SLA Uyarısı", "İlk yanıt SLA süresi dolmak üzere.");
            }
        }
    }

    private async Task CheckResolutionAsync(TicketSla sla, List<int> targetUserIds, DateTime nowUtc)
    {
        if (sla.ResolutionMetAt.HasValue || !sla.ResolutionDueAt.HasValue) return;

        var (warn, breach) = EvaluateMetric(sla.ResolutionDueAt.Value, sla.ResolutionWarned, sla.ResolutionBreached, nowUtc);
        
        if (breach)
        {
            sla.ResolutionBreached = true;
            await _notificationDispatcher.DispatchEventAsync("sla.breached", sla.TicketId, null, "Çözüm SLA süresi aşıldı!");
            await TryEscalateAsync(sla);
        }
        else if (warn)
        {
            sla.ResolutionWarned = true;
            foreach (var targetUserId in targetUserIds) {
                await CreateNotificationAsync(targetUserId, sla.TicketId, "SLA Uyarısı", "Çözüm SLA süresi dolmak üzere.");
            }
        }
    }

    private async Task TryEscalateAsync(TicketSla sla)
    {
        if (sla.EscalatedAt.HasValue || sla.Ticket == null) return; // Idempotent check

        var target = await _context.SlaTargets.FirstOrDefaultAsync(t => t.PriorityId == sla.Ticket.PriorityId && (t.TicketTypeId == sla.Ticket.TypeId || t.TicketTypeId == null));
        if (target == null) return;

        var policy = await _context.SlaPolicies.FirstOrDefaultAsync(p => p.Id == target.SlaPolicyId);
        
        if (policy != null && policy.EscalateOnBreach)
        {
            sla.EscalatedAt = DateTime.UtcNow;
            
            // Priority Bump
            var higherPriority = await _context.Priorities
                .Where(p => p.SeverityLevel > sla.Ticket.Priority!.SeverityLevel)
                .OrderBy(p => p.SeverityLevel)
                .FirstOrDefaultAsync();

            if (higherPriority != null)
            {
                var oldPriority = sla.Ticket.PriorityId.ToString();
                sla.Ticket.PriorityId = higherPriority.Id;

                _context.TicketHistories.Add(new Domain.Entities.Ticket.TicketHistory
                {
                    TicketId = sla.TicketId,
                    Action = "Escalated",
                    FieldName = "PriorityId",
                    OldValue = oldPriority,
                    NewValue = higherPriority.Id.ToString(),
                    CreatedBy = "System"
                });
            }
        }
    }

    private static (bool warn, bool breach) EvaluateMetric(DateTime dueAt, bool warned, bool breached, DateTime now)
    {
        var timeRemaining = (dueAt - now).TotalMinutes;
        
        if (timeRemaining <= 0 && !breached)
            return (false, true);
            
        if (timeRemaining > 0 && timeRemaining <= 120 && !warned) // Standardized 120 for warning threshold to keep pure evaluation simple
            return (true, false);
            
        return (false, false);
    }

    
    private async Task CreateNotificationAsync(int userId, int ticketId, string title, string message)
    {
        var ticket = await _context.Tickets.FindAsync(ticketId);
        string ticketInfo = ticket != null ? $"[{ticket.TicketNumber}] {ticket.Title}" : $"Bilet #{ticketId}";
        string fullMessage = $"{message} ({ticketInfo})";

        _context.Notifications.Add(new Domain.Entities.Notification.Notification
        {
            UserId = userId,
            Title = title,
            Body = fullMessage,
            Type = "sla.warning",
            EntityId = ticketId,
            EntityType = "Ticket"
        });

        var user = await _context.Users.FindAsync(userId);
        if (user != null)
        {
            string htmlBody = $@"
<div style=""font-family: Arial, sans-serif; padding: 20px; background-color: #f4f4f4; color: #333;"">
    <div style=""max-width: 600px; margin: 0 auto; background: #fff; border-radius: 8px; padding: 20px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);"">
        <div style=""border-bottom: 2px solid #ff4d4f; padding-bottom: 10px; margin-bottom: 20px;"">
            <h2 style=""color: #ff4d4f; margin: 0;"">⚠️ {title}</h2>
        </div>
        <div style=""font-size: 16px; line-height: 1.5;"">
            <p><strong>Uyarı:</strong> {message}</p>
            <p><strong>Bilet:</strong> <a href=""http://localhost:5246/ticket-detail.html?id={ticketId}"" style=""color: #1890ff; text-decoration: none;"">{ticketInfo}</a></p>
        </div>
        <div style=""margin-top: 30px; font-size: 12px; color: #999; text-align: center; border-top: 1px solid #eee; padding-top: 15px;"">
            Bu e-posta ITSM Sistemi tarafından otomatik olarak gönderilmiştir.
        </div>
    </div>
</div>";

            await _emailService.SendEmailAsync(user.Email, $"{title} - {ticketInfo}", htmlBody, true);
        }
    }

}
