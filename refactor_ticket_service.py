import re

def main():
    with open('src/ItsTool.Infrastructure/Services/TicketService.cs', 'r') as f:
        content = f.read()

    # 1. Any() -> Count > 0
    content = content.replace("if (historyEntries.Any())", "if (historyEntries.Count > 0)")

    # 2. Extract ChangeStatusAsync logic
    change_status_original = """    public async Task ChangeStatusAsync(int ticketId, ChangeStatusDto dto)
    {
        var t = await _context.Tickets.FirstOrDefaultAsync(x => x.Id == ticketId && !x.IsDeleted);
        if (t == null) throw new KeyNotFoundException(TicketNotFoundMessage);

        if (t.StatusId == dto.NewStatusId) return;

        // Verify Workflow Transition
        var wf = await _context.Workflows
            .Where(w => (w.ProjectId == t.ProjectId || w.ProjectId == null) && !w.IsDeleted)
            .OrderByDescending(w => w.ProjectId == t.ProjectId ? 1 : 0)
            .FirstOrDefaultAsync();
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
            Action = transition.TransitionName.Contains("Reopen") ? "Reopened" : "StatusChanged",
            FieldName = "StatusId",
            OldValue = oldStatus.ToString(),
            NewValue = dto.NewStatusId.ToString(),
            CreatedBy = dto.UserId.ToString()
        });

        await _context.SaveChangesAsync();
    }"""
    
    change_status_new = """    public async Task ChangeStatusAsync(int ticketId, ChangeStatusDto dto)
    {
        var t = await _context.Tickets.FirstOrDefaultAsync(x => x.Id == ticketId && !x.IsDeleted);
        if (t == null) throw new KeyNotFoundException(TicketNotFoundMessage);
        if (t.StatusId == dto.NewStatusId) return;

        var transitionName = await ValidateAndGetTransitionNameAsync(t, dto.NewStatusId, dto.UserId);

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
    }

    private async Task<string> ValidateAndGetTransitionNameAsync(Ticket t, int newStatusId, int userId)
    {
        var wf = await _context.Workflows
            .Where(w => (w.ProjectId == t.ProjectId || w.ProjectId == null) && !w.IsDeleted)
            .OrderByDescending(w => w.ProjectId == t.ProjectId ? 1 : 0)
            .FirstOrDefaultAsync();
        if (wf == null) throw new InvalidOperationException("No workflow found for project.");

        var transition = await _context.WorkflowTransitions.FirstOrDefaultAsync(wt => 
            wt.WorkflowId == wf.Id && wt.FromStatusId == t.StatusId && wt.ToStatusId == newStatusId && !wt.IsDeleted && wt.IsActive);

        if (transition == null)
            throw new InvalidOperationException("Invalid status transition.");

        if (!string.IsNullOrEmpty(transition.RequiredPermissionKey))
        {
            var perms = await _permissionCalculator.CalculateEffectivePermissionsAsync(userId);
            if (!perms.Contains(transition.RequiredPermissionKey))
                throw new UnauthorizedAccessException($"Missing required permission: {transition.RequiredPermissionKey}");
        }

        return transition.TransitionName;
    }"""
    
    content = content.replace(change_status_original, change_status_new)

    with open('src/ItsTool.Infrastructure/Services/TicketService.cs', 'w') as f:
        f.write(content)

main()
