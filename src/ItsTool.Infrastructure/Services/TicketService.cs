using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Helpers;
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
    private readonly IAssignmentEngine _assignmentEngine;
    private readonly INotificationDispatcher _notificationDispatcher;

    public TicketService(ItsToolDbContext context, IFileStorageService fileStorage, IPermissionCalculator permissionCalculator, ISlaEngine slaEngine, IAssignmentEngine assignmentEngine, INotificationDispatcher notificationDispatcher)
    {
        _context = context;
        _fileStorage = fileStorage;
        _permissionCalculator = permissionCalculator;
        _slaEngine = slaEngine;
        _assignmentEngine = assignmentEngine;
        _notificationDispatcher = notificationDispatcher;
    }

    private async Task<string> GenerateTicketNumberAsync(int? projectId)
    {
        string prefix = "GEN";
        if (projectId.HasValue)
        {
            var project = await _context.Projects.FindAsync(projectId.Value);
            if (project == null) throw new KeyNotFoundException("Project not found.");
            prefix = project.ProjectKey;
        }

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
        return $"{prefix}-{sequence.CurrentValue}";
    }

    private async Task ValidateDynamicFieldsAsync(int? projectId, int categoryId, int typeId, Dictionary<string, string> customFields)
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
        
        // Dynamic assignment rules
        await _assignmentEngine.AssignTicketAsync(t);
        await _context.SaveChangesAsync();

        await _slaEngine.AttachSlaToTicketAsync(t.Id);
        await _notificationDispatcher.DispatchEventAsync("ticket.created", t.Id, dto.RequesterUserId, "A new ticket has been created.");

        return new TicketDto(t.Id, t.TicketNumber, t.Title, t.Description, t.ProjectId, t.CategoryId, t.TypeId, t.StatusId, t.PriorityId, t.RequesterUserId, new List<TicketAssigneeDto>(), null);
    }

    public async Task<TicketDto?> GetTicketByIdAsync(int id)
    {
        var t = await _context.Tickets
            .Include(x => x.Assignments)
            .FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted);
        if (t == null) return null;

        var customFields = await _context.TicketFieldValues
            .Include(tfv => tfv.FieldDefinition)
            .Where(tfv => tfv.TicketId == id)
            .ToDictionaryAsync(tfv => tfv.FieldDefinition!.Key, tfv => tfv.ValueString);

        var assignees = t.Assignments.Where(a => a.IsActive).Select(a => new TicketAssigneeDto(a.Id, a.AssignedUserId, a.AssignedGroupId, a.ParentAssignmentId, a.AssignedByUserId, a.IsActive, a.CreatedAt)).ToList();
        return new TicketDto(t.Id, t.TicketNumber, t.Title, t.Description, t.ProjectId, t.CategoryId, t.TypeId, t.StatusId, t.PriorityId, t.RequesterUserId, assignees, customFields);
    }

    public async Task UpdateTicketAsync(int id, UpdateTicketDto dto, int currentUserId)
    {
        var t = await _context.Tickets.FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted);
        if (t == null) throw new KeyNotFoundException(TicketNotFoundMessage);

        await ValidateDynamicFieldsAsync(t.ProjectId, dto.CategoryId, t.TypeId, dto.CustomFields);

        var historyEntries = new List<TicketHistory>();

        void CheckDiff(string fieldName, string? oldVal, string? newVal)
        {
            if (oldVal != newVal)
            {
                historyEntries.Add(new TicketHistory
                {
                    TicketId = id,
                    Action = "Updated",
                    FieldName = fieldName,
                    OldValue = oldVal,
                    NewValue = newVal,
                    CreatedBy = currentUserId.ToString()
                });
            }
        }

        CheckDiff("Title", t.Title, dto.Title);
        CheckDiff("Description", t.Description, dto.Description);
        CheckDiff("CategoryId", t.CategoryId.ToString(), dto.CategoryId.ToString());
        CheckDiff("PriorityId", t.PriorityId.ToString(), dto.PriorityId.ToString());

        t.Title = dto.Title;
        t.Description = dto.Description;
        t.CategoryId = dto.CategoryId;
        t.PriorityId = dto.PriorityId;

        // Custom fields update logic
        var existingFields = await _context.TicketFieldValues
            .Include(f => f.FieldDefinition)
            .Where(f => f.TicketId == id)
            .ToListAsync();

        foreach (var kvp in dto.CustomFields)
        {
            var def = await _context.FieldDefinitions.FirstOrDefaultAsync(fd => fd.Key == kvp.Key);
            if (def == null) continue;

            var existing = existingFields.FirstOrDefault(f => f.FieldDefinitionId == def.Id);
            if (existing == null)
            {
                _context.TicketFieldValues.Add(new TicketFieldValue
                {
                    TicketId = id,
                    FieldDefinitionId = def.Id,
                    ValueString = kvp.Value
                });
                CheckDiff(kvp.Key, null, kvp.Value);
            }
            else
            {
                if (existing.ValueString != kvp.Value)
                {
                    CheckDiff(kvp.Key, existing.ValueString, kvp.Value);
                    existing.ValueString = kvp.Value;
                }
            }
        }

        if (historyEntries.Count > 0)
        {
            _context.TicketHistories.AddRange(historyEntries);
        }
        await _context.SaveChangesAsync();
    }

    
    public async Task<IEnumerable<StatusDto>> GetAllowedTransitionsAsync(int ticketId, int userId)
    {
        var t = await _context.Tickets.FirstOrDefaultAsync(x => x.Id == ticketId && !x.IsDeleted);
        if (t == null) throw new KeyNotFoundException(TicketNotFoundMessage);

        var wf = await _context.Workflows
            .Where(w => (w.ProjectId == t.ProjectId || w.ProjectId == null) && !w.IsDeleted)
            .OrderByDescending(w => w.ProjectId == t.ProjectId ? 1 : 0)
            .FirstOrDefaultAsync();
        if (wf == null) return Enumerable.Empty<StatusDto>();

        var userPerms = await _permissionCalculator.CalculateEffectivePermissionsAsync(userId);

        var transitions = await _context.WorkflowTransitions
            .Include(wt => wt.ToStatus)
            .Where(wt => wt.WorkflowId == wf.Id && wt.FromStatusId == t.StatusId && !wt.IsDeleted && wt.IsActive)
            .ToListAsync();

        var allowed = transitions.Where(wt => 
            string.IsNullOrEmpty(wt.RequiredPermissionKey) || userPerms.Contains(wt.RequiredPermissionKey))
            .Select(wt => new StatusDto(
                wt.ToStatus!.Id,
                wt.ToStatus.Name,
                null, // ColorHex not in entity? Just pass null or "" 
                wt.ToStatus.SortOrder,
                wt.ToStatus.IsClosedStatus,
                wt.ToStatus.IsSystemDefault,
                true // IsActive
            ))
            .OrderBy(s => s.SortOrder)
            .ToList();
            
        // Also include the current status as an option
        var currentStatus = await _context.Statuses.FirstOrDefaultAsync(s => s.Id == t.StatusId);
        if (currentStatus != null && !allowed.Any(a => a.Id == currentStatus.Id))
        {
            allowed.Insert(0, new StatusDto(
                currentStatus.Id,
                currentStatus.Name,
                null,
                currentStatus.SortOrder,
                currentStatus.IsClosedStatus,
                currentStatus.IsSystemDefault,
                true
            ));
        }

        return allowed;
    }

    public async Task ChangeStatusAsync(int ticketId, ChangeStatusDto dto)
    {
        var t = await _context.Tickets.FirstOrDefaultAsync(x => x.Id == ticketId && !x.IsDeleted);
        if (t == null) throw new KeyNotFoundException(TicketNotFoundMessage);
        if (t.StatusId == dto.NewStatusId) return;

        var transitionName = await ValidateTransitionAsync(t, dto.NewStatusId, dto.UserId);
        
        var oldStatus = t.StatusId;
        t.StatusId = dto.NewStatusId;

        _context.TicketHistories.Add(new TicketHistory
        {
            TicketId = t.Id,
            Action = transitionName.Contains("Reopen", StringComparison.OrdinalIgnoreCase) ? "Reopened" : "StatusChanged",
            FieldName = "StatusId",
            OldValue = oldStatus.ToString(),
            NewValue = dto.NewStatusId.ToString(),
            CreatedBy = dto.UserId.ToString()
        });

        await _context.SaveChangesAsync();

        await _slaEngine.ProcessTicketStatusChangeAsync(t.Id, oldStatus, dto.NewStatusId);

        // Notify for CSAT if status changes to Closed (Assuming 5 is Closed)
        if (dto.NewStatusId == 5 && oldStatus != 5)
        {
            await _notificationDispatcher.DispatchEventAsync("ticket.closed.survey", t.Id, dto.UserId, "Your ticket has been closed. Please fill out the satisfaction survey.");
        }
    }

    private async Task<string> ValidateTransitionAsync(Ticket t, int newStatusId, int userId)
    {
        var wf = await _context.Workflows
            .Where(w => (w.ProjectId == t.ProjectId || w.ProjectId == null) && !w.IsDeleted)
            .OrderByDescending(w => w.ProjectId == t.ProjectId ? 1 : 0)
            .FirstOrDefaultAsync();
        if (wf == null) throw new InvalidOperationException("No workflow found for project.");

        var transition = await _context.WorkflowTransitions.FirstOrDefaultAsync(wt => 
            wt.WorkflowId == wf.Id && wt.FromStatusId == t.StatusId && wt.ToStatusId == newStatusId && !wt.IsDeleted && wt.IsActive);

        if (transition == null) throw new InvalidOperationException("Invalid status transition.");

        if (!string.IsNullOrEmpty(transition.RequiredPermissionKey))
        {
            var perms = await _permissionCalculator.CalculateEffectivePermissionsAsync(userId);
            if (!perms.Contains(transition.RequiredPermissionKey))
                throw new UnauthorizedAccessException($"Missing required permission: {transition.RequiredPermissionKey}");
        }
        return transition.TransitionName;
    }

    public async Task AssignTicketAsync(int ticketId, AssignTicketDto dto)
    {
        var t = await _context.Tickets
            .Include(x => x.Assignments)
            .FirstOrDefaultAsync(x => x.Id == ticketId && !x.IsDeleted);
        if (t == null) throw new KeyNotFoundException(TicketNotFoundMessage);

        var perms = await _permissionCalculator.CalculateEffectivePermissionsAsync(dto.AssignerUserId);
        if (!perms.Contains("ticket.assign")) throw new UnauthorizedAccessException("Missing ticket.assign permission.");
        
        // Strict hierarchy check
        var assigner = await _context.Users.FindAsync(dto.AssignerUserId);
        bool isSuperAdmin = perms.Contains("admin.manage");
        
        if (!isSuperAdmin && dto.ParentAssignmentId.HasValue)
        {
            var parentAssignment = t.Assignments.FirstOrDefault(a => a.Id == dto.ParentAssignmentId);
            if (parentAssignment != null && parentAssignment.AssignedUserId != dto.AssignerUserId)
            {
                // Verify if assigner is in the assigned group
                bool isGroupMember = parentAssignment.AssignedGroupId.HasValue && 
                    await _context.Groups.AnyAsync(g => g.Id == parentAssignment.AssignedGroupId && g.DepartmentId == assigner.DepartmentId);
                
                if (!isGroupMember)
                    throw new UnauthorizedAccessException("You can only delegate your own assignments or group assignments.");
            }
        }
        
        if (!isSuperAdmin)
        {
            // Verify targets are in the same department if not super admin
            foreach (var uId in dto.UserIds)
            {
                var targetUser = await _context.Users.FindAsync(uId);
                if (targetUser != null && targetUser.DepartmentId != assigner?.DepartmentId)
                    throw new UnauthorizedAccessException($"Target user {targetUser.Username} is not in your department.");
            }
        }

        // We only deactivate previous assignments if they are not explicitly in the new list, or maybe we just deactivate all and re-assign?
        // Let's deactivate all active assignments for simplicity if no parent assignment is provided (root level reassignment).
        if (dto.ParentAssignmentId == null) {
            foreach (var a in t.Assignments.Where(x => x.IsActive))
            {
                a.IsActive = false;
            }
        }

        foreach (var uId in dto.UserIds)
        {
            var assignment = new TicketAssignment { TicketId = ticketId, AssignedUserId = uId, AssignedByUserId = dto.AssignerUserId, ParentAssignmentId = dto.ParentAssignmentId };
            _context.TicketAssignments.Add(assignment);
        }

        foreach (var gId in dto.GroupIds)
        {
            var assignment = new TicketAssignment { TicketId = ticketId, AssignedGroupId = gId, AssignedByUserId = dto.AssignerUserId, ParentAssignmentId = dto.ParentAssignmentId };
            _context.TicketAssignments.Add(assignment);
        }

        _context.TicketHistories.Add(new TicketHistory
        {
            TicketId = t.Id,
            Action = "Assigned",
            FieldName = "Assignments",
            OldValue = "Multiple",
            NewValue = $"Users:{string.Join(",", dto.UserIds)},Groups:{string.Join(",", dto.GroupIds)}",
            CreatedBy = dto.AssignerUserId.ToString()
        });

        await _context.SaveChangesAsync();
        await _notificationDispatcher.DispatchEventAsync("ticket.assigned", t.Id, dto.AssignerUserId, $"Ticket assigned to multiple entities");
    }

    public async Task TransferTicketAsync(int ticketId, TransferTicketDto dto)
    {
        var t = await _context.Tickets.FirstOrDefaultAsync(x => x.Id == ticketId && !x.IsDeleted);
        if (t == null) throw new KeyNotFoundException(TicketNotFoundMessage);

        var perms = await _permissionCalculator.CalculateEffectivePermissionsAsync(dto.TransferrerUserId);
        if (!perms.Contains("ticket.transfer")) throw new UnauthorizedAccessException("Missing ticket.transfer permission.");
        
        bool isSuperAdmin = perms.Contains("admin.manage");
        if (!isSuperAdmin && dto.ProjectId.HasValue && dto.ProjectId != t.ProjectId)
        {
            throw new UnauthorizedAccessException("Only administrators can transfer tickets across projects.");
        }

        var oldProj = t.ProjectId;

        if (dto.ProjectId.HasValue) t.ProjectId = dto.ProjectId.Value == -1 ? null : dto.ProjectId.Value;
        
        if (dto.GroupId.HasValue && dto.GroupId.Value != -1) {
            _context.TicketAssignments.Add(new TicketAssignment { TicketId = ticketId, AssignedGroupId = dto.GroupId.Value, AssignedByUserId = dto.TransferrerUserId });
        }

        _context.TicketHistories.Add(new TicketHistory
        {
            TicketId = t.Id,
            Action = "Transferred",
            FieldName = "Transfer",
            OldValue = $"Proj:{oldProj},Grp:-",
            NewValue = $"Proj:{t.ProjectId},Grp:{dto.GroupId}",
            CreatedBy = dto.TransferrerUserId.ToString()
        });

        await _context.SaveChangesAsync();
    }

    public async Task<IEnumerable<TicketAssigneeDto>> GetAssignmentTreeAsync(int ticketId)
    {
        var assignments = await _context.TicketAssignments
            .Where(a => a.TicketId == ticketId)
            .ToListAsync();
            
        return assignments.Select(a => new TicketAssigneeDto(a.Id, a.AssignedUserId, a.AssignedGroupId, a.ParentAssignmentId, a.AssignedByUserId, a.IsActive, a.CreatedAt));
    }

    public async Task<TicketCommentDto> AddCommentAsync(int ticketId, CreateCommentDto dto)
    {
        var c = new TicketComment
        {
            TicketId = ticketId,
            Content = dto.Content,
            IsInternal = dto.IsInternal,
            AuthorUserId = dto.AuthorUserId,
            ParentCommentId = dto.ParentCommentId
        };
        _context.TicketComments.Add(c);
        await _context.SaveChangesAsync();

        _context.TicketHistories.Add(new TicketHistory
        {
            TicketId = ticketId,
            Action = dto.ParentCommentId.HasValue ? "CommentReplied" : (dto.IsInternal ? "InternalNoteAdded" : "CommentAdded"),
            FieldName = c.Id.ToString(),
            OldValue = null,
            NewValue = c.Content,
            CreatedBy = dto.AuthorUserId.ToString()
        });
        await _context.SaveChangesAsync();
        
        await _slaEngine.ProcessTicketCommentAsync(ticketId, dto.IsInternal);
        await _notificationDispatcher.DispatchEventAsync("ticket.comment.added", ticketId, dto.AuthorUserId, "A new comment was added.");
        
        return new TicketCommentDto(c.Id, c.TicketId, c.AuthorUserId, c.Content, c.IsInternal, c.CreatedAt, c.ParentCommentId, c.IsEdited, c.UpdatedAt);
    }

    public async Task<TicketCommentDto> UpdateCommentAsync(int ticketId, int commentId, UpdateCommentDto dto, int userId, bool hasEditPerm)
    {
        var c = await _context.TicketComments.FirstOrDefaultAsync(x => x.Id == commentId && x.TicketId == ticketId && !x.IsDeleted);
        if (c == null) throw new KeyNotFoundException("Comment not found");

        if (c.AuthorUserId != userId && !hasEditPerm)
        {
            throw new UnauthorizedAccessException("You do not have permission to edit this comment.");
        }

        var oldContent = c.Content;
        c.Content = dto.Content;
        c.IsEdited = true;
        c.UpdatedAt = DateTime.UtcNow;

        _context.TicketHistories.Add(new TicketHistory
        {
            TicketId = ticketId,
            Action = "CommentEdited",
            FieldName = c.Id.ToString(),
            OldValue = oldContent,
            NewValue = c.Content,
            CreatedBy = userId.ToString()
        });

        await _context.SaveChangesAsync();
        
        return new TicketCommentDto(c.Id, c.TicketId, c.AuthorUserId, c.Content, c.IsInternal, c.CreatedAt, c.ParentCommentId, c.IsEdited, c.UpdatedAt);
    }

    public async Task DeleteCommentAsync(int ticketId, int commentId, int userId, bool hasDeletePerm)
    {
        var c = await _context.TicketComments.FirstOrDefaultAsync(x => x.Id == commentId && x.TicketId == ticketId && !x.IsDeleted);
        if (c == null) throw new KeyNotFoundException("Comment not found");

        if (c.AuthorUserId != userId && !hasDeletePerm)
            throw new UnauthorizedAccessException("You don't have permission to delete this comment.");

        c.IsDeleted = true;

        _context.TicketHistories.Add(new TicketHistory
        {
            TicketId = ticketId,
            Action = "CommentDeleted",
            FieldName = c.Id.ToString(),
            OldValue = c.Content,
            NewValue = null,
            CreatedBy = userId.ToString()
        });

        await _context.SaveChangesAsync();
    }

    public async Task RestoreCommentAsync(int ticketId, int commentId, int userId, bool hasDeletePerm)
    {
        var c = await _context.TicketComments.FirstOrDefaultAsync(x => x.Id == commentId && x.TicketId == ticketId && x.IsDeleted);
        if (c == null) throw new KeyNotFoundException("Comment not found or not deleted");

        if (c.AuthorUserId != userId && !hasDeletePerm)
            throw new UnauthorizedAccessException("You don't have permission to restore this comment.");

        c.IsDeleted = false;

        // Remove the accidental CommentDeleted history entry so it disappears from logs
        var deletedHistory = await _context.TicketHistories
            .Where(h => h.TicketId == ticketId && h.Action == "CommentDeleted" && h.FieldName == c.Id.ToString())
            .OrderByDescending(h => h.CreatedAt)
            .FirstOrDefaultAsync();
            
        if (deletedHistory != null)
        {
            _context.TicketHistories.Remove(deletedHistory);
        }

        await _context.SaveChangesAsync();
    }

    public async Task<IEnumerable<TicketCommentDto>> GetCommentsAsync(int ticketId, bool includeInternal)
    {
        var q = _context.TicketComments.Where(c => c.TicketId == ticketId && !c.IsDeleted);
        if (!includeInternal) q = q.Where(c => !c.IsInternal);
        
        var list = await q.OrderBy(c => c.CreatedAt).ToListAsync();
        return list.Select(c => new TicketCommentDto(c.Id, c.TicketId, c.AuthorUserId, c.Content, c.IsInternal, c.CreatedAt, c.ParentCommentId, c.IsEdited, c.UpdatedAt));
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

        query = await TicketQueryHelpers.ApplySecurityScopeAsync(query, perms, userId, _context);
        query = TicketQueryHelpers.ApplyBasicFilters(query, filter);
        query = TicketQueryHelpers.ApplyKeywordAndSlaFilters(query, filter);

        query = filter.SortDescending 
            ? query.OrderByDescending(e => EF.Property<object>(e, filter.SortBy ?? "CreatedAt"))
            : query.OrderBy(e => EF.Property<object>(e, filter.SortBy ?? "CreatedAt"));

        var totalCount = await query.CountAsync();

        var tickets = await query
            .Skip((filter.Page - 1) * filter.PageSize)
            .Take(filter.PageSize)
            .Select(t => new TicketDto(t.Id, t.TicketNumber, t.Title, t.Description, t.ProjectId, t.CategoryId, t.TypeId, t.StatusId, t.PriorityId, t.RequesterUserId, t.Assignments.Where(a => a.IsActive).Select(a => new TicketAssigneeDto(a.Id, a.AssignedUserId, a.AssignedGroupId, a.ParentAssignmentId, a.AssignedByUserId, a.IsActive, a.CreatedAt)).ToList(), null))
            .ToListAsync();

        return new PagedResult<TicketDto>
        {
            Items = tickets,
            TotalCount = totalCount,
            Page = filter.Page,
            PageSize = filter.PageSize
        };
    }

    

    

    

    public async Task<TicketSurveyDto> SubmitSurveyAsync(int ticketId, SubmitTicketSurveyDto dto, int userId)
    {
        var ticket = await _context.Tickets.FirstOrDefaultAsync(t => t.Id == ticketId && !t.IsDeleted);
        if (ticket == null) throw new KeyNotFoundException("Ticket not found");

        if (ticket.RequesterUserId != userId)
            throw new UnauthorizedAccessException("Only the requester can submit a survey for this ticket");

        // Assume Status 5 is closed
        if (ticket.StatusId != 5)
            throw new InvalidOperationException("Surveys can only be submitted for closed tickets");

        var existingSurvey = await _context.TicketSurveys.AnyAsync(s => s.TicketId == ticketId);
        if (existingSurvey)
            throw new InvalidOperationException("A survey has already been submitted for this ticket");

        if (dto.Rating < 1 || dto.Rating > 5)
            throw new InvalidOperationException("Rating must be between 1 and 5");

        var survey = new TicketSurvey
        {
            TicketId = ticketId,
            Rating = dto.Rating,
            Comment = dto.Comment
        };

        _context.TicketSurveys.Add(survey);
        await _context.SaveChangesAsync();

        return new TicketSurveyDto(survey.Id, survey.TicketId, survey.Rating, survey.Comment, survey.SubmittedAt);
    }
}
