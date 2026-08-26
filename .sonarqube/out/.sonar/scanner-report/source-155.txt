using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Services;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class ReportServiceTests : TestBase
{
    private readonly ReportService _reportService;
    private readonly Mock<IPermissionCalculator> _mockPermCalculator;

    public ReportServiceTests() : base()
    {
        _mockPermCalculator = new Mock<IPermissionCalculator>();
        _reportService = new ReportService(_context, _mockPermCalculator.Object);
    }

    [Fact]
    public async Task ExportTicketsToCsvAsync_ShouldReturnFilteredCsvStream()
    {
        _mockPermCalculator.Setup(x => x.CalculateEffectivePermissionsAsync(1)).ReturnsAsync(new HashSet<string> { "report.view" });

        var openStatus = new Status { Name = "Open", IsClosedStatus = false };
        _context.Statuses.Add(openStatus);
        
        var project = new ItsTool.Domain.Entities.Project.Project { Name = "TestProj", ProjectKey = "TP" };
        _context.Projects.Add(project);
        
        await _context.SaveChangesAsync();

        var category = new ItsTool.Domain.Entities.Ticket.Category { Name = "Cat" };
        var type = new ItsTool.Domain.Entities.Ticket.TicketType { Name = "Type" };
        var priority = new ItsTool.Domain.Entities.Ticket.Priority { Name = "High", SeverityLevel = 1 };
        var user = new ItsTool.Domain.Entities.Organization.User { Email = "u@u.com", FirstName = "F", LastName = "L", PasswordHash = "x" };
        _context.Categories.Add(category);
        _context.TicketTypes.Add(type);
        _context.Priorities.Add(priority);
        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        _context.Tickets.Add(new Ticket { TicketNumber = "TP-1", Title = "Title 1", Description = "", StatusId = openStatus.Id, ProjectId = project.Id, CategoryId = category.Id, TypeId = type.Id, PriorityId = priority.Id, RequesterUserId = user.Id });
        _context.Tickets.Add(new Ticket { TicketNumber = "TP-2", Title = "Another", Description = "", StatusId = openStatus.Id, ProjectId = project.Id, CategoryId = category.Id, TypeId = type.Id, PriorityId = priority.Id, RequesterUserId = user.Id });
        await _context.SaveChangesAsync();

        var filter = new TicketSearchFilterDto { Keyword = "title" }; // Should match TP-1 only
        
        var stream = await _reportService.ExportTicketsToCsvAsync(filter, 1);
        stream.Position = 0;
        using var reader = new StreamReader(stream);
        var csvContent = await reader.ReadToEndAsync();
        
        Console.WriteLine("CSV Content:");
        Console.WriteLine(csvContent);
        
        Assert.Contains("TP-1", csvContent);
        Assert.DoesNotContain("TP-2", csvContent); // Did not match keyword
    }
}
