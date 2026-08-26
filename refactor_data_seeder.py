import re

def main():
    with open('src/ItsTool.Infrastructure/Data/DataSeeder.cs', 'r') as f:
        content = f.read()

    # 1. Static readonly arrays for permissions
    new_statics = """
    private static readonly string[] ManagerPermissions = new[] { "report.view", "audit.view", "ticket.view", "ticket.assign", "kb.manage" };
    private static readonly string[] AgentPermissions = new[] { "ticket.view", PermissionConstants.TicketEdit, PermissionConstants.TicketResolve, "ticket.comment", "kb.view" };
    private static readonly string[] EndUserPermissions = new[] { "ticket.create", "ticket.view", "survey.submit", "kb.view" };
"""
    content = content.replace("public class DataSeeder\n{", "public class DataSeeder\n{" + new_statics)
    
    # 2. Replace hardcoded arrays with the static variables
    roles_to_seed = """        var rolesToSeed = new Dictionary<string, string[]>
        {
            { "SuperAdmin", allPermissions.ToArray() },
            { "Manager", new[] { "report.view", "audit.view", "ticket.view", "ticket.assign", "kb.manage" } },
            { "Agent", new[] { "ticket.view", PermissionConstants.TicketEdit, PermissionConstants.TicketResolve, "ticket.comment", "kb.view" } },
            { "EndUser", new[] { "ticket.create", "ticket.view", "survey.submit", "kb.view" } }
        };"""
    new_roles_to_seed = """        var rolesToSeed = new Dictionary<string, string[]>
        {
            { "SuperAdmin", allPermissions.ToArray() },
            { "Manager", ManagerPermissions },
            { "Agent", AgentPermissions },
            { "EndUser", EndUserPermissions }
        };"""
    content = content.replace(roles_to_seed, new_roles_to_seed)

    # 3. Refactor SeedUsersAsync conditional block
    users_loop = """        foreach (var u in usersToSeed)
        {
            var user = existingUsers.FirstOrDefault(x => x.Username == u.Username);
            if (user == null && itDept != null)
            {
                user = new User
                {
                    Username = u.Username,
                    Email = $"{u.Username}@itsm.local",
                    FirstName = u.FirstName,
                    LastName = u.LastName,
                    DepartmentId = itDept.Id,
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword(u.Password)
                };
                _context.Users.Add(user);
                existingUsers.Add(user);
                await _context.SaveChangesAsync(); // get Id
            }

            if (user != null)
            {
                var role = existingRoles.First(r => r.Name == u.Role);
                if (!user.UserRoles.Any(ur => ur.RoleId == role.Id))
                {
                    _context.UserRoles.Add(new UserRole { UserId = user.Id, RoleId = role.Id });
                }

                if (u.Username == "agent2")
                {
                    var closePerm = existingPermissions.First(p => p.Key == PermissionConstants.TicketClose);
                    if (!user.PermissionOverrides.Any(po => po.PermissionId == closePerm.Id))
                    {
                        _context.UserPermissionOverrides.Add(new UserPermissionOverride
                        {
                            UserId = user.Id,
                            PermissionId = closePerm.Id,
                            IsGranted = true
                        });
                    }
                }
            }
        }"""
    
    new_users_loop = """        foreach (var u in usersToSeed)
        {
            await CreateOrUpdateUserAsync(u, existingUsers, itDept, existingRoles, existingPermissions);
        }"""
    
    create_or_update_user_method = """
    private async Task CreateOrUpdateUserAsync(
        (string Username, string Password, string Role, string FirstName, string LastName) u,
        List<ItsTool.Domain.Entities.Auth.User> existingUsers, 
        ItsTool.Domain.Entities.Organization.Department? itDept,
        List<ItsTool.Domain.Entities.Auth.Role> existingRoles, 
        List<ItsTool.Domain.Entities.Auth.Permission> existingPermissions)
    {
        var user = existingUsers.FirstOrDefault(x => x.Username == u.Username);
        if (user == null && itDept != null)
        {
            user = new ItsTool.Domain.Entities.Auth.User
            {
                Username = u.Username,
                Email = $"{u.Username}@itsm.local",
                FirstName = u.FirstName,
                LastName = u.LastName,
                DepartmentId = itDept.Id,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword(u.Password)
            };
            _context.Users.Add(user);
            existingUsers.Add(user);
            await _context.SaveChangesAsync(); // get Id
        }

        if (user != null)
        {
            var role = existingRoles.First(r => r.Name == u.Role);
            if (!user.UserRoles.Any(ur => ur.RoleId == role.Id))
            {
                _context.UserRoles.Add(new ItsTool.Domain.Entities.Auth.UserRole { UserId = user.Id, RoleId = role.Id });
            }

            if (u.Username == "agent2")
            {
                var closePerm = existingPermissions.First(p => p.Key == PermissionConstants.TicketClose);
                if (!user.PermissionOverrides.Any(po => po.PermissionId == closePerm.Id))
                {
                    _context.UserPermissionOverrides.Add(new ItsTool.Domain.Entities.Auth.UserPermissionOverride
                    {
                        UserId = user.Id,
                        PermissionId = closePerm.Id,
                        IsGranted = true
                    });
                }
            }
        }
    }"""
    
    content = content.replace(users_loop, new_users_loop)
    # inject the helper method at the end of the class
    content = content.rstrip()[:-1] + create_or_update_user_method + "\n}"
    
    # 4. Remove unused itsProject in DataSeeder L249
    unused_its_project = """        var itsProject = await _context.Projects.FirstOrDefaultAsync(p => p.ProjectKey == "ITS");
        // Dynamic Fields Demo"""
    new_unused_its_project = """        // Dynamic Fields Demo"""
    content = content.replace(unused_its_project, new_unused_its_project)

    # 5. Change TransitionName = "Close" to StatusConstants.Closed
    content = content.replace('TransitionName = "Close"', f'TransitionName = StatusConstants.Closed')
    
    # 6. Extract WorkflowTransitions condition
    workflow_transitions = """        if (openStatus != null && inProgressStatus != null && onHoldStatus != null && resolvedStatus != null && closedStatus != null)
        {
            var desiredTransitions = new List<ItsTool.Domain.Entities.Workflow.WorkflowTransition>
            {
                // Open -> {InProgress,Pending,Resolved,Closed}
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = openStatus.Id, ToStatusId = inProgressStatus.Id, IsActive = true, TransitionName = "Start Progress" },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = openStatus.Id, ToStatusId = onHoldStatus.Id, IsActive = true, TransitionName = "Put on Hold" },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = openStatus.Id, ToStatusId = resolvedStatus.Id, IsActive = true, TransitionName = "Resolve", RequiredPermissionKey = PermissionConstants.TicketResolve },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = openStatus.Id, ToStatusId = closedStatus.Id, IsActive = true, TransitionName = StatusConstants.Closed, RequiredPermissionKey = PermissionConstants.TicketClose },

                // In Progress -> {Open,Pending,Resolved,Closed}
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = inProgressStatus.Id, ToStatusId = openStatus.Id, IsActive = true, TransitionName = "Move to Open" },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = inProgressStatus.Id, ToStatusId = onHoldStatus.Id, IsActive = true, TransitionName = "Put on Hold" },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = inProgressStatus.Id, ToStatusId = resolvedStatus.Id, IsActive = true, TransitionName = "Resolve", RequiredPermissionKey = PermissionConstants.TicketResolve },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = inProgressStatus.Id, ToStatusId = closedStatus.Id, IsActive = true, TransitionName = StatusConstants.Closed, RequiredPermissionKey = PermissionConstants.TicketClose },

                // Pending (On Hold) -> {Open,InProgress,Resolved,Closed}
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = onHoldStatus.Id, ToStatusId = openStatus.Id, IsActive = true, TransitionName = "Move to Open" },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = onHoldStatus.Id, ToStatusId = inProgressStatus.Id, IsActive = true, TransitionName = "Resume Progress" },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = onHoldStatus.Id, ToStatusId = resolvedStatus.Id, IsActive = true, TransitionName = "Resolve", RequiredPermissionKey = PermissionConstants.TicketResolve },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = onHoldStatus.Id, ToStatusId = closedStatus.Id, IsActive = true, TransitionName = StatusConstants.Closed, RequiredPermissionKey = PermissionConstants.TicketClose },

                // Resolved -> {Open,InProgress,Pending,Closed}
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = resolvedStatus.Id, ToStatusId = openStatus.Id, IsActive = true, TransitionName = "Reopen to Open", RequiredPermissionKey = PermissionConstants.TicketReopen },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = resolvedStatus.Id, ToStatusId = inProgressStatus.Id, IsActive = true, TransitionName = "Reopen to Progress", RequiredPermissionKey = PermissionConstants.TicketReopen },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = resolvedStatus.Id, ToStatusId = onHoldStatus.Id, IsActive = true, TransitionName = "Reopen to Pending", RequiredPermissionKey = PermissionConstants.TicketReopen },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = resolvedStatus.Id, ToStatusId = closedStatus.Id, IsActive = true, TransitionName = StatusConstants.Closed, RequiredPermissionKey = PermissionConstants.TicketClose },

                // Closed -> {Open,InProgress,Pending,Resolved}
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = closedStatus.Id, ToStatusId = openStatus.Id, IsActive = true, TransitionName = "Reopen to Open", RequiredPermissionKey = PermissionConstants.TicketReopen },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = closedStatus.Id, ToStatusId = inProgressStatus.Id, IsActive = true, TransitionName = "Reopen to Progress", RequiredPermissionKey = PermissionConstants.TicketReopen },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = closedStatus.Id, ToStatusId = onHoldStatus.Id, IsActive = true, TransitionName = "Reopen to Pending", RequiredPermissionKey = PermissionConstants.TicketReopen },
                new() { WorkflowId = defaultWorkflow.Id, FromStatusId = closedStatus.Id, ToStatusId = resolvedStatus.Id, IsActive = true, TransitionName = "Resolve", RequiredPermissionKey = PermissionConstants.TicketResolve }
            };

            var existingTransitions = await _context.WorkflowTransitions.Where(wt => wt.WorkflowId == defaultWorkflow.Id).ToListAsync();
            if (existingTransitions.Count == 0)
            {
                _context.WorkflowTransitions.AddRange(desiredTransitions);
                await _context.SaveChangesAsync();
            }
        }"""
    
    new_workflow_transitions = """        if (openStatus != null && inProgressStatus != null && onHoldStatus != null && resolvedStatus != null && closedStatus != null)
        {
            await AddDefaultTransitionsAsync(defaultWorkflow, openStatus, inProgressStatus, onHoldStatus, resolvedStatus, closedStatus);
        }"""
    
    add_default_transitions_method = """
    private async Task AddDefaultTransitionsAsync(ItsTool.Domain.Entities.Workflow.Workflow defaultWorkflow, 
        ItsTool.Domain.Entities.Ticket.Status openStatus, ItsTool.Domain.Entities.Ticket.Status inProgressStatus, 
        ItsTool.Domain.Entities.Ticket.Status onHoldStatus, ItsTool.Domain.Entities.Ticket.Status resolvedStatus, 
        ItsTool.Domain.Entities.Ticket.Status closedStatus)
    {
        var desiredTransitions = new List<ItsTool.Domain.Entities.Workflow.WorkflowTransition>
        {
            // Open -> {InProgress,Pending,Resolved,Closed}
            new() { WorkflowId = defaultWorkflow.Id, FromStatusId = openStatus.Id, ToStatusId = inProgressStatus.Id, IsActive = true, TransitionName = "Start Progress" },
            new() { WorkflowId = defaultWorkflow.Id, FromStatusId = openStatus.Id, ToStatusId = onHoldStatus.Id, IsActive = true, TransitionName = "Put on Hold" },
            new() { WorkflowId = defaultWorkflow.Id, FromStatusId = openStatus.Id, ToStatusId = resolvedStatus.Id, IsActive = true, TransitionName = "Resolve", RequiredPermissionKey = PermissionConstants.TicketResolve },
            new() { WorkflowId = defaultWorkflow.Id, FromStatusId = openStatus.Id, ToStatusId = closedStatus.Id, IsActive = true, TransitionName = StatusConstants.Closed, RequiredPermissionKey = PermissionConstants.TicketClose },

            // In Progress -> {Open,Pending,Resolved,Closed}
            new() { WorkflowId = defaultWorkflow.Id, FromStatusId = inProgressStatus.Id, ToStatusId = openStatus.Id, IsActive = true, TransitionName = "Move to Open" },
            new() { WorkflowId = defaultWorkflow.Id, FromStatusId = inProgressStatus.Id, ToStatusId = onHoldStatus.Id, IsActive = true, TransitionName = "Put on Hold" },
            new() { WorkflowId = defaultWorkflow.Id, FromStatusId = inProgressStatus.Id, ToStatusId = resolvedStatus.Id, IsActive = true, TransitionName = "Resolve", RequiredPermissionKey = PermissionConstants.TicketResolve },
            new() { WorkflowId = defaultWorkflow.Id, FromStatusId = inProgressStatus.Id, ToStatusId = closedStatus.Id, IsActive = true, TransitionName = StatusConstants.Closed, RequiredPermissionKey = PermissionConstants.TicketClose },

            // Pending (On Hold) -> {Open,InProgress,Resolved,Closed}
            new() { WorkflowId = defaultWorkflow.Id, FromStatusId = onHoldStatus.Id, ToStatusId = openStatus.Id, IsActive = true, TransitionName = "Move to Open" },
            new() { WorkflowId = defaultWorkflow.Id, FromStatusId = onHoldStatus.Id, ToStatusId = inProgressStatus.Id, IsActive = true, TransitionName = "Resume Progress" },
            new() { WorkflowId = defaultWorkflow.Id, FromStatusId = onHoldStatus.Id, ToStatusId = resolvedStatus.Id, IsActive = true, TransitionName = "Resolve", RequiredPermissionKey = PermissionConstants.TicketResolve },
            new() { WorkflowId = defaultWorkflow.Id, FromStatusId = onHoldStatus.Id, ToStatusId = closedStatus.Id, IsActive = true, TransitionName = StatusConstants.Closed, RequiredPermissionKey = PermissionConstants.TicketClose },

            // Resolved -> {Open,InProgress,Pending,Closed}
            new() { WorkflowId = defaultWorkflow.Id, FromStatusId = resolvedStatus.Id, ToStatusId = openStatus.Id, IsActive = true, TransitionName = "Reopen to Open", RequiredPermissionKey = PermissionConstants.TicketReopen },
            new() { WorkflowId = defaultWorkflow.Id, FromStatusId = resolvedStatus.Id, ToStatusId = inProgressStatus.Id, IsActive = true, TransitionName = "Reopen to Progress", RequiredPermissionKey = PermissionConstants.TicketReopen },
            new() { WorkflowId = defaultWorkflow.Id, FromStatusId = resolvedStatus.Id, ToStatusId = onHoldStatus.Id, IsActive = true, TransitionName = "Reopen to Pending", RequiredPermissionKey = PermissionConstants.TicketReopen },
            new() { WorkflowId = defaultWorkflow.Id, FromStatusId = resolvedStatus.Id, ToStatusId = closedStatus.Id, IsActive = true, TransitionName = StatusConstants.Closed, RequiredPermissionKey = PermissionConstants.TicketClose },

            // Closed -> {Open,InProgress,Pending,Resolved}
            new() { WorkflowId = defaultWorkflow.Id, FromStatusId = closedStatus.Id, ToStatusId = openStatus.Id, IsActive = true, TransitionName = "Reopen to Open", RequiredPermissionKey = PermissionConstants.TicketReopen },
            new() { WorkflowId = defaultWorkflow.Id, FromStatusId = closedStatus.Id, ToStatusId = inProgressStatus.Id, IsActive = true, TransitionName = "Reopen to Progress", RequiredPermissionKey = PermissionConstants.TicketReopen },
            new() { WorkflowId = defaultWorkflow.Id, FromStatusId = closedStatus.Id, ToStatusId = onHoldStatus.Id, IsActive = true, TransitionName = "Reopen to Pending", RequiredPermissionKey = PermissionConstants.TicketReopen },
            new() { WorkflowId = defaultWorkflow.Id, FromStatusId = closedStatus.Id, ToStatusId = resolvedStatus.Id, IsActive = true, TransitionName = "Resolve", RequiredPermissionKey = PermissionConstants.TicketResolve }
        };

        var existingTransitions = await _context.WorkflowTransitions.Where(wt => wt.WorkflowId == defaultWorkflow.Id).ToListAsync();
        if (existingTransitions.Count == 0)
        {
            _context.WorkflowTransitions.AddRange(desiredTransitions);
            await _context.SaveChangesAsync();
        }
    }"""
    
    content = content.replace(workflow_transitions, new_workflow_transitions)
    content = content.rstrip()[:-1] + add_default_transitions_method + "\n}"

    with open('src/ItsTool.Infrastructure/Data/DataSeeder.cs', 'w') as f:
        f.write(content)

main()
