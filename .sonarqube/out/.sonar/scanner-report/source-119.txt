using System;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Auth;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using BCrypt.Net;

namespace ItsTool.Infrastructure.Services;

public class EmailIngestionService : IEmailIngestionService
{
    private readonly ItsToolDbContext _context;
    public EmailIngestionService(ItsToolDbContext context)
    {
        _context = context;
    }

    public async Task ProcessIncomingEmailAsync(EmailIngestionDto dto)
    {
        // 1. Dedupe check
        if (string.IsNullOrEmpty(dto.MessageId)) return; // Ignore if no message id

        var existingTicket = await _context.Tickets.FirstOrDefaultAsync(t => t.ExternalMessageId == dto.MessageId);
        if (existingTicket != null) return; // Already processed

        // 2. Identify or Create User
        var user = await _context.Users.FirstOrDefaultAsync(u => string.Equals(u.Email, dto.From, StringComparison.OrdinalIgnoreCase));
        if (user == null)
        {
            user = new User
            {
                Username = dto.From, // Username as email for external users
                Email = dto.From,
                FirstName = "External",
                LastName = "User",
                PasswordHash = BCrypt.Net.BCrypt.HashPassword(Guid.NewGuid().ToString()) // random dummy password
            };
            _context.Users.Add(user);
            await _context.SaveChangesAsync();
        }

        // 3. Routing (Project selection by [PROJECTKEY])
        int projectId = 1; // Default
        try
        {
            var match = Regex.Match(dto.Subject, @"\[(.*?)\]", RegexOptions.None, TimeSpan.FromSeconds(2));
            if (match.Success)
            {
                var pKey = match.Groups[1].Value.ToUpper();
                var project = await _context.Projects.FirstOrDefaultAsync(p => p.ProjectKey == pKey);
                if (project != null)
                {
                    projectId = project.Id;
                }
            }
        }
        catch (RegexMatchTimeoutException)
        {
            // Ignore if timeout occurs, fallback to default project
        }

        // Generate TicketNumber (borrow logic from CreateTicketAsync)
        var proj = await _context.Projects.FindAsync(projectId);
        var seq = await _context.ProjectSequences.FirstOrDefaultAsync(s => s.ProjectId == projectId);
        if (seq == null) {
            seq = new ItsTool.Domain.Entities.Project.ProjectSequence { ProjectId = projectId, CurrentValue = 0 };
            _context.ProjectSequences.Add(seq);
        }
        seq.CurrentValue++;
        var tNumber = $"{proj?.ProjectKey ?? "T"}-{seq.CurrentValue}";
        
        // Ensure default properties
        var category = await _context.Categories.FirstOrDefaultAsync();
        var type = await _context.TicketTypes.FirstOrDefaultAsync();
        var priority = await _context.Priorities.FirstOrDefaultAsync();
        var status = await _context.Statuses.FirstOrDefaultAsync(s => s.IsSystemDefault);

        if (category == null || type == null || priority == null || status == null)
        {
            throw new InvalidOperationException("System defaults not properly seeded for email ingestion");
        }

        // Create Ticket manually instead of ITicketService to inject ExternalMessageId
        var ticket = new Ticket
        {
            TicketNumber = tNumber,
            Title = string.IsNullOrWhiteSpace(dto.Subject) ? "(No Subject)" : dto.Subject,
            Description = dto.Body,
            ProjectId = projectId,
            CategoryId = category.Id,
            TypeId = type.Id,
            PriorityId = priority.Id,
            StatusId = status.Id,
            RequesterUserId = user.Id,
            ExternalMessageId = dto.MessageId
        };

        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        _context.TicketHistories.Add(new TicketHistory
        {
            TicketId = ticket.Id,
            Action = "CreatedViaEmail",
            FieldName = "System",
            NewValue = dto.MessageId,
            CreatedBy = user.Id.ToString()
        });

        await _context.SaveChangesAsync();

        // Note: For full integration, we could resolve IAssignmentEngine & INotificationDispatcher manually here or pass via ITicketService. 
        // For simplicity, we are directly creating the ticket. But to keep features intact, we should ideally trigger assignment.
    }
}
