using System;
using System.Threading.Tasks;
using ItsTool.API.Controllers;
using ItsTool.Application.DTOs;
using ItsTool.Domain.Entities.Ticket;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;
using Xunit;
using Microsoft.EntityFrameworkCore;
using System.Linq;

namespace ItsTool.UnitTests.Controllers;

public class AuditLogControllerTests : TestBase
{
    private readonly AuditLogController _controller;

    public AuditLogControllerTests() : base()
    {
        _controller = new AuditLogController(_context);
        
        var user = new ClaimsPrincipal(new ClaimsIdentity(new Claim[]
        {
            new Claim(ClaimTypes.NameIdentifier, "1")
        }, "mock"));

        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = user }
        };
    }

    [Fact]
    public async Task GetAuditLogs_ShouldFilterByDateRange()
    {
        _context.TicketHistories.Add(new TicketHistory { TicketId = 1, Action = "A", CreatedBy = "1", CreatedAt = new DateTime(2023, 1, 10, 0, 0, 0, DateTimeKind.Utc) });
        _context.TicketHistories.Add(new TicketHistory { TicketId = 2, Action = "B", CreatedBy = "1", CreatedAt = new DateTime(2023, 1, 15, 0, 0, 0, DateTimeKind.Utc) });
        _context.TicketHistories.Add(new TicketHistory { TicketId = 3, Action = "C", CreatedBy = "1", CreatedAt = new DateTime(2023, 1, 20, 0, 0, 0, DateTimeKind.Utc) });
        await _context.SaveChangesAsync();

        var filter = new AuditLogFilterDto(
            UserId: null, 
            Action: null, 
            TicketId: null, 
            FromDate: new DateTime(2023, 1, 12, 0, 0, 0, DateTimeKind.Utc), 
            ToDate: new DateTime(2023, 1, 18, 0, 0, 0, DateTimeKind.Utc), 
            Page: 1, 
            PageSize: 10
        );

        var result = await _controller.GetAuditLogs(filter);
        var okResult = Assert.IsType<OkObjectResult>(result);
        var pagedData = Assert.IsType<PaginatedAuditLogDto>(okResult.Value);

        Assert.Single(pagedData.Items);
        Assert.Equal("B", pagedData.Items.First().Action);
    }
}
