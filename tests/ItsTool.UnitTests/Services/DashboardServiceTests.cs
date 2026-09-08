using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Domain.Entities.Project;
using ItsTool.Domain.Entities.SLA;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Services;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class DashboardServiceTests : TestBase
{
    private readonly Mock<IPermissionCalculator> _permCalcMock = new();
    private readonly DashboardService _dashboardService;

    public DashboardServiceTests() : base()
    {
        _dashboardService = new DashboardService(_context, _permCalcMock.Object);
        SeedData();
    }

    private void SeedData()
    {
        _context.Departments.Add(new Department { Id = 1, Name = "Network", IsActive = true });
        _context.Categories.Add(new Category { Id = 1, Name = "Infrastructure", IsActive = true });
        _context.Priorities.Add(new Priority { Id = 1, Name = "High", SeverityLevel = 2, IsActive = true });
        _context.Statuses.Add(new Status { Id = 1, Name = "Open", IsClosedStatus = false, IsActive = true });
        _context.Statuses.Add(new Status { Id = 2, Name = "Resolved", IsClosedStatus = true, IsActive = true });
        _context.Projects.Add(new Project { Id = 1, Name = "Project Alpha", ProjectKey = "ALP", IsActive = true });

        _context.Users.Add(new User { Id = 1, Username = "admin", Email = "admin@test.com", FirstName = "Admin", LastName = "User", PasswordHash = "h", DepartmentId = 1 });
        _context.Users.Add(new User { Id = 2, Username = "agent", Email = "agent@test.com", FirstName = "Agent", LastName = "Bob", PasswordHash = "h", DepartmentId = 1 });

        // Tickets
        var t1 = new Ticket
        {
            TicketNumber = "ALP-1",
            Title = "Switch failure",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            ProjectId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        var t2 = new Ticket
        {
            TicketNumber = "ALP-2",
            Title = "Router reboot",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 2,
            TypeId = 1,
            ProjectId = 1,
            RequesterUserId = 2,
            CreatedAt = DateTime.UtcNow
        };
        _context.Tickets.AddRange(t1, t2);
        _context.SaveChanges();

        // SLA
        _context.TicketSlas.Add(new TicketSla
        {
            TicketId = t1.Id,
            FirstResponseDueAt = DateTime.UtcNow.AddHours(2),
            ResolutionDueAt = DateTime.UtcNow.AddHours(8)
        });
        _context.TicketSlas.Add(new TicketSla
        {
            TicketId = t2.Id,
            FirstResponseDueAt = DateTime.UtcNow.AddHours(-1),
            ResolutionDueAt = DateTime.UtcNow.AddHours(-1),
            ResolutionMetAt = DateTime.UtcNow.AddHours(-2)
        });
        _context.SaveChanges();
    }

    [Fact]
    public async Task GetOverviewAsync_AdminUser_ReturnsAggregateMetrics()
    {
        _permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(1))
            .ReturnsAsync(new HashSet<string> { "report.view" });

        var overview = await _dashboardService.GetOverviewAsync(userId: 1);

        Assert.NotNull(overview);
        Assert.Equal(1, overview.OpenTickets);
    }

    [Fact]
    public async Task GetDistributionsAsync_ReturnsAllDistributions()
    {
        _permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(1))
            .ReturnsAsync(new HashSet<string> { "report.view" });

        var distributions = await _dashboardService.GetDistributionsAsync(1);
        Assert.NotNull(distributions);
        Assert.NotNull(distributions.ByStatus);
        Assert.NotNull(distributions.ByPriority);
        Assert.NotNull(distributions.ByProject);
        Assert.NotNull(distributions.ByCategory);
    }

    [Fact]
    public async Task GetSlaComplianceAsync_CalculatesComplianceRate()
    {
        _permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(1))
            .ReturnsAsync(new HashSet<string> { "report.view" });

        var compliance = await _dashboardService.GetSlaComplianceAsync(1);
        Assert.NotNull(compliance);
        Assert.True(compliance.FirstResponseComplianceRate >= 0);
    }

    [Fact]
    public async Task GetDepartmentWorkloadAsync_ReturnsDepartmentWorkload()
    {
        _permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(1))
            .ReturnsAsync(new HashSet<string> { "report.view" });

        var workload = (await _dashboardService.GetDepartmentWorkloadAsync(1)).ToList();
        Assert.NotNull(workload);
    }
}
