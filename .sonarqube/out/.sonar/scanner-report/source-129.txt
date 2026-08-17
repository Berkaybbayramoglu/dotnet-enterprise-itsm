using System;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Domain.Entities.Auth;
using ItsTool.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class EmailIngestionServiceTests : TestBase
{
    private readonly EmailIngestionService _service;
    private readonly Mock<ITicketService> _ticketServiceMock;

    public EmailIngestionServiceTests() : base()
    {
        _ticketServiceMock = new Mock<ITicketService>();
        _service = new EmailIngestionService(_context, _ticketServiceMock.Object);
        SeedBasicData().Wait();
    }

    private async Task SeedBasicData()
    {
        _context.Categories.Add(new Category { Name = "Hardware" });
        _context.TicketTypes.Add(new TicketType { Name = "Incident" });
        _context.Priorities.Add(new Priority { Name = "Low", SeverityLevel = 1 });
        _context.Statuses.Add(new Status { Name = "Open", IsSystemDefault = true });
        _context.Projects.Add(new ItsTool.Domain.Entities.Project.Project { ProjectKey = "TEST", Name = "Test Project" });
        await _context.SaveChangesAsync();
    }

    [Fact]
    public async Task ProcessIncomingEmailAsync_ShouldCreateExternalUser_AndRouteByProjectKey()
    {
        var dto = new EmailIngestionDto("msg-1", "newuser@test.com", "Help me with [TEST]", "My PC is broken");

        await _service.ProcessIncomingEmailAsync(dto);

        var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == "newuser@test.com");
        Assert.NotNull(user);
        Assert.Equal("External", user.FirstName);

        var ticket = await _context.Tickets.FirstOrDefaultAsync(t => t.ExternalMessageId == "msg-1");
        Assert.NotNull(ticket);
        Assert.Equal("My PC is broken", ticket.Description);
        
        var project = await _context.Projects.FindAsync(ticket.ProjectId);
        Assert.Equal("TEST", project?.ProjectKey);
    }

    [Fact]
    public async Task ProcessIncomingEmailAsync_ShouldDedupe_WhenMessageIdAlreadyExists()
    {
        var dto = new EmailIngestionDto("msg-dedupe", "user@test.com", "Subject", "Body");

        await _service.ProcessIncomingEmailAsync(dto);
        var initialCount = await _context.Tickets.CountAsync();

        // Send again
        await _service.ProcessIncomingEmailAsync(dto);
        var finalCount = await _context.Tickets.CountAsync();

        Assert.Equal(initialCount, finalCount);
    }
}
