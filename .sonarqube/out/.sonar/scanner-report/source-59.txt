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
    private readonly IDepartmentService _departmentService;

    public LookupController(ICatalogService catalogService, IProjectService projectService, IDepartmentService departmentService)
    {
        _catalogService = catalogService;
        _projectService = projectService;
        _departmentService = departmentService;
    }

    [HttpGet]
    public async Task<IActionResult> GetLookups()
    {
        var projects = await _projectService.GetAllAsync();
        var categories = await _catalogService.GetCategoriesAsync(null);
        var ticketTypes = await _catalogService.GetTicketTypesAsync();
        var priorities = await _catalogService.GetPrioritiesAsync();
        var statuses = await _catalogService.GetStatusesAsync();
        var departments = await _departmentService.GetAllAsync();

        return Ok(new
        {
            projects,
            categories,
            ticketTypes,
            priorities,
            statuses,
            departments
        });
    }
}
