using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.Infrastructure.Helpers;

public static class TicketQueryHelpers
{
    public static async Task<IQueryable<Ticket>> ApplySecurityScopeAsync(
        IQueryable<Ticket> query, 
        HashSet<string> perms, 
        int userId,
        ItsToolDbContext context)
    {
        if (!perms.Contains("report.view"))
        {
            var isAgent = perms.Contains("ticket.manage") || perms.Contains("ticket.assign");
            if (isAgent)
            {
                var userGroupIds = await context.GroupMembers
                    .Where(gm => gm.UserId == userId && !gm.IsDeleted)
                    .Select(gm => gm.GroupId)
                    .ToListAsync();

                return query.Where(t => t.Assignments.Any(a => a.IsActive && (a.AssignedUserId == userId || (a.AssignedGroupId.HasValue && userGroupIds.Contains(a.AssignedGroupId.Value)))) ||
                                        t.RequesterUserId == userId);
            }
            return query.Where(t => t.RequesterUserId == userId);
        }
        return query;
    }

    public static IQueryable<Ticket> ApplyBasicFilters(IQueryable<Ticket> query, TicketSearchFilterDto filter)
    {
        if (filter.ProjectId.HasValue) query = query.Where(t => t.ProjectId == filter.ProjectId.Value);
        if (filter.CategoryId.HasValue) query = query.Where(t => t.CategoryId == filter.CategoryId.Value);
        if (filter.TypeId.HasValue) query = query.Where(t => t.TypeId == filter.TypeId.Value);
        if (filter.StatusId.HasValue) query = query.Where(t => t.StatusId == filter.StatusId.Value);
        if (filter.PriorityId.HasValue) query = query.Where(t => t.PriorityId == filter.PriorityId.Value);
        if (filter.AssigneeUserId.HasValue) query = query.Where(t => t.Assignments.Any(a => a.IsActive && a.AssignedUserId == filter.AssigneeUserId.Value));
        if (filter.RequesterUserId.HasValue) query = query.Where(t => t.RequesterUserId == filter.RequesterUserId.Value);
        if (filter.FromDate.HasValue) query = query.Where(t => t.CreatedAt >= filter.FromDate.Value);
        if (filter.ToDate.HasValue) query = query.Where(t => t.CreatedAt <= filter.ToDate.Value);
        if (filter.Unassigned == true) query = query.Where(t => !t.Assignments.Any(a => a.IsActive && !a.IsDeleted));
        if (filter.ExcludeStatusId.HasValue) query = query.Where(t => t.StatusId != filter.ExcludeStatusId.Value);
        return query;
    }

    public static IQueryable<Ticket> ApplyKeywordAndSlaFilters(IQueryable<Ticket> query, TicketSearchFilterDto filter)
    {
        if (!string.IsNullOrWhiteSpace(filter.Keyword))
        {
            var kw = filter.Keyword;
            query = query.Where(t => 
                t.TicketNumber.Contains(kw, StringComparison.OrdinalIgnoreCase) || 
                t.Title.Contains(kw, StringComparison.OrdinalIgnoreCase) || 
                t.Description.Contains(kw, StringComparison.OrdinalIgnoreCase));
        }

        if (!string.IsNullOrWhiteSpace(filter.SlaStatus))
        {
            var s = filter.SlaStatus.ToLower();
            if (s == "breached")
                query = query.Where(t => t.TicketSla != null && (t.TicketSla.FirstResponseBreached || t.TicketSla.ResolutionBreached));
            else if (s == "warning")
                query = query.Where(t => t.TicketSla != null && (t.TicketSla.FirstResponseWarned || t.TicketSla.ResolutionWarned) && !(t.TicketSla.FirstResponseBreached || t.TicketSla.ResolutionBreached));
            else if (s == "ontrack")
                query = query.Where(t => t.TicketSla != null && !t.TicketSla.FirstResponseWarned && !t.TicketSla.ResolutionWarned && !t.TicketSla.FirstResponseBreached && !t.TicketSla.ResolutionBreached);
        }
        return query;
    }
}
