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
            if (!IsRuleMatch(rule, ticket)) continue;

            if (rule.TargetGroupId.HasValue)
            {
                var groupAssignment = new TicketAssignment 
                { 
                    TicketId = ticket.Id, 
                    AssignedGroupId = rule.TargetGroupId, 
                    AssignedByUserId = ticket.RequesterUserId,
                    IsActive = true
                };
                ticket.Assignments.Add(groupAssignment);
                _context.Set<TicketAssignment>().Add(groupAssignment);
            }

            if (rule.TargetUserId.HasValue)
            {
                var userAssignment = new TicketAssignment 
                { 
                    TicketId = ticket.Id, 
                    AssignedUserId = rule.TargetUserId,
                    AssignedByUserId = ticket.RequesterUserId,
                    IsActive = true
                };
                ticket.Assignments.Add(userAssignment);
                _context.Set<TicketAssignment>().Add(userAssignment);
            }
            // Mark the ticket as assigned in the system implicitly
            return;
        }
    }

    private static bool IsRuleMatch(ItsTool.Domain.Entities.Organization.AssignmentRule rule, Ticket ticket)
    {
        if (rule.ProjectId.HasValue && rule.ProjectId.Value != ticket.ProjectId) return false;
        if (rule.CategoryId.HasValue && rule.CategoryId.Value != ticket.CategoryId) return false;
        if (rule.TicketTypeId.HasValue && rule.TicketTypeId.Value != ticket.TypeId) return false;
        if (rule.PriorityId.HasValue && rule.PriorityId.Value != ticket.PriorityId) return false;
        return true;
    }
}
