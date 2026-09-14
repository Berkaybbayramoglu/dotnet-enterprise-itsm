using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Claims;
using System.Threading.Tasks;
using ItsTool.API.Controllers;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
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
using ItsTool.Infrastructure.Agents;
using ItsTool.Infrastructure.Data;
using ItsTool.Infrastructure.Data.Interceptors;
using ItsTool.Infrastructure.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Abstractions;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class HighCoverageBoostTests : TestBase
{
    private readonly Mock<IHttpContextAccessor> _httpContextAccessorMock;
    private readonly Mock<IEmailService> _emailServiceMock;
    private readonly Mock<INotificationDispatcher> _notificationDispatcherMock;
    private readonly Mock<ILlmService> _llmServiceMock;
    private readonly Mock<IPermissionCalculator> _permissionCalculatorMock;
    private readonly Mock<IAssignmentEngine> _assignmentEngineMock;
    private readonly Mock<ISlaEngine> _slaEngineMock;
    private readonly Mock<ISignalRPusher> _signalRPusherMock;

    public HighCoverageBoostTests() : base()
    {
        _httpContextAccessorMock = new Mock<IHttpContextAccessor>();
        _emailServiceMock = new Mock<IEmailService>();
        _notificationDispatcherMock = new Mock<INotificationDispatcher>();
        _llmServiceMock = new Mock<ILlmService>();
        _permissionCalculatorMock = new Mock<IPermissionCalculator>();
        _assignmentEngineMock = new Mock<IAssignmentEngine>();
        _slaEngineMock = new Mock<ISlaEngine>();
        _signalRPusherMock = new Mock<ISignalRPusher>();

        var user = new ClaimsPrincipal(new ClaimsIdentity(new[]
        {
            new Claim(ClaimTypes.NameIdentifier, "1"),
            new Claim(ClaimTypes.Name, "admin"),
            new Claim("permissions", "ticket.assign"),
            new Claim("permissions", "ticket.manage"),
            new Claim("permissions", "ticket.transfer")
        }, "TestAuth"));
        var httpContext = new DefaultHttpContext { User = user };
        _httpContextAccessorMock.Setup(h => h.HttpContext).Returns(httpContext);
    }

    [Fact]
    public async Task SystemAuditInterceptor_ShouldCoverSlaSummary_GroupMember_SoftDeleteRestore_AndGeneralProps()
    {
        var interceptor = new SystemAuditInterceptor(_httpContextAccessorMock.Object);
        var options = new DbContextOptionsBuilder<ItsToolDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .AddInterceptors(interceptor)
            .Options;

        using var ctx = new ItsToolDbContext(options);

        // 1. SlaPolicy with Project & Targets & Priorities
        var proj = new Project { Name = "AuditProj", ProjectKey = "AP", Status = ProjectStatus.Active };
        ctx.Projects.Add(proj);
        var prio = new Priority { Name = "High", SeverityLevel = 1, ColorHex = "#ff0000" };
        ctx.Priorities.Add(prio);
        await ctx.SaveChangesAsync();

        var sla = new SlaPolicy { Name = "Gold SLA", ProjectId = proj.Id, EscalateOnBreach = true, Description = "Gold Desc" };
        ctx.SlaPolicies.Add(sla);
        await ctx.SaveChangesAsync();

        var target = new SlaTarget { SlaPolicyId = sla.Id, PriorityId = prio.Id, FirstResponseMinutes = 15, ResolutionMinutes = 60 };
        ctx.SlaTargets.Add(target);
        await ctx.SaveChangesAsync();

        // Update SLA policy and soft-delete/restore to trigger GetSlaSummary
        sla.Description = "Updated Gold Desc";
        await ctx.SaveChangesAsync();
        sla.IsDeleted = true;
        await ctx.SaveChangesAsync();
        sla.IsDeleted = false;
        await ctx.SaveChangesAsync();

        // 2. GroupMember name resolution
        var user = new User { Username = "audit_user", Email = "u@test.com" };
        var group = new Group { Name = "Audit Team" };
        ctx.Users.Add(user);
        ctx.Groups.Add(group);
        await ctx.SaveChangesAsync();

        var gm = new GroupMember { UserId = user.Id, GroupId = group.Id };
        ctx.GroupMembers.Add(gm);
        await ctx.SaveChangesAsync();

        // 3. Soft delete and Restore
        var cat = new Category { Name = "AuditCat", Description = "Cat Desc" };
        ctx.Categories.Add(cat);
        await ctx.SaveChangesAsync();

        cat.IsDeleted = true;
        await ctx.SaveChangesAsync();

        cat.IsDeleted = false; // Restore branch
        await ctx.SaveChangesAsync();

        // 4. Normal property change (return false in TryProcessSoftDeleteOrRestore)
        cat.Name = "AuditCatRenamed";
        await ctx.SaveChangesAsync();

        // 5. General properties summary entity
        var upo = new UserPermissionOverride { UserId = user.Id, PermissionId = 1, IsGranted = true };
        ctx.UserPermissionOverrides.Add(upo);
        await ctx.SaveChangesAsync();

        upo.IsGranted = false;
        await ctx.SaveChangesAsync();

        var logs = await ctx.SystemAuditLogs.ToListAsync();
        Assert.NotEmpty(logs);
    }

    [Fact]
    public async Task SlaEngine_ShouldHandleComments_Warnings_Breaches_AndEscalations()
    {
        var engine = new SlaEngine(_context, _emailServiceMock.Object, _notificationDispatcherMock.Object);

        // 1. ProcessTicketCommentAsync
        var t = new Ticket { TicketNumber = "T-SLA-1", ProjectId = 1, PriorityId = 1 };
        _context.Tickets.Add(t);
        await _context.SaveChangesAsync();

        var sla = new TicketSla
        {
            TicketId = t.Id,
            CreatedAt = DateTime.UtcNow.AddMinutes(-30),
            FirstResponseDueAt = DateTime.UtcNow.AddMinutes(10), // Within warning range
            ResolutionDueAt = DateTime.UtcNow.AddMinutes(15)     // Within warning range
        };
        _context.TicketSlas.Add(sla);
        await _context.SaveChangesAsync();

        // Internal comment should not set FirstResponseMetAt
        await engine.ProcessTicketCommentAsync(t.Id, isInternal: true);
        Assert.Null(sla.FirstResponseMetAt);

        // Public comment should set FirstResponseMetAt
        await engine.ProcessTicketCommentAsync(t.Id, isInternal: false);
        Assert.NotNull(sla.FirstResponseMetAt);

        // 2. CheckBreachesAsync with Warning triggers
        var user = new User { Email = "sla_user@test.com", FirstName = "SLA", LastName = "User" };
        _context.Users.Add(user);
        _context.TicketAssignments.Add(new TicketAssignment { TicketId = t.Id, AssignedUserId = user.Id, IsActive = true });
        await _context.SaveChangesAsync();

        sla.FirstResponseMetAt = null; // reset for check
        sla.FirstResponseWarned = false;
        sla.ResolutionWarned = false;
        await _context.SaveChangesAsync();

        await engine.CheckBreachesAsync(DateTime.UtcNow);
        Assert.True(sla.FirstResponseWarned || sla.ResolutionWarned);

        // 3. CheckBreachesAsync with Breach & Escalation
        var p1 = new Priority { Name = "Low", SeverityLevel = 1 };
        var p2 = new Priority { Name = "High", SeverityLevel = 2 };
        _context.Priorities.AddRange(p1, p2);
        var policy = new SlaPolicy { Name = "EscalatePolicy", ProjectId = t.ProjectId, EscalateOnBreach = true, IsActive = true };
        _context.SlaPolicies.Add(policy);
        await _context.SaveChangesAsync();

        var target = new SlaTarget { SlaPolicyId = policy.Id, PriorityId = p1.Id, FirstResponseMinutes = 10, ResolutionMinutes = 30, IsActive = true };
        _context.SlaTargets.Add(target);

        t.PriorityId = p1.Id;
        t.Priority = p1;
        sla.FirstResponseDueAt = DateTime.UtcNow.AddMinutes(-10); // Breached
        sla.ResolutionDueAt = DateTime.UtcNow.AddMinutes(-5);     // Breached
        sla.FirstResponseBreached = false;
        sla.ResolutionBreached = false;
        sla.EscalatedAt = null;
        await _context.SaveChangesAsync();

        await engine.CheckBreachesAsync(DateTime.UtcNow);
        Assert.True(sla.FirstResponseBreached);
        Assert.True(sla.ResolutionBreached);
        Assert.NotNull(sla.EscalatedAt);
    }

    [Fact]
    public async Task SlaService_CreatePolicyAsync_ShouldCreatePolicyWithTargets()
    {
        var service = new SlaService(_context);

        var dto = new CreateSlaPolicyDto(
            "VIP SLA",
            "VIP policy description",
            null,
            true,
            new List<CreateSlaTargetDto>
            {
                new CreateSlaTargetDto(0, 1, null, 15, 60),
                new CreateSlaTargetDto(0, 2, null, 30, 120)
            }
        );

        var result = await service.CreatePolicyAsync(dto);
        Assert.NotNull(result);
        Assert.Equal("VIP SLA", result.Name);

        var savedTargets = await _context.SlaTargets.Where(st => st.SlaPolicyId == result.Id).ToListAsync();
        Assert.Equal(2, savedTargets.Count);
    }

    [Fact]
    public async Task TicketHandoffSwarm_ShouldCoverEnAndTrHeuristicsAndRunAsync()
    {
        _llmServiceMock.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync("[AI Modülü Hatası: Bağlantı koptu]");
        _llmServiceMock.Setup(l => l.GetModelName()).Returns("mock-llm");

        var swarm = new TicketHandoffSwarm(_llmServiceMock.Object, _context, NullLogger<TicketHandoffSwarm>.Instance);

        var prio = new Priority { Name = "Urgent", SeverityLevel = 3 };
        var cat = new Category { Name = "Database" };
        var status = new Status { Name = "In Progress" };
        _context.Priorities.Add(prio);
        _context.Categories.Add(cat);
        _context.Statuses.Add(status);
        await _context.SaveChangesAsync();

        var t = new Ticket 
        { 
            TicketNumber = "SWARM-1", 
            Title = "DB Outage", 
            Description = "Database down", 
            PriorityId = prio.Id, 
            Priority = prio,
            CategoryId = cat.Id,
            Category = cat,
            StatusId = status.Id,
            Status = status
        };
        _context.Tickets.Add(t);
        await _context.SaveChangesAsync();

        // 1. Without comments in EN
        var resEnNoComments = await swarm.GenerateHandoffSummaryAsync(t.Id, postAsComment: true, language: "en");
        Assert.True(resEnNoComments.Success);
        Assert.Contains("DB Outage", resEnNoComments.Summary);

        // 2. With comments in EN
        _context.TicketComments.Add(new TicketComment { TicketId = t.Id, Content = "Checking primary replica", IsInternal = false, CreatedBy = "dba" });
        await _context.SaveChangesAsync();

        var resEnWithComments = await swarm.GenerateHandoffSummaryAsync(t.Id, postAsComment: false, language: "en");
        Assert.True(resEnWithComments.Success);
        Assert.Contains("Recent Actions", resEnWithComments.Actions);

        // 3. RunAsync
        await swarm.RunAsync(t);

        // 4. Turkish heuristic
        var resTr = await swarm.GenerateHandoffSummaryAsync(t.Id, postAsComment: false, language: "tr");
        Assert.True(resTr.Success);
        Assert.Contains("numaralı", resTr.Summary);
    }

    [Fact]
    public async Task DashboardService_ShouldCoverSurveysAndDepartmentWorkload()
    {
        var dept = new Department { Name = "NOC" };
        _context.Departments.Add(dept);
        var user = new User { Username = "noc_agent", DepartmentId = dept.Id, IsActive = true, FirstName = "Agent", LastName = "One" };
        _context.Users.Add(user);
        var t = new Ticket { TicketNumber = "DASH-1", RequesterUserId = user.Id, StatusId = 1 };
        _context.Tickets.Add(t);
        var survey = new TicketSurvey { TicketId = t.Id, Rating = 5, Comment = "Great job" };
        _context.TicketSurveys.Add(survey);
        await _context.SaveChangesAsync();

        // Without report.view perm
        _permissionCalculatorMock.Setup(p => p.CalculateEffectivePermissionsAsync(user.Id))
            .ReturnsAsync(new HashSet<string>());

        var dashService = new DashboardService(_context, _permissionCalculatorMock.Object);

        var surveysWithoutPerm = await dashService.GetRecentSurveysAsync(user.Id);
        Assert.NotNull(surveysWithoutPerm);

        var workloadWithoutPerm = await dashService.GetDepartmentWorkloadAsync(user.Id);
        Assert.NotNull(workloadWithoutPerm);

        // With report.view perm
        _permissionCalculatorMock.Setup(p => p.CalculateEffectivePermissionsAsync(user.Id))
            .ReturnsAsync(new HashSet<string> { "report.view" });

        var surveysWithPerm = await dashService.GetRecentSurveysAsync(user.Id);
        Assert.NotEmpty(surveysWithPerm);

        var workloadWithPerm = await dashService.GetDepartmentWorkloadAsync(user.Id);
        Assert.NotEmpty(workloadWithPerm);
    }

    [Fact]
    public void EmailTemplateService_ShouldGenerateSlaAndTicketBodies()
    {
        var service = new EmailTemplateService(NullLogger<EmailTemplateService>.Instance);

        var data = new Dictionary<string, string>
        {
            { "EventName", "SLA Aşımı" },
            { "Context", "Bilet süresi aşıldı" },
            { "AppUrl", "http://localhost:5000" },
            { "TicketNumber", "T-100" }
        };

        var slaBody = service.GenerateEmailBody("sla.breached", data);
        Assert.Contains("SLA Aşımı", slaBody);
        Assert.Contains("T-100", slaBody);

        var ticketBody = service.GenerateEmailBody("ticket.created", data);
        Assert.Contains("T-100", ticketBody);
    }

    [Fact]
    public async Task TicketService_ShouldCoverRegex_Options_CustomFields_AndHierarchyChecks()
    {
        var ticketService = new TicketService(
            _context,
            Mock.Of<IFileStorageService>(),
            _permissionCalculatorMock.Object,
            _slaEngineMock.Object,
            _assignmentEngineMock.Object,
            _notificationDispatcherMock.Object
        );

        var dept1 = new Department { Name = "IT" };
        var dept2 = new Department { Name = "HR" };
        _context.Departments.AddRange(dept1, dept2);

        var u1 = new User { Username = "u1", DepartmentId = dept1.Id, IsActive = true };
        var u2 = new User { Username = "u2", DepartmentId = dept2.Id, IsActive = true };
        _context.Users.AddRange(u1, u2);

        var p = new Project { Name = "CustomProj", ProjectKey = "CP" };
        var cat = new Category { Name = "Hardware" };
        var type = new TicketType { Name = "Incident" };
        var status = new Status { Name = "New", IsSystemDefault = true };
        var prio = new Priority { Name = "Medium", SeverityLevel = 2 };
        _context.Projects.Add(p);
        _context.Categories.Add(cat);
        _context.TicketTypes.Add(type);
        _context.Statuses.Add(status);
        _context.Priorities.Add(prio);
        await _context.SaveChangesAsync();

        // 1. Dynamic field with Regex & Dropdown validations
        var regexDef = new FieldDefinition { Key = "ip_addr", Label = "IP Address", FieldType = FieldType.Text, ValidationRegex = @"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$" };
        var dropDef = new FieldDefinition { Key = "env", Label = "Environment", FieldType = FieldType.Dropdown };
        _context.FieldDefinitions.AddRange(regexDef, dropDef);
        await _context.SaveChangesAsync();

        _context.FieldOptions.Add(new FieldOption { FieldDefinitionId = dropDef.Id, Value = "Production" });
        _context.FormFieldPlacements.Add(new FormFieldPlacement { ProjectId = p.Id, CategoryId = cat.Id, TicketTypeId = type.Id, FieldDefinitionId = regexDef.Id, IsRequired = true, IsActive = true });
        _context.FormFieldPlacements.Add(new FormFieldPlacement { ProjectId = p.Id, CategoryId = cat.Id, TicketTypeId = type.Id, FieldDefinitionId = dropDef.Id, IsRequired = true, IsActive = true });
        await _context.SaveChangesAsync();

        // Invalid regex should throw
        var invalidRegexDto = new CreateTicketDto("Title", "Desc", p.Id, cat.Id, type.Id, prio.Id, u1.Id, new Dictionary<string, string> { { "ip_addr", "invalid_ip" }, { "env", "Production" } });
        await Assert.ThrowsAsync<InvalidOperationException>(() => ticketService.CreateTicketAsync(invalidRegexDto));

        // Invalid dropdown option should throw
        var invalidOptionDto = new CreateTicketDto("Title", "Desc", p.Id, cat.Id, type.Id, prio.Id, u1.Id, new Dictionary<string, string> { { "ip_addr", "192.168.1.1" }, { "env", "Staging" } });
        await Assert.ThrowsAsync<InvalidOperationException>(() => ticketService.CreateTicketAsync(invalidOptionDto));

        // Valid creation
        var validDto = new CreateTicketDto("Title", "Desc", p.Id, cat.Id, type.Id, prio.Id, u1.Id, new Dictionary<string, string> { { "ip_addr", "192.168.1.1" }, { "env", "Production" } });
        var created = await ticketService.CreateTicketAsync(validDto);
        Assert.NotNull(created);

        // 2. UpdateTicketAsync diffs & custom fields
        var updateDto = new UpdateTicketDto("Updated Title", "Updated Desc", cat.Id, prio.Id, new Dictionary<string, string> { { "ip_addr", "10.0.0.1" }, { "env", "Production" } });
        await ticketService.UpdateTicketAsync(created.Id, updateDto, u1.Id);

        var updated = await ticketService.GetTicketByIdAsync(created.Id);
        Assert.Equal("Updated Title", updated!.Title);

        // 3. Comments mention & unauthorized update
        var comment = await ticketService.AddCommentAsync(created.Id, new CreateCommentDto("Initial Comment", false, u1.Id));
        
        // Unauthorized comment edit
        var updateCommentDto = new UpdateCommentDto("Hacked content", null);
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => ticketService.UpdateCommentAsync(created.Id, comment.Id, updateCommentDto, u2.Id, false));

        // Authorized comment edit with mentions
        var validCommentUpdate = new UpdateCommentDto("Valid update @u2", new List<int> { u2.Id });
        var editedComment = await ticketService.UpdateCommentAsync(created.Id, comment.Id, validCommentUpdate, u1.Id, false);
        Assert.True(editedComment.IsEdited);

        // 4. Watchers
        await ticketService.AddWatcherAsync(created.Id, u1.Id);
        var watchers = await ticketService.GetWatchersAsync(created.Id);
        Assert.NotEmpty(watchers);
        await ticketService.RemoveWatcherAsync(created.Id, u1.Id);

        // 5. Assignment hierarchy & department checks
        _permissionCalculatorMock.Setup(pc => pc.CalculateEffectivePermissionsAsync(u1.Id))
            .ReturnsAsync(new HashSet<string> { "ticket.assign" }); // has assign but not admin.manage

        // Trying to assign target user u2 (HR dept) while u1 is in IT dept throws
        var assignDto = new AssignTicketDto(new List<int> { u2.Id }, new List<int>(), u1.Id, null);
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => ticketService.AssignTicketAsync(created.Id, assignDto));

        // 6. Survey validations
        var surveyDto = new SubmitTicketSurveyDto(6, "Bad rating");
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => ticketService.SubmitSurveyAsync(created.Id, surveyDto, u2.Id)); // not requester

        var surveyDto2 = new SubmitTicketSurveyDto(0, "Zero rating");
        await Assert.ThrowsAsync<InvalidOperationException>(() => ticketService.SubmitSurveyAsync(created.Id, surveyDto2, u1.Id)); // status not closed (statusId != 5)
    }

    [Fact]
    public async Task UserService_And_RoleService_ShouldCoverPermissionOverridesAndRoles()
    {
        var userRepoMock = new Mock<IRepository<User>>();
        var userService = new UserService(userRepoMock.Object, _context, _httpContextAccessorMock.Object);
        var roleRepoMock = new Mock<IRepository<Role>>();
        var roleService = new RoleService(roleRepoMock.Object, _context);

        var u = new User { Username = "usertest", Email = "ut@test.com", IsActive = true };
        _context.Users.Add(u);
        var perm = new Permission { Key = "test.perm", Name = "Test Perm" };
        _context.Permissions.Add(perm);
        await _context.SaveChangesAsync();

        // 1. UserService Override
        await userService.AddPermissionOverrideAsync(u.Id, perm.Id, true);
        var hasOverride = await _context.UserPermissionOverrides.AnyAsync(o => o.UserId == u.Id && o.PermissionId == perm.Id);
        Assert.True(hasOverride);

        await userService.RemovePermissionOverrideAsync(u.Id, perm.Id);
        var stillHasOverride = await _context.UserPermissionOverrides.AnyAsync(o => o.UserId == u.Id && o.PermissionId == perm.Id);
        Assert.False(stillHasOverride);

        // Non-existing remove should not throw
        await userService.RemovePermissionOverrideAsync(u.Id, 9999);

        // Reset password
        await userService.ResetPasswordAsync(u.Id, "NewSecretPass123!");
        Assert.True(u.MustChangePassword);

        // 2. RoleService Assign & Revoke
        var role = new Role { Name = "TesterRole" };
        _context.Roles.Add(role);
        await _context.SaveChangesAsync();

        await roleService.AssignPermissionAsync(role.Id, perm.Id);
        await roleService.AssignPermissionAsync(role.Id, perm.Id); // idempotent

        await roleService.RevokePermissionAsync(role.Id, perm.Id);
        await roleService.RevokePermissionAsync(role.Id, 9999); // non-existing
    }

    [Fact]
    public async Task TicketController_DownloadAttachment_ShouldCoverBranches()
    {
        var ticketServiceMock = new Mock<ITicketService>();
        var controller = new TicketController(ticketServiceMock.Object);

        // 1. KeyNotFoundException -> NotFound
        ticketServiceMock.Setup(s => s.GetAttachmentFileInfoAsync(1, 99))
            .ThrowsAsync(new KeyNotFoundException());

        var res1 = await controller.DownloadAttachment(1, 99);
        Assert.IsType<NotFoundResult>(res1);

        // 2. File does not exist on disk -> NotFound
        ticketServiceMock.Setup(s => s.GetAttachmentFileInfoAsync(1, 10))
            .ReturnsAsync(("/non/existent/path.png", "image/png", "path.png"));

        var res2 = await controller.DownloadAttachment(1, 10);
        Assert.IsType<NotFoundResult>(res2);

        // 3. File exists on disk -> PhysicalFile
        var tempFile = Path.GetTempFileName();
        try
        {
            File.WriteAllText(tempFile, "sample data");
            ticketServiceMock.Setup(s => s.GetAttachmentFileInfoAsync(1, 11))
                .ReturnsAsync((tempFile, "text/plain", "sample.txt"));

            var res3 = await controller.DownloadAttachment(1, 11);
            Assert.IsType<PhysicalFileResult>(res3);
        }
        finally
        {
            if (File.Exists(tempFile)) File.Delete(tempFile);
        }
    }

    [Fact]
    public async Task SmtpEmailService_ShouldCoverMissingConfigAndExceptions()
    {
        // 1. Missing config
        var inMemoryConfig = new Dictionary<string, string?>
        {
            { "Smtp:Host", "" },
            { "Smtp:Port", "" }
        };
        var config = new ConfigurationBuilder().AddInMemoryCollection(inMemoryConfig).Build();
        var service = new SmtpEmailService(config, NullLogger<SmtpEmailService>.Instance);
        await service.SendEmailAsync("to@test.com", "Subj", "Body");

        // 2. Invalid port/host throwing exception caught gracefully
        var inMemoryConfig2 = new Dictionary<string, string?>
        {
            { "Smtp:Host", "127.0.0.1" },
            { "Smtp:Port", "1" },
            { "Smtp:Username", "user" },
            { "Smtp:Password", "pass" }
        };
        var config2 = new ConfigurationBuilder().AddInMemoryCollection(inMemoryConfig2).Build();
        var service2 = new SmtpEmailService(config2, NullLogger<SmtpEmailService>.Instance);
        var ex = await Record.ExceptionAsync(() => service2.SendEmailAsync("to@test.com", "Subj", "Body"));
        Assert.Null(ex);
    }

    [Fact]
    public void DTOs_And_Entities_FullPropertiesCoverage()
    {
        var now = DateTime.UtcNow;

        // DTOs
        var histDto = new TicketHistoryDto(1, 2, "Field", "Old", "New", "Action", now);
        Assert.Equal(1, histDto.Id);
        Assert.Equal(2, histDto.TicketId);
        Assert.Equal("Field", histDto.FieldName);
        Assert.Equal("Old", histDto.OldValue);
        Assert.Equal("New", histDto.NewValue);
        Assert.Equal("Action", histDto.Action);
        Assert.Equal(now, histDto.CreatedAt);

        var slaTargetDto = new SlaTargetItemDto(1, 2, 3, "P1", "#ff0000", 1, 4, "Type", 60, 120, true);
        Assert.Equal(1, slaTargetDto.Id);
        Assert.Equal(2, slaTargetDto.SlaPolicyId);
        Assert.Equal(3, slaTargetDto.PriorityId);
        Assert.Equal("P1", slaTargetDto.PriorityName);
        Assert.Equal("#ff0000", slaTargetDto.PriorityColor);
        Assert.Equal(1, slaTargetDto.PrioritySeverityLevel);
        Assert.Equal(4, slaTargetDto.TicketTypeId);
        Assert.Equal("Type", slaTargetDto.TicketTypeName);
        Assert.Equal(60, slaTargetDto.FirstResponseMinutes);
        Assert.Equal(120, slaTargetDto.ResolutionMinutes);
        Assert.True(slaTargetDto.IsActive);

        var auditDto = new AuditLogItemDto(1, 10, "Update", "Title", "Old", "New", "User", now, "Ticket", "Title", "10");
        Assert.Equal(1, auditDto.Id);
        Assert.Equal(10, auditDto.TicketId);
        Assert.Equal("Update", auditDto.Action);
        Assert.Equal("Title", auditDto.FieldName);
        Assert.Equal("Old", auditDto.OldValue);
        Assert.Equal("New", auditDto.NewValue);
        Assert.Equal("User", auditDto.CreatedBy);
        Assert.Equal(now, auditDto.CreatedAt);
        Assert.Equal("Ticket", auditDto.EntityType);
        Assert.Equal("Title", auditDto.EntityName);
        Assert.Equal("10", auditDto.EntityId);

        var paginatedAudit = new PaginatedAuditLogDto(new List<AuditLogItemDto> { auditDto }, 1, 1, 10);
        Assert.Single(paginatedAudit.Items);
        Assert.Equal(1, paginatedAudit.TotalCount);
        Assert.Equal(1, paginatedAudit.Page);
        Assert.Equal(10, paginatedAudit.PageSize);

        var slaDetail = new SlaPolicyDetailDto(1, "Name", "Desc", 2, "Proj", true, true, new List<SlaTargetItemDto> { slaTargetDto });
        Assert.Equal(1, slaDetail.Id);
        Assert.Equal("Name", slaDetail.Name);
        Assert.Equal("Desc", slaDetail.Description);
        Assert.Equal(2, slaDetail.ProjectId);
        Assert.Equal("Proj", slaDetail.ProjectName);
        Assert.True(slaDetail.EscalateOnBreach);
        Assert.True(slaDetail.IsActive);
        Assert.Single(slaDetail.Targets);

        var slaInfo = new TicketSlaInfoDto(now, true, true, false, now, now, now, true, now);
        Assert.Equal(now, slaInfo.ResolutionDueAt);
        Assert.True(slaInfo.ResolutionWarned);
        Assert.True(slaInfo.ResolutionBreached);
        Assert.False(slaInfo.FirstResponseBreached);
        Assert.Equal(now, slaInfo.FirstResponseDueAt);
        Assert.Equal(now, slaInfo.FirstResponseMetAt);
        Assert.Equal(now, slaInfo.ResolutionMetAt);
        Assert.True(slaInfo.FirstResponseWarned);
        Assert.Equal(now, slaInfo.PausedAt);

        var compliance = new SlaComplianceDto(95.5, 98.2, 45.0);
        Assert.Equal(95.5, compliance.FirstResponseComplianceRate);
        Assert.Equal(98.2, compliance.ResolutionComplianceRate);
        Assert.Equal(45.0, compliance.AverageResolutionTimeMinutes);

        var meDto = new MeResponseDto(1, "john", "j@test.com", new List<string> { "grp1" }, new List<string> { "admin" }, new List<string> { "perm1" }, new List<string> { "ovr1" }, 5, "photo.jpg", false);
        Assert.Equal(1, meDto.Id);
        Assert.Equal("john", meDto.Username);
        Assert.Equal("j@test.com", meDto.Email);
        Assert.Single(meDto.Groups);
        Assert.Single(meDto.Roles);
        Assert.Single(meDto.Permissions);
        Assert.Single(meDto.Overrides);
        Assert.Equal(5, meDto.KbArticleCount);
        Assert.Equal("photo.jpg", meDto.ProfilePhoto);
        Assert.False(meDto.MustChangePassword);

        var authDto = new AuthResponseDto("tok", now, "john", new List<string> { "admin" }, new List<string> { "perm1" }, false);
        Assert.Equal("tok", authDto.Token);
        Assert.Equal(now, authDto.ExpiresAt);
        Assert.Equal("john", authDto.Username);
        Assert.Single(authDto.Roles);
        Assert.Single(authDto.Permissions);
        Assert.False(authDto.MustChangePassword);

        var surveyDto = new TicketSurveyDto(1, 2, 5, "Good", now);
        Assert.Equal(1, surveyDto.Id);
        Assert.Equal(2, surveyDto.TicketId);
        Assert.Equal(5, surveyDto.Rating);
        Assert.Equal("Good", surveyDto.Comment);
        Assert.Equal(now, surveyDto.SubmittedAt);

        var paged = new PagedResult<string> { Items = new List<string> { "A" }, TotalCount = 1, Page = 1, PageSize = 10 };
        Assert.Single(paged.Items);
        Assert.Equal(1, paged.TotalCount);
        Assert.Equal(1, paged.Page);
        Assert.Equal(10, paged.PageSize);

        var errResp = new SystemController.SystemErrorResponse("Err", "Detail");
        Assert.Equal("Err", errResp.Message);
        Assert.Equal("Detail", errResp.Error);

        // Domain Entities
        var parentKc = new KnowledgeCategory { Id = 2, Name = "Parent" };
        var kc = new KnowledgeCategory { Id = 1, Name = "Cat", ParentId = 2, Parent = parentKc };
        Assert.Equal(1, kc.Id);
        Assert.Equal("Cat", kc.Name);
        Assert.Equal(2, kc.ParentId);
        Assert.NotNull(kc.Parent);

        var tw = new TicketWatcher { Id = 1, TicketId = 2, UserId = 3, Ticket = new Ticket(), User = new User() };
        Assert.Equal(1, tw.Id);
        Assert.Equal(2, tw.TicketId);
        Assert.Equal(3, tw.UserId);
        Assert.NotNull(tw.Ticket);
        Assert.NotNull(tw.User);

        var np = new NotificationPreference { Id = 1, UserId = 2, Category = "SLA", EmailEnabled = true };
        Assert.Equal(1, np.Id);
        Assert.Equal(2, np.UserId);
        Assert.Equal("SLA", np.Category);
        Assert.True(np.EmailEnabled);

        var sf = new SavedFilter { Id = 1, Name = "Filter", QueryJson = "{}", UserId = 2 };
        Assert.Equal(1, sf.Id);
        Assert.Equal("Filter", sf.Name);
        Assert.Equal("{}", sf.QueryJson);
        Assert.Equal(2, sf.UserId);

        var tc = new TicketComment { Id = 1, TicketId = 2, AuthorUserId = 3, Content = "C", IsInternal = false, ParentCommentId = 4 };
        Assert.Equal(1, tc.Id);
        Assert.Equal(2, tc.TicketId);
        Assert.Equal(3, tc.AuthorUserId);
        Assert.Equal("C", tc.Content);
        Assert.False(tc.IsInternal);
        Assert.Equal(4, tc.ParentCommentId);

        var ta = new TicketAssignment { Id = 1, TicketId = 2, AssignedUserId = 3, AssignedGroupId = 4, ParentAssignmentId = 5, AssignedByUserId = 6, IsActive = true };
        Assert.Equal(1, ta.Id);
        Assert.Equal(2, ta.TicketId);
        Assert.Equal(3, ta.AssignedUserId);
        Assert.Equal(4, ta.AssignedGroupId);
        Assert.Equal(5, ta.ParentAssignmentId);
        Assert.Equal(6, ta.AssignedByUserId);
        Assert.True(ta.IsActive);

        var pm = new ProjectMember { Id = 1, ProjectId = 2, UserId = 3, SpecificRoleId = 4 };
        Assert.Equal(1, pm.Id);
        Assert.Equal(2, pm.ProjectId);
        Assert.Equal(3, pm.UserId);
        Assert.Equal(4, pm.SpecificRoleId);

        var tfv = new TicketFieldValue { Id = 1, TicketId = 2, FieldDefinitionId = 3, ValueString = "Val" };
        Assert.Equal(1, tfv.Id);
        Assert.Equal(2, tfv.TicketId);
        Assert.Equal(3, tfv.FieldDefinitionId);
        Assert.Equal("Val", tfv.ValueString);

        var ar = new AssignmentRule { Id = 1, Name = "Rule", ProjectId = 2, CategoryId = 3, PriorityId = 4, TicketTypeId = 5, TargetUserId = 6, TargetGroupId = 7, SortOrder = 8, IsActive = true };
        Assert.Equal(1, ar.Id);
        Assert.Equal("Rule", ar.Name);
        Assert.Equal(2, ar.ProjectId);
        Assert.Equal(3, ar.CategoryId);
        Assert.Equal(4, ar.PriorityId);
        Assert.Equal(5, ar.TicketTypeId);
        Assert.Equal(6, ar.TargetUserId);
        Assert.Equal(7, ar.TargetGroupId);
        Assert.Equal(8, ar.SortOrder);
        Assert.True(ar.IsActive);

        var dept = new Department { Id = 1, Name = "Dept", Description = "Desc", ManagerUserId = 2, IsActive = true };
        Assert.Equal(1, dept.Id);
        Assert.Equal("Dept", dept.Name);
        Assert.Equal("Desc", dept.Description);
        Assert.Equal(2, dept.ManagerUserId);
        Assert.True(dept.IsActive);

        var tat = new TicketAttachment { Id = 1, TicketId = 2, FileName = "f.txt", FilePath = "/p/f.txt", FileSize = 100, ContentType = "text/plain", UploadedByUserId = 3 };
        Assert.Equal(1, tat.Id);
        Assert.Equal(2, tat.TicketId);
        Assert.Equal("f.txt", tat.FileName);
        Assert.Equal("/p/f.txt", tat.FilePath);
        Assert.Equal(100, tat.FileSize);
        Assert.Equal("text/plain", tat.ContentType);
        Assert.Equal(3, tat.UploadedByUserId);
    }

    [Fact]
    public async Task SlaService_CreatePolicyAsync_ShouldSeedDefaultTargets_WhenTargetsNull()
    {
        var service = new SlaService(_context);
        var p1 = new Priority { Name = "Critical", SeverityLevel = 1 };
        var p2 = new Priority { Name = "High", SeverityLevel = 2 };
        var p3 = new Priority { Name = "Medium", SeverityLevel = 3 };
        var p4 = new Priority { Name = "Low", SeverityLevel = 4 };
        _context.Priorities.AddRange(p1, p2, p3, p4);
        await _context.SaveChangesAsync();

        var dto = new CreateSlaPolicyDto("Default Seed SLA", "Desc", null, false, null);
        var res = await service.CreatePolicyAsync(dto);
        Assert.NotNull(res);

        var targets = await _context.SlaTargets.Where(t => t.SlaPolicyId == res.Id).ToListAsync();
        Assert.True(targets.Count >= 4);
    }

    [Fact]
    public async Task KnowledgeBaseService_ShouldCoverStatusTransitionsAndManagerNotifications()
    {
        var kbService = new KnowledgeBaseService(_context, _permissionCalculatorMock.Object, _signalRPusherMock.Object);

        var author = new User { Username = "author", Email = "author@test.com", IsActive = true };
        var manager = new User { Username = "manager", Email = "manager@test.com", IsActive = true };
        _context.Users.AddRange(author, manager);

        var kbManagePerm = new Permission { Key = "kb.manage", Name = "Manage KB" };
        _context.Permissions.Add(kbManagePerm);
        var role = new Role { Name = "KB Manager" };
        _context.Roles.Add(role);
        await _context.SaveChangesAsync();

        _context.RolePermissions.Add(new RolePermission { RoleId = role.Id, PermissionId = kbManagePerm.Id });
        _context.UserRoles.Add(new UserRole { RoleId = role.Id, UserId = manager.Id });

        var cat = new KnowledgeCategory { Name = "General KB" };
        _context.KnowledgeCategories.Add(cat);
        await _context.SaveChangesAsync();

        // 1. Create draft article
        var article = new KnowledgeArticle
        {
            Title = "Draft Guide",
            Content = "Draft content",
            CategoryId = cat.Id,
            AuthorUserId = author.Id,
            Status = ArticleStatus.Draft,
            Visibility = ArticleVisibility.Public
        };
        _context.KnowledgeArticles.Add(article);
        await _context.SaveChangesAsync();

        // 2. Author transitions to PendingReview -> triggers NotifyManagersOfSuggestionAsync
        _permissionCalculatorMock.Setup(p => p.CalculateEffectivePermissionsAsync(author.Id))
            .ReturnsAsync(new HashSet<string>());

        var updateDto = new UpdateKbArticleDto(cat.Id, "Draft Guide Updated", "Draft content updated", ArticleStatus.PendingReview, ArticleVisibility.Public);
        await kbService.UpdateArticleAsync(article.Id, updateDto, author.Id);

        var updated = await _context.KnowledgeArticles.FindAsync(article.Id);
        Assert.Equal(ArticleStatus.PendingReview, updated!.Status);

        // 3. Manager publishes article
        _permissionCalculatorMock.Setup(p => p.CalculateEffectivePermissionsAsync(manager.Id))
            .ReturnsAsync(new HashSet<string> { "kb.manage" });

        var publishDto = new UpdateKbArticleDto(cat.Id, "Published Guide", "Final content", ArticleStatus.Published, ArticleVisibility.Public);
        await kbService.UpdateArticleAsync(article.Id, publishDto, manager.Id);

        var published = await _context.KnowledgeArticles.FindAsync(article.Id);
        Assert.Equal(ArticleStatus.Published, published!.Status);
    }

    [Fact]
    public async Task TicketService_ShouldCoverHierarchyPass_And_TransferTicket()
    {
        var ticketService = new TicketService(
            _context,
            Mock.Of<IFileStorageService>(),
            _permissionCalculatorMock.Object,
            _slaEngineMock.Object,
            _assignmentEngineMock.Object,
            _notificationDispatcherMock.Object
        );

        var dept = new Department { Name = "SharedDept" };
        _context.Departments.Add(dept);
        var assigner = new User { Username = "assigner", DepartmentId = dept.Id, IsActive = true };
        var delegateUser = new User { Username = "delegatee", DepartmentId = dept.Id, IsActive = true };
        var group = new Group { Name = "SharedGroup", DepartmentId = dept.Id };
        _context.Users.AddRange(assigner, delegateUser);
        _context.Groups.Add(group);

        var p = new Project { Name = "P1", ProjectKey = "P1" };
        var cat = new Category { Name = "C1" };
        var type = new TicketType { Name = "T1" };
        var status = new Status { Name = "S1", IsSystemDefault = true };
        var prio = new Priority { Name = "Pr1", SeverityLevel = 1 };
        _context.Projects.Add(p);
        _context.Categories.Add(cat);
        _context.TicketTypes.Add(type);
        _context.Statuses.Add(status);
        _context.Priorities.Add(prio);
        await _context.SaveChangesAsync();

        var ticket = new Ticket { TicketNumber = "T-HIER-1", Title = "Test", ProjectId = p.Id, CategoryId = cat.Id, TypeId = type.Id, StatusId = status.Id, PriorityId = prio.Id, RequesterUserId = assigner.Id };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        var parentAssign = new TicketAssignment { TicketId = ticket.Id, AssignedGroupId = group.Id, IsActive = true };
        ticket.Assignments.Add(parentAssign);
        await _context.SaveChangesAsync();

        // Assign with valid hierarchy delegation (group member with same department)
        _permissionCalculatorMock.Setup(pc => pc.CalculateEffectivePermissionsAsync(assigner.Id))
            .ReturnsAsync(new HashSet<string> { "ticket.assign", "ticket.transfer" });

        var assignDto = new AssignTicketDto(new List<int> { delegateUser.Id }, new List<int>(), assigner.Id, parentAssign.Id);
        await ticketService.AssignTicketAsync(ticket.Id, assignDto);

        // Transfer ticket
        var transferDto = new TransferTicketDto(p.Id, group.Id, assigner.Id);
        await ticketService.TransferTicketAsync(ticket.Id, transferDto);

        var reloaded = await ticketService.GetTicketByIdAsync(ticket.Id);
        Assert.NotNull(reloaded);
    }

    [Fact]
    public async Task SlaController_And_TicketController_Coverage()
    {
        var slaServiceMock = new Mock<ISlaService>();
        var slaController = new SlaController(slaServiceMock.Object);

        // RestorePolicy: success & 404
        slaServiceMock.Setup(s => s.RestorePolicyAsync(1)).Returns(Task.CompletedTask);
        slaServiceMock.Setup(s => s.RestorePolicyAsync(99)).ThrowsAsync(new KeyNotFoundException());

        var resSuccess = await slaController.RestorePolicy(1);
        Assert.IsType<NoContentResult>(resSuccess);

        var resNotFound = await slaController.RestorePolicy(99);
        Assert.IsType<NotFoundResult>(resNotFound);

        var ticketServiceMock = new Mock<ITicketService>();
        var ticketController = new TicketController(ticketServiceMock.Object);
        var mockUser = new ClaimsPrincipal(new ClaimsIdentity(new[]
        {
            new Claim(ClaimTypes.NameIdentifier, "1"),
            new Claim(ClaimTypes.Role, "SuperAdmin"),
            new Claim("permissions", "ticket.manage")
        }, "mock"));
        ticketController.ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext { User = mockUser } };

        ticketServiceMock.Setup(s => s.AddAttachmentAsync(It.IsAny<int>(), It.IsAny<IFormFile>(), It.IsAny<int>()))
            .ThrowsAsync(new InvalidOperationException("File too large"));

        var addRes = await ticketController.AddAttachment(1, Mock.Of<IFormFile>());
        Assert.IsType<BadRequestObjectResult>(addRes);

        ticketServiceMock.Setup(s => s.DeleteAttachmentAsync(1, 10, It.IsAny<int>(), It.IsAny<bool>()))
            .ThrowsAsync(new UnauthorizedAccessException("Forbidden"));
        var delRes1 = await ticketController.DeleteAttachment(1, 10);
        Assert.Equal(403, (delRes1 as ObjectResult)?.StatusCode);

        ticketServiceMock.Setup(s => s.DeleteAttachmentAsync(1, 20, It.IsAny<int>(), It.IsAny<bool>()))
            .ThrowsAsync(new KeyNotFoundException("Missing"));
        var delRes2 = await ticketController.DeleteAttachment(1, 20);
        Assert.Equal(404, (delRes2 as ObjectResult)?.StatusCode);
    }

    [Fact]
    public async Task DynamicFormService_And_RoleService_Coverage()
    {
        var defRepo = new Repository<FieldDefinition>(_context);
        var optRepo = new Repository<FieldOption>(_context);
        var placeRepo = new Repository<FormFieldPlacement>(_context);
        var dynamicService = new DynamicFormService(defRepo, optRepo, placeRepo, _context);

        var def = new FieldDefinition { Key = "test_field", Label = "Test" };
        _context.FieldDefinitions.Add(def);
        await _context.SaveChangesAsync();

        var opt = new FieldOption { FieldDefinitionId = def.Id, Value = "Opt1" };
        _context.FieldOptions.Add(opt);
        var plc = new FormFieldPlacement { FieldDefinitionId = def.Id, ProjectId = 1, CategoryId = 1, TicketTypeId = 1 };
        _context.FormFieldPlacements.Add(plc);
        await _context.SaveChangesAsync();

        var getOpt = await dynamicService.GetFieldOptionByIdAsync(opt.Id);
        Assert.NotNull(getOpt);
        var getPlc = await dynamicService.GetPlacementByIdAsync(plc.Id);
        Assert.NotNull(getPlc);

        // RoleService Update with additions and removals
        var roleRepoMock = new Mock<IRepository<Role>>();
        var roleService = new RoleService(roleRepoMock.Object, _context);

        var r = new Role { Name = "RoleToUpdate", Description = "Desc", IsActive = true };
        _context.Roles.Add(r);
        var p1 = new Permission { Key = "p1", Name = "P1" };
        var p2 = new Permission { Key = "p2", Name = "P2" };
        _context.Permissions.AddRange(p1, p2);
        await _context.SaveChangesAsync();

        _context.RolePermissions.Add(new RolePermission { RoleId = r.Id, PermissionId = p1.Id, Permission = p1 });
        await _context.SaveChangesAsync();

        var updateDto = new UpdateRoleDto("UpdatedRole", "New Desc", true, new[] { "p2" });
        await roleService.UpdateAsync(r.Id, updateDto);

        var hasP2 = await _context.RolePermissions.AnyAsync(rp => rp.RoleId == r.Id && rp.PermissionId == p2.Id);
        Assert.True(hasP2);
    }
}
