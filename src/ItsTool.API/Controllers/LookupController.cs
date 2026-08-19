using ItsTool.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/lookup")]
[Authorize]
public class LookupController : ControllerBase
{
    private readonly ICatalogService _catalogService;
    private readonly IProjectService _projectService;

    public LookupController(ICatalogService catalogService, IProjectService projectService)
    {
        _catalogService = catalogService;
        _projectService = projectService;
    }

    [HttpGet]
    public async Task<IActionResult> GetLookups()
    {
        var projects = await _projectService.GetAllAsync();
        var categories = await _catalogService.GetCategoriesAsync(null);
        var ticketTypes = await _catalogService.GetTicketTypesAsync();
        var priorities = await _catalogService.GetPrioritiesAsync();
        var statuses = await _catalogService.GetStatusesAsync();

        return Ok(new
        {
            projects,
            categories,
            ticketTypes,
            priorities,
            statuses
        });
    }
}
