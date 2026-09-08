using System;
using System.Threading.Tasks;
using ItsTool.Domain.Entities.SLA;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Services;
using ItsTool.Application.Interfaces;
using Microsoft.EntityFrameworkCore;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class SlaEscalationTests : TestBase
{
    private readonly SlaEngine _engine;
    private readonly Mock<IEmailService> _mockEmailService;
    private readonly Mock<INotificationDispatcher> _mockNotificationDispatcher;

    public SlaEscalationTests() : base()
    {
        _mockEmailService = new Mock<IEmailService>();
        _mockNotificationDispatcher = new Mock<INotificationDispatcher>();
        _engine = new SlaEngine(_context, _mockEmailService.Object, _mockNotificationDispatcher.Object);
        SeedBasicData().Wait();
    }

    private async Task SeedBasicData()
    {
        var lowPriority = new Priority { Name = "Low", SeverityLevel = 1 };
        var highPriority = new Priority { Name = "High", SeverityLevel = 2 };
        _context.Priorities.AddRange(lowPriority, highPriority);

        var policy = new SlaPolicy { Name = "Escalate Policy", EscalateOnBreach = true, IsActive = true };
        _context.SlaPolicies.Add(policy);
        await _context.SaveChangesAsync();

        _context.SlaTargets.Add(new SlaTarget { SlaPolicyId = policy.Id, PriorityId = lowPriority.Id, FirstResponseMinutes = 60, ResolutionMinutes = 120, IsActive = true });
        await _context.SaveChangesAsync();
    }

    [Fact]
    public async Task CheckBreachesAsync_ShouldEscalate_WhenBreachedAndPolicyAllows()
    {
        var ticket = new Ticket { TicketNumber = "T-1", PriorityId = _context.Priorities.First(p => p.SeverityLevel == 1).Id };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        var sla = new TicketSla
        {
            TicketId = ticket.Id,
            FirstResponseDueAt = DateTime.UtcNow.AddMinutes(-10), // Breached
            ResolutionDueAt = DateTime.UtcNow.AddMinutes(10)
        };
        _context.TicketSlas.Add(sla);
        await _context.SaveChangesAsync();

        await _engine.CheckBreachesAsync(DateTime.UtcNow);

        // Verify Escalation
        var updatedTicket = await _context.Tickets.FindAsync(ticket.Id);
        var highPriorityId = (await _context.Priorities.FirstAsync(p => p.SeverityLevel == 2)).Id;
        
        Assert.Equal(highPriorityId, updatedTicket?.PriorityId); // Priority bumped
        
        var updatedSla = await _context.TicketSlas.FindAsync(sla.Id);
        Assert.NotNull(updatedSla?.EscalatedAt); // EscalatedAt set

        _mockNotificationDispatcher.Verify(d => d.DispatchEventAsync("sla.breached", ticket.Id, null, It.IsAny<string>()), Times.Once);
    }

    [Fact]
    public async Task TryEscalateAsync_ShouldBeIdempotent()
    {
        var ticket = new Ticket { TicketNumber = "T-1", PriorityId = _context.Priorities.First(p => p.SeverityLevel == 1).Id };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        var sla = new TicketSla
        {
            TicketId = ticket.Id,
            FirstResponseDueAt = DateTime.UtcNow.AddMinutes(-10), // Breached
            ResolutionDueAt = DateTime.UtcNow.AddMinutes(10),
            EscalatedAt = DateTime.UtcNow.AddDays(-1) // Already escalated
        };
        _context.TicketSlas.Add(sla);
        await _context.SaveChangesAsync();

        await _engine.CheckBreachesAsync(DateTime.UtcNow);

        // Priority should still be low because it shouldn't escalate twice
        var updatedTicket = await _context.Tickets.FindAsync(ticket.Id);
        var lowPriorityId = (await _context.Priorities.FirstAsync(p => p.SeverityLevel == 1)).Id;
        Assert.Equal(lowPriorityId, updatedTicket?.PriorityId); 
    }
}
