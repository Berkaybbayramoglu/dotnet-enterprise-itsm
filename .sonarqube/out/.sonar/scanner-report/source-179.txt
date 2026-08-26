import re

with open("src/ItsTool.Infrastructure/Data/DataSeeder.cs", "r") as f:
    content = f.read()

# Replace the AddRange block
old_block = """                    _context.WorkflowTransitions.AddRange(
                        // Open -> X
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = openStatus.Id, ToStatusId = inProgressStatus.Id, IsActive = true, TransitionName = "Start Progress" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = openStatus.Id, ToStatusId = onHoldStatus.Id, IsActive = true, TransitionName = "Put on Hold" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = openStatus.Id, ToStatusId = resolvedStatus.Id, IsActive = true, TransitionName = "Resolve", RequiredPermissionKey = "ticket.resolve" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = openStatus.Id, ToStatusId = closedStatus.Id, IsActive = true, TransitionName = "Close", RequiredPermissionKey = "ticket.close" },

                        // In Progress -> X
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = inProgressStatus.Id, ToStatusId = openStatus.Id, IsActive = true, TransitionName = "Move to Open" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = inProgressStatus.Id, ToStatusId = onHoldStatus.Id, IsActive = true, TransitionName = "Put on Hold" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = inProgressStatus.Id, ToStatusId = resolvedStatus.Id, IsActive = true, TransitionName = "Resolve", RequiredPermissionKey = "ticket.resolve" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = inProgressStatus.Id, ToStatusId = closedStatus.Id, IsActive = true, TransitionName = "Close", RequiredPermissionKey = "ticket.close" },

                        // Pending (On Hold) -> X
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = onHoldStatus.Id, ToStatusId = openStatus.Id, IsActive = true, TransitionName = "Move to Open" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = onHoldStatus.Id, ToStatusId = inProgressStatus.Id, IsActive = true, TransitionName = "Resume Progress" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = onHoldStatus.Id, ToStatusId = resolvedStatus.Id, IsActive = true, TransitionName = "Resolve", RequiredPermissionKey = "ticket.resolve" },

                        // Resolved -> X
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = resolvedStatus.Id, ToStatusId = closedStatus.Id, IsActive = true, TransitionName = "Close", RequiredPermissionKey = "ticket.close" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = resolvedStatus.Id, ToStatusId = inProgressStatus.Id, IsActive = true, TransitionName = "Reopen", RequiredPermissionKey = "ticket.reopen" },

                        // Closed -> X
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = closedStatus.Id, ToStatusId = inProgressStatus.Id, IsActive = true, TransitionName = "Reopen", RequiredPermissionKey = "ticket.reopen" }
                    );"""

new_block = """                    _context.WorkflowTransitions.AddRange(
                        // Open -> {InProgress,Pending,Resolved,Closed}
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = openStatus.Id, ToStatusId = inProgressStatus.Id, IsActive = true, TransitionName = "Start Progress" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = openStatus.Id, ToStatusId = onHoldStatus.Id, IsActive = true, TransitionName = "Put on Hold" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = openStatus.Id, ToStatusId = resolvedStatus.Id, IsActive = true, TransitionName = "Resolve", RequiredPermissionKey = "ticket.resolve" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = openStatus.Id, ToStatusId = closedStatus.Id, IsActive = true, TransitionName = "Close", RequiredPermissionKey = "ticket.close" },

                        // In Progress -> {Open,Pending,Resolved,Closed}
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = inProgressStatus.Id, ToStatusId = openStatus.Id, IsActive = true, TransitionName = "Move to Open" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = inProgressStatus.Id, ToStatusId = onHoldStatus.Id, IsActive = true, TransitionName = "Put on Hold" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = inProgressStatus.Id, ToStatusId = resolvedStatus.Id, IsActive = true, TransitionName = "Resolve", RequiredPermissionKey = "ticket.resolve" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = inProgressStatus.Id, ToStatusId = closedStatus.Id, IsActive = true, TransitionName = "Close", RequiredPermissionKey = "ticket.close" },

                        // Pending (On Hold) -> {Open,InProgress,Resolved,Closed}
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = onHoldStatus.Id, ToStatusId = openStatus.Id, IsActive = true, TransitionName = "Move to Open" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = onHoldStatus.Id, ToStatusId = inProgressStatus.Id, IsActive = true, TransitionName = "Resume Progress" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = onHoldStatus.Id, ToStatusId = resolvedStatus.Id, IsActive = true, TransitionName = "Resolve", RequiredPermissionKey = "ticket.resolve" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = onHoldStatus.Id, ToStatusId = closedStatus.Id, IsActive = true, TransitionName = "Close", RequiredPermissionKey = "ticket.close" },

                        // Resolved -> {Open,InProgress,Pending,Closed}
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = resolvedStatus.Id, ToStatusId = openStatus.Id, IsActive = true, TransitionName = "Reopen to Open", RequiredPermissionKey = "ticket.reopen" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = resolvedStatus.Id, ToStatusId = inProgressStatus.Id, IsActive = true, TransitionName = "Reopen to Progress", RequiredPermissionKey = "ticket.reopen" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = resolvedStatus.Id, ToStatusId = onHoldStatus.Id, IsActive = true, TransitionName = "Reopen to Pending", RequiredPermissionKey = "ticket.reopen" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = resolvedStatus.Id, ToStatusId = closedStatus.Id, IsActive = true, TransitionName = "Close", RequiredPermissionKey = "ticket.close" },

                        // Closed -> {Open,InProgress,Pending}
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = closedStatus.Id, ToStatusId = openStatus.Id, IsActive = true, TransitionName = "Reopen to Open", RequiredPermissionKey = "ticket.reopen" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = closedStatus.Id, ToStatusId = inProgressStatus.Id, IsActive = true, TransitionName = "Reopen to Progress", RequiredPermissionKey = "ticket.reopen" },
                        new ItsTool.Domain.Entities.Workflow.WorkflowTransition { WorkflowId = defaultWorkflow.Id, FromStatusId = closedStatus.Id, ToStatusId = onHoldStatus.Id, IsActive = true, TransitionName = "Reopen to Pending", RequiredPermissionKey = "ticket.reopen" }
                    );"""

content = content.replace(old_block, new_block)

# Also fix the count check `if (existingCount < 14)` to `if (existingCount < 19)`
content = content.replace("if (existingCount < 14)", "if (existingCount < 19)")

with open("src/ItsTool.Infrastructure/Data/DataSeeder.cs", "w") as f:
    f.write(content)
