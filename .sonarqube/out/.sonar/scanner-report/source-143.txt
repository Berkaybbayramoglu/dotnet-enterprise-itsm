using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Services;
using Moq;
using Xunit;
using ItsTool.Domain.Entities.Organization;

namespace ItsTool.UnitTests.Services;

public class DashboardServiceTests : TestBase
{
    private readonly DashboardService _dashboardService;
    private readonly Mock<IPermissionCalculator> _mockPermCalculator;

    public DashboardServiceTests() : base()
    {
        _mockPermCalculator = new Mock<IPermissionCalculator>();
        _dashboardService = new DashboardService(_context, _mockPermCalculator.Object);
    }

    [Fact]
    public async Task GetOverviewAsync_ShouldReturnZeros_WhenNoTickets()
    {
        _mockPermCalculator.Setup(x => x.CalculateEffectivePermissionsAsync(1)).ReturnsAsync(new HashSet<string> { "report.view" });

        var result = await _dashboardService.GetOverviewAsync(1);

        Assert.Equal(0, result.OpenTickets);
        Assert.Equal(0, result.CriticalTickets);
        Assert.Equal(0, result.SlaBreachedTickets);
        Assert.Equal(0, result.SlaRiskTickets);
        Assert.Equal(0, result.UnassignedTickets);
    }


    [Fact]
    public async Task GetOverviewAsync_ShouldReturnCorrectCounts_ForAdmin()
    {
        _mockPermCalculator.Setup(x => x.CalculateEffectivePermissionsAsync(1)).ReturnsAsync(new HashSet<string> { "report.view" });

        var openStatus = new Status { Name = "Open", IsClosedStatus = false };
        var closedStatus = new Status { Name = "Closed", IsClosedStatus = true };
        _context.Statuses.AddRange(openStatus, closedStatus);
        await _context.SaveChangesAsync();

        _context.Tickets.Add(new Ticket { TicketNumber = "T1", StatusId = openStatus.Id });
        _context.Tickets.Add(new Ticket { TicketNumber = "T2", StatusId = closedStatus.Id });
        _context.Tickets.Add(new Ticket { TicketNumber = "T3", StatusId = openStatus.Id, Priority = new Priority { SeverityLevel = 1 } });
        await _context.SaveChangesAsync();

        var result = await _dashboardService.GetOverviewAsync(1);

        Assert.Equal(2, result.OpenTickets); // T1 and T3 are open
        Assert.Equal(1, result.CriticalTickets); // T3
    }

    [Fact]
    public async Task GetOverviewAsync_ShouldOnlyCountAgentTickets_ForAgent()
    {
        _mockPermCalculator.Setup(x => x.CalculateEffectivePermissionsAsync(2)).ReturnsAsync(new HashSet<string> { "ticket.manage" });

        var openStatus = new Status { Name = "Open", IsClosedStatus = false };
        _context.Statuses.Add(openStatus);
        await _context.SaveChangesAsync();

        _context.Tickets.Add(new Ticket { TicketNumber = "T1", StatusId = openStatus.Id, AssignedUserId = 2 }); // Assigned to agent
        _context.Tickets.Add(new Ticket { TicketNumber = "T2", StatusId = openStatus.Id, AssignedUserId = 99 }); // Assigned to someone else
        await _context.SaveChangesAsync();

        var result = await _dashboardService.GetOverviewAsync(2);

        Assert.Equal(1, result.OpenTickets); // Only T1
    }

    [Fact]
    public async Task GetOverviewAsync_ShouldOnlyCountRequestedTickets_ForEndUser()
    {
        _mockPermCalculator.Setup(x => x.CalculateEffectivePermissionsAsync(3)).ReturnsAsync(new HashSet<string>());

        var openStatus = new Status { Name = "Open", IsClosedStatus = false };
        _context.Statuses.Add(openStatus);
        await _context.SaveChangesAsync();

        _context.Tickets.Add(new Ticket { TicketNumber = "T1", StatusId = openStatus.Id, RequesterUserId = 3 }); // Requested by user
        _context.Tickets.Add(new Ticket { TicketNumber = "T2", StatusId = openStatus.Id, RequesterUserId = 99 }); // Requested by someone else
        await _context.SaveChangesAsync();

        var result = await _dashboardService.GetOverviewAsync(3);

        Assert.Equal(1, result.OpenTickets); // Only T1
    }

    [Fact]
    public async Task GetOverviewAsync_ShouldCalculateCsatAverage()
    {
        _mockPermCalculator.Setup(x => x.CalculateEffectivePermissionsAsync(1)).ReturnsAsync(new HashSet<string> { "report.view" });

        _context.TicketSurveys.Add(new TicketSurvey { TicketId = 1, Rating = 4 });
        _context.TicketSurveys.Add(new TicketSurvey { TicketId = 2, Rating = 5 });
        await _context.SaveChangesAsync();

        var result = await _dashboardService.GetOverviewAsync(1);
        
        Assert.Equal(4.5, result.CsatAverage);
    }
}
