using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.Infrastructure.Services;

public class ReportService : IReportService
{
    private readonly ItsToolDbContext _context;
    private readonly IPermissionCalculator _permissionCalculator;

    public ReportService(ItsToolDbContext context, IPermissionCalculator permissionCalculator)
    {
        _context = context;
        _permissionCalculator = permissionCalculator;
    }

    public async Task<Stream> ExportTicketsToCsvAsync(TicketSearchFilterDto filter, int userId)
    {
        var perms = await _permissionCalculator.CalculateEffectivePermissionsAsync(userId);
        
        var query = _context.Tickets
            .Include(t => t.Project)
            .Include(t => t.Category)
            .Include(t => t.Type)
            .Include(t => t.Status)
            .Include(t => t.Priority)
            .Include(t => t.RequesterUser)
            .Include(t => t.AssignedUser)
            .Include(t => t.TicketSla)
            .Where(t => !t.IsDeleted);

        // Security Scope filtering
        if (!perms.Contains("report.view"))
        {
            var isAgent = perms.Contains("ticket.manage") || perms.Contains("ticket.assign");
            if (isAgent)
            {
                var userGroupIds = await _context.GroupMembers
                    .Where(gm => gm.UserId == userId && !gm.IsDeleted)
                    .Select(gm => gm.GroupId)
                    .ToListAsync();

                query = query.Where(t => t.AssignedUserId == userId || 
                                        (t.AssignedGroupId.HasValue && userGroupIds.Contains(t.AssignedGroupId.Value)) ||
                                        t.RequesterUserId == userId);
            }
            else
            {
                query = query.Where(t => t.RequesterUserId == userId);
            }
        }

        // Apply filters
        if (filter.ProjectId.HasValue) query = query.Where(t => t.ProjectId == filter.ProjectId.Value);
        if (filter.CategoryId.HasValue) query = query.Where(t => t.CategoryId == filter.CategoryId.Value);
        if (filter.TypeId.HasValue) query = query.Where(t => t.TypeId == filter.TypeId.Value);
        if (filter.StatusId.HasValue) query = query.Where(t => t.StatusId == filter.StatusId.Value);
        if (filter.PriorityId.HasValue) query = query.Where(t => t.PriorityId == filter.PriorityId.Value);
        if (filter.AssigneeUserId.HasValue) query = query.Where(t => t.AssignedUserId == filter.AssigneeUserId.Value);
        if (filter.RequesterUserId.HasValue) query = query.Where(t => t.RequesterUserId == filter.RequesterUserId.Value);
        if (filter.FromDate.HasValue) query = query.Where(t => t.CreatedAt >= filter.FromDate.Value);
        if (filter.ToDate.HasValue) query = query.Where(t => t.CreatedAt <= filter.ToDate.Value);
        
        if (!string.IsNullOrWhiteSpace(filter.Keyword))
        {
            var kw = filter.Keyword.ToLower();
            query = query.Where(t => 
                t.TicketNumber.ToLower().Contains(kw) || 
                t.Title.ToLower().Contains(kw) || 
                t.Description.ToLower().Contains(kw));
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

        // Ordering (Default to CreatedAt Desc)
        query = query.OrderByDescending(t => t.CreatedAt);

        // Limiting to Max 10.000 for safety
        var tickets = await query.Take(10000).ToListAsync();

        var ms = new MemoryStream();
        var sw = new StreamWriter(ms, Encoding.UTF8);

        // Header
        await sw.WriteLineAsync("TicketNumber,Title,Project,Category,Type,Status,Priority,Requester,Assignee,CreatedAt,SLA Status");

        foreach (var t in tickets)
        {
            var slaStatus = "On Track";
            if (t.TicketSla != null)
            {
                if (t.TicketSla.FirstResponseBreached || t.TicketSla.ResolutionBreached) slaStatus = "Breached";
                else if (t.TicketSla.FirstResponseWarned || t.TicketSla.ResolutionWarned) slaStatus = "Warning";
            }

            var line = $"\"{EscapeCsv(t.TicketNumber)}\",\"{EscapeCsv(t.Title)}\",\"{EscapeCsv(t.Project?.Name)}\",\"{EscapeCsv(t.Category?.Name)}\",\"{EscapeCsv(t.Type?.Name)}\",\"{EscapeCsv(t.Status?.Name)}\",\"{EscapeCsv(t.Priority?.Name)}\",\"{EscapeCsv(t.RequesterUser?.FirstName + " " + t.RequesterUser?.LastName)}\",\"{EscapeCsv(t.AssignedUser?.FirstName + " " + t.AssignedUser?.LastName)}\",\"{t.CreatedAt:yyyy-MM-dd HH:mm:ss}\",\"{slaStatus}\"";
            await sw.WriteLineAsync(line);
        }

        await sw.FlushAsync();
        ms.Position = 0;
        return ms;
    }

    private static string EscapeCsv(string? field)
    {
        if (string.IsNullOrEmpty(field)) return "";
        return field.Replace("\"", "\"\"");
    }
}
