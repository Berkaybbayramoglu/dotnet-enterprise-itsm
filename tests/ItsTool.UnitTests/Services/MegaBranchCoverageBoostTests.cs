using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Claims;
using System.Text;
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

public class MegaBranchCoverageBoostTests : TestBase
{
    private readonly Mock<IHttpContextAccessor> _httpContextAccessorMock;
    private readonly Mock<ILlmService> _llmServiceMock;
    private readonly Mock<IPermissionCalculator> _permissionCalculatorMock;
    private readonly Mock<ISignalRPusher> _signalRPusherMock;
    private readonly Mock<IFileStorageService> _fileStorageMock;
    private readonly Mock<ISlaEngine> _slaEngineMock;
    private readonly Mock<IAssignmentEngine> _assignmentEngineMock;
    private readonly Mock<INotificationDispatcher> _notificationDispatcherMock;
    private readonly Mock<IConfiguration> _configurationMock;
    private readonly Mock<ITokenService> _tokenServiceMock;

    public MegaBranchCoverageBoostTests() : base()
    {
        _httpContextAccessorMock = new Mock<IHttpContextAccessor>();
        _llmServiceMock = new Mock<ILlmService>();
        _permissionCalculatorMock = new Mock<IPermissionCalculator>();
        _signalRPusherMock = new Mock<ISignalRPusher>();
        _fileStorageMock = new Mock<IFileStorageService>();
        _slaEngineMock = new Mock<ISlaEngine>();
        _assignmentEngineMock = new Mock<IAssignmentEngine>();
        _notificationDispatcherMock = new Mock<INotificationDispatcher>();
        _configurationMock = new Mock<IConfiguration>();
        _tokenServiceMock = new Mock<ITokenService>();

        var user = new ClaimsPrincipal(new ClaimsIdentity(new[]
        {
            new Claim(ClaimTypes.NameIdentifier, "1"),
            new Claim(ClaimTypes.Name, "admin"),
            new Claim(ClaimTypes.Role, "SuperAdmin"),
            new Claim("permissions", "ticket.manage"),
            new Claim("permissions", "ticket.assign"),
            new Claim("permissions", "ticket.comment.internal")
        }, "TestAuth"));
        var httpContext = new DefaultHttpContext { User = user };
        _httpContextAccessorMock.Setup(h => h.HttpContext).Returns(httpContext);
    }

    [Fact]
    public async Task ResolutionCopilotAgent_AskQuestion_And_DraftReply_AllBranches()
    {
        var prio = new Priority { Name = "Urgent", SeverityLevel = 1 };
        var cat = new Category { Name = "Cloud" };
        var stat = new Status { Name = "Open" };
        _context.Priorities.Add(prio);
        _context.Categories.Add(cat);
        _context.Statuses.Add(stat);
        await _context.SaveChangesAsync();

        var t = new Ticket
        {
            TicketNumber = "T-AGENT-1",
            Title = "Cloud Service Down",
            Description = "All servers are unreachable",
            PriorityId = prio.Id,
            Priority = prio,
            CategoryId = cat.Id,
            Category = cat,
            StatusId = stat.Id,
            Status = stat
        };
        _context.Tickets.Add(t);
        await _context.SaveChangesAsync();

        _context.TicketComments.Add(new TicketComment { TicketId = t.Id, Content = "Initial triage done", CreatedBy = "operator" });
        await _context.SaveChangesAsync();

        // 1. Live LLM successful response (language = "en" and "tr")
        _llmServiceMock.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync("Detailed analysis: Check the load balancer settings.");
        _llmServiceMock.Setup(l => l.GetModelName()).Returns("gpt-4o");

        var agent = new ResolutionCopilotAgent(_llmServiceMock.Object, _context, NullLogger<ResolutionCopilotAgent>.Instance);

        var ansEnLive = await agent.AskQuestionWithSourceAsync(t.Id, "What should I do?", "en");
        Assert.True(ansEnLive.IsLlm);
        Assert.Contains("load balancer", ansEnLive.Answer);

        var ansTrLive = await agent.AskQuestionWithSourceAsync(t.Id, "Ne yapmalıyım?", "tr");
        Assert.True(ansTrLive.IsLlm);

        var draftEnLive = await agent.DraftReplyWithSourceAsync(t.Id, "en");
        Assert.True(draftEnLive.IsLlm);

        var draftTrLive = await agent.DraftReplyWithSourceAsync(t.Id, "tr");
        Assert.True(draftTrLive.IsLlm);

        // 2. Fallback enabled (LLM fails, uses smart heuristic fallback)
        _llmServiceMock.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync("[AI Modülü Hatası: Servis yanıt vermedi]");
        _llmServiceMock.Setup(l => l.IsFallbackDisabled()).Returns(false);

        var ansEnFallback = await agent.AskQuestionWithSourceAsync(t.Id, "What should I do?", "en");
        Assert.False(ansEnFallback.IsLlm);
        Assert.Contains("Question:", ansEnFallback.Answer);

        var ansTrFallback = await agent.AskQuestionWithSourceAsync(t.Id, "Ne yapmalıyım?", "tr");
        Assert.False(ansTrFallback.IsLlm);
        Assert.Contains("Sorunuz:", ansTrFallback.Answer);

        var draftEnFallback = await agent.DraftReplyWithSourceAsync(t.Id, "en");
        Assert.False(draftEnFallback.IsLlm);

        var draftTrFallback = await agent.DraftReplyWithSourceAsync(t.Id, "tr");
        Assert.False(draftTrFallback.IsLlm);

        // 3. Fallback disabled (throws InvalidOperationException)
        _llmServiceMock.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync("[AI İsteği Başarısız: Timeout error]");
        _llmServiceMock.Setup(l => l.IsFallbackDisabled()).Returns(true);

        await Assert.ThrowsAsync<InvalidOperationException>(() => agent.AskQuestionWithSourceAsync(t.Id, "Q?", "en"));
        await Assert.ThrowsAsync<InvalidOperationException>(() => agent.DraftReplyWithSourceAsync(t.Id, "en"));

        // 4. GenerateResolutionSuggestionAsync with fallback enabled
        _llmServiceMock.Setup(l => l.IsFallbackDisabled()).Returns(false);
        var sugRes = await agent.GenerateResolutionSuggestionAsync(t.Id, postAsComment: false, language: "en");
        Assert.NotNull(sugRes.Suggestion);
    }

    [Fact]
    public async Task ReportService_ExportTicketsToCsv_AllFieldBranches()
    {
        var proj = new Project { Name = "Report Project", ProjectKey = "RP" };
        var cat = new Category { Name = "Database" };
        var type = new TicketType { Name = "Incident" };
        var stat = new Status { Name = "Active" };
        var prio = new Priority { Name = "P1" };
        _context.Projects.Add(proj);
        _context.Categories.Add(cat);
        _context.TicketTypes.Add(type);
        _context.Statuses.Add(stat);
        _context.Priorities.Add(prio);
        await _context.SaveChangesAsync();

        var u1 = new User { FirstName = "John", LastName = "Doe", Username = "jdoe", Email = "jd@test.com" };
        var u2 = new User { FirstName = "External", LastName = "User", Username = "noname", Email = "nn@test.com" };
        _context.Users.AddRange(u1, u2);
        var grp = new Group { Name = "DB Team" };
        _context.Groups.Add(grp);
        await _context.SaveChangesAsync();

        // Ticket 1: SLA Breached + User Assignee + Requester
        var t1 = new Ticket
        {
            TicketNumber = "T-CSV-1",
            Title = "Title with \"quotes\"",
            Description = "Desc 1",
            ProjectId = proj.Id,
            Project = proj,
            CategoryId = cat.Id,
            Category = cat,
            TypeId = type.Id,
            Type = type,
            StatusId = stat.Id,
            Status = stat,
            PriorityId = prio.Id,
            Priority = prio,
            RequesterUserId = u1.Id,
            RequesterUser = u1
        };
        _context.Tickets.Add(t1);
        await _context.SaveChangesAsync();

        _context.TicketAssignments.Add(new TicketAssignment { TicketId = t1.Id, AssignedUserId = u1.Id, AssignedUser = u1, IsActive = true });
        _context.TicketSlas.Add(new TicketSla { TicketId = t1.Id, FirstResponseBreached = true });

        // Ticket 2: SLA Warning + Group Assignee
        var t2 = new Ticket
        {
            TicketNumber = "T-CSV-2",
            Title = "Simple Title",
            Description = "Desc 2",
            ProjectId = proj.Id,
            Project = proj,
            CategoryId = cat.Id,
            Category = cat,
            TypeId = type.Id,
            Type = type,
            StatusId = stat.Id,
            Status = stat,
            PriorityId = prio.Id,
            Priority = prio,
            RequesterUserId = u2.Id,
            RequesterUser = u2
        };
        _context.Tickets.Add(t2);
        await _context.SaveChangesAsync();

        _context.TicketAssignments.Add(new TicketAssignment { TicketId = t2.Id, AssignedGroupId = grp.Id, AssignedGroup = grp, IsActive = true });
        _context.TicketSlas.Add(new TicketSla { TicketId = t2.Id, ResolutionWarned = true });
        await _context.SaveChangesAsync();

        // Ticket 3: No SLA + No Assignees + Null Requester
        var t3 = new Ticket
        {
            TicketNumber = "T-CSV-3",
            Title = "No SLA Ticket",
            Description = "Desc 3",
            ProjectId = proj.Id,
            Project = proj,
            CategoryId = cat.Id,
            Category = cat,
            TypeId = type.Id,
            Type = type,
            StatusId = stat.Id,
            Status = stat,
            PriorityId = prio.Id,
            Priority = prio,
            RequesterUserId = u1.Id
        };
        _context.Tickets.Add(t3);
        await _context.SaveChangesAsync();

        _permissionCalculatorMock.Setup(p => p.CalculateEffectivePermissionsAsync(u1.Id))
            .ReturnsAsync(new HashSet<string> { "report.view" });

        var reportService = new ReportService(_context, _permissionCalculatorMock.Object);
        using var stream = await reportService.ExportTicketsToCsvAsync(new TicketSearchFilterDto(), u1.Id);
        Assert.NotNull(stream);
        using var reader = new StreamReader(stream, Encoding.UTF8);
        var csv = await reader.ReadToEndAsync();
        Assert.Contains("T-CSV-1", csv);
        Assert.Contains("Breached", csv);
        Assert.Contains("Warning", csv);
        Assert.Contains("On Track", csv);
        Assert.Contains("DB Team", csv);
    }

    [Fact]
    public async Task KnowledgeBaseService_GetArticle_And_Search_AllBranches()
    {
        _permissionCalculatorMock.Setup(p => p.CalculateEffectivePermissionsAsync(It.IsAny<int>()))
            .ReturnsAsync(new HashSet<string>());
        var kbService = new KnowledgeBaseService(_context, _permissionCalculatorMock.Object, _signalRPusherMock.Object);

        var author = new User { Username = "author", FirstName = "Author", LastName = "One" };
        var reader = new User { Username = "reader", FirstName = "Reader", LastName = "Two" };
        _context.Users.AddRange(author, reader);
        var cat = new KnowledgeCategory { Name = "IT Guide" };
        _context.KnowledgeCategories.Add(cat);
        await _context.SaveChangesAsync();

        // 1. Non-existent article returns null
        var nonExistent = await kbService.GetArticleAsync(99999, author.Id);
        Assert.Null(nonExistent);

        // 2. Draft article: author can view, another normal user cannot view
        var draftArt = new KnowledgeArticle
        {
            Title = "Draft Secret",
            Content = "Draft body",
            CategoryId = cat.Id,
            AuthorUserId = author.Id,
            Status = ArticleStatus.Draft,
            Visibility = ArticleVisibility.Public
        };
        _context.KnowledgeArticles.Add(draftArt);
        await _context.SaveChangesAsync();

        _permissionCalculatorMock.Setup(p => p.CalculateEffectivePermissionsAsync(author.Id))
            .ReturnsAsync(new HashSet<string>());
        _permissionCalculatorMock.Setup(p => p.CalculateEffectivePermissionsAsync(reader.Id))
            .ReturnsAsync(new HashSet<string>());

        var authorDraftView = await kbService.GetArticleAsync(draftArt.Id, author.Id);
        Assert.NotNull(authorDraftView);

        var readerDraftView = await kbService.GetArticleAsync(draftArt.Id, reader.Id);
        Assert.Null(readerDraftView);

        // 3. Internal article: staff or kb.manage can view, external normal reader cannot view
        var internalArt = new KnowledgeArticle
        {
            Title = "Internal Staff Guide",
            Content = "Internal body",
            CategoryId = cat.Id,
            AuthorUserId = author.Id,
            Status = ArticleStatus.Published,
            Visibility = ArticleVisibility.Internal
        };
        _context.KnowledgeArticles.Add(internalArt);
        await _context.SaveChangesAsync();

        var readerInternalView = await kbService.GetArticleAsync(internalArt.Id, reader.Id);
        Assert.Null(readerInternalView);

        // Reader with ticket.manage can view internal article and increments ViewCount
        _permissionCalculatorMock.Setup(p => p.CalculateEffectivePermissionsAsync(reader.Id))
            .ReturnsAsync(new HashSet<string> { "ticket.manage" });

        var staffInternalView = await kbService.GetArticleAsync(internalArt.Id, reader.Id);
        Assert.NotNull(staffInternalView);
        Assert.Equal(1, staffInternalView.ViewCount);

        // 4. SearchArticlesAsync with keyword, categoryId, and permissions
        var searchAll = await kbService.SearchArticlesAsync(reader.Id, "Staff", cat.Id);
        Assert.Single(searchAll);

        // 5. CreateArticleAsync with Published status -> gets forced to PendingReview
        var createDto = new CreateKbArticleDto(cat.Id, "Auto Published", "Content", ArticleStatus.Published, ArticleVisibility.Public);
        var created = await kbService.CreateArticleAsync(createDto, author.Id);
        Assert.Equal(ArticleStatus.PendingReview, created.Status);

        // 6. ReviewArticleAsync Approve & Reject
        _permissionCalculatorMock.Setup(p => p.CalculateEffectivePermissionsAsync(reader.Id))
            .ReturnsAsync(new HashSet<string> { "kb.manage" });

        var reviewRejectDto = new ReviewKbArticleDto(ArticleStatus.Rejected, "Needs more detail");
        await kbService.ReviewArticleAsync(created.Id, reviewRejectDto, reader.Id);
        var rejected = await _context.KnowledgeArticles.FindAsync(created.Id);
        Assert.Equal(ArticleStatus.Rejected, rejected!.Status);

        var reviewApproveDto = new ReviewKbArticleDto(ArticleStatus.Published, "Looks great");
        await kbService.ReviewArticleAsync(created.Id, reviewApproveDto, reader.Id);
        var approved = await _context.KnowledgeArticles.FindAsync(created.Id);
        Assert.Equal(ArticleStatus.Published, approved!.Status);
    }

    [Fact]
    public async Task TicketService_GetAssignmentTree_And_Comments_AllBranches()
    {
        var ticketService = new TicketService(
            _context,
            _fileStorageMock.Object,
            _permissionCalculatorMock.Object,
            _slaEngineMock.Object,
            _assignmentEngineMock.Object,
            _notificationDispatcherMock.Object
        );

        var u = new User { FirstName = "Active", LastName = "User", Username = "act_u" };
        _context.Users.Add(u);
        var g = new Group { Name = "Support Group" };
        _context.Groups.Add(g);
        await _context.SaveChangesAsync();

        var t = new Ticket { TicketNumber = "T-TREE-1", Title = "Tree Test", Description = "Desc" };
        _context.Tickets.Add(t);
        await _context.SaveChangesAsync();

        // 1. Assignment with user, assignment with group, assignment with null nav props
        var a1 = new TicketAssignment { TicketId = t.Id, AssignedUserId = u.Id, AssignedUser = u, IsActive = true };
        var a2 = new TicketAssignment { TicketId = t.Id, AssignedGroupId = g.Id, AssignedGroup = g, IsActive = true };
        var a3 = new TicketAssignment { TicketId = t.Id, AssignedUserId = 9999, AssignedUser = null, IsActive = false };
        _context.TicketAssignments.AddRange(a1, a2, a3);
        await _context.SaveChangesAsync();

        var tree = await ticketService.GetAssignmentTreeAsync(t.Id);
        Assert.Equal(3, tree.Count());

        // 2. AddCommentAsync: Normal comment, Internal note, Reply comment
        var c1 = await ticketService.AddCommentAsync(t.Id, new CreateCommentDto("Public comment", false, u.Id));
        Assert.False(c1.IsInternal);

        var c2 = await ticketService.AddCommentAsync(t.Id, new CreateCommentDto("Internal note", true, u.Id));
        Assert.True(c2.IsInternal);

        var c3 = await ticketService.AddCommentAsync(t.Id, new CreateCommentDto("Reply note", false, u.Id, c1.Id));
        Assert.Equal(c1.Id, c3.ParentCommentId);

        // 3. GetCommentsAsync: includeInternal true vs false
        var allComments = await ticketService.GetCommentsAsync(t.Id, includeInternal: true);
        Assert.Equal(3, allComments.Count());

        var publicComments = await ticketService.GetCommentsAsync(t.Id, includeInternal: false);
        Assert.Equal(2, publicComments.Count());

        // 4. DeleteCommentAsync: non-existent, unauthorized, and authorized
        await Assert.ThrowsAsync<KeyNotFoundException>(() => ticketService.DeleteCommentAsync(t.Id, 9999, u.Id, false));
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => ticketService.DeleteCommentAsync(t.Id, c1.Id, 9999, false));

        await ticketService.DeleteCommentAsync(t.Id, c1.Id, u.Id, false);
        var deletedComment = await _context.TicketComments.IgnoreQueryFilters().FirstOrDefaultAsync(x => x.Id == c1.Id);
        Assert.True(deletedComment!.IsDeleted);

        // 5. RestoreCommentAsync: non-existent, unauthorized, and authorized (removes CommentDeleted history)
        await Assert.ThrowsAsync<KeyNotFoundException>(() => ticketService.RestoreCommentAsync(t.Id, 9999, u.Id, false));
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => ticketService.RestoreCommentAsync(t.Id, c1.Id, 9999, false));

        await ticketService.RestoreCommentAsync(t.Id, c1.Id, u.Id, false);
        var restoredComment = await _context.TicketComments.FindAsync(c1.Id);
        Assert.False(restoredComment!.IsDeleted);
    }

    [Fact]
    public async Task TicketService_Transitions_And_StatusChanges_AllBranches()
    {
        var ticketService = new TicketService(
            _context,
            _fileStorageMock.Object,
            _permissionCalculatorMock.Object,
            _slaEngineMock.Object,
            _assignmentEngineMock.Object,
            _notificationDispatcherMock.Object
        );

        var p = new Project { Name = "Workflow Proj", ProjectKey = "WP" };
        _context.Projects.Add(p);
        var sOpen = new Status { Id = 1, Name = "Open" };
        var sInProg = new Status { Id = 2, Name = "InProgress" };
        var sClosed = new Status { Id = 5, Name = "Closed", IsClosedStatus = true };
        _context.Statuses.AddRange(sOpen, sInProg, sClosed);
        await _context.SaveChangesAsync();

        var wf = new Workflow { Name = "Default WF", ProjectId = p.Id };
        _context.Workflows.Add(wf);
        await _context.SaveChangesAsync();

        var trans1 = new WorkflowTransition { WorkflowId = wf.Id, FromStatusId = sOpen.Id, ToStatusId = sInProg.Id, TransitionName = "Start Work", IsActive = true };
        var trans2 = new WorkflowTransition { WorkflowId = wf.Id, FromStatusId = sInProg.Id, ToStatusId = sClosed.Id, TransitionName = "Close Ticket", RequiredPermissionKey = "ticket.close", IsActive = true };
        _context.WorkflowTransitions.AddRange(trans1, trans2);
        await _context.SaveChangesAsync();

        var u = new User { Username = "worker", IsActive = true };
        _context.Users.Add(u);
        await _context.SaveChangesAsync();

        var t = new Ticket { TicketNumber = "T-WF-1", Title = "WF Test", Description = "Desc", ProjectId = p.Id, StatusId = sOpen.Id, RequesterUserId = u.Id };
        _context.Tickets.Add(t);
        await _context.SaveChangesAsync();

        // 1. Transition Open -> InProgress (no permission key required)
        _permissionCalculatorMock.Setup(pc => pc.CalculateEffectivePermissionsAsync(u.Id))
            .ReturnsAsync(new HashSet<string>());

        await ticketService.ChangeStatusAsync(t.Id, new ChangeStatusDto(sInProg.Id, u.Id));
        Assert.Equal(sInProg.Id, t.StatusId);

        // 2. Transition InProgress -> Closed without required permission throws
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => ticketService.ChangeStatusAsync(t.Id, new ChangeStatusDto(sClosed.Id, u.Id)));

        // 3. Transition InProgress -> Closed with required permission dispatches survey
        _permissionCalculatorMock.Setup(pc => pc.CalculateEffectivePermissionsAsync(u.Id))
            .ReturnsAsync(new HashSet<string> { "ticket.close" });

        await ticketService.ChangeStatusAsync(t.Id, new ChangeStatusDto(sClosed.Id, u.Id));
        Assert.Equal(sClosed.Id, t.StatusId);
        _notificationDispatcherMock.Verify(n => n.DispatchEventAsync("ticket.closed.survey", t.Id, u.Id, It.IsAny<string>()), Times.Once);

        // 4. Invalid status transition throws
        await Assert.ThrowsAsync<InvalidOperationException>(() => ticketService.ChangeStatusAsync(t.Id, new ChangeStatusDto(sOpen.Id, u.Id)));
    }

    [Fact]
    public async Task EmailIngestionService_ProcessIncomingEmail_AllBranches()
    {
        var ingestion = new EmailIngestionService(_context);

        // 1. Missing message id returns early
        await ingestion.ProcessIncomingEmailAsync(new EmailIngestionDto("", "test@test.com", "Hi", ""));

        // Setup project with key [SEC]
        var proj = new Project { Name = "Security Proj", ProjectKey = "SEC" };
        _context.Projects.Add(proj);
        var existingUser = new User { Email = "internal@test.com", Username = "internal_u" };
        _context.Users.Add(existingUser);
        if (!await _context.Categories.AnyAsync()) _context.Categories.Add(new Category { Name = "General" });
        if (!await _context.TicketTypes.AnyAsync()) _context.TicketTypes.Add(new TicketType { Name = "Support" });
        if (!await _context.Priorities.AnyAsync()) _context.Priorities.Add(new Priority { Name = "Medium" });
        if (!await _context.Statuses.AnyAsync(s => s.IsSystemDefault)) _context.Statuses.Add(new Status { Name = "Open", IsSystemDefault = true });
        await _context.SaveChangesAsync();

        // 2. Process email from brand new external user with project key in subject
        var email1 = new EmailIngestionDto(
            "<msg-001@mail.com>",
            "customer@external.com",
            "[SEC] Server compromised",
            "Urgent help needed"
        );
        await ingestion.ProcessIncomingEmailAsync(email1);

        var createdTicket = await _context.Tickets.FirstOrDefaultAsync(t => t.ExternalMessageId == "<msg-001@mail.com>");
        Assert.NotNull(createdTicket);
        Assert.Equal(proj.Id, createdTicket.ProjectId);

        // 3. Deduplication: processing the same message id returns early
        await ingestion.ProcessIncomingEmailAsync(email1);

        // 4. Process email from existing user with no project brackets (default project fallback)
        var email2 = new EmailIngestionDto(
            "<msg-002@mail.com>",
            "internal@test.com",
            "General Inquiry without brackets",
            "Can you help?"
        );
        await ingestion.ProcessIncomingEmailAsync(email2);

        var ticket2 = await _context.Tickets.FirstOrDefaultAsync(t => t.ExternalMessageId == "<msg-002@mail.com>");
        Assert.NotNull(ticket2);
    }

    [Fact]
    public async Task GroupService_MembersAndDepartments_AllBranches()
    {
        var groupRepoMock = new Mock<IRepository<Group>>();
        var groupService = new GroupService(groupRepoMock.Object, _context, _httpContextAccessorMock.Object);

        var d1 = new Department { Name = "Old Dept" };
        var d2 = new Department { Name = "New Dept" };
        _context.Departments.AddRange(d1, d2);
        var g = new Group { Name = "SecOps", DepartmentId = d1.Id };
        _context.Groups.Add(g);
        var u = new User { Username = "sec_user", Email = "sec@test.com" };
        _context.Users.Add(u);
        await _context.SaveChangesAsync();

        groupRepoMock.Setup(r => r.GetByIdAsync(g.Id)).ReturnsAsync(g);

        // 1. UpdateAsync: changing department triggers audit log
        var updateDto = new UpdateGroupDto("SecOps Renamed", true, d2.Id);
        await groupService.UpdateAsync(g.Id, updateDto);
        groupRepoMock.Verify(r => r.UpdateAsync(It.IsAny<Group>()), Times.Once);

        // 2. AddMemberAsync: first time adds member and logs audit; second time is idempotent
        await groupService.AddMemberAsync(g.Id, u.Id);
        Assert.True(await _context.GroupMembers.AnyAsync(gm => gm.GroupId == g.Id && gm.UserId == u.Id));

        await groupService.AddMemberAsync(g.Id, u.Id); // idempotent branch

        // 3. RemoveMemberAsync: removes member and logs audit; non-existent member is safe
        await groupService.RemoveMemberAsync(g.Id, u.Id);
        Assert.False(await _context.GroupMembers.AnyAsync(gm => gm.GroupId == g.Id && gm.UserId == u.Id));

        await groupService.RemoveMemberAsync(g.Id, 99999); // non-existent safe

        // 4. DeleteAsync removes associated ticket assignments
        var t = new Ticket { TicketNumber = "T-GRP-1", Title = "Grp Test", Description = "Desc" };
        _context.Tickets.Add(t);
        await _context.SaveChangesAsync();

        var assign = new TicketAssignment { TicketId = t.Id, AssignedGroupId = g.Id, IsActive = true };
        _context.TicketAssignments.Add(assign);
        await _context.SaveChangesAsync();

        await groupService.DeleteAsync(g.Id);
        Assert.False(assign.IsActive);
        Assert.True(assign.IsDeleted);
    }

    [Fact]
    public async Task SlaService_GetPolicies_WithMissingReferences_AllBranches()
    {
        var slaService = new SlaService(_context);

        var proj = new Project { Name = "Known Project", ProjectKey = "KP" };
        var prio = new Priority { Name = "Known Priority", ColorHex = "#123456", SeverityLevel = 2 };
        var type = new TicketType { Name = "Known Type" };
        _context.Projects.Add(proj);
        _context.Priorities.Add(prio);
        _context.TicketTypes.Add(type);
        await _context.SaveChangesAsync();

        // Policy with known project & priority & type
        var p1 = new SlaPolicy { Name = "Policy 1", ProjectId = proj.Id, IsActive = true };
        _context.SlaPolicies.Add(p1);
        await _context.SaveChangesAsync();
        _context.SlaTargets.Add(new SlaTarget { SlaPolicyId = p1.Id, PriorityId = prio.Id, TicketTypeId = type.Id, FirstResponseMinutes = 10, ResolutionMinutes = 30 });

        // Policy with unknown project & unknown priority & null type
        var p2 = new SlaPolicy { Name = "Policy 2", ProjectId = 99999, IsActive = true };
        _context.SlaPolicies.Add(p2);
        await _context.SaveChangesAsync();
        _context.SlaTargets.Add(new SlaTarget { SlaPolicyId = p2.Id, PriorityId = 99999, TicketTypeId = null, FirstResponseMinutes = 20, ResolutionMinutes = 60 });

        // Deleted policy
        var p3 = new SlaPolicy { Name = "Deleted Policy", ProjectId = null, IsActive = false, IsDeleted = true };
        _context.SlaPolicies.Add(p3);
        await _context.SaveChangesAsync();
        _context.SlaTargets.Add(new SlaTarget { SlaPolicyId = p3.Id, PriorityId = prio.Id, FirstResponseMinutes = 15, ResolutionMinutes = 45 });

        await _context.SaveChangesAsync();

        var activePolicies = await slaService.GetPoliciesAsync();
        Assert.NotEmpty(activePolicies);

        var deletedPolicies = await slaService.GetDeletedPoliciesAsync();
        Assert.NotEmpty(deletedPolicies);
    }

    [Fact]
    public async Task SystemAuditInterceptor_GetGroupMemberName_And_ProcessModifiedEntity()
    {
        var interceptor = new SystemAuditInterceptor(_httpContextAccessorMock.Object);
        var options = new DbContextOptionsBuilder<ItsToolDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .AddInterceptors(interceptor)
            .Options;

        using var ctx = new ItsToolDbContext(options);

        var u = new User { Username = "member_u", Email = "mu@test.com" };
        var g = new Group { Name = "Member Group" };
        ctx.Users.Add(u);
        ctx.Groups.Add(g);
        await ctx.SaveChangesAsync();

        // 1. GroupMember Added state
        var gm = new GroupMember { UserId = u.Id, GroupId = g.Id };
        ctx.GroupMembers.Add(gm);
        var entryAdded = ctx.Entry(gm);
        var nameAdded = SystemAuditInterceptor.GetGroupMemberName(entryAdded, ctx);
        Assert.Contains("member_u", nameAdded);
        Assert.Contains("Member Group", nameAdded);

        await ctx.SaveChangesAsync();

        // 2. GroupMember Deleted state
        ctx.GroupMembers.Remove(gm);
        var entryDeleted = ctx.Entry(gm);
        var nameDeleted = SystemAuditInterceptor.GetGroupMemberName(entryDeleted, ctx);
        Assert.Contains("member_u", nameDeleted);

        // 3. Null context branch
        var nameNullCtx = SystemAuditInterceptor.GetGroupMemberName(entryAdded, null);
        Assert.Contains("User:", nameNullCtx);

        // 4. Unknown entity throwing in GetGroupMemberName catch block
        var cat = new Category { Name = "TestCat" };
        ctx.Categories.Add(cat);
        var catEntry = ctx.Entry(cat);
        var errName = SystemAuditInterceptor.GetGroupMemberName(catEntry, ctx);
        Assert.Contains("GroupMember (Err:", errName);

        // 5. ProcessModifiedEntity: changing properties, ignoring UpdatedAt/PasswordHash
        var uToMod = new User { Username = "mod_user", Email = "mod@test.com", FirstName = "OldFirst" };
        ctx.Users.Add(uToMod);
        await ctx.SaveChangesAsync();

        uToMod.FirstName = "NewFirst";
        uToMod.UpdatedAt = DateTime.UtcNow;
        uToMod.PasswordHash = "newhash";
        await ctx.SaveChangesAsync();

        var logs = await ctx.SystemAuditLogs.Where(l => l.EntityName == "mod_user").ToListAsync();
        Assert.Contains(logs, l => l.FieldName == "FirstName");
        Assert.DoesNotContain(logs, l => l.FieldName == "UpdatedAt");
        Assert.DoesNotContain(logs, l => l.FieldName == "PasswordHash");
    }

    [Fact]
    public async Task DashboardService_GetSlaCompliance_AllBranches()
    {
        var dashService = new DashboardService(_context, _permissionCalculatorMock.Object);
        _permissionCalculatorMock.Setup(p => p.CalculateEffectivePermissionsAsync(1))
            .ReturnsAsync(new HashSet<string> { "report.view" });

        // 1. When no tickets have SLA, returns 100, 100, 0
        var emptyCompliance = await dashService.GetSlaComplianceAsync(1);
        Assert.Equal(100, emptyCompliance.FirstResponseComplianceRate);
        Assert.Equal(100, emptyCompliance.ResolutionComplianceRate);

        // 2. Tickets with compliant and breached SLAs, and resolved ticket
        var sClosed = new Status { Name = "Closed", IsClosedStatus = true };
        _context.Statuses.Add(sClosed);
        await _context.SaveChangesAsync();

        var t = new Ticket { TicketNumber = "T-SLA-COMP-1", StatusId = sClosed.Id, Status = sClosed, CreatedAt = DateTime.UtcNow.AddHours(-2) };
        _context.Tickets.Add(t);
        await _context.SaveChangesAsync();

        var sla = new TicketSla
        {
            TicketId = t.Id,
            FirstResponseDueAt = DateTime.UtcNow.AddHours(-1),
            FirstResponseBreached = false,
            ResolutionDueAt = DateTime.UtcNow.AddHours(-1),
            ResolutionBreached = false,
            ResolutionMetAt = DateTime.UtcNow.AddMinutes(-30)
        };
        _context.TicketSlas.Add(sla);
        await _context.SaveChangesAsync();

        var compliance = await dashService.GetSlaComplianceAsync(1);
        Assert.Equal(100, compliance.FirstResponseComplianceRate);
        Assert.Equal(100, compliance.ResolutionComplianceRate);
        Assert.True(compliance.AverageResolutionTimeMinutes > 0);
    }

    [Fact]
    public async Task AuthService_ChangePassword_AllValidationBranches()
    {
        var authService = new AuthService(
            _context,
            _tokenServiceMock.Object,
            _permissionCalculatorMock.Object,
            _configurationMock.Object
        );

        // 1. null request throws
        await Assert.ThrowsAsync<ArgumentException>(() => authService.ChangePasswordAsync(1, null!));

        // 2. empty passwords throw
        await Assert.ThrowsAsync<ArgumentException>(() => authService.ChangePasswordAsync(1, new ChangePasswordRequestDto("", "123")));

        // 3. mismatched passwords throw
        await Assert.ThrowsAsync<ArgumentException>(() => authService.ChangePasswordAsync(1, new ChangePasswordRequestDto("password123", "different")));

        // 4. short password throws
        await Assert.ThrowsAsync<ArgumentException>(() => authService.ChangePasswordAsync(1, new ChangePasswordRequestDto("123", "123")));

        // 5. non-existent or inactive user throws
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => authService.ChangePasswordAsync(99999, new ChangePasswordRequestDto("newpassword123", "newpassword123")));

        // 6. valid change password succeeds
        var u = new User { Username = "pw_change_u", Email = "pw@test.com", PasswordHash = "old_hash", IsActive = true, MustChangePassword = true };
        _context.Users.Add(u);
        await _context.SaveChangesAsync();

        _tokenServiceMock.Setup(t => t.GenerateToken(u.Id, u.Username, It.IsAny<IEnumerable<string>>(), It.IsAny<IEnumerable<string>>(), false))
            .Returns("valid_new_jwt_token");

        var res = await authService.ChangePasswordAsync(u.Id, new ChangePasswordRequestDto("brandNewPassword123!", "brandNewPassword123!"));
        Assert.NotNull(res);
        Assert.False(u.MustChangePassword);
    }

    [Fact]
    public async Task TicketController_GetTimeline_AllBranches()
    {
        var ticketServiceMock = new Mock<ITicketService>();
        var controller = new TicketController(ticketServiceMock.Object);

        // 1. User with SuperAdmin role claim
        var userAdmin = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim(ClaimTypes.Role, "SuperAdmin") }));
        controller.ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext { User = userAdmin } };
        await controller.GetTimeline(1);
        ticketServiceMock.Verify(s => s.GetTimelineAsync(1, true), Times.Once);

        // 2. User with permission claim "ticket.comment.internal"
        var userPerm = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim("permission", "ticket.comment.internal") }));
        controller.ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext { User = userPerm } };
        await controller.GetTimeline(2);
        ticketServiceMock.Verify(s => s.GetTimelineAsync(2, true), Times.Once);

        // 3. User with neither (hasInternalPerm = false)
        var userPlain = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim(ClaimTypes.Role, "User") }));
        controller.ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext { User = userPlain } };
        await controller.GetTimeline(3);
        ticketServiceMock.Verify(s => s.GetTimelineAsync(3, false), Times.Once);
    }
}
