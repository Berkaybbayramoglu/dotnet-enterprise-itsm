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
        
        var query = _context.Tickets
            .Include(t => t.TicketSla)
            .Include(t => t.Status)
            .Include(t => t.Priority)
            .Include(t => t.Project)
            .Include(t => t.Category)
            .Include(t => t.AssignedUser)
            .Where(t => !t.IsDeleted);

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

    public async Task<IEnumerable<DepartmentWorkloadDto>> GetDepartmentWorkloadAsync(int userId)
    {
        var activeUsers = await _context.Users
            .Include(u => u.Department)
            .Where(u => !u.IsDeleted && u.IsActive)
            .ToListAsync();

        var query = await GetScopedTicketsQueryAsync(userId);
        
        var openTicketsCountPerUser = await query
            .Where(t => t.AssignedUserId != null && t.Status != null && !t.Status.IsClosedStatus)
            .GroupBy(t => t.AssignedUserId)
            .Select(g => new { UserId = g.Key, Count = g.Count() })
            .ToDictionaryAsync(k => k.UserId ?? 0, v => v.Count);

        var workload = activeUsers
            .GroupBy(u => new { DepartmentId = u.DepartmentId ?? 0, DepartmentName = u.Department?.Name ?? "No Department" })
            .Select(g => new DepartmentWorkloadDto(
                g.Key.DepartmentId,
                g.Key.DepartmentName,
                g.Sum(u => openTicketsCountPerUser.ContainsKey(u.Id) ? openTicketsCountPerUser[u.Id] : 0),
                g.Select(u => new AgentWorkloadDto(
                    u.Id,
                    $"{u.FirstName} {u.LastName}",
                    openTicketsCountPerUser.ContainsKey(u.Id) ? openTicketsCountPerUser[u.Id] : 0
                )).OrderByDescending(a => a.OpenTicketCount).ToList()
            ))
            .Where(w => w.DepartmentId != 0 || w.OpenTicketCount > 0)
            .OrderByDescending(w => w.OpenTicketCount)
            .ThenBy(w => w.DepartmentName)
            .ToList();

        return workload;
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

    public async Task<IEnumerable<TicketSurveyDto>> GetRecentSurveysAsync(int userId)
    {
        var perms = await _permissionCalculator.CalculateEffectivePermissionsAsync(userId);
        
        // Let's assume we want to return all surveys for users with report.view,
        // else return an empty list or only surveys related to their tickets.
        // For simplicity, we just join with Tickets and apply the same scoped query if needed, 
        // or just return recent 50 surveys for demo purposes.
        var query = _context.TicketSurveys.AsQueryable();

        if (!perms.Contains("report.view"))
        {
            // Limit to surveys they submitted, or nothing. For this drilldown, usually managers/agents view it.
            // But we'll let it pass if they can see the ticket.
            var scopedTickets = await GetScopedTicketsQueryAsync(userId);
            var scopedTicketIds = await scopedTickets.Select(t => t.Id).ToListAsync();
            query = query.Where(s => scopedTicketIds.Contains(s.TicketId));
        }

        var surveys = await query
            .Include(s => s.Ticket)
            .OrderByDescending(s => s.CreatedAt)
            .Take(50)
            .Select(s => new TicketSurveyDto(s.Id, s.TicketId, s.Rating, s.Comment, s.CreatedAt))
            .ToListAsync();

        return surveys;
    }
}
