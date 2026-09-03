using System.Threading.Tasks;
using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class DashboardController : ControllerBase
{
    private readonly IDashboardService _dashboardService;

    public DashboardController(IDashboardService dashboardService)
    {
        _dashboardService = dashboardService;
    }

    private int GetCurrentUserId() => int.Parse(User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value ?? "0");

    [HttpGet("overview")]
    public async Task<IActionResult> GetOverview()
    {
        var result = await _dashboardService.GetOverviewAsync(GetCurrentUserId());
        return Ok(result);
    }

    [HttpGet("distributions")]
    public async Task<IActionResult> GetDistributions()
    {
        var result = await _dashboardService.GetDistributionsAsync(GetCurrentUserId());
        return Ok(result);
    }

    [HttpGet("department-workload")]
    public async Task<IActionResult> GetDepartmentWorkload()
    {
        var result = await _dashboardService.GetDepartmentWorkloadAsync(GetCurrentUserId());
        return Ok(result);
    }

    [HttpGet("sla-compliance")]
    public async Task<IActionResult> GetSlaCompliance()
    {
        var result = await _dashboardService.GetSlaComplianceAsync(GetCurrentUserId());
        return Ok(result);
    }

    [HttpGet("surveys")]
    public async Task<IActionResult> GetRecentSurveys()
    {
        var result = await _dashboardService.GetRecentSurveysAsync(GetCurrentUserId());
        return Ok(result);
    }
}
