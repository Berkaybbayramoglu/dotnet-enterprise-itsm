using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Moq;
using Xunit;
using ItsTool.Application.Interfaces;

namespace ItsTool.UnitTests.Services;

public class TicketUpdateTests : TestBase
{
    private readonly TicketService _service;

    public TicketUpdateTests()
    {
        var assignMock = new Mock<IAssignmentEngine>();
        var slaMock = new Mock<ISlaEngine>();
        var notifMock = new Mock<INotificationDispatcher>();
        var permMock = new Mock<IPermissionCalculator>();
        var fileMock = new Mock<IFileStorageService>();

        _service = new TicketService(_context, fileMock.Object, permMock.Object, slaMock.Object, assignMock.Object, notifMock.Object);
    }

    [Fact]
    public async Task UpdateTicketAsync_ShouldAddHistory_WhenFieldsChange()
    {
        var ticket = new Ticket { Title = "Old Title", Description = "Old Desc", ProjectId = 1, CategoryId = 1, TypeId = 1, PriorityId = 1, StatusId = 1, RequesterUserId = 1 };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        var dto = new UpdateTicketDto("New Title", "New Desc", 1, 1, new Dictionary<string, string>());
        await _service.UpdateTicketAsync(ticket.Id, dto, 99);

        var history = await _context.TicketHistories.Where(h => h.TicketId == ticket.Id).ToListAsync();
        Assert.Equal(2, history.Count);
        Assert.Contains(history, h => h.FieldName == "Title" && h.OldValue == "Old Title" && h.NewValue == "New Title");
        Assert.Contains(history, h => h.FieldName == "Description" && h.OldValue == "Old Desc" && h.NewValue == "New Desc");
    }

    [Fact]
    public async Task UpdateTicketAsync_ShouldNotAddHistory_WhenNoFieldsChange()
    {
        var ticket = new Ticket { Title = "Same Title", Description = "Same Desc", ProjectId = 1, CategoryId = 1, TypeId = 1, PriorityId = 1, StatusId = 1, RequesterUserId = 1 };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        var dto = new UpdateTicketDto("Same Title", "Same Desc", 1, 1, new Dictionary<string, string>());
        await _service.UpdateTicketAsync(ticket.Id, dto, 99);

        var history = await _context.TicketHistories.Where(h => h.TicketId == ticket.Id).ToListAsync();
        Assert.Empty(history); // No-op
    }
}
