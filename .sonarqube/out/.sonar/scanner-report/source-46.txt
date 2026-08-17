using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Infrastructure.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/audit-log")]
[Authorize(Policy = "RequirePermission:audit.view")]
public class AuditLogController : ControllerBase
{
    private readonly ItsToolDbContext _context;

    public AuditLogController(ItsToolDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    [ProducesResponseType(typeof(PaginatedAuditLogDto), 200)]
    public async Task<IActionResult> GetAuditLogs([FromQuery] AuditLogFilterDto filter)
    {
        var query = _context.TicketHistories.AsQueryable();

        if (filter.TicketId.HasValue)
        {
            query = query.Where(h => h.TicketId == filter.TicketId.Value);
        }

        if (!string.IsNullOrEmpty(filter.Action))
        {
            query = query.Where(h => h.Action == filter.Action);
        }

        if (filter.UserId.HasValue)
        {
            var userIdStr = filter.UserId.Value.ToString();
            query = query.Where(h => h.CreatedBy == userIdStr);
        }

        if (filter.FromDate.HasValue)
        {
            // Convert to UTC for DB comparison if needed, assuming CreatedAt is UTC
            query = query.Where(h => h.CreatedAt >= filter.FromDate.Value);
        }

        if (filter.ToDate.HasValue)
        {
            query = query.Where(h => h.CreatedAt <= filter.ToDate.Value);
        }

        var totalCount = await query.CountAsync();

        var items = await query
            .OrderByDescending(h => h.CreatedAt)
            .Skip((filter.Page - 1) * filter.PageSize)
            .Take(filter.PageSize)
            .Select(h => new AuditLogItemDto(
                h.Id,
                h.TicketId,
                h.Action,
                h.FieldName,
                h.OldValue,
                h.NewValue,
                h.CreatedBy,
                h.CreatedAt
            ))
            .ToListAsync();

        return Ok(new PaginatedAuditLogDto(items, totalCount, filter.Page, filter.PageSize));
    }
}
