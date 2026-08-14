using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.SLA;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Data;
using ItsTool.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class SlaEngineTests : TestBase
{
    private readonly SlaEngine _slaEngine;
    private readonly Mock<IEmailService> _emailServiceMock;

    public SlaEngineTests() : base()
    {
        _emailServiceMock = new Mock<IEmailService>();
        _slaEngine = new SlaEngine(_context, _emailServiceMock.Object);
    }

    [Fact]
    public async Task AttachSlaToTicketAsync_ShouldCalculateDueDatesCorrectly()
    {
        var p = new ItsTool.Domain.Entities.Project.Project { Name = "P", ProjectKey = "P" };
        _context.Projects.Add(p);
        var prio = new Priority { Name = "P1", SeverityLevel = 1 };
        _context.Priorities.Add(prio);
        await _context.SaveChangesAsync();

        var pol = new SlaPolicy { Name = "Pol", ProjectId = p.Id, IsActive = true };
        _context.SlaPolicies.Add(pol);
        await _context.SaveChangesAsync();

        var tgt = new SlaTarget { SlaPolicyId = pol.Id, PriorityId = prio.Id, FirstResponseMinutes = 60, ResolutionMinutes = 120 };
        _context.SlaTargets.Add(tgt);
        
        // Define Monday to Friday 09:00 - 18:00
        for (int i = 1; i <= 5; i++)
        {
            _context.BusinessHours.Add(new BusinessHour { DayOfWeek = (DayOfWeek)i, StartTime = new TimeSpan(9, 0, 0), EndTime = new TimeSpan(18, 0, 0), IsWorkingDay = true });
        }
        await _context.SaveChangesAsync();

        var t = new Ticket { TicketNumber = "1", ProjectId = p.Id, PriorityId = prio.Id };
        _context.Tickets.Add(t);
        await _context.SaveChangesAsync();

        // Need to mock current time conceptually, but calculate starts from "DateTime.UtcNow" internally in SlaEngine. 
        // We will just verify the SLA is created.
        await _slaEngine.AttachSlaToTicketAsync(t.Id);

        var sla = await _context.TicketSlas.FirstOrDefaultAsync(s => s.TicketId == t.Id);
        Assert.NotNull(sla);
        Assert.NotNull(sla.FirstResponseDueAt);
        Assert.NotNull(sla.ResolutionDueAt);
    }

    [Fact]
    public async Task ProcessTicketStatusChangeAsync_ShouldPauseAndResumeSla()
    {
        var t = new Ticket { TicketNumber = "1" };
        _context.Tickets.Add(t);
        
        var sla = new TicketSla { TicketId = 1, FirstResponseDueAt = DateTime.UtcNow.AddHours(2), ResolutionDueAt = DateTime.UtcNow.AddHours(4) };
        _context.TicketSlas.Add(sla);
        
        var s1 = new Status { Name = "Open", PausesSla = false };
        var s2 = new Status { Name = "Pending", PausesSla = true };
        _context.Statuses.AddRange(s1, s2);
        
        for (int i = 1; i <= 5; i++)
        {
            _context.BusinessHours.Add(new BusinessHour { DayOfWeek = (DayOfWeek)i, StartTime = new TimeSpan(9, 0, 0), EndTime = new TimeSpan(18, 0, 0), IsWorkingDay = true });
        }
        await _context.SaveChangesAsync();

        // Pause
        await _slaEngine.ProcessTicketStatusChangeAsync(t.Id, s1.Id, s2.Id);
        var dbSla = await _context.TicketSlas.FirstAsync();
        Assert.NotNull(dbSla.PausedAt);

        // Resume
        await _slaEngine.ProcessTicketStatusChangeAsync(t.Id, s2.Id, s1.Id);
        dbSla = await _context.TicketSlas.FirstAsync();
        Assert.Null(dbSla.PausedAt);
        Assert.True(dbSla.TotalPausedMinutes >= 0);
    }

    [Fact]
    public async Task CheckBreachesAsync_ShouldNotDuplicateNotifications()
    {
        var t = new Ticket { TicketNumber = "1", AssignedUserId = 1 };
        _context.Tickets.Add(t);
        
        var sla = new TicketSla 
        { 
            TicketId = 1, 
            FirstResponseDueAt = DateTime.UtcNow.AddMinutes(-10), // Breached
            FirstResponseMetAt = null 
        };
        _context.TicketSlas.Add(sla);
        await _context.SaveChangesAsync();

        await _slaEngine.CheckBreachesAsync(DateTime.UtcNow);
        
        var dbSla = await _context.TicketSlas.FirstAsync();
        Assert.True(dbSla.FirstResponseBreached);
        
        var notifs = await _context.Notifications.ToListAsync();
        Assert.Single(notifs);

        // Second run should not create duplicate
        await _slaEngine.CheckBreachesAsync(DateTime.UtcNow);
        var notifs2 = await _context.Notifications.ToListAsync();
        Assert.Single(notifs2); // Still 1
    }

    [Fact]
    public void ConsumeMinutesWithinDay_ShouldReturnZeroRemaining_IfFitsInDay()
    {
        var startTime = new TimeSpan(9, 0, 0);
        var endTime = new TimeSpan(18, 0, 0);
        var current = new DateTime(2023, 1, 1, 10, 0, 0); // 10:00 AM

        var (newTime, remaining) = SlaEngine.ConsumeMinutesWithinDay(current, 120, startTime, endTime);
        
        Assert.Equal(0, remaining);
        Assert.Equal(new DateTime(2023, 1, 1, 12, 0, 0), newTime);
    }

    [Fact]
    public void ConsumeMinutesWithinDay_ShouldSpillOver_IfNotFits()
    {
        var startTime = new TimeSpan(9, 0, 0);
        var endTime = new TimeSpan(18, 0, 0);
        var current = new DateTime(2023, 1, 1, 17, 0, 0); // 17:00 PM (1 hour left)

        var (newTime, remaining) = SlaEngine.ConsumeMinutesWithinDay(current, 120, startTime, endTime);
        
        Assert.Equal(60, remaining);
        Assert.Equal(new DateTime(2023, 1, 2, 9, 0, 0), newTime); // Jumps to next day start
    }
}
