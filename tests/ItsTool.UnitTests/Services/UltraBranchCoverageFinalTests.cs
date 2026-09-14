using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
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
using Microsoft.Extensions.Logging.Abstractions;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class UltraBranchCoverageFinalTests : TestBase
{
    private readonly Mock<IHttpContextAccessor> _httpMock;
    private readonly Mock<ILlmService> _llmMock;
    private readonly Mock<IPermissionCalculator> _permMock;
    private readonly Mock<ISignalRPusher> _signalRMock;
    private readonly Mock<INotificationDispatcher> _notifMock;
    private readonly Mock<IFileStorageService> _fileStorageMock;
    private readonly Mock<ISlaEngine> _slaEngineMock;
    private readonly Mock<IAssignmentEngine> _assignmentEngineMock;

    public UltraBranchCoverageFinalTests()
    {
        _httpMock = new Mock<IHttpContextAccessor>();
        _llmMock = new Mock<ILlmService>();
        _permMock = new Mock<IPermissionCalculator>();
        _signalRMock = new Mock<ISignalRPusher>();
        _notifMock = new Mock<INotificationDispatcher>();
        _fileStorageMock = new Mock<IFileStorageService>();
        _slaEngineMock = new Mock<ISlaEngine>();
        _assignmentEngineMock = new Mock<IAssignmentEngine>();

        var user = new ClaimsPrincipal(new ClaimsIdentity(new[]
        {
            new Claim(ClaimTypes.NameIdentifier, "1"),
            new Claim(ClaimTypes.Name, "admin"),
            new Claim(ClaimTypes.Role, "SuperAdmin")
        }, "TestAuth"));

        var httpContext = new DefaultHttpContext { User = user };
        _httpMock.Setup(h => h.HttpContext).Returns(httpContext);
    }

    [Fact]
    public async Task TicketService_Exceptions_And_Validation_Branches()
    {
        var ticketService = new TicketService(_context, _fileStorageMock.Object, _permMock.Object, _slaEngineMock.Object, _assignmentEngineMock.Object, _notifMock.Object);

        // 1. CreateTicketAsync invalid ProjectId throws KeyNotFoundException
        var invalidProjDto = new CreateTicketDto("Title", "Desc", 99999, 1, 1, 1, 1, new Dictionary<string, string>());
        await Assert.ThrowsAsync<KeyNotFoundException>(() => ticketService.CreateTicketAsync(invalidProjDto));

        // 2. CreateTicketAsync missing required dynamic form placement throws InvalidOperationException
        var proj = new Project { Name = "DynProj", ProjectKey = "DP" };
        var cat = new Category { Name = "Hardware" };
        var type = new TicketType { Name = "Request" };
        var stat = new Status { Name = "New", IsSystemDefault = true };
        var prio = new Priority { Name = "P2" };
        var reqUser = new User { Username = "u1", FirstName = "F", LastName = "L" };
        _context.Projects.Add(proj);
        _context.Categories.Add(cat);
        _context.TicketTypes.Add(type);
        _context.Statuses.Add(stat);
        _context.Priorities.Add(prio);
        _context.Users.Add(reqUser);
        await _context.SaveChangesAsync();

        var def = new FieldDefinition { Key = "req_field", Label = "Required Field", FieldType = FieldType.Text };
        _context.FieldDefinitions.Add(def);
        await _context.SaveChangesAsync();

        var placement = new FormFieldPlacement { FieldDefinitionId = def.Id, ProjectId = proj.Id, CategoryId = cat.Id, TicketTypeId = type.Id, IsRequired = true };
        _context.FormFieldPlacements.Add(placement);
        await _context.SaveChangesAsync();

        var missingReqDto = new CreateTicketDto("Title", "Desc", proj.Id, cat.Id, type.Id, prio.Id, reqUser.Id, CustomFields: new Dictionary<string, string>());
        await Assert.ThrowsAsync<InvalidOperationException>(() => ticketService.CreateTicketAsync(missingReqDto));

        // 3. GetTicketByIdAsync non-existent returns null, UpdateTicketAsync non-existent throws
        Assert.Null(await ticketService.GetTicketByIdAsync(99999));
        await Assert.ThrowsAsync<KeyNotFoundException>(() => ticketService.UpdateTicketAsync(99999, new UpdateTicketDto("T", "D", cat.Id, prio.Id, new Dictionary<string, string>()), reqUser.Id));

        // 4. UpdateTicketAsync updating Estimated dates
        var validDto = new CreateTicketDto("Title", "Desc", proj.Id, cat.Id, type.Id, prio.Id, reqUser.Id, CustomFields: new Dictionary<string, string> { { "req_field", "value" } });
        var created = await ticketService.CreateTicketAsync(validDto);

        var updateDto = new UpdateTicketDto("New Title", "New Desc", cat.Id, prio.Id, new Dictionary<string, string> { { "req_field", "value" } }, EstimatedStartDate: DateTime.UtcNow.AddDays(1), EstimatedEndDate: DateTime.UtcNow.AddDays(3));
        await ticketService.UpdateTicketAsync(created.Id, updateDto, reqUser.Id);
        var updated = await ticketService.GetTicketByIdAsync(created.Id);
        Assert.NotNull(updated!.EstimatedStartDate);
        Assert.NotNull(updated.EstimatedEndDate);
    }

    [Fact]
    public async Task TicketService_Workflow_Status_And_Assignment_Branches()
    {
        _permMock.Setup(p => p.CalculateEffectivePermissionsAsync(It.IsAny<int>())).ReturnsAsync(new HashSet<string>());
        var ticketService = new TicketService(_context, _fileStorageMock.Object, _permMock.Object, _slaEngineMock.Object, _assignmentEngineMock.Object, _notifMock.Object);

        var proj = new Project { Name = "WF Project", ProjectKey = "WP" };
        var sOpen = new Status { Name = "Open", IsSystemDefault = true };
        var sInProg = new Status { Name = "In Progress" };
        var sResolved = new Status { Name = "Resolved" };
        var user = new User { Username = "agent1", FirstName = "A", LastName = "G", DepartmentId = 1 };
        var userOtherDept = new User { Username = "agent2", FirstName = "B", LastName = "H", DepartmentId = 2 };
        _context.Projects.Add(proj);
        _context.Statuses.AddRange(sOpen, sInProg, sResolved);
        _context.Users.AddRange(user, userOtherDept);
        await _context.SaveChangesAsync();

        var ticket = new Ticket { TicketNumber = "WP-1", Title = "Wf Ticket", Description = "Desc", ProjectId = proj.Id, StatusId = sOpen.Id, RequesterUserId = user.Id };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        // 1. GetAllowedTransitionsAsync non-existent ticket throws
        await Assert.ThrowsAsync<KeyNotFoundException>(() => ticketService.GetAllowedTransitionsAsync(99999, user.Id));

        // 2. GetAllowedTransitionsAsync with no workflow returns empty
        var emptyNext = await ticketService.GetAllowedTransitionsAsync(ticket.Id, user.Id);
        Assert.Empty(emptyNext);

        // Add workflow with transition requiring permission
        var wf = new Workflow { Name = "Proj WF", ProjectId = proj.Id, IsActive = true };
        _context.Workflows.Add(wf);
        await _context.SaveChangesAsync();

        var trans1 = new WorkflowTransition { WorkflowId = wf.Id, FromStatusId = sOpen.Id, ToStatusId = sInProg.Id, RequiredPermissionKey = "ticket.progress" };
        var trans2 = new WorkflowTransition { WorkflowId = wf.Id, FromStatusId = sOpen.Id, ToStatusId = sResolved.Id }; // no permission required
        _context.WorkflowTransitions.AddRange(trans1, trans2);
        await _context.SaveChangesAsync();

        // User lacks "ticket.progress"
        _permMock.Setup(p => p.CalculateEffectivePermissionsAsync(user.Id)).ReturnsAsync(new HashSet<string>());
        var allowedNoPerm = await ticketService.GetAllowedTransitionsAsync(ticket.Id, user.Id);
        Assert.Contains(allowedNoPerm, s => s.Id == sResolved.Id);
        Assert.DoesNotContain(allowedNoPerm, s => s.Id == sInProg.Id);

        // User has "ticket.progress"
        _permMock.Setup(p => p.CalculateEffectivePermissionsAsync(user.Id)).ReturnsAsync(new HashSet<string> { "ticket.progress" });
        var allowedWithPerm = await ticketService.GetAllowedTransitionsAsync(ticket.Id, user.Id);
        Assert.Contains(allowedWithPerm, s => s.Id == sInProg.Id);

        // 3. ChangeStatusAsync same status is early return
        await ticketService.ChangeStatusAsync(ticket.Id, new ChangeStatusDto(sOpen.Id, user.Id));

        // 4. AssignTicketAsync non-existent throws
        await Assert.ThrowsAsync<KeyNotFoundException>(() => ticketService.AssignTicketAsync(99999, new AssignTicketDto(new List<int> { user.Id }, new List<int>(), user.Id)));

        // Missing ticket.assign permission throws
        _permMock.Setup(p => p.CalculateEffectivePermissionsAsync(user.Id)).ReturnsAsync(new HashSet<string>());
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => ticketService.AssignTicketAsync(ticket.Id, new AssignTicketDto(new List<int> { user.Id }, new List<int>(), user.Id)));

        // AssignTicketAsync valid assignment
        _permMock.Setup(p => p.CalculateEffectivePermissionsAsync(user.Id)).ReturnsAsync(new HashSet<string> { "ticket.assign" });
        await ticketService.AssignTicketAsync(ticket.Id, new AssignTicketDto(new List<int> { user.Id }, new List<int>(), user.Id));
        Assert.True(await _context.TicketAssignments.AnyAsync(a => a.TicketId == ticket.Id));

        // Sub-assignment from different department or unauthorized assigner
        var parentAssign = await _context.TicketAssignments.FirstAsync(a => a.TicketId == ticket.Id);
        var subAssignDto = new AssignTicketDto(new List<int> { userOtherDept.Id }, new List<int>(), userOtherDept.Id, ParentAssignmentId: parentAssign.Id);
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => ticketService.AssignTicketAsync(ticket.Id, subAssignDto));
    }

    [Fact]
    public async Task TicketService_Transfer_Attachments_And_Survey_Branches()
    {
        var ticketService = new TicketService(_context, _fileStorageMock.Object, _permMock.Object, _slaEngineMock.Object, _assignmentEngineMock.Object, _notifMock.Object);

        var proj1 = new Project { Name = "P1", ProjectKey = "P1" };
        var proj2 = new Project { Name = "P2", ProjectKey = "P2" };
        var user = new User { Username = "transUser", FirstName = "T", LastName = "U" };
        var otherUser = new User { Username = "otherUser", FirstName = "O", LastName = "U" };
        var grp = new Group { Name = "Support Group" };
        _context.Projects.AddRange(proj1, proj2);
        _context.Users.AddRange(user, otherUser);
        _context.Groups.Add(grp);
        await _context.SaveChangesAsync();

        var t = new Ticket { TicketNumber = "P1-1", Title = "Transfer Ticket", Description = "Desc", ProjectId = proj1.Id, RequesterUserId = user.Id };
        _context.Tickets.Add(t);
        await _context.SaveChangesAsync();

        // 1. TransferTicketAsync non-existent throws
        await Assert.ThrowsAsync<KeyNotFoundException>(() => ticketService.TransferTicketAsync(99999, new TransferTicketDto(proj2.Id, null, user.Id)));

        // Missing ticket.transfer permission throws
        _permMock.Setup(p => p.CalculateEffectivePermissionsAsync(user.Id)).ReturnsAsync(new HashSet<string>());
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => ticketService.TransferTicketAsync(t.Id, new TransferTicketDto(proj2.Id, null, user.Id)));

        // Non-superadmin changing project throws
        _permMock.Setup(p => p.CalculateEffectivePermissionsAsync(user.Id)).ReturnsAsync(new HashSet<string> { "ticket.transfer" });
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => ticketService.TransferTicketAsync(t.Id, new TransferTicketDto(proj2.Id, null, user.Id)));

        // Superadmin changing project, unsetting project (-1), and setting group
        _permMock.Setup(p => p.CalculateEffectivePermissionsAsync(user.Id)).ReturnsAsync(new HashSet<string> { "ticket.transfer", "admin.manage" });
        await ticketService.TransferTicketAsync(t.Id, new TransferTicketDto(proj2.Id, grp.Id, user.Id));
        Assert.Equal(proj2.Id, t.ProjectId);

        await ticketService.TransferTicketAsync(t.Id, new TransferTicketDto(-1, -1, user.Id));
        Assert.Null(t.ProjectId);

        // 2. DeleteAttachmentAsync non-existent throws
        await Assert.ThrowsAsync<KeyNotFoundException>(() => ticketService.DeleteAttachmentAsync(t.Id, 99999, user.Id, false));

        // DeleteAttachmentAsync uploaded by other user without manage perm throws
        var att = new TicketAttachment { TicketId = t.Id, FileName = "test.txt", FilePath = "/files/test.txt", UploadedByUserId = otherUser.Id };
        _context.TicketAttachments.Add(att);
        await _context.SaveChangesAsync();

        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => ticketService.DeleteAttachmentAsync(t.Id, att.Id, user.Id, false));

        // Authorized deletion
        _fileStorageMock.Setup(f => f.DeleteFileAsync(It.IsAny<string>())).Returns(Task.CompletedTask);
        await ticketService.DeleteAttachmentAsync(t.Id, att.Id, otherUser.Id, false);
        Assert.True(att.IsDeleted);

        // 3. SearchTicketsAsync sort ascending
        var searchRes = await ticketService.SearchTicketsAsync(new TicketSearchFilterDto { SortDescending = false }, user.Id);
        Assert.NotNull(searchRes);

        // 4. SubmitSurveyAsync non-existent throws
        await Assert.ThrowsAsync<KeyNotFoundException>(() => ticketService.SubmitSurveyAsync(99999, new SubmitTicketSurveyDto(5, "Good"), user.Id));

        t.StatusId = 5;
        await _context.SaveChangesAsync();

        // Invalid ratings (< 1 or > 5) throw InvalidOperationException
        await Assert.ThrowsAsync<InvalidOperationException>(() => ticketService.SubmitSurveyAsync(t.Id, new SubmitTicketSurveyDto(0, "Bad"), user.Id));
        await Assert.ThrowsAsync<InvalidOperationException>(() => ticketService.SubmitSurveyAsync(t.Id, new SubmitTicketSurveyDto(6, "Super"), user.Id));

        // Valid survey submit
        var surveyRes = await ticketService.SubmitSurveyAsync(t.Id, new SubmitTicketSurveyDto(5, "Great service"), user.Id);
        Assert.Equal(5, surveyRes.Rating);

        // Resubmitting survey throws InvalidOperationException
        await Assert.ThrowsAsync<InvalidOperationException>(() => ticketService.SubmitSurveyAsync(t.Id, new SubmitTicketSurveyDto(4, "Duplicate"), user.Id));
    }

    [Fact]
    public async Task SlaEngine_All_Branch_Scenarios()
    {
        for (int i = 0; i < 7; i++)
        {
            _context.BusinessHours.Add(new BusinessHour { DayOfWeek = (DayOfWeek)i, StartTime = new TimeSpan(9, 0, 0), EndTime = new TimeSpan(18, 0, 0), IsWorkingDay = true });
        }
        await _context.SaveChangesAsync();

        var emailServiceMock = new Mock<IEmailService>();
        var slaEngine = new SlaEngine(_context, emailServiceMock.Object, _notifMock.Object);

        // 1. AttachSlaToTicketAsync non-existent ticket is safe
        await slaEngine.AttachSlaToTicketAsync(99999);

        // Ticket with no matching policy
        var tNoPolicy = new Ticket { TicketNumber = "T-NOPOL", Title = "No Policy", Description = "Desc", ProjectId = 99999, PriorityId = 99999 };
        _context.Tickets.Add(tNoPolicy);
        await _context.SaveChangesAsync();
        await slaEngine.AttachSlaToTicketAsync(tNoPolicy.Id);

        // Ticket with policy but no matching target priority
        var proj = new Project { Name = "SLA Proj", ProjectKey = "SP" };
        _context.Projects.Add(proj);
        var prio = new Priority { Name = "High", SeverityLevel = 2 };
        var sOpen = new Status { Name = "SOpen" };
        var sHold = new Status { Name = "SHold", PausesSla = true };
        var sClosed = new Status { Name = "SClosed", IsClosedStatus = true };
        _context.Statuses.AddRange(sOpen, sHold, sClosed);
        _context.Priorities.Add(prio);
        await _context.SaveChangesAsync();

        var policy = new SlaPolicy { Name = "Proj Policy", ProjectId = proj.Id, IsActive = true };
        _context.SlaPolicies.Add(policy);
        await _context.SaveChangesAsync();

        var tNoTarget = new Ticket { TicketNumber = "T-NOTGT", Title = "No Target", Description = "Desc", ProjectId = proj.Id, PriorityId = 99999 };
        _context.Tickets.Add(tNoTarget);
        await _context.SaveChangesAsync();
        await slaEngine.AttachSlaToTicketAsync(tNoTarget.Id);

        // 2. ProcessTicketStatusChangeAsync with null/valid statuses
        await slaEngine.ProcessTicketStatusChangeAsync(tNoPolicy.Id, 99999, 99998); // status not found safe

        var tSlaTicket = new Ticket { TicketNumber = "T-SLA", Title = "SLA Ticket", Description = "Desc", ProjectId = proj.Id, PriorityId = prio.Id, StatusId = sOpen.Id };
        _context.Tickets.Add(tSlaTicket);
        var target = new SlaTarget { SlaPolicyId = policy.Id, PriorityId = prio.Id, FirstResponseMinutes = 60, ResolutionMinutes = 120, IsActive = true };
        _context.SlaTargets.Add(target);
        await _context.SaveChangesAsync();

        await slaEngine.AttachSlaToTicketAsync(tSlaTicket.Id);
        // Status changes: Open -> Hold (pauses SLA), Hold -> Open (resumes SLA), Open -> Closed (resolves SLA)
        await slaEngine.ProcessTicketStatusChangeAsync(tSlaTicket.Id, sOpen.Id, sHold.Id);
        await slaEngine.ProcessTicketStatusChangeAsync(tSlaTicket.Id, sHold.Id, sOpen.Id);
        await slaEngine.ProcessTicketStatusChangeAsync(tSlaTicket.Id, sOpen.Id, sClosed.Id);

        // 3. ProcessTicketCommentAsync
        await slaEngine.ProcessTicketCommentAsync(tSlaTicket.Id, isInternal: true); // internal ignored
        await slaEngine.ProcessTicketCommentAsync(tSlaTicket.Id, isInternal: false); // public recorded

        // 4. CheckBreachesAsync with Warning & Breach
        var now = DateTime.UtcNow;
        var warnSla = new TicketSla
        {
            TicketId = tSlaTicket.Id,
            CreatedAt = now.AddMinutes(-100),
            FirstResponseDueAt = now.AddMinutes(-10), // breached
            ResolutionDueAt = now.AddMinutes(20), // warned
            FirstResponseWarned = false,
            FirstResponseBreached = false,
            ResolutionWarned = false,
            ResolutionBreached = false
        };
        _context.TicketSlas.Add(warnSla);
        await _context.SaveChangesAsync();

        await slaEngine.CheckBreachesAsync(now);
    }

    [Fact]
    public async Task KnowledgeBaseService_Edge_Branches()
    {
        _permMock.Setup(p => p.CalculateEffectivePermissionsAsync(It.IsAny<int>())).ReturnsAsync(new HashSet<string>());
        var kbService = new KnowledgeBaseService(_context, _permMock.Object, _signalRMock.Object);

        // 1. UpdateCategoryAsync invalid category throws
        await Assert.ThrowsAsync<KeyNotFoundException>(() => kbService.UpdateCategoryAsync(99999, new CreateKbCategoryDto("NonExistent", null)));

        // 2. Non-manager creating Published article gets redirected or throws
        var cat = new KnowledgeCategory { Name = "General Knowledge" };
        _context.KnowledgeCategories.Add(cat);
        var author = new User { Username = "authorUser" };
        var manager = new User { Username = "kbManager" };
        _context.Users.AddRange(author, manager);
        await _context.SaveChangesAsync();

        _permMock.Setup(p => p.CalculateEffectivePermissionsAsync(author.Id)).ReturnsAsync(new HashSet<string>());
        _permMock.Setup(p => p.CalculateEffectivePermissionsAsync(manager.Id)).ReturnsAsync(new HashSet<string> { "kb.manage" });

        // Non-manager can only create Draft
        var artDraft = await kbService.CreateArticleAsync(new CreateKbArticleDto(cat.Id, "Draft Title", "Body", ArticleStatus.Draft, ArticleVisibility.Public), author.Id);
        Assert.Equal(ArticleStatus.Draft, artDraft.Status);

        // 3. UpdateArticleAsync non-existent throws
        await Assert.ThrowsAsync<KeyNotFoundException>(() => kbService.UpdateArticleAsync(99999, new UpdateKbArticleDto(cat.Id, "T", "C", ArticleStatus.Draft, ArticleVisibility.Public), author.Id));

        // UpdateArticleAsync unauthorized user throws
        var otherUser = new User { Username = "stranger" };
        _context.Users.Add(otherUser);
        await _context.SaveChangesAsync();
        _permMock.Setup(p => p.CalculateEffectivePermissionsAsync(otherUser.Id)).ReturnsAsync(new HashSet<string>());

        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => kbService.UpdateArticleAsync(artDraft.Id, new UpdateKbArticleDto(cat.Id, "Hacked", "Body", ArticleStatus.Draft, ArticleVisibility.Public), otherUser.Id));

        // 4. ReviewArticleAsync unauthorized throws
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => kbService.ReviewArticleAsync(artDraft.Id, new ReviewKbArticleDto(ArticleStatus.Published, "Approved"), author.Id));

        // ReviewArticleAsync non-existent throws
        await Assert.ThrowsAsync<KeyNotFoundException>(() => kbService.ReviewArticleAsync(99999, new ReviewKbArticleDto(ArticleStatus.Published, "Approved"), manager.Id));

        // ReviewArticleAsync with feedback
        await kbService.ReviewArticleAsync(artDraft.Id, new ReviewKbArticleDto(ArticleStatus.Published, "Well written!"), manager.Id);
        var reviewed = await kbService.GetArticleAsync(artDraft.Id, manager.Id);
        Assert.Equal(ArticleStatus.Published, reviewed!.Status);
        Assert.Contains("Well written!", reviewed.ManagerFeedback);
    }

    [Fact]
    public async Task DynamicFormService_All_Branch_Scenarios()
    {
        var defRepo = new Repository<FieldDefinition>(_context);
        var optRepo = new Repository<FieldOption>(_context);
        var placementRepo = new Repository<FormFieldPlacement>(_context);
        var service = new DynamicFormService(defRepo, optRepo, placementRepo, _context);

        // 1. GetFieldDefinitionByIdAsync non-existent returns null
        Assert.Null(await service.GetFieldDefinitionByIdAsync(99999));

        // 2. CreateFieldDefinitionAsync duplicate key throws
        var f1 = await service.CreateFieldDefinitionAsync(new CreateFieldDefinitionDto("key1", "Label 1", "Text", null));
        await Assert.ThrowsAsync<InvalidOperationException>(() => service.CreateFieldDefinitionAsync(new CreateFieldDefinitionDto("key1", "Duplicate", "Text", null)));

        // 3. CreateFieldDefinitionAsync invalid FieldType throws ArgumentException
        await Assert.ThrowsAsync<ArgumentException>(() => service.CreateFieldDefinitionAsync(new CreateFieldDefinitionDto("key2", "Label 2", "InvalidType", null)));

        // 4. UpdateFieldDefinitionAsync non-existent throws KeyNotFoundException
        await Assert.ThrowsAsync<KeyNotFoundException>(() => service.UpdateFieldDefinitionAsync(99999, new UpdateFieldDefinitionDto("k", "L", "Text", null, true)));

        // 5. UpdateFieldDefinitionAsync duplicate key & invalid type throw
        var f2 = await service.CreateFieldDefinitionAsync(new CreateFieldDefinitionDto("key2", "Label 2", "Text", null));
        await Assert.ThrowsAsync<InvalidOperationException>(() => service.UpdateFieldDefinitionAsync(f2.Id, new UpdateFieldDefinitionDto("key1", "Colliding", "Text", null, true)));
        await Assert.ThrowsAsync<ArgumentException>(() => service.UpdateFieldDefinitionAsync(f2.Id, new UpdateFieldDefinitionDto("key2", "Label 2", "BadType", null, true)));

        // 6. Options: Get non-existent returns null, Update non-existent throws
        Assert.Null(await service.GetFieldOptionByIdAsync(99999));
        await Assert.ThrowsAsync<KeyNotFoundException>(() => service.UpdateFieldOptionAsync(99999, new UpdateFieldOptionDto("V", "L", 1, true)));

        // 7. Placements: Get non-existent returns null, duplicate placement throws
        Assert.Null(await service.GetPlacementByIdAsync(99999));
        var proj = new Project { Name = "DynProj2", ProjectKey = "DP2" };
        _context.Projects.Add(proj);
        await _context.SaveChangesAsync();

        var p1 = await service.CreatePlacementAsync(new CreateFormFieldPlacementDto(f1.Id, proj.Id, null, null, 1, false));
        await Assert.ThrowsAsync<InvalidOperationException>(() => service.CreatePlacementAsync(new CreateFormFieldPlacementDto(f1.Id, proj.Id, null, null, 1, false)));

        await Assert.ThrowsAsync<KeyNotFoundException>(() => service.UpdatePlacementAsync(99999, new UpdateFormFieldPlacementDto(proj.Id, null, null, 1, false, true)));
    }

    [Fact]
    public async Task WorkflowService_And_CatalogService_All_Branches()
    {
        var wfRepo = new Repository<Workflow>(_context);
        var transRepo = new Repository<WorkflowTransition>(_context);
        var wfService = new WorkflowService(wfRepo, transRepo);

        // WorkflowService branches
        Assert.Null(await wfService.GetWorkflowByIdAsync(99999));
        await Assert.ThrowsAsync<KeyNotFoundException>(() => wfService.UpdateWorkflowAsync(99999, new UpdateWorkflowDto("W", "D", null, true)));
        Assert.Null(await wfService.GetTransitionByIdAsync(99999));
        await Assert.ThrowsAsync<InvalidOperationException>(() => wfService.CreateTransitionAsync(new CreateWorkflowTransitionDto(1, 1, 1, "T1", null, 1))); // From == To throws
        await Assert.ThrowsAsync<InvalidOperationException>(() => wfService.UpdateTransitionAsync(1, new UpdateWorkflowTransitionDto(2, 2, "T2", null, 1, true))); // From == To throws
        await Assert.ThrowsAsync<KeyNotFoundException>(() => wfService.UpdateTransitionAsync(99999, new UpdateWorkflowTransitionDto(1, 2, "T2", null, 1, true)));

        // CatalogService branches
        var catRepo = new Repository<Category>(_context);
        var typeRepo = new Repository<TicketType>(_context);
        var statRepo = new Repository<Status>(_context);
        var prioRepo = new Repository<Priority>(_context);
        var catService = new CatalogService(catRepo, typeRepo, statRepo, prioRepo, _context);

        Assert.Null(await catService.GetCategoryByIdAsync(99999));
        await Assert.ThrowsAsync<KeyNotFoundException>(() => catService.UpdateCategoryAsync(99999, new UpdateCategoryDto("C", 1, null, "Desc", null, true)));

        Assert.Null(await catService.GetTicketTypeByIdAsync(99999));
        await Assert.ThrowsAsync<KeyNotFoundException>(() => catService.UpdateTicketTypeAsync(99999, new UpdateTicketTypeDto("T", true)));

        Assert.Null(await catService.GetStatusByIdAsync(99999));
        await Assert.ThrowsAsync<KeyNotFoundException>(() => catService.UpdateStatusAsync(99999, new UpdateStatusDto("S", "#fff", 1, false, false, true)));

        var sInUse = new Status { Name = "ActiveStatus" };
        _context.Statuses.Add(sInUse);
        var wtInUse = new WorkflowTransition { FromStatusId = sInUse.Id, ToStatusId = 99999, TransitionName = "InUseTrans" };
        _context.WorkflowTransitions.Add(wtInUse);
        await _context.SaveChangesAsync();
        await Assert.ThrowsAsync<InvalidOperationException>(() => catService.DeleteStatusAsync(sInUse.Id));

        Assert.Null(await catService.GetPriorityByIdAsync(99999));
        await Assert.ThrowsAsync<KeyNotFoundException>(() => catService.UpdatePriorityAsync(99999, new UpdatePriorityDto("P", "#fff", 1, 1, true)));
    }

    [Fact]
    public async Task SlaService_And_DashboardService_All_Branches()
    {
        var slaService = new SlaService(_context);

        // SlaService branches
        Assert.Null(await slaService.GetPolicyByIdAsync(99999));
        await Assert.ThrowsAsync<KeyNotFoundException>(() => slaService.UpdatePolicyAsync(99999, new UpdateSlaPolicyDto("P", "D", null, false, true)));
        await Assert.ThrowsAsync<KeyNotFoundException>(() => slaService.RestorePolicyAsync(99999));
        await slaService.DeletePolicyAsync(99999);
        await slaService.DeleteTargetAsync(99999);

        // Global policy without project
        var globalPolicy = await slaService.CreatePolicyAsync(new CreateSlaPolicyDto("Global SLA", "Desc", null, true));
        Assert.Null(globalPolicy.ProjectId);
        Assert.Null((await slaService.GetPolicyByIdAsync(globalPolicy.Id))!.ProjectName);

        // DashboardService branches
        var dashService = new DashboardService(_context, _permMock.Object);

        var adminUser = new User { Username = "dashAdmin" };
        var normalUser = new User { Username = "dashNormal" };
        _context.Users.AddRange(adminUser, normalUser);
        await _context.SaveChangesAsync();

        _permMock.Setup(p => p.CalculateEffectivePermissionsAsync(adminUser.Id)).ReturnsAsync(new HashSet<string> { "ticket.manage" });
        _permMock.Setup(p => p.CalculateEffectivePermissionsAsync(normalUser.Id)).ReturnsAsync(new HashSet<string>());

        var adminDash = await dashService.GetOverviewAsync(adminUser.Id);
        Assert.NotNull(adminDash);
        var userDash = await dashService.GetOverviewAsync(normalUser.Id);
        Assert.NotNull(userDash);

        var workload = await dashService.GetDepartmentWorkloadAsync(adminUser.Id);
        Assert.NotNull(workload);

        var compliance = await dashService.GetSlaComplianceAsync(adminUser.Id);
        Assert.NotNull(compliance);
    }

    [Fact]
    public async Task UserService_And_GroupService_Branches()
    {
        var userRepo = new Repository<User>(_context);
        var userService = new UserService(userRepo, _context, _httpMock.Object);

        // UserService branches
        Assert.Null(await userService.GetByIdAsync(99999));
        await Assert.ThrowsAsync<KeyNotFoundException>(() => userService.UpdateAsync(99999, new UpdateUserDto("e@t.com", "F", "L", true, null, null, null)));
        await Assert.ThrowsAsync<KeyNotFoundException>(() => userService.ResetPasswordAsync(99999, "newpass"));

        var u = await userService.CreateAsync(new CreateUserDto("new_u", "e@u.com", "Pass123!", "F", "L", null, null, null));
        // Deactivate user branch
        await userService.UpdateAsync(u.Id, new UpdateUserDto("e@u.com", "F", "L", false, null, null, null, "NewPass123!"));
        var updatedU = await userService.GetByIdAsync(u.Id);
        Assert.False(updatedU!.IsActive);

        // GroupService branches
        var groupRepo = new Repository<Group>(_context);
        var groupService = new GroupService(groupRepo, _context, _httpMock.Object);

        Assert.Null(await groupService.GetByIdAsync(99999));
        await Assert.ThrowsAsync<KeyNotFoundException>(() => groupService.UpdateAsync(99999, new UpdateGroupDto("G", true, 0)));

        var grp = await groupService.CreateAsync(new CreateGroupDto("TestGrp", 0));
        await groupService.UpdateAsync(grp.Id, new UpdateGroupDto("TestGrpRenamed", true, 0));
        Assert.NotNull(await groupService.GetByIdAsync(grp.Id));
    }

    [Fact]
    public async Task AiController_And_PermissionsController_Branches()
    {
        // 1. AiController branches
        var aiController = new AiController(_llmMock.Object);

        _llmMock.Setup(l => l.GetCurrentConfig()).Returns(new LlmConfigDto { Endpoint = "endpoint", Model = "model", FallbackToHeuristic = true, TimeoutSeconds = 30 });
        var statusRes = await aiController.GetStatus() as OkObjectResult;
        Assert.NotNull(statusRes);

        // 2. AiTicketCopilotController branches
        var agent = new ResolutionCopilotAgent(_llmMock.Object, _context, new NullLogger<ResolutionCopilotAgent>());
        var copilotController = new AiTicketCopilotController(agent);

        var badQ = await copilotController.Ask(1, new AiTicketCopilotController.AskQuestionDto("   ")) as BadRequestObjectResult;
        Assert.NotNull(badQ);

        // Resolution suggestion not found (ticket 99999 doesn't exist)
        var notFoundSug = await copilotController.SuggestResolution(99999) as NotFoundObjectResult;
        Assert.NotNull(notFoundSug);

        // 3. AiTicketHandoffController branches
        var swarm = new TicketHandoffSwarm(_llmMock.Object, _context, new NullLogger<TicketHandoffSwarm>());
        var handoffController = new AiTicketHandoffController(swarm);
        var notFoundHandoff = await handoffController.Summarize(99999) as NotFoundObjectResult;
        Assert.NotNull(notFoundHandoff);

        // 4. PermissionsController branches
        var permController = new PermissionsController(_context, _permMock.Object);
        _permMock.Setup(p => p.CalculateEffectivePermissionsAsync(1)).ReturnsAsync(new HashSet<string> { "admin.manage" });
        _permMock.Setup(p => p.CalculateEffectivePermissionsAsync(0)).ReturnsAsync(new HashSet<string>());

        // User with admin.manage
        permController.ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext { User = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim(ClaimTypes.NameIdentifier, "1") })) } };
        await permController.GetAll();
        await permController.GetById(99999);
        var createdPerm = await permController.Create(new CreatePermissionDto("Ultra Perm", "ultra.perm", "Desc")) as OkObjectResult;
        Assert.NotNull(createdPerm);

        // User without NameIdentifier (userId = 0) throws/forbids
        permController.ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext() };
        var forbidRes = await permController.Create(new CreatePermissionDto("Fail", "fail", "Desc")) as ForbidResult;
        Assert.NotNull(forbidRes);
    }

    [Fact]
    public async Task Agent_Heuristics_And_Interceptor_Internals()
    {
        // 1. ResolutionCopilotAgent heuristics with IEnumerable
        var simTickets = new List<SimilarTicketSummary>
        {
            new SimilarTicketSummary(1, "T-1", "Similar Title", "Desc")
        }.AsEnumerable();

        var kbArticles = new List<KbArticleSummary>
        {
            new KbArticleSummary(1, "KB Title", "Kb content")
        }.AsEnumerable();

        var t = new Ticket { TicketNumber = "T-HD", Title = "Handoff Ticket", Description = null };

        var enHeuristic = ResolutionCopilotAgent.BuildSmartHeuristicSuggestionEn(t, simTickets, kbArticles);
        Assert.Contains("Similar Title", enHeuristic);
        Assert.Contains("KB Title", enHeuristic);

        var trHeuristic = ResolutionCopilotAgent.BuildSmartHeuristicSuggestion(t, simTickets, kbArticles);
        Assert.Contains("Similar Title", trHeuristic);
        Assert.Contains("KB Title", trHeuristic);

        // 2. TicketHandoffSwarm heuristics
        var snippets = new List<string> { "Working on it" };

        var (enSum, enAct) = TicketHandoffSwarm.BuildSmartHeuristicHandoffEn(t, 1, snippets);
        Assert.Contains("T-HD", enSum);

        var (trSum, trAct) = TicketHandoffSwarm.BuildSmartHeuristicHandoff(t, 1, snippets);
        Assert.Contains("T-HD", trSum);

        // 3. SystemAuditService HttpContext variations
        var auditService = new SystemAuditService(_context, _httpMock.Object);
        await auditService.LogAuditAsync("Ticket", "1", "T", "Created", "Title", "-", "New");

        var emptyHttpMock = new Mock<IHttpContextAccessor>();
        emptyHttpMock.Setup(h => h.HttpContext).Returns((HttpContext?)null);
        var auditServiceNoHttp = new SystemAuditService(_context, emptyHttpMock.Object);
        await auditServiceNoHttp.LogAuditAsync("Ticket", "2", "T", "Created", "Title", "-", "New");

        // 4. LlmService config and masking
        Assert.Equal("YOUR****_KEY", LlmService.MaskApiKey("YOUR_API_KEY"));
        Assert.Equal("********", LlmService.MaskApiKey("none"));
        Assert.Equal("sk-1****abcd", LlmService.MaskApiKey("sk-1234567890abcd"));
    }
}

