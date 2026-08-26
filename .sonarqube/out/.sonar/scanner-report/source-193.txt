import re

with open("src/ItsTool.Infrastructure/Data/DataSeeder.cs", "r") as f:
    content = f.read()

# Replace block 1: The default workflow logic. We need it outside the condition and just look it up.
old_wf_block = """        // 13. Default Workflow & Transitions
        if (!_context.Workflows.Any())
        {
            var defaultWorkflow = new ItsTool.Domain.Entities.Workflow.Workflow 
            { 
                Name = "Default Global Workflow", 
                Description = "Sistem varsayılan iş akışı", 
                IsActive = true 
            };
            _context.Workflows.Add(defaultWorkflow);
            await _context.SaveChangesAsync();"""

new_wf_block = """        // 13. Default Workflow & Transitions
        var defaultWorkflow = await _context.Workflows.FirstOrDefaultAsync(w => w.Name == "Default Global Workflow");
        if (defaultWorkflow == null)
        {
            defaultWorkflow = new ItsTool.Domain.Entities.Workflow.Workflow 
            { 
                Name = "Default Global Workflow", 
                Description = "Sistem varsayılan iş akışı", 
                IsActive = true 
            };
            _context.Workflows.Add(defaultWorkflow);
            await _context.SaveChangesAsync();
        }"""
content = content.replace(old_wf_block, new_wf_block)

# Remove the indentation for statuses inside the previously closed block
content = content.replace("""            var openStatus = _context.Statuses.FirstOrDefault(s => s.Name == "Açık");
            var inProgressStatus = _context.Statuses.FirstOrDefault(s => s.Name == "Devam Ediyor");
            var onHoldStatus = _context.Statuses.FirstOrDefault(s => s.Name == "Beklemede");
            var resolvedStatus = _context.Statuses.FirstOrDefault(s => s.Name == "Çözüldü");
            var closedStatus = _context.Statuses.FirstOrDefault(s => s.Name == "Kapatıldı");

            if (openStatus != null && inProgressStatus != null && onHoldStatus != null && resolvedStatus != null && closedStatus != null)
            {
                var existingCount = await _context.WorkflowTransitions.CountAsync(wt => wt.WorkflowId == defaultWorkflow.Id);
                if (existingCount < 14)
                {
                    var oldTransitions = await _context.WorkflowTransitions.Where(wt => wt.WorkflowId == defaultWorkflow.Id).ToListAsync();
                    _context.WorkflowTransitions.RemoveRange(oldTransitions);
                    await _context.SaveChangesAsync();""",
"""        var openStatus = _context.Statuses.FirstOrDefault(s => s.Name == "Açık");
        var inProgressStatus = _context.Statuses.FirstOrDefault(s => s.Name == "Devam Ediyor");
        var onHoldStatus = _context.Statuses.FirstOrDefault(s => s.Name == "Beklemede");
        var resolvedStatus = _context.Statuses.FirstOrDefault(s => s.Name == "Çözüldü");
        var closedStatus = _context.Statuses.FirstOrDefault(s => s.Name == "Kapatıldı");

        if (openStatus != null && inProgressStatus != null && onHoldStatus != null && resolvedStatus != null && closedStatus != null)
        {
            var existingCount = await _context.WorkflowTransitions.CountAsync(wt => wt.WorkflowId == defaultWorkflow.Id);
            if (existingCount < 14)
            {
                var oldTransitions = await _context.WorkflowTransitions.Where(wt => wt.WorkflowId == defaultWorkflow.Id).ToListAsync();
                _context.WorkflowTransitions.RemoveRange(oldTransitions);
                await _context.SaveChangesAsync();""")

# Remove the trailing curly braces and fix existingTransitions logic
content = content.replace("""                    );
                    await _context.SaveChangesAsync();
                }
            }
        }

        var existingTransitions""",
"""                    );
                await _context.SaveChangesAsync();
            }
        }

        var existingTransitions""")

# The inner resolvedStatus/closedStatus/inProgressStatus are now shadowed, so we need to rename them or use the outer ones.
content = content.replace("""        if (existingTransitions.Any())
        {
            var resolvedStatus = _context.Statuses.FirstOrDefault(s => s.Name == "Çözüldü");
            var closedStatus = _context.Statuses.FirstOrDefault(s => s.Name == "Kapatıldı");
            var inProgressStatus = _context.Statuses.FirstOrDefault(s => s.Name == "Devam Ediyor");

            foreach (var et in existingTransitions)
            {
                if ((et.FromStatusId == resolvedStatus?.Id || et.FromStatusId == closedStatus?.Id) && et.ToStatusId == inProgressStatus?.Id)""",
"""        if (existingTransitions.Any())
        {
            var rStatus = _context.Statuses.FirstOrDefault(s => s.Name == "Çözüldü");
            var cStatus = _context.Statuses.FirstOrDefault(s => s.Name == "Kapatıldı");
            var ipStatus = _context.Statuses.FirstOrDefault(s => s.Name == "Devam Ediyor");

            foreach (var et in existingTransitions)
            {
                if ((et.FromStatusId == rStatus?.Id || et.FromStatusId == cStatus?.Id) && et.ToStatusId == ipStatus?.Id)""")


with open("src/ItsTool.Infrastructure/Data/DataSeeder.cs", "w") as f:
    f.write(content)
