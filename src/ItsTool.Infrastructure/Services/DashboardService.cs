using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.Infrastructure.Services;

public class DashboardService : IDashboardService
{
    private readonly ItsToolDbContext _context;
    private readonly IPermissionCalculator _permissionCalculator;

    public DashboardService(ItsToolDbContext context, IPermissionCalculator permissionCalculator)
    {
        _context = context;
        _permissionCalculator = permissionCalculator;
    }

    private async Task<IQueryable<Ticket>> GetScopedTicketsQueryAsync(int userId)
    {
        var perms = await _permissionCalculator.CalculateEffectivePermissionsAsync(userId);
        
        var query = _context.Tickets.Include(t => t.TicketSla).Where(t => !t.IsDeleted);

        if (perms.Contains("report.view"))
        {
            // Admin / Report Viewer: All tickets
            return query;
        }

        var isAgent = perms.Contains("ticket.manage") || perms.Contains("ticket.assign");
        if (isAgent)
        {
            var userGroupIds = await _context.GroupMembers
                .Where(gm => gm.UserId == userId && !gm.IsDeleted)
                .Select(gm => gm.GroupId)
                .ToListAsync();

            return query.Where(t => t.AssignedUserId == userId || 
                                    (t.AssignedGroupId.HasValue && userGroupIds.Contains(t.AssignedGroupId.Value)) ||
                                    t.RequesterUserId == userId);
        }

        // End user
        return query.Where(t => t.RequesterUserId == userId);
    }

    public async Task<DashboardOverviewDto> GetOverviewAsync(int userId)
    {
        var query = await GetScopedTicketsQueryAsync(userId);

        var openTicketsCount = await query.CountAsync(t => t.Status != null && !t.Status.IsClosedStatus);
        var criticalTicketsCount = await query.CountAsync(t => t.Priority != null && t.Priority.SeverityLevel == 1 && t.Status != null && !t.Status.IsClosedStatus);
        var slaBreachedCount = await query.CountAsync(t => t.TicketSla != null && (t.TicketSla.FirstResponseBreached || t.TicketSla.ResolutionBreached) && t.Status != null && !t.Status.IsClosedStatus);
        var slaRiskCount = await query.CountAsync(t => t.TicketSla != null && (t.TicketSla.FirstResponseWarned || t.TicketSla.ResolutionWarned) && !(t.TicketSla.FirstResponseBreached || t.TicketSla.ResolutionBreached) && t.Status != null && !t.Status.IsClosedStatus);
        var unassignedCount = await query.CountAsync(t => t.AssignedUserId == null && t.Status != null && !t.Status.IsClosedStatus);

        var csatQuery = _context.TicketSurveys.AsQueryable();
        var csatAverage = await csatQuery.AnyAsync() ? await csatQuery.AverageAsync(s => s.Rating) : 0.0;

        return new DashboardOverviewDto(openTicketsCount, criticalTicketsCount, slaBreachedCount, slaRiskCount, unassignedCount, csatAverage);
    }

    public async Task<DashboardDistributionsDto> GetDistributionsAsync(int userId)
    {
        var query = await GetScopedTicketsQueryAsync(userId);

        var byStatus = await query
            .Where(t => t.Status != null)
            .GroupBy(t => t.Status!.Name)
            .Select(g => new TicketDistributionDto(g.Key, g.Count()))
            .ToListAsync();

        var byPriority = await query
            .Where(t => t.Priority != null)
            .GroupBy(t => t.Priority!.Name)
            .Select(g => new TicketDistributionDto(g.Key, g.Count()))
            .ToListAsync();

        var byProject = await query
            .Where(t => t.Project != null)
            .GroupBy(t => t.Project!.Name)
            .Select(g => new TicketDistributionDto(g.Key, g.Count()))
            .ToListAsync();

        var byCategory = await query
            .Where(t => t.Category != null)
            .GroupBy(t => t.Category!.Name)
            .Select(g => new TicketDistributionDto(g.Key, g.Count()))
            .ToListAsync();

        return new DashboardDistributionsDto(byStatus, byPriority, byProject, byCategory);
    }

    public async Task<IEnumerable<AgentWorkloadDto>> GetAgentWorkloadAsync(int userId)
    {
        var query = await GetScopedTicketsQueryAsync(userId);
        
        var workload = await query
            .Where(t => t.AssignedUserId != null && t.Status != null && !t.Status.IsClosedStatus)
            .GroupBy(t => new { t.AssignedUserId, FirstName = t.AssignedUser != null ? t.AssignedUser.FirstName : "Unknown", LastName = t.AssignedUser != null ? t.AssignedUser.LastName : "User" })
            .Select(g => new AgentWorkloadDto(g.Key.AssignedUserId!.Value, $"{g.Key.FirstName} {g.Key.LastName}", g.Count()))
            .ToListAsync();

        return workload.OrderByDescending(w => w.OpenTicketCount);
    }

    public async Task<SlaComplianceDto> GetSlaComplianceAsync(int userId)
    {
        var query = await GetScopedTicketsQueryAsync(userId);
        
        var ticketsWithSla = await query
            .Where(t => t.TicketSla != null)
            .Select(t => new { 
                t.TicketSla!.FirstResponseDueAt, 
                t.TicketSla.FirstResponseMetAt,
                t.TicketSla.ResolutionDueAt,
                t.TicketSla.ResolutionMetAt,
                t.TicketSla.FirstResponseBreached,
                t.TicketSla.ResolutionBreached,
                CreatedAt = t.CreatedAt,
                ResolvedAt = t.Status != null && t.Status.IsClosedStatus ? t.TicketSla.ResolutionMetAt ?? DateTime.UtcNow : (DateTime?)null
            })
            .ToListAsync();

        if (ticketsWithSla.Count == 0) return new SlaComplianceDto(100, 100, 0);

        var firstResponseEligible = ticketsWithSla.Where(t => t.FirstResponseDueAt != null).ToList();
        var frCompliant = firstResponseEligible.Count(t => !t.FirstResponseBreached);
        var frRate = firstResponseEligible.Count > 0 ? (frCompliant / (double)firstResponseEligible.Count) * 100 : 100;

        var resEligible = ticketsWithSla.Where(t => t.ResolutionDueAt != null).ToList();
        var resCompliant = resEligible.Count(t => !t.ResolutionBreached);
        var resRate = resEligible.Count > 0 ? (resCompliant / (double)resEligible.Count) * 100 : 100;

        var resolvedTickets = ticketsWithSla.Where(t => t.ResolvedAt != null).ToList();
        var avgTime = resolvedTickets.Count > 0 ? resolvedTickets.Average(t => (t.ResolvedAt!.Value - t.CreatedAt).TotalMinutes) : 0.0;

        return new SlaComplianceDto(frRate, resRate, avgTime);
    }
}
