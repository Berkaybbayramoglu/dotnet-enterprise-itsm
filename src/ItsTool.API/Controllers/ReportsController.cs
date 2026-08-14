using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/reports")]
[Authorize]
public class ReportsController : ControllerBase
{
    private readonly IReportService _reportService;

    public ReportsController(IReportService reportService)
    {
        _reportService = reportService;
    }

    private int GetCurrentUserId() => int.Parse(User.FindFirst("UserId")?.Value ?? "0");

    [HttpGet("tickets/csv")]
    public async Task<IActionResult> ExportTicketsCsv([FromQuery] TicketSearchFilterDto filter)
    {
        var stream = await _reportService.ExportTicketsToCsvAsync(filter, GetCurrentUserId());
        return File(stream, "text/csv", $"tickets_export_{System.DateTime.UtcNow:yyyyMMdd_HHmmss}.csv");
    }
}
