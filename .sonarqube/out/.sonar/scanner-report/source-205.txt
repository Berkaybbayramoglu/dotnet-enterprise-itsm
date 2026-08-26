import re
content = open("src/ItsTool.Infrastructure/Data/DataSeeder.cs").read()

if "using Microsoft.EntityFrameworkCore;" not in content:
    content = "using Microsoft.EntityFrameworkCore;\n" + content

# Replace 1: Default Workflow fallback
content = content.replace("""        if (!_context.Workflows.Any())
        {
            var defaultWorkflow = new ItsTool.Domain.Entities.Workflow.Workflow 
            { 
                Name = "Default Global Workflow", 
                Description = "Sistem varsayılan iş akışı", 
                IsActive = true 
            };
            _context.Workflows.Add(defaultWorkflow);
            await _context.SaveChangesAsync();""", """        var defaultWorkflow = await _context.Workflows.FirstOrDefaultAsync(w => w.Name == "Default Global Workflow");
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
        }""")

# Replace 2: WorkflowTransitions block logic correctly keeping scopes
content = content.replace("""            if (openStatus != null && inProgressStatus != null && onHoldStatus != null && resolvedStatus != null && closedStatus != null)
            {
                var existingCount = await _context.WorkflowTransitions.CountAsync(wt => wt.WorkflowId == defaultWorkflow.Id);
                if (existingCount < 14)
                {""", """        if (openStatus != null && inProgressStatus != null && onHoldStatus != null && resolvedStatus != null && closedStatus != null)
        {
            var existingCount = await _context.WorkflowTransitions.CountAsync(wt => wt.WorkflowId == defaultWorkflow.Id);
            if (existingCount < 14)
            {""")

content = content.replace("""                    );
                    await _context.SaveChangesAsync();
                }
            }
        }

        var existingTransitions""", """                    );
                await _context.SaveChangesAsync();
            }
        }

        var existingTransitions""")


open("src/ItsTool.Infrastructure/Data/DataSeeder.cs", "w").write(content)
