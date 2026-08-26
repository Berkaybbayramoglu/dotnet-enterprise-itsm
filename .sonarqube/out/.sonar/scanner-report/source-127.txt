using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Helpers;

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

        query = await TicketQueryHelpers.ApplySecurityScopeAsync(query, perms, userId, _context);
        query = TicketQueryHelpers.ApplyBasicFilters(query, filter);
        query = TicketQueryHelpers.ApplyKeywordAndSlaFilters(query, filter);

        query = query.OrderByDescending(t => t.CreatedAt);
        var tickets = await query.Take(10000).ToListAsync();

        return await GenerateCsvStreamAsync(tickets);
    }

    

    

    

    private static async Task<Stream> GenerateCsvStreamAsync(System.Collections.Generic.List<Domain.Entities.Ticket.Ticket> tickets)
    {
        var ms = new MemoryStream();
        var sw = new StreamWriter(ms, Encoding.UTF8);

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
