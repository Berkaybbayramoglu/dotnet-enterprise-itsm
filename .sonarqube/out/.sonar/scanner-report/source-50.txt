using ItsTool.Infrastructure.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class SystemController : ControllerBase
{
    private readonly DataSeeder _dataSeeder;
    private readonly ItsToolDbContext _context;

    public SystemController(DataSeeder dataSeeder, ItsToolDbContext context)
    {
        _dataSeeder = dataSeeder;
        _context = context;
    }

    public record SystemResponse(string Message);
    public record SystemErrorResponse(string Message, string Error);

    [AllowAnonymous]
    [HttpPost("seed")]
    [ProducesResponseType(typeof(SystemResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(SystemErrorResponse), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> SeedDatabase()
    {
        try
        {
            if (_context.Users.Any())
            {
                return Ok(new SystemResponse("Database already seeded."));
            }

            await _dataSeeder.SeedAsync();
            return Ok(new SystemResponse("Seed data applied successfully."));
        }
        catch (Exception ex)
        {
            return StatusCode(500, new SystemErrorResponse("An error occurred while seeding.", ex.Message));
        }
    }

    [AllowAnonymous]
    [HttpGet("db-test")]
    [ProducesResponseType(typeof(SystemResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(SystemErrorResponse), StatusCodes.Status500InternalServerError)]
    public IActionResult TestDatabaseConnection()
    {
        try
        {
            bool canConnect = _context.Database.CanConnect();
            if (canConnect)
            {
                int userCount = _context.Users.Count();
                return Ok(new SystemResponse($"Connection OK, Table Count (Users): {userCount}"));
            }
            
            return StatusCode(500, new SystemResponse("Cannot connect to the database."));
        }
        catch (Exception ex)
        {
            return StatusCode(500, new SystemErrorResponse("An error occurred while testing connection.", ex.Message));
        }
    }
}
