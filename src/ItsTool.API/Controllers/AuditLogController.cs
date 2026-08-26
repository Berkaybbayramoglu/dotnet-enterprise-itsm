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
        var ticketQuery = _context.TicketHistories.AsQueryable();
        var systemQuery = _context.SystemAuditLogs.AsQueryable();
        
        bool isTicketFiltered = false;

        if (!string.IsNullOrEmpty(filter.Ticket))
        {
            var ticketStr = filter.Ticket.Trim().ToUpper();
            if (ticketStr.StartsWith("ITS-"))
            {
                if (int.TryParse(ticketStr.AsSpan(4), out int parsedId))
                {
                    ticketQuery = ticketQuery.Where(h => h.TicketId == parsedId);
                    isTicketFiltered = true;
                }
            }
            else if (int.TryParse(ticketStr, out int parsedId))
            {
                ticketQuery = ticketQuery.Where(h => h.TicketId == parsedId);
                isTicketFiltered = true;
            }
        }

        if (!string.IsNullOrEmpty(filter.Action))
        {
            ticketQuery = ticketQuery.Where(h => h.Action == filter.Action);
            systemQuery = systemQuery.Where(h => h.Action == filter.Action);
        }

        if (filter.UserId.HasValue)
        {
            var userIdStr = filter.UserId.Value.ToString();
            ticketQuery = ticketQuery.Where(h => h.CreatedBy == userIdStr);
            systemQuery = systemQuery.Where(h => h.CreatedBy == userIdStr);
        }

        if (filter.FromDate.HasValue)
        {
            ticketQuery = ticketQuery.Where(h => h.CreatedAt >= filter.FromDate.Value);
            systemQuery = systemQuery.Where(h => h.CreatedAt >= filter.FromDate.Value);
        }

        if (filter.ToDate.HasValue)
        {
            ticketQuery = ticketQuery.Where(h => h.CreatedAt <= filter.ToDate.Value);
            systemQuery = systemQuery.Where(h => h.CreatedAt <= filter.ToDate.Value);
        }

        var ticketCount = await ticketQuery.CountAsync();
        var systemCount = isTicketFiltered ? 0 : await systemQuery.CountAsync();
        var totalCount = ticketCount + systemCount;

        var ticketItems = await ticketQuery
            .OrderByDescending(h => h.CreatedAt)
            .Take(filter.PageSize * filter.Page)
            .Select(h => new AuditLogItemDto(
                h.Id,
                h.TicketId,
                h.Action,
                h.FieldName,
                h.OldValue,
                h.NewValue,
                h.CreatedBy ?? "system",
                h.CreatedAt,
                null,
                null
            ))
            .ToListAsync();

        var systemItems = new System.Collections.Generic.List<AuditLogItemDto>();
        if (!isTicketFiltered)
        {
            systemItems = await systemQuery
                .OrderByDescending(h => h.CreatedAt)
                .Take(filter.PageSize * filter.Page)
                .Select(h => new AuditLogItemDto(
                    h.Id,
                    null,
                    h.Action,
                    h.FieldName ?? "",
                    h.OldValue,
                    h.NewValue,
                    h.CreatedBy ?? "system",
                    h.CreatedAt,
                    h.EntityName,
                    h.EntityId
                ))
                .ToListAsync();
        }

        var items = ticketItems.Concat(systemItems)
            .OrderByDescending(h => h.CreatedAt)
            .Skip((filter.Page - 1) * filter.PageSize)
            .Take(filter.PageSize)
            .ToList();

        return Ok(new PaginatedAuditLogDto(items, totalCount, filter.Page, filter.PageSize));
    }
}
