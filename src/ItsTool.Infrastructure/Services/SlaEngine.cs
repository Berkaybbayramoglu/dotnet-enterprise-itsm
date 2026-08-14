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

    public SlaEngine(ItsToolDbContext context, IEmailService emailService)
    {
        _context = context;
        _emailService = emailService;
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
            .Where(s => s.PausedAt == null && (!s.ResolutionMetAt.HasValue || !s.FirstResponseMetAt.HasValue))
            .ToListAsync();

        foreach (var sla in activeSlas)
        {
            if (sla.Ticket == null) continue;
            var targetUserId = sla.Ticket.AssignedUserId ?? sla.Ticket.RequesterUserId;

            await CheckFirstResponseAsync(sla, targetUserId, nowUtc);
            await CheckResolutionAsync(sla, targetUserId, nowUtc);
        }

        await _context.SaveChangesAsync();
    }

    private async Task CheckFirstResponseAsync(TicketSla sla, int targetUserId, DateTime nowUtc)
    {
        if (sla.FirstResponseMetAt.HasValue || !sla.FirstResponseDueAt.HasValue) return;

        var (warn, breach) = EvaluateMetric(sla.FirstResponseDueAt.Value, sla.FirstResponseWarned, sla.FirstResponseBreached, nowUtc);
        
        if (breach)
        {
            sla.FirstResponseBreached = true;
            await CreateNotificationAsync(targetUserId, sla.TicketId, "SLA Breached", "First Response SLA breached!");
        }
        else if (warn)
        {
            sla.FirstResponseWarned = true;
            await CreateNotificationAsync(targetUserId, sla.TicketId, "SLA Warning", "First Response SLA approaching breach.");
        }
    }

    private async Task CheckResolutionAsync(TicketSla sla, int targetUserId, DateTime nowUtc)
    {
        if (sla.ResolutionMetAt.HasValue || !sla.ResolutionDueAt.HasValue) return;

        var (warn, breach) = EvaluateMetric(sla.ResolutionDueAt.Value, sla.ResolutionWarned, sla.ResolutionBreached, nowUtc);
        
        if (breach)
        {
            sla.ResolutionBreached = true;
            await CreateNotificationAsync(targetUserId, sla.TicketId, "SLA Breached", "Resolution SLA breached!");
        }
        else if (warn)
        {
            sla.ResolutionWarned = true;
            await CreateNotificationAsync(targetUserId, sla.TicketId, "SLA Warning", "Resolution SLA approaching breach.");
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
        _context.Notifications.Add(new Notification
        {
            UserId = userId,
            Title = title,
            Message = message,
            RelatedEntityId = ticketId,
            RelatedEntityType = "Ticket"
        });

        // Fire and forget email via stub
        var user = await _context.Users.FindAsync(userId);
        if (user != null)
        {
            await _emailService.SendEmailAsync(user.Email, title, message);
        }
    }
}
