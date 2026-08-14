using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Domain.Entities.Project;
using ItsTool.Domain.Entities.Workflow;
using ItsTool.Domain.Entities.Config;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using System.Text.RegularExpressions;
using Microsoft.AspNetCore.Http;

namespace ItsTool.Infrastructure.Services;

public class TicketService : ITicketService
{
    private const string TicketNotFoundMessage = "Ticket not found.";
    private readonly ItsToolDbContext _context;
    private readonly IFileStorageService _fileStorage;
    private readonly IPermissionCalculator _permissionCalculator;
    private readonly ISlaEngine _slaEngine;

    public TicketService(ItsToolDbContext context, IFileStorageService fileStorage, IPermissionCalculator permissionCalculator, ISlaEngine slaEngine)
    {
        _context = context;
        _fileStorage = fileStorage;
        _permissionCalculator = permissionCalculator;
        _slaEngine = slaEngine;
    }

    private async Task<string> GenerateTicketNumberAsync(int projectId)
    {
        var project = await _context.Projects.FindAsync(projectId);
        if (project == null) throw new KeyNotFoundException("Project not found.");

        var sequence = await _context.ProjectSequences.FirstOrDefaultAsync(ps => ps.ProjectId == projectId);
        if (sequence == null)
        {
            sequence = new ProjectSequence { ProjectId = projectId, CurrentValue = 1 };
            _context.ProjectSequences.Add(sequence);
        }
        else
        {
            sequence.CurrentValue++;
        }

        await _context.SaveChangesAsync();
        return $"{project.ProjectKey}-{sequence.CurrentValue}";
    }

    private async Task ValidateDynamicFieldsAsync(int projectId, int categoryId, int typeId, Dictionary<string, string> customFields)
    {
        var placements = await _context.FormFieldPlacements
            .Include(p => p.FieldDefinition)
            .Where(p => !p.IsDeleted && p.IsActive && p.ProjectId == projectId && p.CategoryId == categoryId && p.TicketTypeId == typeId)
            .ToListAsync();

        foreach (var p in placements)
        {
            var def = p.FieldDefinition!;
            customFields.TryGetValue(def.Key, out var val);

            ValidateRequiredField(p, def, val);
            
            if (!string.IsNullOrWhiteSpace(val))
            {
                ValidateRegexFormat(def, val);
                await ValidateFieldOptionsAsync(def, val);
            }
        }
    }

    private static void ValidateRequiredField(FormFieldPlacement placement, FieldDefinition def, string? val)
    {
        if (placement.IsRequired && string.IsNullOrWhiteSpace(val))
            throw new InvalidOperationException($"Field {def.Label} is required.");
    }

    private static void ValidateRegexFormat(FieldDefinition def, string val)
    {
        if (!string.IsNullOrWhiteSpace(def.ValidationRegex))
        {
            try
            {
                if (!Regex.IsMatch(val, def.ValidationRegex, RegexOptions.None, TimeSpan.FromSeconds(2)))
                    throw new InvalidOperationException($"Field {def.Label} format is invalid.");
            }
            catch (RegexMatchTimeoutException)
            {
                throw new InvalidOperationException($"Field {def.Label} format is invalid.");
            }
        }
    }

    private async Task ValidateFieldOptionsAsync(FieldDefinition def, string val)
    {
        if (def.FieldType == FieldType.Dropdown || def.FieldType == FieldType.MultiSelect)
        {
            var options = await _context.FieldOptions.Where(o => o.FieldDefinitionId == def.Id && !o.IsDeleted).Select(o => o.Value).ToListAsync();
            if (!options.Contains(val))
                throw new InvalidOperationException($"Field {def.Label} contains invalid option.");
        }
    }

    public async Task<TicketDto> CreateTicketAsync(CreateTicketDto dto)
    {
        var number = await GenerateTicketNumberAsync(dto.ProjectId);
        await ValidateDynamicFieldsAsync(dto.ProjectId, dto.CategoryId, dto.TypeId, dto.CustomFields);

        // find default status
        var defaultStatus = await _context.Statuses.FirstOrDefaultAsync(s => s.IsSystemDefault && !s.IsDeleted);
        if (defaultStatus == null) throw new InvalidOperationException("System default status not found.");

        var t = new Ticket
        {
            TicketNumber = number,
            Title = dto.Title,
            Description = dto.Description,
            ProjectId = dto.ProjectId,
            CategoryId = dto.CategoryId,
            TypeId = dto.TypeId,
            PriorityId = dto.PriorityId,
            RequesterUserId = dto.RequesterUserId,
            StatusId = defaultStatus.Id
        };
        _context.Tickets.Add(t);
        await _context.SaveChangesAsync();

        foreach (var kvp in dto.CustomFields)
        {
            var def = await _context.FieldDefinitions.FirstOrDefaultAsync(fd => fd.Key == kvp.Key);
            if (def != null)
            {
                _context.TicketFieldValues.Add(new TicketFieldValue
                {
                    TicketId = t.Id,
                    FieldDefinitionId = def.Id,
                    ValueString = kvp.Value
                });
            }
        }

        _context.TicketHistories.Add(new TicketHistory
        {
            TicketId = t.Id,
            Action = "Created",
            FieldName = "Ticket",
            NewValue = t.TicketNumber,
            CreatedBy = dto.RequesterUserId.ToString()
        });
        await _context.SaveChangesAsync();
        
        await _slaEngine.AttachSlaToTicketAsync(t.Id);

        return new TicketDto(t.Id, t.TicketNumber, t.Title, t.Description, t.ProjectId, t.CategoryId, t.TypeId, t.StatusId, t.PriorityId, t.RequesterUserId, t.AssignedUserId, t.AssignedGroupId);
    }

    public async Task<TicketDto?> GetTicketByIdAsync(int id)
    {
        var t = await _context.Tickets.FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted);
        if (t == null) return null;
        return new TicketDto(t.Id, t.TicketNumber, t.Title, t.Description, t.ProjectId, t.CategoryId, t.TypeId, t.StatusId, t.PriorityId, t.RequesterUserId, t.AssignedUserId, t.AssignedGroupId);
    }

    public async Task UpdateTicketAsync(int id, UpdateTicketDto dto, int currentUserId)
    {
        var t = await _context.Tickets.FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted);
        if (t == null) throw new KeyNotFoundException(TicketNotFoundMessage);

        await ValidateDynamicFieldsAsync(t.ProjectId, dto.CategoryId, t.TypeId, dto.CustomFields);

        t.Title = dto.Title;
        t.Description = dto.Description;
        t.CategoryId = dto.CategoryId;
        t.PriorityId = dto.PriorityId;

        // Custom fields update logic would go here in a full system
        // For brevity and scope, ignoring Field History diffs

        await _context.SaveChangesAsync();
    }

    public async Task ChangeStatusAsync(int ticketId, ChangeStatusDto dto)
    {
        var t = await _context.Tickets.FirstOrDefaultAsync(x => x.Id == ticketId && !x.IsDeleted);
        if (t == null) throw new KeyNotFoundException(TicketNotFoundMessage);

        if (t.StatusId == dto.NewStatusId) return;

        // Verify Workflow Transition
        var wf = await _context.Workflows.FirstOrDefaultAsync(w => (w.ProjectId == t.ProjectId || w.ProjectId == null) && !w.IsDeleted);
        if (wf == null) throw new InvalidOperationException("No workflow found for project.");

        var transition = await _context.WorkflowTransitions.FirstOrDefaultAsync(wt => 
            wt.WorkflowId == wf.Id && wt.FromStatusId == t.StatusId && wt.ToStatusId == dto.NewStatusId && !wt.IsDeleted && wt.IsActive);

        if (transition == null)
            throw new InvalidOperationException("Invalid status transition.");

        if (!string.IsNullOrEmpty(transition.RequiredPermissionKey))
        {
            var perms = await _permissionCalculator.CalculateEffectivePermissionsAsync(dto.UserId);
            if (!perms.Contains(transition.RequiredPermissionKey))
                throw new UnauthorizedAccessException($"Missing required permission: {transition.RequiredPermissionKey}");
        }

        var oldStatus = t.StatusId;
        t.StatusId = dto.NewStatusId;

        _context.TicketHistories.Add(new TicketHistory
        {
            TicketId = t.Id,
            Action = "StatusChanged",
            FieldName = "StatusId",
            OldValue = oldStatus.ToString(),
            NewValue = dto.NewStatusId.ToString(),
            CreatedBy = dto.UserId.ToString()
        });

        await _context.SaveChangesAsync();
        
        await _slaEngine.ProcessTicketStatusChangeAsync(t.Id, oldStatus, dto.NewStatusId);
    }

    public async Task AssignTicketAsync(int ticketId, AssignTicketDto dto)
    {
        var t = await _context.Tickets.FirstOrDefaultAsync(x => x.Id == ticketId && !x.IsDeleted);
        if (t == null) throw new KeyNotFoundException(TicketNotFoundMessage);

        var perms = await _permissionCalculator.CalculateEffectivePermissionsAsync(dto.AssignerUserId);
        if (!perms.Contains("ticket.assign")) throw new UnauthorizedAccessException("Missing ticket.assign permission.");

        var oldAssignee = t.AssignedUserId;
        t.AssignedUserId = dto.UserId;

        _context.TicketHistories.Add(new TicketHistory
        {
            TicketId = t.Id,
            Action = "Assigned",
            FieldName = "AssignedUserId",
            OldValue = oldAssignee?.ToString(),
            NewValue = dto.UserId.ToString(),
            CreatedBy = dto.AssignerUserId.ToString()
        });

        await _context.SaveChangesAsync();
    }

    public async Task TransferTicketAsync(int ticketId, TransferTicketDto dto)
    {
        var t = await _context.Tickets.FirstOrDefaultAsync(x => x.Id == ticketId && !x.IsDeleted);
        if (t == null) throw new KeyNotFoundException(TicketNotFoundMessage);

        var perms = await _permissionCalculator.CalculateEffectivePermissionsAsync(dto.TransferrerUserId);
        if (!perms.Contains("ticket.transfer")) throw new UnauthorizedAccessException("Missing ticket.transfer permission.");

        var oldProj = t.ProjectId;
        var oldGroup = t.AssignedGroupId;

        if (dto.ProjectId.HasValue) t.ProjectId = dto.ProjectId.Value;
        if (dto.GroupId.HasValue) t.AssignedGroupId = dto.GroupId.Value;

        _context.TicketHistories.Add(new TicketHistory
        {
            TicketId = t.Id,
            Action = "Transferred",
            FieldName = "Transfer",
            OldValue = $"Proj:{oldProj},Grp:{oldGroup}",
            NewValue = $"Proj:{t.ProjectId},Grp:{t.AssignedGroupId}",
            CreatedBy = dto.TransferrerUserId.ToString()
        });

        await _context.SaveChangesAsync();
    }

    public async Task<TicketCommentDto> AddCommentAsync(int ticketId, CreateCommentDto dto)
    {
        var c = new TicketComment
        {
            TicketId = ticketId,
            Content = dto.Content,
            IsInternal = dto.IsInternal,
            AuthorUserId = dto.AuthorUserId
        };
        _context.TicketComments.Add(c);

        _context.TicketHistories.Add(new TicketHistory
        {
            TicketId = ticketId,
            Action = "CommentAdded",
            FieldName = "Comment",
            NewValue = c.Id.ToString(),
            CreatedBy = dto.AuthorUserId.ToString()
        });

        await _context.SaveChangesAsync();
        
        await _slaEngine.ProcessTicketCommentAsync(ticketId, dto.IsInternal);
        
        return new TicketCommentDto(c.Id, c.TicketId, c.AuthorUserId, c.Content, c.IsInternal, c.CreatedAt);
    }

    public async Task<IEnumerable<TicketCommentDto>> GetCommentsAsync(int ticketId, bool includeInternal)
    {
        var q = _context.TicketComments.Where(c => c.TicketId == ticketId && !c.IsDeleted);
        if (!includeInternal) q = q.Where(c => !c.IsInternal);
        
        var list = await q.OrderBy(c => c.CreatedAt).ToListAsync();
        return list.Select(c => new TicketCommentDto(c.Id, c.TicketId, c.AuthorUserId, c.Content, c.IsInternal, c.CreatedAt));
    }

    public async Task<TicketAttachmentDto> AddAttachmentAsync(int ticketId, IFormFile file, int userId)
    {
        var path = await _fileStorage.SaveFileAsync(file, ticketId);
        
        var a = new TicketAttachment
        {
            TicketId = ticketId,
            FileName = file.FileName,
            FilePath = path,
            FileSize = file.Length,
            ContentType = file.ContentType,
            UploadedByUserId = userId
        };
        _context.TicketAttachments.Add(a);
        
        _context.TicketHistories.Add(new TicketHistory
        {
            TicketId = ticketId,
            Action = "AttachmentAdded",
            FieldName = "Attachment",
            NewValue = a.FileName,
            CreatedBy = userId.ToString()
        });

        await _context.SaveChangesAsync();
        return new TicketAttachmentDto(a.Id, a.TicketId, a.FileName, a.FilePath, a.FileSize, a.ContentType, a.UploadedByUserId, a.CreatedAt);
    }

    public async Task<IEnumerable<TicketAttachmentDto>> GetAttachmentsAsync(int ticketId)
    {
        var list = await _context.TicketAttachments.Where(a => a.TicketId == ticketId && !a.IsDeleted).ToListAsync();
        return list.Select(a => new TicketAttachmentDto(a.Id, a.TicketId, a.FileName, a.FilePath, a.FileSize, a.ContentType, a.UploadedByUserId, a.CreatedAt));
    }

    public async Task AddWatcherAsync(int ticketId, int userId)
    {
        var exists = await _context.TicketWatchers.AnyAsync(w => w.TicketId == ticketId && w.UserId == userId && !w.IsDeleted);
        if (!exists)
        {
            _context.TicketWatchers.Add(new TicketWatcher { TicketId = ticketId, UserId = userId });
            await _context.SaveChangesAsync();
        }
    }

    public async Task RemoveWatcherAsync(int ticketId, int userId)
    {
        var w = await _context.TicketWatchers.FirstOrDefaultAsync(x => x.TicketId == ticketId && x.UserId == userId && !x.IsDeleted);
        if (w != null)
        {
            _context.TicketWatchers.Remove(w);
            await _context.SaveChangesAsync();
        }
    }

    public async Task<IEnumerable<TicketWatcherDto>> GetWatchersAsync(int ticketId)
    {
        var list = await _context.TicketWatchers.Where(w => w.TicketId == ticketId && !w.IsDeleted).ToListAsync();
        return list.Select(w => new TicketWatcherDto(w.TicketId, w.UserId));
    }

    public async Task<IEnumerable<TimelineEventDto>> GetTimelineAsync(int ticketId, bool includeInternal)
    {
        var events = new List<TimelineEventDto>();

        var histories = await _context.TicketHistories.Where(h => h.TicketId == ticketId && !h.IsDeleted).ToListAsync();
        events.AddRange(histories.Select(h => new TimelineEventDto("History", h.CreatedAt, h)));

        var comments = await _context.TicketComments.Where(c => c.TicketId == ticketId && !c.IsDeleted).ToListAsync();
        if (!includeInternal) comments = comments.Where(c => !c.IsInternal).ToList();
        events.AddRange(comments.Select(c => new TimelineEventDto("Comment", c.CreatedAt, c)));

        var attachments = await _context.TicketAttachments.Where(a => a.TicketId == ticketId && !a.IsDeleted).ToListAsync();
        events.AddRange(attachments.Select(a => new TimelineEventDto("Attachment", a.CreatedAt, a)));

        return events.OrderBy(e => e.Timestamp);
    }

    public async Task<PagedResult<TicketDto>> SearchTicketsAsync(TicketSearchFilterDto filter, int userId)
    {
        var perms = await _permissionCalculator.CalculateEffectivePermissionsAsync(userId);
        
        var query = _context.Tickets
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

        // Sorting
        query = filter.SortDescending 
            ? query.OrderByDescending(e => EF.Property<object>(e, filter.SortBy ?? "CreatedAt"))
            : query.OrderBy(e => EF.Property<object>(e, filter.SortBy ?? "CreatedAt"));

        var totalCount = await query.CountAsync();

        var tickets = await query
            .Skip((filter.Page - 1) * filter.PageSize)
            .Take(filter.PageSize)
            .Select(t => new TicketDto(t.Id, t.TicketNumber, t.Title, t.Description, t.ProjectId, t.CategoryId, t.TypeId, t.StatusId, t.PriorityId, t.RequesterUserId, t.AssignedUserId, t.AssignedGroupId))
            .ToListAsync();

        return new PagedResult<TicketDto>
        {
            Items = tickets,
            TotalCount = totalCount,
            Page = filter.Page,
            PageSize = filter.PageSize
        };
    }
}
