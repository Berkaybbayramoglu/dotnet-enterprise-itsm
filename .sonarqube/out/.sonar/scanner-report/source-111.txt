using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.Infrastructure.Services;

public class AssignmentEngine : IAssignmentEngine
{
    private readonly ItsToolDbContext _context;

    public AssignmentEngine(ItsToolDbContext context)
    {
        _context = context;
    }

    public async Task AssignTicketAsync(Ticket ticket)
    {
        var rules = await _context.AssignmentRules
            .Where(r => r.IsActive && !r.IsDeleted)
            .OrderBy(r => r.SortOrder)
            .ToListAsync();

        foreach (var rule in rules)
        {
            if (rule.ProjectId.HasValue && rule.ProjectId.Value != ticket.ProjectId) continue;
            if (rule.CategoryId.HasValue && rule.CategoryId.Value != ticket.CategoryId) continue;
            if (rule.TicketTypeId.HasValue && rule.TicketTypeId.Value != ticket.TypeId) continue;
            if (rule.PriorityId.HasValue && rule.PriorityId.Value != ticket.PriorityId) continue;

            // Match found!
            ticket.AssignedGroupId = rule.TargetGroupId;
            ticket.AssignedUserId = rule.TargetUserId;
            
            // Mark the ticket as assigned in the system implicitly
            return;
        }
    }
}
