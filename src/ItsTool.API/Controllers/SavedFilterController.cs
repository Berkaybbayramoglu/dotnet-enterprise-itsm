using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Domain.Entities.Config;
using ItsTool.Infrastructure.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/saved-filters")]
[Authorize]
public class SavedFilterController : ControllerBase
{
    private readonly ItsToolDbContext _context;

    public SavedFilterController(ItsToolDbContext context)
    {
        _context = context;
    }

    private int GetCurrentUserId()
    {
        var idClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        return int.Parse(idClaim ?? "0");
    }

    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<SavedFilterDto>), 200)]
    public async Task<IActionResult> GetMyFilters()
    {
        var userId = GetCurrentUserId();
        var filters = await _context.SavedFilters
            .Where(f => f.UserId == userId && !f.IsDeleted)
            .ToListAsync();
            
        return Ok(filters.Select(f => new SavedFilterDto(f.Id, f.UserId, f.Name, f.QueryJson)));
    }

    [HttpGet("{id}")]
    [ProducesResponseType(typeof(SavedFilterDto), 200)]
    public async Task<IActionResult> GetFilterById(int id)
    {
        var userId = GetCurrentUserId();
        var filter = await _context.SavedFilters.FirstOrDefaultAsync(f => f.Id == id && f.UserId == userId && !f.IsDeleted);
        if (filter == null) return NotFound();
        return Ok(new SavedFilterDto(filter.Id, filter.UserId, filter.Name, filter.QueryJson));
    }

    [HttpPost]
    [ProducesResponseType(typeof(SavedFilterDto), 201)]
    public async Task<IActionResult> CreateFilter([FromBody] CreateSavedFilterDto dto)
    {
        var userId = GetCurrentUserId();
        var filter = new SavedFilter
        {
            UserId = userId,
            Name = dto.Name,
            QueryJson = dto.QueryJson
        };
        
        _context.SavedFilters.Add(filter);
        await _context.SaveChangesAsync();
        
        return CreatedAtAction(nameof(GetMyFilters), new { id = filter.Id }, new SavedFilterDto(filter.Id, filter.UserId, filter.Name, filter.QueryJson));
    }

    [HttpDelete("{id}")]
    [ProducesResponseType(204)]
    public async Task<IActionResult> DeleteFilter(int id)
    {
        var userId = GetCurrentUserId();
        var filter = await _context.SavedFilters.FirstOrDefaultAsync(f => f.Id == id && f.UserId == userId && !f.IsDeleted);
        
        if (filter == null) return NotFound();
        
        filter.IsDeleted = true;
        await _context.SaveChangesAsync();
        
        return NoContent();
    }
}
