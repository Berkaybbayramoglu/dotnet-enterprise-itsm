using ItsTool.Domain.Common;
using ItsTool.Domain.Entities;
using ItsTool.Domain.Entities.Auth;
using ItsTool.Domain.Entities.Config;
using ItsTool.Domain.Entities.KnowledgeBase;
using ItsTool.Domain.Entities.Notification;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Domain.Entities.Project;
using ItsTool.Domain.Entities.SLA;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Domain.Entities.Workflow;
using ItsTool.Domain.Enums;
using Xunit;

namespace ItsTool.UnitTests.Domain;

public class EntityCoverageTests
{
    [Fact]
    public void TestAuthEntities_PropertiesAndNavigation()
    {
        var role = new Role { Id = 1, Name = "Admin", Description = "Admin Role", CreatedAt = DateTime.UtcNow };
        Assert.Equal(1, role.Id);
        Assert.Equal("Admin", role.Name);
        Assert.Equal("Admin Role", role.Description);
        Assert.NotNull(role.RolePermissions);

        var perm = new Permission { Id = 2, Key = "ticket.create", Name = "Create Ticket", Description = "Create ticket" };
        Assert.Equal(2, perm.Id);
        Assert.Equal("ticket.create", perm.Key);
        Assert.Equal("Create Ticket", perm.Name);
        Assert.Equal("Create ticket", perm.Description);

        var rp = new RolePermission { RoleId = 1, Role = role, PermissionId = 2, Permission = perm };
        Assert.Equal(1, rp.RoleId);
        Assert.Equal(role, rp.Role);
        Assert.Equal(2, rp.PermissionId);
        Assert.Equal(perm, rp.Permission);

        var user = new User { Id = 10, Username = "john", Email = "john@example.com", FirstName = "John", LastName = "Doe" };
        var ur = new UserRole { UserId = 10, User = user, RoleId = 1, Role = role };
        Assert.Equal(10, ur.UserId);
        Assert.Equal(user, ur.User);
        Assert.Equal(1, ur.RoleId);
        Assert.Equal(role, ur.Role);

        var group = new Group { Id = 5, Name = "Support" };
        var gr = new GroupRole { GroupId = 5, Group = group, RoleId = 1, Role = role };
        Assert.Equal(5, gr.GroupId);
        Assert.Equal(group, gr.Group);
        Assert.Equal(1, gr.RoleId);
        Assert.Equal(role, gr.Role);

        var upo = new UserPermissionOverride
        {
            Id = 3,
            UserId = 10,
            User = user,
            PermissionId = 2,
            Permission = perm,
            IsGranted = true
        };
        Assert.Equal(3, upo.Id);
        Assert.Equal(10, upo.UserId);
        Assert.Equal(user, upo.User);
        Assert.Equal(2, upo.PermissionId);
        Assert.Equal(perm, upo.Permission);
        Assert.True(upo.IsGranted);
    }

    [Fact]
    public void TestOrganizationEntities_PropertiesAndNavigation()
    {
        var dept = new Department { Id = 1, Name = "IT", Description = "IT Dept", IsActive = true };
        Assert.Equal(1, dept.Id);
        Assert.Equal("IT", dept.Name);
        Assert.Equal("IT Dept", dept.Description);
        Assert.True(dept.IsActive);
        Assert.NotNull(dept.Users);

        var user = new User
        {
            Id = 1,
            Username = "admin",
            Email = "admin@example.com",
            FirstName = "Admin",
            LastName = "User",
            DepartmentId = 1,
            Department = dept,
            PasswordHash = "hash",
            ProfilePhoto = "admin.jpg"
        };
        Assert.Equal(1, user.Id);
        Assert.Equal("admin", user.Username);
        Assert.Equal("admin@example.com", user.Email);
        Assert.Equal("Admin", user.FirstName);
        Assert.Equal("User", user.LastName);
        Assert.Equal(1, user.DepartmentId);
        Assert.Equal(dept, user.Department);
        Assert.Equal("hash", user.PasswordHash);
        Assert.Equal("admin.jpg", user.ProfilePhoto);
        Assert.NotNull(user.UserRoles);
        Assert.NotNull(user.GroupMemberships);
        Assert.NotNull(user.PermissionOverrides);

        var group = new Group
        {
            Id = 2,
            Name = "Tier 1",
            DepartmentId = 1,
            Department = dept
        };
        Assert.Equal(2, group.Id);
        Assert.Equal("Tier 1", group.Name);
        Assert.Equal(1, group.DepartmentId);
        Assert.Equal(dept, group.Department);
        Assert.NotNull(group.Members);

        var gm = new GroupMember
        {
            Id = 7,
            GroupId = 2,
            Group = group,
            UserId = 1,
            User = user
        };
        Assert.Equal(7, gm.Id);
        Assert.Equal(2, gm.GroupId);
        Assert.Equal(group, gm.Group);
        Assert.Equal(1, gm.UserId);
        Assert.Equal(user, gm.User);

        var pEntity = new Priority { Id = 30, Name = "High" };
        var ttEntity = new TicketType { Id = 20, Name = "Incident" };
        var ar = new AssignmentRule
        {
            Id = 4,
            Name = "Rule 1",
            SortOrder = 1,
            TargetGroupId = 2,
            TargetGroup = group,
            TargetUserId = 1,
            TargetUser = user,
            CategoryId = 10,
            TicketTypeId = 20,
            TicketType = ttEntity,
            PriorityId = 30,
            Priority = pEntity
        };
        Assert.Equal(4, ar.Id);
        Assert.Equal("Rule 1", ar.Name);
        Assert.Equal(1, ar.SortOrder);
        Assert.Equal(2, ar.TargetGroupId);
        Assert.Equal(group, ar.TargetGroup);
        Assert.Equal(1, ar.TargetUserId);
        Assert.Equal(user, ar.TargetUser);
        Assert.Equal(10, ar.CategoryId);
        Assert.Equal(20, ar.TicketTypeId);
        Assert.Equal(ttEntity, ar.TicketType);
        Assert.Equal(30, ar.PriorityId);
        Assert.Equal(pEntity, ar.Priority);
    }

    [Fact]
    public void TestProjectEntities_PropertiesAndNavigation()
    {
        var proj = new Project
        {
            Id = 1,
            ProjectKey = "PROJ",
            Name = "Project Alpha",
            Description = "Main project",
            CurrentTicketSequence = 5,
            Status = ProjectStatus.Active
        };
        Assert.Equal(1, proj.Id);
        Assert.Equal("PROJ", proj.ProjectKey);
        Assert.Equal("Project Alpha", proj.Name);
        Assert.Equal("Main project", proj.Description);
        Assert.Equal(5, proj.CurrentTicketSequence);
        Assert.Equal(ProjectStatus.Active, proj.Status);

        var member = new ProjectMember
        {
            Id = 1,
            ProjectId = 1,
            Project = proj,
            UserId = 5,
            SpecificRoleId = 2
        };
        Assert.Equal(1, member.Id);
        Assert.Equal(1, member.ProjectId);
        Assert.Equal(proj, member.Project);
        Assert.Equal(5, member.UserId);
        Assert.Equal(2, member.SpecificRoleId);

        var seq = new ProjectSequence
        {
            ProjectId = 1,
            Project = proj,
            CurrentValue = 42
        };
        Assert.Equal(1, seq.ProjectId);
        Assert.Equal(proj, seq.Project);
        Assert.Equal(42, seq.CurrentValue);
    }

    [Fact]
    public void TestNotificationEntities_PropertiesAndNavigation()
    {
        var notif = new Notification
        {
            Id = 1,
            UserId = 10,
            Type = "ticket.assigned",
            Title = "Alert",
            Body = "Server down",
            EntityType = "Ticket",
            EntityId = 123,
            Priority = "Normal",
            IsRead = false,
            CreatedAt = DateTime.UtcNow
        };
        Assert.Equal(1, notif.Id);
        Assert.Equal(10, notif.UserId);
        Assert.Equal("ticket.assigned", notif.Type);
        Assert.Equal("Alert", notif.Title);
        Assert.Equal("Server down", notif.Body);
        Assert.Equal("Ticket", notif.EntityType);
        Assert.Equal(123, notif.EntityId);
        Assert.Equal("Normal", notif.Priority);
        Assert.False(notif.IsRead);

        var pref = new NotificationPreference
        {
            Id = 2,
            UserId = 10,
            Category = "Ticket",
            EmailEnabled = true
        };
        Assert.Equal(2, pref.Id);
        Assert.Equal(10, pref.UserId);
        Assert.Equal("Ticket", pref.Category);
        Assert.True(pref.EmailEnabled);
    }

    [Fact]
    public void TestTicketEntities_PropertiesAndNavigation()
    {
        var cat = new Category { Id = 1, ProjectId = 1, Name = "Hardware", Description = "Hardware issues", ParentCategoryId = null, DefaultAssigneeGroupId = 5 };
        Assert.Equal(1, cat.Id);
        Assert.Equal(1, cat.ProjectId);
        Assert.Equal("Hardware", cat.Name);
        Assert.Equal("Hardware issues", cat.Description);
        Assert.Null(cat.ParentCategoryId);
        Assert.Equal(5, cat.DefaultAssigneeGroupId);

        var tt = new TicketType { Id = 2, ProjectId = 1, Name = "Incident", Description = "Incident ticket", Icon = "bug", ColorHex = "#ff0000", IsSystemDefault = true };
        Assert.Equal(2, tt.Id);
        Assert.Equal(1, tt.ProjectId);
        Assert.Equal("Incident", tt.Name);
        Assert.Equal("Incident ticket", tt.Description);
        Assert.Equal("bug", tt.Icon);
        Assert.Equal("#ff0000", tt.ColorHex);
        Assert.True(tt.IsSystemDefault);

        var p = new Priority { Id = 3, Name = "High", ProjectId = 1, Weight = 10, ColorHex = "#ff0000", SortOrder = 1, SeverityLevel = 1 };
        Assert.Equal(3, p.Id);
        Assert.Equal("High", p.Name);
        Assert.Equal(1, p.ProjectId);
        Assert.Equal(10, p.Weight);
        Assert.Equal("#ff0000", p.ColorHex);
        Assert.Equal(1, p.SortOrder);
        Assert.Equal(1, p.SeverityLevel);

        var st = new Status { Id = 4, Name = "Open", ProjectId = 1, IsClosedStatus = false, ColorHex = "#00ff00", SortOrder = 1, IsSystemDefault = true, PausesSla = false };
        Assert.Equal(4, st.Id);
        Assert.Equal("Open", st.Name);
        Assert.Equal(1, st.ProjectId);
        Assert.False(st.IsClosedStatus);
        Assert.Equal("#00ff00", st.ColorHex);
        Assert.Equal(1, st.SortOrder);
        Assert.True(st.IsSystemDefault);
        Assert.False(st.PausesSla);

        var ticket = new Ticket
        {
            Id = 100,
            TicketNumber = "TICK-100",
            Title = "Cannot login",
            Description = "Account locked",
            ProjectId = 1,
            TypeId = 2,
            PriorityId = 3,
            StatusId = 4,
            CategoryId = 1,
            RequesterUserId = 10,
            ExternalMessageId = "msg-123",
            EstimatedStartDate = DateTime.UtcNow,
            EstimatedEndDate = DateTime.UtcNow.AddDays(2),
            ColorHex = "#ffffff",
            IsDeleted = false,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        };
        Assert.Equal(100, ticket.Id);
        Assert.Equal("TICK-100", ticket.TicketNumber);
        Assert.Equal("Cannot login", ticket.Title);
        Assert.Equal("Account locked", ticket.Description);
        Assert.Equal(1, ticket.ProjectId);
        Assert.Equal(2, ticket.TypeId);
        Assert.Equal(3, ticket.PriorityId);
        Assert.Equal(4, ticket.StatusId);
        Assert.Equal(1, ticket.CategoryId);
        Assert.Equal(10, ticket.RequesterUserId);
        Assert.Equal("msg-123", ticket.ExternalMessageId);
        Assert.Equal("#ffffff", ticket.ColorHex);
        Assert.False(ticket.IsDeleted);

        var watcher = new TicketWatcher
        {
            Id = 1,
            TicketId = 100,
            Ticket = ticket,
            UserId = 10,
            CreatedAt = DateTime.UtcNow
        };
        Assert.Equal(1, watcher.Id);
        Assert.Equal(100, watcher.TicketId);
        Assert.Equal(ticket, watcher.Ticket);
        Assert.Equal(10, watcher.UserId);

        var assign = new TicketAssignment
        {
            Id = 2,
            TicketId = 100,
            Ticket = ticket,
            AssignedUserId = 11,
            AssignedGroupId = 5,
            AssignedByUserId = 10,
            ParentAssignmentId = null
        };
        Assert.Equal(2, assign.Id);
        Assert.Equal(100, assign.TicketId);
        Assert.Equal(ticket, assign.Ticket);
        Assert.Equal(11, assign.AssignedUserId);
        Assert.Equal(5, assign.AssignedGroupId);
        Assert.Equal(10, assign.AssignedByUserId);
        Assert.Null(assign.ParentAssignmentId);

        var attach = new TicketAttachment
        {
            Id = 3,
            TicketId = 100,
            Ticket = ticket,
            FileName = "error.png",
            FilePath = "/uploads/error.png",
            ContentType = "image/png",
            FileSize = 1024,
            UploadedByUserId = 10
        };
        Assert.Equal(3, attach.Id);
        Assert.Equal(100, attach.TicketId);
        Assert.Equal(ticket, attach.Ticket);
        Assert.Equal("error.png", attach.FileName);
        Assert.Equal("/uploads/error.png", attach.FilePath);
        Assert.Equal("image/png", attach.ContentType);
        Assert.Equal(1024, attach.FileSize);
        Assert.Equal(10, attach.UploadedByUserId);

        var comment = new TicketComment
        {
            Id = 4,
            TicketId = 100,
            Ticket = ticket,
            AuthorUserId = 10,
            Content = "Investigating",
            IsInternal = true,
            IsEdited = false,
            CreatedAt = DateTime.UtcNow
        };
        Assert.Equal(4, comment.Id);
        Assert.Equal(100, comment.TicketId);
        Assert.Equal(ticket, comment.Ticket);
        Assert.Equal(10, comment.AuthorUserId);
        Assert.Equal("Investigating", comment.Content);
        Assert.True(comment.IsInternal);
        Assert.False(comment.IsEdited);

        var hist = new TicketHistory
        {
            Id = 5,
            TicketId = 100,
            Ticket = ticket,
            FieldName = "Status",
            OldValue = "Open",
            NewValue = "In Progress",
            Action = "UPDATE",
            CreatedAt = DateTime.UtcNow
        };
        Assert.Equal(5, hist.Id);
        Assert.Equal(100, hist.TicketId);
        Assert.Equal(ticket, hist.Ticket);
        Assert.Equal("Status", hist.FieldName);
        Assert.Equal("Open", hist.OldValue);
        Assert.Equal("In Progress", hist.NewValue);
        Assert.Equal("UPDATE", hist.Action);

        var survey = new TicketSurvey
        {
            Id = 6,
            TicketId = 100,
            Ticket = ticket,
            Rating = 5,
            Comment = "Great service",
            SubmittedAt = DateTime.UtcNow
        };
        Assert.Equal(6, survey.Id);
        Assert.Equal(100, survey.TicketId);
        Assert.Equal(ticket, survey.Ticket);
        Assert.Equal(5, survey.Rating);
        Assert.Equal("Great service", survey.Comment);
    }

    [Fact]
    public void TestConfigAndCustomFieldEntities_PropertiesAndNavigation()
    {
        var fd = new FieldDefinition
        {
            Id = 1,
            Key = "cost_center",
            Label = "Cost Center",
            FieldType = FieldType.Dropdown,
            ValidationRegex = "^[A-Z0-9]+$"
        };
        Assert.Equal(1, fd.Id);
        Assert.Equal("cost_center", fd.Key);
        Assert.Equal("Cost Center", fd.Label);
        Assert.Equal(FieldType.Dropdown, fd.FieldType);
        Assert.Equal("^[A-Z0-9]+$", fd.ValidationRegex);

        var fo = new FieldOption
        {
            Id = 2,
            FieldDefinitionId = 1,
            FieldDefinition = fd,
            Value = "IT-01",
            Label = "IT Department",
            SortOrder = 1
        };
        Assert.Equal(2, fo.Id);
        Assert.Equal(1, fo.FieldDefinitionId);
        Assert.Equal(fd, fo.FieldDefinition);
        Assert.Equal("IT-01", fo.Value);
        Assert.Equal("IT Department", fo.Label);
        Assert.Equal(1, fo.SortOrder);

        var ffp = new FormFieldPlacement
        {
            Id = 3,
            ProjectId = 10,
            CategoryId = 20,
            TicketTypeId = 30,
            FieldDefinitionId = 1,
            FieldDefinition = fd,
            SortOrder = 2,
            IsRequired = true
        };
        Assert.Equal(3, ffp.Id);
        Assert.Equal(10, ffp.ProjectId);
        Assert.Equal(20, ffp.CategoryId);
        Assert.Equal(30, ffp.TicketTypeId);
        Assert.Equal(1, ffp.FieldDefinitionId);
        Assert.Equal(fd, ffp.FieldDefinition);
        Assert.Equal(2, ffp.SortOrder);
        Assert.True(ffp.IsRequired);

        var tfv = new TicketFieldValue
        {
            Id = 4,
            TicketId = 100,
            FieldDefinitionId = 1,
            FieldDefinition = fd,
            ValueString = "IT-01",
            ValueText = "Extended info"
        };
        Assert.Equal(4, tfv.Id);
        Assert.Equal(100, tfv.TicketId);
        Assert.Equal(1, tfv.FieldDefinitionId);
        Assert.Equal(fd, tfv.FieldDefinition);
        Assert.Equal("IT-01", tfv.ValueString);
        Assert.Equal("Extended info", tfv.ValueText);

        var filter = new SavedFilter
        {
            Id = 5,
            Name = "My Filter",
            UserId = 10,
            QueryJson = "{}"
        };
        Assert.Equal(5, filter.Id);
        Assert.Equal("My Filter", filter.Name);
        Assert.Equal(10, filter.UserId);
        Assert.Equal("{}", filter.QueryJson);

        var wh = new WebhookSubscription
        {
            Id = 6,
            Url = "https://hooks.slack.com/123",
            Secret = "secret",
            EventsCsv = "ticket.created,ticket.updated"
        };
        Assert.Equal(6, wh.Id);
        Assert.Equal("https://hooks.slack.com/123", wh.Url);
        Assert.Equal("secret", wh.Secret);
        Assert.Equal("ticket.created,ticket.updated", wh.EventsCsv);
    }

    [Fact]
    public void TestKnowledgeBaseAndSlaAndWorkflowAndAuditEntities()
    {
        var kbCat = new KnowledgeCategory
        {
            Id = 1,
            Name = "Network",
            ParentId = null
        };
        Assert.Equal(1, kbCat.Id);
        Assert.Equal("Network", kbCat.Name);
        Assert.Null(kbCat.ParentId);

        var kbArt = new KnowledgeArticle
        {
            Id = 2,
            CategoryId = 1,
            Category = kbCat,
            Title = "VPN Setup",
            Content = "Instructions...",
            AuthorUserId = 10,
            Status = ArticleStatus.Published,
            Visibility = ArticleVisibility.Public,
            ViewCount = 100,
            ManagerFeedback = "Approved",
            CreatedAt = DateTime.UtcNow
        };
        Assert.Equal(2, kbArt.Id);
        Assert.Equal(1, kbArt.CategoryId);
        Assert.Equal(kbCat, kbArt.Category);
        Assert.Equal("VPN Setup", kbArt.Title);
        Assert.Equal("Instructions...", kbArt.Content);
        Assert.Equal(10, kbArt.AuthorUserId);
        Assert.Equal(ArticleStatus.Published, kbArt.Status);
        Assert.Equal(ArticleVisibility.Public, kbArt.Visibility);
        Assert.Equal(100, kbArt.ViewCount);
        Assert.Equal("Approved", kbArt.ManagerFeedback);

        var slaPol = new SlaPolicy
        {
            Id = 1,
            Name = "Standard SLA",
            Description = "Standard tier",
            ProjectId = 1,
            EscalateOnBreach = true
        };
        Assert.Equal(1, slaPol.Id);
        Assert.Equal("Standard SLA", slaPol.Name);
        Assert.Equal("Standard tier", slaPol.Description);
        Assert.Equal(1, slaPol.ProjectId);
        Assert.True(slaPol.EscalateOnBreach);

        var slaTarget = new SlaTarget
        {
            Id = 2,
            SlaPolicyId = 1,
            SlaPolicy = slaPol,
            PriorityId = 1,
            TicketTypeId = 2,
            FirstResponseMinutes = 30,
            ResolutionMinutes = 120
        };
        Assert.Equal(2, slaTarget.Id);
        Assert.Equal(1, slaTarget.SlaPolicyId);
        Assert.Equal(slaPol, slaTarget.SlaPolicy);
        Assert.Equal(1, slaTarget.PriorityId);
        Assert.Equal(2, slaTarget.TicketTypeId);
        Assert.Equal(30, slaTarget.FirstResponseMinutes);
        Assert.Equal(120, slaTarget.ResolutionMinutes);

        var bh = new BusinessHour
        {
            Id = 1,
            DayOfWeek = DayOfWeek.Monday,
            StartTime = TimeSpan.FromHours(9),
            EndTime = TimeSpan.FromHours(18),
            IsWorkingDay = true
        };
        Assert.Equal(DayOfWeek.Monday, bh.DayOfWeek);
        Assert.True(bh.IsWorkingDay);

        var hol = new Holiday
        {
            Id = 1,
            Name = "New Year",
            Date = new DateTime(2026, 1, 1),
            IsRecurring = true
        };
        Assert.Equal("New Year", hol.Name);
        Assert.True(hol.IsRecurring);

        var ticketSla = new TicketSla
        {
            Id = 3,
            TicketId = 100,
            FirstResponseDueAt = DateTime.UtcNow.AddMinutes(30),
            ResolutionDueAt = DateTime.UtcNow.AddMinutes(120),
            FirstResponseMetAt = DateTime.UtcNow.AddMinutes(15),
            ResolutionMetAt = null,
            FirstResponseWarned = false,
            FirstResponseBreached = false,
            ResolutionWarned = false,
            ResolutionBreached = false,
            PausedAt = null,
            TotalPausedMinutes = 0,
            EscalatedAt = null
        };
        Assert.Equal(3, ticketSla.Id);
        Assert.Equal(100, ticketSla.TicketId);
        Assert.False(ticketSla.FirstResponseBreached);
        Assert.False(ticketSla.ResolutionBreached);
        Assert.Equal(0, ticketSla.TotalPausedMinutes);

        var wfDef = new Workflow
        {
            Id = 1,
            Name = "Standard Incident Workflow",
            Description = "Default incident workflow",
            ProjectId = 10
        };
        Assert.Equal(1, wfDef.Id);
        Assert.Equal("Standard Incident Workflow", wfDef.Name);
        Assert.Equal("Default incident workflow", wfDef.Description);
        Assert.Equal(10, wfDef.ProjectId);

        var wfTrans = new WorkflowTransition
        {
            Id = 2,
            WorkflowId = 1,
            Workflow = wfDef,
            FromStatusId = 1,
            ToStatusId = 2,
            TransitionName = "Resolve",
            RequiredPermissionKey = "ticket.edit",
            SortOrder = 1
        };
        Assert.Equal(2, wfTrans.Id);
        Assert.Equal(1, wfTrans.WorkflowId);
        Assert.Equal(wfDef, wfTrans.Workflow);
        Assert.Equal(1, wfTrans.FromStatusId);
        Assert.Equal(2, wfTrans.ToStatusId);
        Assert.Equal("Resolve", wfTrans.TransitionName);
        Assert.Equal("ticket.edit", wfTrans.RequiredPermissionKey);
        Assert.Equal(1, wfTrans.SortOrder);

        var audit = new SystemAuditLog
        {
            Id = 1,
            EntityType = "Ticket",
            EntityName = "Incident #100",
            EntityId = "100",
            Action = "UPDATE",
            FieldName = "Status",
            OldValue = "Open",
            NewValue = "Closed"
        };
        Assert.Equal(1, audit.Id);
        Assert.Equal("Ticket", audit.EntityType);
        Assert.Equal("Incident #100", audit.EntityName);
        Assert.Equal("100", audit.EntityId);
        Assert.Equal("UPDATE", audit.Action);
        Assert.Equal("Status", audit.FieldName);
        Assert.Equal("Open", audit.OldValue);
        Assert.Equal("Closed", audit.NewValue);
    }
}
