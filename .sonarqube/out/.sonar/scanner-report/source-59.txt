using ItsTool.Infrastructure.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class PermissionsController : ControllerBase
{
    private readonly ItsToolDbContext _context;

    public PermissionsController(ItsToolDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var perms = await _context.Permissions.Select(p => new { p.Id, p.Key, p.Name }).ToListAsync();
        return Ok(perms);
    }
}
