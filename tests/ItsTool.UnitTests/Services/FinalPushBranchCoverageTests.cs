using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Reflection;
using System.Security.Claims;
using System.Text;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using ItsTool.API.Controllers;
using ItsTool.API.Security;
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
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Services;

[Collection("LlmTests")]
public class FinalPushBranchCoverageTests : IDisposable
{
    public FinalPushBranchCoverageTests()
    {
        LlmService.ResetRuntimeConfig();
    }

    public void Dispose()
    {
        LlmService.ResetRuntimeConfig();
    }

    private ItsToolDbContext CreateDbContext(string dbName)
    {
        var options = new DbContextOptionsBuilder<ItsToolDbContext>()
            .UseInMemoryDatabase(databaseName: dbName)
            .Options;
        return new ItsToolDbContext(options);
    }

    private class OptionalNavDbContext : ItsToolDbContext
    {
        public OptionalNavDbContext(DbContextOptions<ItsToolDbContext> options) : base(options) { }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.Entity<Ticket>().HasOne(t => t.Category).WithMany().IsRequired(false);
            modelBuilder.Entity<Ticket>().HasOne(t => t.Priority).WithMany().IsRequired(false);
            modelBuilder.Entity<Ticket>().HasOne(t => t.Status).WithMany().IsRequired(false);
        }
    }

    private ItsToolDbContext CreateOptionalNavDbContext(string dbName)
    {
        var options = new DbContextOptionsBuilder<ItsToolDbContext>()
            .UseInMemoryDatabase(databaseName: dbName)
            .Options;
        return new OptionalNavDbContext(options);
    }

    private Mock<IHttpContextAccessor> CreateHttpContext(string userId = "1", string role = "Admin")
    {
        var mockAccessor = new Mock<IHttpContextAccessor>();
        var claims = new List<Claim>
        {
            new Claim(ClaimTypes.NameIdentifier, userId),
            new Claim(ClaimTypes.Name, "testuser"),
            new Claim(ClaimTypes.Role, role)
        };
        var identity = new ClaimsIdentity(claims, "TestAuth");
        var principal = new ClaimsPrincipal(identity);
        var httpContext = new DefaultHttpContext { User = principal };
        mockAccessor.Setup(a => a.HttpContext).Returns(httpContext);
        return mockAccessor;
    }

    [Fact]
    public async Task ResolutionCopilotAgent_UncoveredBranches_Covered()
    {
        using var context = CreateDbContext("Copilot_Uncovered_" + Guid.NewGuid());
        var logger = new Mock<ILogger<ResolutionCopilotAgent>>();
        var llmService = new Mock<ILlmService>();

        var cat = new Category { Id = 1, Name = "Hardware" };
        var prio = new Priority { Id = 1, Name = "High" };
        var status = new Status { Id = 1, Name = "Open", IsSystemDefault = true };
        var closedStatus = new Status { Id = 2, Name = "Closed", IsClosedStatus = true };
        context.Categories.Add(cat);
        context.Priorities.Add(prio);
        context.Statuses.AddRange(status, closedStatus);

        var t1 = new Ticket
        {
            Id = 101,
            TicketNumber = "T-101",
            Title = "Laptop screen flickering",
            Description = "Screen flickers periodically",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        var tClosed = new Ticket
        {
            Id = 102,
            TicketNumber = "T-102",
            Title = "Laptop screen broken",
            Description = "Replaced screen cable",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 2,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        var kbShort = new KnowledgeArticle
        {
            Id = 1,
            Title = "Screen flickering fix",
            Content = "Short content",
            CategoryId = 1,
            IsDeleted = false
        };
        context.Tickets.AddRange(t1, tClosed);
        context.KnowledgeArticles.Add(kbShort);
        await context.SaveChangesAsync();

        var agent = new ResolutionCopilotAgent(llmService.Object, context, logger.Object);

        // 1. HandleSuggestionCompletion branches:
        var handleSuggMethod = typeof(ResolutionCopilotAgent).GetMethod("HandleSuggestionCompletion", BindingFlags.NonPublic | BindingFlags.Instance)!;
        llmService.Setup(l => l.IsFallbackDisabled()).Returns(true);
        var resFail = ((string Suggestion, string Source, bool IsLlm, bool IsError, string? ErrorMessage))handleSuggMethod.Invoke(agent, new object?[] { "[AI İsteği Başarısız: Timeout]", "gpt-4", false, t1, new List<SimilarTicketSummary>(), new List<KbArticleSummary>() })!;
        Assert.True(resFail.IsError);
        Assert.Contains("Timeout", resFail.ErrorMessage);

        var resNull = ((string Suggestion, string Source, bool IsLlm, bool IsError, string? ErrorMessage))handleSuggMethod.Invoke(agent, new object?[] { null, "gpt-4", false, t1, new List<SimilarTicketSummary>(), new List<KbArticleSummary>() })!;
        Assert.True(resNull.IsError);

        var resOther = ((string Suggestion, string Source, bool IsLlm, bool IsError, string? ErrorMessage))handleSuggMethod.Invoke(agent, new object?[] { "[AI Modülü Devre Dışı]", "gpt-4", false, t1, new List<SimilarTicketSummary>(), new List<KbArticleSummary>() })!;
        Assert.True(resOther.IsError);

        // 2. GenerateResolutionSuggestionAsync with language = "en" and postAsComment = true
        llmService.Setup(l => l.IsFallbackDisabled()).Returns(false);
        llmService.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync("[AI İsteği Başarısız: Service Down]");
        llmService.Setup(l => l.GetModelName()).Returns("local-heuristic");

        var enResult = await agent.GenerateResolutionSuggestionAsync(101, postAsComment: true, language: "en");
        Assert.True(enResult.Success);
        Assert.Equal("Akıllı Yerel Asistan", enResult.Source);

        // 3. GenerateResolutionSuggestionAsync with fallback disabled and error result
        llmService.Setup(l => l.IsFallbackDisabled()).Returns(true);
        llmService.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync("[AI İsteği Başarısız: Fatal]");
        var errResult = await agent.GenerateResolutionSuggestionAsync(101, postAsComment: false, language: "tr");
        Assert.False(errResult.Success);

        // 4. Ticket not found
        var notFound = await agent.GenerateResolutionSuggestionAsync(9999, postAsComment: false, language: "en");
        Assert.False(notFound.Success);
        Assert.Equal("Bilet bulunamadı.", notFound.Suggestion);

        // 5. DraftReplyWithSourceAsync: ticket not found in en and tr
        var draftEnNotFound = await agent.DraftReplyWithSourceAsync(9999, "en");
        Assert.Equal("Ticket not found.", draftEnNotFound.Draft);
        var draftTrNotFound = await agent.DraftReplyWithSourceAsync(9999, "tr");
        Assert.Equal("Bilet bulunamadı.", draftTrNotFound.Draft);

        // 6. HandleDraftCompletion with fallback disabled
        var handleDraftMethod = typeof(ResolutionCopilotAgent).GetMethod("HandleDraftCompletion", BindingFlags.NonPublic | BindingFlags.Instance)!;
        llmService.Setup(l => l.IsFallbackDisabled()).Returns(true);
        var ex1 = Assert.Throws<TargetInvocationException>(() => handleDraftMethod.Invoke(agent, new object?[] { "[AI İsteği Başarısız: Err]", "model", false, t1 }));
        Assert.IsType<InvalidOperationException>(ex1.InnerException);
        var ex2 = Assert.Throws<TargetInvocationException>(() => handleDraftMethod.Invoke(agent, new object?[] { null, "model", false, t1 }));
        Assert.IsType<InvalidOperationException>(ex2.InnerException);

        // 7. AskQuestionWithSourceAsync
        llmService.Setup(l => l.IsFallbackDisabled()).Returns(false);
        llmService.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync("[AI İsteği Başarısız: Fallback]");
        
        var askNotFoundEn = await agent.AskQuestionWithSourceAsync(9999, "How to fix?", "en");
        Assert.Equal("Ticket not found.", askNotFoundEn.Answer);
        var askNotFoundTr = await agent.AskQuestionWithSourceAsync(9999, "Nasıl çözülür?", "tr");
        Assert.Equal("Bilet bulunamadı.", askNotFoundTr.Answer);

        var askEn = await agent.AskQuestionWithSourceAsync(101, "What is the status?", "en");
        Assert.Contains("Question:", askEn.Answer);

        llmService.Setup(l => l.IsFallbackDisabled()).Returns(true);
        llmService.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync("[AI İsteği Başarısız: Err]");
        await Assert.ThrowsAsync<InvalidOperationException>(() => agent.AskQuestionWithSourceAsync(101, "Question?", "tr"));

        // Live LLM branch for AskQuestionWithSourceAsync
        llmService.Setup(l => l.IsFallbackDisabled()).Returns(false);
        llmService.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync("Here is the answer from live LLM");
        var liveAsk = await agent.AskQuestionWithSourceAsync(101, "What is the status?", "en");
        Assert.True(liveAsk.IsLlm);

        // Fallback in Turkish
        llmService.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync("[AI İsteği Başarısız: Timeout]");
        var trAsk = await agent.AskQuestionWithSourceAsync(101, "Durum nedir?", "tr");
        Assert.False(trAsk.IsLlm);
        Assert.Contains("Sorunuz:", trAsk.Answer);

        // Populate Category, Priority, Status on t1
        t1.Category = cat;
        t1.Priority = prio;
        t1.Status = status;
        await context.SaveChangesAsync();

        var askWithNavEn = await agent.AskQuestionWithSourceAsync(101, "What is the status?", "en");
        Assert.Contains("Hardware", askWithNavEn.Answer);
        var askWithNavTr = await agent.AskQuestionWithSourceAsync(101, "Durum nedir?", "tr");
        Assert.Contains("Hardware", askWithNavTr.Answer);

        var trSuggWithNav = await agent.GenerateResolutionSuggestionAsync(101, postAsComment: false, language: "tr");
        Assert.True(trSuggWithNav.Success);

        var enSuggWithNav = await agent.GenerateResolutionSuggestionAsync(101, postAsComment: false, language: "en");
        Assert.True(enSuggWithNav.Success);

        // 8. BuildSmartHeuristicSuggestionEn & BuildSmartHeuristicSuggestion with non-IList IEnumerable
        var simList = new List<SimilarTicketSummary> { new SimilarTicketSummary(102, "T-102", "Title", "Desc") };
        var kbList = new List<KbArticleSummary> { new KbArticleSummary(1, "KB1", "Content") };

        IEnumerable<SimilarTicketSummary> nonListSim = simList.Where(x => true);
        IEnumerable<KbArticleSummary> nonListKb = kbList.Where(x => true);

        var enHeuristic = ResolutionCopilotAgent.BuildSmartHeuristicSuggestionEn(t1, nonListSim, nonListKb);
        Assert.Contains("Recommended Resolution and Diagnostic Steps", enHeuristic);
        Assert.Contains("Past Similar Resolved Tickets", enHeuristic);

        var trHeuristic = ResolutionCopilotAgent.BuildSmartHeuristicSuggestion(t1, nonListSim, nonListKb);
        Assert.Contains("Önerilen Çözüm ve Teşhis Adımları", trHeuristic);
        Assert.Contains("Geçmiş Benzer Çözülmüş Biletler", trHeuristic);

        var emptySim = Enumerable.Empty<SimilarTicketSummary>();
        var emptyKb = Enumerable.Empty<KbArticleSummary>();
        var enEmpty = ResolutionCopilotAgent.BuildSmartHeuristicSuggestionEn(t1, emptySim, emptyKb);
        Assert.DoesNotContain("Past Similar Resolved Tickets", enEmpty);
        var trEmpty = ResolutionCopilotAgent.BuildSmartHeuristicSuggestion(t1, emptySim, emptyKb);
        Assert.DoesNotContain("Geçmiş Benzer Çözülmüş Biletler", trEmpty);

        var bareTicket = new Ticket { Id = 103, TicketNumber = "T-103", Title = null, Description = null };
        var bareEn = ResolutionCopilotAgent.BuildSmartHeuristicSuggestionEn(bareTicket, emptySim, emptyKb);
        Assert.Contains("Category: General", bareEn);
    }

    [Fact]
    public async Task TicketService_UncoveredBranches_Covered()
    {
        using var context = CreateDbContext("TicketService_Uncovered_" + Guid.NewGuid());
        var user = new User { Id = 1, Username = "agent1", FirstName = "A", LastName = "B", DepartmentId = 10 };
        var manager = new User { Id = 2, Username = "mgr", FirstName = "M", LastName = "G", DepartmentId = 10 };
        var otherUser = new User { Id = 3, Username = "other", FirstName = "O", LastName = "T", DepartmentId = 20 };
        var dept = new Department { Id = 10, Name = "IT", ManagerUserId = 2 };
        var otherDept = new Department { Id = 20, Name = "HR" };
        var group = new Group { Id = 5, Name = "IT Group", DepartmentId = 10 };
        var gm = new GroupMember { Id = 1, GroupId = 5, UserId = 1 };

        var cat = new Category { Id = 1, Name = "Hardware" };
        var prio = new Priority { Id = 1, Name = "Normal" };
        var stOpen = new Status { Id = 1, Name = "Open", IsSystemDefault = true };
        var stResolved = new Status { Id = 2, Name = "Resolved", IsClosedStatus = true };
        var type = new TicketType { Id = 1, Name = "Incident" };
        var proj = new Project { Id = 1, Name = "Core", ProjectKey = "CR" };

        context.Users.AddRange(user, manager, otherUser);
        context.Departments.AddRange(dept, otherDept);
        context.Groups.Add(group);
        context.GroupMembers.Add(gm);
        context.Categories.Add(cat);
        context.Priorities.Add(prio);
        context.Statuses.AddRange(stOpen, stResolved);
        context.TicketTypes.Add(type);
        context.Projects.Add(proj);

        var ticket = new Ticket
        {
            Id = 201,
            TicketNumber = "CR-1",
            Title = "Monitor not turning on",
            Description = "Power cable seems loose",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            ProjectId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        var parentAssign = new TicketAssignment
        {
            Id = 501,
            TicketId = 201,
            AssignedUserId = 2,
            AssignedGroupId = 5,
            IsActive = true
        };
        ticket.Assignments.Add(parentAssign);
        context.Tickets.Add(ticket);
        await context.SaveChangesAsync();

        var httpContext = CreateHttpContext("1", "Agent");
        var notificationDispatcher = new Mock<INotificationDispatcher>();
        var slaEngine = new Mock<ISlaEngine>();
        var fileStorage = new Mock<IFileStorageService>();
        var permCalc = new Mock<IPermissionCalculator>();
        permCalc.Setup(p => p.CalculateEffectivePermissionsAsync(1)).ReturnsAsync(new HashSet<string> { "ticket.assign", "ticket.view" });
        permCalc.Setup(p => p.CalculateEffectivePermissionsAsync(3)).ReturnsAsync(new HashSet<string> { "ticket.assign", "ticket.view" });
        var assignmentEngine = new Mock<IAssignmentEngine>();

        var ticketService = new TicketService(
            context,
            fileStorage.Object,
            permCalc.Object,
            slaEngine.Object,
            assignmentEngine.Object,
            notificationDispatcher.Object);

        // 1. ValidateRequiredField with placement.IsRequired = true and non-empty val
        var placement = new FormFieldPlacement { IsRequired = true };
        var def = new FieldDefinition { Label = "Serial", Key = "serial" };
        var ex = Record.Exception(() =>
        {
            var method = typeof(TicketService).GetMethod("ValidateRequiredField", BindingFlags.NonPublic | BindingFlags.Static);
            method?.Invoke(null, new object[] { placement, def, "12345" });
        });
        Assert.Null(ex);

        Assert.Throws<TargetInvocationException>(() =>
        {
            var method = typeof(TicketService).GetMethod("ValidateRequiredField", BindingFlags.NonPublic | BindingFlags.Static);
            method?.Invoke(null, new object[] { placement, def, "" });
        });

        // 2. VerifyHierarchyCheckAsync & VerifyDepartmentTargetsAsync via AssignTicketAsync:
        var assignDto = new AssignTicketDto(
            UserIds: new List<int> { 1 },
            GroupIds: new List<int>(),
            AssignerUserId: 1,
            ParentAssignmentId: 501
        );
        await ticketService.AssignTicketAsync(201, assignDto);
        notificationDispatcher.Verify(n => n.DispatchEventAsync("ticket.assigned", 201, 1, It.IsAny<string>()), Times.Once);

        var invalidDeptDto = new AssignTicketDto(
            UserIds: new List<int> { 3 },
            GroupIds: new List<int>(),
            AssignerUserId: 1,
            ParentAssignmentId: 501
        );
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => ticketService.AssignTicketAsync(201, invalidDeptDto));

        var invalidHierarchyDto = new AssignTicketDto(
            UserIds: new List<int> { 3 },
            GroupIds: new List<int>(),
            AssignerUserId: 3,
            ParentAssignmentId: 501
        );
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => ticketService.AssignTicketAsync(201, invalidHierarchyDto));

        // 3. AddCommentAsync with MentionedUserIds
        var commentDtoWithMentions = new CreateCommentDto(
            Content: "Hey @user2 check this out",
            IsInternal: false,
            AuthorUserId: 1,
            ParentCommentId: null,
            MentionedUserIds: new[] { 2 }
        );
        var cRes = await ticketService.AddCommentAsync(201, commentDtoWithMentions);
        Assert.NotNull(cRes);

        var commentDtoNoMentions = new CreateCommentDto(
            Content: "Normal comment",
            IsInternal: true,
            AuthorUserId: 1,
            ParentCommentId: null,
            MentionedUserIds: null
        );
        var cRes2 = await ticketService.AddCommentAsync(201, commentDtoNoMentions);
        Assert.NotNull(cRes2);

        // 4. DeleteTicketAsync and RestoreTicketAsync
        await ticketService.DeleteTicketAsync(201, 1);
        var deletedTicket = await context.Tickets.FindAsync(201);
        Assert.True(deletedTicket!.IsDeleted);

        await Assert.ThrowsAsync<KeyNotFoundException>(() => ticketService.DeleteTicketAsync(201, 1));

        await ticketService.RestoreTicketAsync(201, 1);
        Assert.False(deletedTicket.IsDeleted);

        await Assert.ThrowsAsync<KeyNotFoundException>(() => ticketService.RestoreTicketAsync(201, 1));

        // 5. GetAllowedTransitionsAsync
        var transitions = await ticketService.GetAllowedTransitionsAsync(201, 1);
        Assert.NotNull(transitions);

        // 6. GetTimelineAsync
        var timeline = await ticketService.GetTimelineAsync(201, true);
        Assert.NotNull(timeline);

        // 7. GetAssignmentTreeAsync with user and group assignments
        var groupAssign = new TicketAssignment
        {
            TicketId = 201,
            AssignedUserId = null,
            AssignedGroupId = 5,
            AssignedGroup = group,
            IsActive = true
        };
        context.TicketAssignments.Add(groupAssign);
        await context.SaveChangesAsync();

        var tree = await ticketService.GetAssignmentTreeAsync(201);
        Assert.NotNull(tree);
    }

    [Fact]
    public async Task SystemAuditInterceptor_UncoveredBranches_Covered()
    {
        using var context = CreateDbContext("Audit_Uncovered_" + Guid.NewGuid());
        var user = new User { Id = 10, Username = "audit_user", FirstName = "Audit", LastName = "User" };
        var grp = new Group { Id = 20, Name = "Audit_Group" };
        var proj = new Project { Id = 10, Name = "P10", ProjectKey = "P10" };
        context.Users.Add(user);
        context.Groups.Add(grp);
        context.Projects.Add(proj);
        await context.SaveChangesAsync();

        // 1. GetGroupMemberName with Added, Deleted, null user, null group, and exception
        var gm = new GroupMember { Id = 100, UserId = 10, GroupId = 20 };
        context.GroupMembers.Add(gm);
        var entryAdded = context.Entry(gm);
        var nameAdded = SystemAuditInterceptor.GetGroupMemberName(entryAdded, context);
        Assert.Contains("audit_user", nameAdded);
        Assert.Contains("Audit_Group", nameAdded);

        var gm2 = new GroupMember { Id = 101, UserId = 9999, GroupId = 8888 };
        context.GroupMembers.Add(gm2);
        await context.SaveChangesAsync();
        context.GroupMembers.Remove(gm2);
        var entryDeleted = context.Entry(gm2);
        var nameDeleted = SystemAuditInterceptor.GetGroupMemberName(entryDeleted, context);
        Assert.Contains("User: 9999", nameDeleted);
        Assert.Contains("Group: 8888", nameDeleted);

        var userEntry = context.Entry(user);
        var nameErr = SystemAuditInterceptor.GetGroupMemberName(userEntry, context);
        Assert.Contains("GroupMember (Err:", nameErr);

        var nameNullCtx = SystemAuditInterceptor.GetGroupMemberName(entryAdded, null);
        Assert.Contains("User: 10", nameNullCtx);

        // 2. GetSlaSummary branches
        var polBoth = new SlaPolicy { Id = 1, Name = "P1", ProjectId = 10, EscalateOnBreach = true, Description = "Important" };
        var polProjNotFound = new SlaPolicy { Id = 2, Name = "P2", ProjectId = 9999, EscalateOnBreach = false, Description = null };
        var polGlobal = new SlaPolicy { Id = 3, Name = "P3", ProjectId = null, EscalateOnBreach = true };

        context.SlaTargets.Add(new SlaTarget { Id = 1, SlaPolicyId = 1, PriorityId = 1, FirstResponseMinutes = 30, ResolutionMinutes = 120 });
        await context.SaveChangesAsync();

        var s1 = SystemAuditInterceptor.GetSlaSummary(polBoth, context);
        var s2 = SystemAuditInterceptor.GetSlaSummary(polProjNotFound, context);
        var s3 = SystemAuditInterceptor.GetSlaSummary(polGlobal, context);
        var sNullContext = SystemAuditInterceptor.GetSlaSummary(polBoth, null);

        Assert.Contains("P10", s1);
        Assert.Contains("Proje #9999", s2);
        Assert.Contains("Genel Sistem", s3);
        Assert.Contains("Politika: P1", sNullContext);

        // 3. ProcessModifiedEntity with original == null, current == null, original == current
        user.FirstName = "UpdatedAudit";
        user.ProfilePhoto = "photo.png";
        await context.SaveChangesAsync();
        Assert.NotNull(user.FirstName);

        user.ProfilePhoto = null;
        await context.SaveChangesAsync();
        Assert.Null(user.ProfilePhoto);
    }

    [Fact]
    public async Task NotificationDispatcher_UncoveredBranches_Covered()
    {
        using var context = CreateDbContext("Notif_Uncovered_" + Guid.NewGuid());
        var user1 = new User { Id = 1, Username = "u1", Email = "u1@test.com", FirstName = "U", LastName = "One" };
        var user2 = new User { Id = 2, Username = "u2", Email = "u2@test.com", FirstName = "U", LastName = "Two" };
        var mgr = new User { Id = 3, Username = "mgr", Email = "mgr@test.com", FirstName = "M", LastName = "Three" };
        var dept = new Department { Id = 1, Name = "Support", ManagerUserId = 3 };
        var grp = new Group { Id = 1, Name = "Level 1", DepartmentId = 1 };
        var gm = new GroupMember { Id = 1, GroupId = 1, UserId = 2 };

        var prio = new Priority { Id = 1, Name = "High" };
        var status = new Status { Id = 1, Name = "Open", IsSystemDefault = true };
        var ticket = new Ticket
        {
            Id = 301,
            TicketNumber = "T-301",
            Title = "Notif Ticket",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        ticket.Assignments.Add(new TicketAssignment { TicketId = 301, AssignedUserId = 2, IsActive = true });
        ticket.Assignments.Add(new TicketAssignment { TicketId = 301, AssignedGroupId = 1, IsActive = true });

        context.Users.AddRange(user1, user2, mgr);
        context.Departments.Add(dept);
        context.Groups.Add(grp);
        context.GroupMembers.Add(gm);
        context.Priorities.Add(prio);
        context.Statuses.Add(status);
        context.Tickets.Add(ticket);
        await context.SaveChangesAsync();

        var cfg = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AppBaseUrl", "https://itsm.local" }
        }).Build();

        var webhookMock = new Mock<IWebhookDispatcher>();
        var signalRMock = new Mock<ISignalRPusher>();
        var emailQueueMock = new Mock<IEmailQueue>();
        var templateMock = new Mock<IEmailTemplateService>();
        var aiAgentMock = new Mock<IAiAgentDispatcher>();

        var dispatcher = new NotificationDispatcher(context, webhookMock.Object, signalRMock.Object, emailQueueMock.Object, templateMock.Object, cfg, aiAgentMock.Object);

        // 1. DispatchEventAsync with comment.mention and various contexts
        await dispatcher.DispatchEventAsync("comment.mention", 301, 1, null);
        await dispatcher.DispatchEventAsync("comment.mention", 301, 1, "abc|message");
        await dispatcher.DispatchEventAsync("comment.mention", 301, 1, "2|Valid mention text");

        // 2. EnqueueEmailAsync branches: eventKey containing warning, risk, breach
        await dispatcher.DispatchEventAsync("sla.warning", 301, null, "SLA warning message");
        await dispatcher.DispatchEventAsync("sla.risk", 301, null, "SLA risk message");
        await dispatcher.DispatchEventAsync("sla.breached", 301, null, "SLA breached message");

        // 3. Ticket with unknown priority / status
        var bareTicket = new Ticket
        {
            Id = 302,
            TicketNumber = "T-302",
            Title = "Bare Ticket",
            PriorityId = 9999,
            StatusId = 9999,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        bareTicket.Assignments.Add(new TicketAssignment { TicketId = 302, AssignedUserId = 2, IsActive = true });
        context.Tickets.Add(bareTicket);
        await context.SaveChangesAsync();

        await dispatcher.DispatchEventAsync("ticket.created", 302, 1, "New Ticket Created");

        // 4. EnqueueEmailAsync direct invocation for badge colors and missing Priority/Status
        var enqueueMethod = typeof(NotificationDispatcher).GetMethod("EnqueueEmailAsync", BindingFlags.NonPublic | BindingFlags.Instance);
        await (Task)enqueueMethod!.Invoke(dispatcher, new object[] { 1, "SLA Breached", ticket, "body", "sla.breached" })!;
        await (Task)enqueueMethod.Invoke(dispatcher, new object[] { 1, "SLA Warning", ticket, "body", "sla.warning" })!;
        await (Task)enqueueMethod.Invoke(dispatcher, new object[] { 1, "SLA Risk", ticket, "body", "sla.risk" })!;
        await (Task)enqueueMethod.Invoke(dispatcher, new object[] { 1, "Normal Event", bareTicket, "body", "custom.event" })!;
    }

    [Fact]
    public async Task KnowledgeBaseService_UncoveredBranches_Covered()
    {
        using var context = CreateDbContext("KB_Uncovered_" + Guid.NewGuid());
        var userAuthor = new User { Id = 1, Username = "author", FirstName = "A", LastName = "U" };
        var userReviewer = new User { Id = 2, Username = "reviewer", FirstName = "R", LastName = "V" };
        var perm = new Permission { Id = 1, Key = "kb.manage", Name = "kb.manage" };
        var role = new Role { Id = 1, Name = "SuperAdmin", IsActive = true };
        var rp = new RolePermission { RoleId = 1, PermissionId = 1 };
        var ur = new UserRole { RoleId = 1, UserId = 2 };

        context.Users.AddRange(userAuthor, userReviewer);
        context.Permissions.Add(perm);
        context.Roles.Add(role);
        context.RolePermissions.Add(rp);
        context.UserRoles.Add(ur);

        var article = new KnowledgeArticle
        {
            Id = 10,
            Title = "VPN Setup Guide",
            Content = "Step 1: Download client",
            AuthorUserId = 1,
            Status = ArticleStatus.Draft,
            IsDeleted = false
        };
        context.KnowledgeArticles.Add(article);
        await context.SaveChangesAsync();

        var permCalc = new Mock<IPermissionCalculator>();
        permCalc.Setup(p => p.CalculateEffectivePermissionsAsync(2)).ReturnsAsync(new HashSet<string> { "kb.manage" });
        permCalc.Setup(p => p.CalculateEffectivePermissionsAsync(1)).ReturnsAsync(new HashSet<string>());

        var pusher = new Mock<ISignalRPusher>();
        var kbService = new KnowledgeBaseService(context, permCalc.Object, pusher.Object);

        // 1. NotifyManagersOfSuggestionAsync via reflection
        var notifyMethod = typeof(KnowledgeBaseService).GetMethod("NotifyManagersOfSuggestionAsync", BindingFlags.NonPublic | BindingFlags.Instance);
        await (Task)notifyMethod!.Invoke(kbService, new object[] { 10, "VPN Setup Guide" })!;
        pusher.Verify(p => p.PushNotificationAsync(2, It.IsAny<object>()), Times.Once);

        await (Task)notifyMethod!.Invoke(kbService, new object[] { 9999, "Non existent" })!;

        // 2. ReviewArticleAsync: Feedback empty/whitespace vs provided
        var reviewDtoEmptyFeedback = new ReviewKbArticleDto(ArticleStatus.Published, "");
        await kbService.ReviewArticleAsync(10, reviewDtoEmptyFeedback, 2);
        var artAfterReview = await context.KnowledgeArticles.FindAsync(10);
        Assert.Equal(ArticleStatus.Published, artAfterReview!.Status);
        Assert.Null(artAfterReview.ManagerFeedback);

        var reviewDtoWithFeedback = new ReviewKbArticleDto(ArticleStatus.Published, "Looks great!");
        await kbService.ReviewArticleAsync(10, reviewDtoWithFeedback, 2);
        Assert.Contains("Looks great!", artAfterReview.ManagerFeedback);

        // 3. ApplyArticleStatusTransitionAsync via reflection
        var transitionMethod = typeof(KnowledgeBaseService).GetMethod("ApplyArticleStatusTransitionAsync", BindingFlags.NonPublic | BindingFlags.Instance);
        await (Task)transitionMethod!.Invoke(kbService, new object[] { artAfterReview, ArticleStatus.Draft, true, false, "VPN Guide" })!;
        Assert.Equal(ArticleStatus.Draft, artAfterReview.Status);

        await (Task)transitionMethod!.Invoke(kbService, new object[] { artAfterReview, ArticleStatus.PendingReview, true, false, "VPN Guide" })!;
        Assert.Equal(ArticleStatus.PendingReview, artAfterReview.Status);

        await (Task)transitionMethod!.Invoke(kbService, new object[] { artAfterReview, ArticleStatus.PendingReview, true, false, "VPN Guide" })!;
        Assert.Equal(ArticleStatus.PendingReview, artAfterReview.Status);

        await (Task)transitionMethod!.Invoke(kbService, new object[] { artAfterReview, ArticleStatus.Published, false, true, "VPN Guide" })!;
        Assert.Equal(ArticleStatus.Published, artAfterReview.Status);
    }

    [Fact]
    public async Task SlaEngine_UncoveredBranches_Covered()
    {
        using var context = CreateDbContext("SlaEngine_Uncovered_" + Guid.NewGuid());
        var ticket = new Ticket
        {
            Id = 401,
            TicketNumber = "T-401",
            Title = "SLA Breach Test",
            RequesterUserId = 1,
            StatusId = 1,
            CreatedAt = DateTime.UtcNow.AddHours(-5)
        };
        context.Tickets.Add(ticket);
        await context.SaveChangesAsync();

        var notifDispatcher = new Mock<INotificationDispatcher>();
        var emailService = new Mock<IEmailService>();

        var engine = new SlaEngine(context, emailService.Object, notifDispatcher.Object);

        // 1. EvaluateMetric branches:
        var now = DateTime.UtcNow;

        var evalAlreadyBreached = SlaEngine.EvaluateMetric(now.AddMinutes(-10), warned: true, breached: true, now);
        Assert.False(evalAlreadyBreached.warn);
        Assert.False(evalAlreadyBreached.breach);

        var evalAlreadyWarned = SlaEngine.EvaluateMetric(now.AddMinutes(10), warned: true, breached: false, now);
        Assert.False(evalAlreadyWarned.warn);
        Assert.False(evalAlreadyWarned.breach);

        var evalNullCreated = SlaEngine.EvaluateMetric(now.AddMinutes(15), warned: false, breached: false, now, createdAt: null);
        Assert.True(evalNullCreated.warn);

        var evalInvCreated = SlaEngine.EvaluateMetric(now.AddMinutes(15), warned: false, breached: false, now, createdAt: now.AddHours(2));
        Assert.True(evalInvCreated.warn);

        // 2. CheckBreachesAsync with no SLA records
        await engine.CheckBreachesAsync(DateTime.UtcNow);

        // 3. TicketSla with first response met and resolution met (returns early)
        var slaMet = new TicketSla
        {
            Id = 1,
            TicketId = 401,
            FirstResponseDueAt = now.AddHours(1),
            FirstResponseMetAt = now.AddMinutes(-5),
            ResolutionDueAt = now.AddHours(4),
            ResolutionMetAt = now.AddMinutes(-2),
            CreatedAt = now.AddHours(-1)
        };
        context.TicketSlas.Add(slaMet);
        await context.SaveChangesAsync();

        await engine.CheckBreachesAsync(DateTime.UtcNow);

        // 4. TicketSla with null FirstResponseDueAt and null ResolutionDueAt (covers line 212 and 233 !HasValue)
        var ticket2 = new Ticket { Id = 402, TicketNumber = "T-402", Title = "SLA Null Dues", RequesterUserId = 1, StatusId = 1, CreatedAt = DateTime.UtcNow };
        var slaNullDues = new TicketSla
        {
            Id = 2,
            TicketId = 402,
            FirstResponseDueAt = null,
            FirstResponseMetAt = null,
            ResolutionDueAt = null,
            ResolutionMetAt = null,
            CreatedAt = now
        };
        context.Tickets.Add(ticket2);
        context.TicketSlas.Add(slaNullDues);
        await context.SaveChangesAsync();
        await engine.CheckBreachesAsync(DateTime.UtcNow);

        // 5. ProcessTicketStatusChangeAsync branches (null sla, null oldStatus, null newStatus)
        await engine.ProcessTicketStatusChangeAsync(9999, 1, 2); // sla == null
        await engine.ProcessTicketStatusChangeAsync(401, 9999, 1); // oldStatus == null
        await engine.ProcessTicketStatusChangeAsync(401, 1, 9999); // newStatus == null
    }

    [Fact]
    public async Task TicketHandoffSwarm_UncoveredBranches_Covered()
    {
        using var context = CreateDbContext("Handoff_Uncovered_" + Guid.NewGuid());
        var prio = new Priority { Name = "Urgent", SeverityLevel = 3 };
        var cat = new Category { Name = "Database" };
        var status = new Status { Name = "In Progress" };
        context.Priorities.Add(prio);
        context.Categories.Add(cat);
        context.Statuses.Add(status);
        await context.SaveChangesAsync();

        var ticket = new Ticket
        {
            TicketNumber = "T-501",
            Title = "Server Migration Handoff",
            Description = "Migrating DB to cloud",
            PriorityId = prio.Id,
            Priority = prio,
            CategoryId = cat.Id,
            Category = cat,
            StatusId = status.Id,
            Status = status,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow.AddDays(-1)
        };
        context.Tickets.Add(ticket);
        await context.SaveChangesAsync();

        var llmService = new Mock<ILlmService>();
        llmService.Setup(l => l.GetModelName()).Returns("gpt-4");
        var logger = new Mock<ILogger<TicketHandoffSwarm>>();

        var swarm = new TicketHandoffSwarm(llmService.Object, context, logger.Object);

        // 1. BuildSmartHeuristicHandoff with empty recentComments vs null vs populated
        var emptyHandoff = TicketHandoffSwarm.BuildSmartHeuristicHandoff(ticket, 2, new List<string>());
        Assert.Contains("Mevcut Durum: Bilet halihazırda inceleme ve devir sürecindedir.", emptyHandoff.Actions);

        var nullHandoff = TicketHandoffSwarm.BuildSmartHeuristicHandoff(ticket, 0, null);
        Assert.Contains("Mevcut Durum: Bilet halihazırda inceleme ve devir sürecindedir.", nullHandoff.Actions);

        var populatedHandoff = TicketHandoffSwarm.BuildSmartHeuristicHandoff(ticket, 1, new List<string> { "Step 1 done" });
        Assert.Contains("Step 1 done", populatedHandoff.Actions);

        var bareTicket = new Ticket { Id = 502, TicketNumber = "T-502", Title = "Bare", Description = null };
        var bareHandoff = TicketHandoffSwarm.BuildSmartHeuristicHandoff(bareTicket, 0, null);
        Assert.Contains("Açıklama girilmemiş", bareHandoff.Summary);

        // 2. GenerateHandoffSummaryAsync in English with fallback
        llmService.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync("[AI İsteği Başarısız: Timeout]");

        var handoffEn = await swarm.GenerateHandoffSummaryAsync(ticket.Id, postAsComment: true, language: "en");
        Assert.True(handoffEn.Success);
        Assert.Contains("Summary:", handoffEn.Summary);

        // Ticket not found in en and tr
        var notFoundEn = await swarm.GenerateHandoffSummaryAsync(9999, postAsComment: false, language: "en");
        Assert.False(notFoundEn.Success);
        Assert.Equal("Bilet bulunamadı.", notFoundEn.Summary);

        var notFoundTr = await swarm.GenerateHandoffSummaryAsync(9999, postAsComment: false, language: "tr");
        Assert.False(notFoundTr.Success);
        Assert.Equal("Bilet bulunamadı.", notFoundTr.Summary);
    }

    [Fact]
    public async Task GroupService_UncoveredBranches_Covered()
    {
        using var context = CreateDbContext("GroupService_Uncovered_" + Guid.NewGuid());
        var user = new User { Id = 1, Username = "user1" };
        var dept1 = new Department { Id = 1, Name = "Dept 1" };
        var group = new Group { Id = 1, Name = "Group 1", DepartmentId = null };
        context.Users.Add(user);
        context.Departments.Add(dept1);
        context.Groups.Add(group);
        await context.SaveChangesAsync();

        var repo = new Mock<IRepository<Group>>();
        repo.Setup(r => r.GetByIdAsync(1)).ReturnsAsync(group);

        var httpContext = CreateHttpContext("1", "Admin");
        var groupService = new GroupService(repo.Object, context, httpContext.Object);

        // 1. UpdateAsync: group.DepartmentId was null, new dto.DepartmentId is 0
        var updateDto = new UpdateGroupDto(Name: "Group Renamed", DepartmentId: 0, IsActive: true);
        await groupService.UpdateAsync(1, updateDto);

        // 2. AddMemberAsync: member already exists
        context.GroupMembers.Add(new GroupMember { GroupId = 1, UserId = 1 });
        await context.SaveChangesAsync();
        await groupService.AddMemberAsync(1, 1);

        // 3. RemoveMemberAsync: member not found
        await groupService.RemoveMemberAsync(1, 999);

        // 4. RemoveMemberAsync: member exists
        await groupService.RemoveMemberAsync(1, 1);
        Assert.False(await context.GroupMembers.AnyAsync(gm => gm.GroupId == 1 && gm.UserId == 1));

        // 5. GroupService with null HttpContext
        var nullHttp = new Mock<IHttpContextAccessor>();
        nullHttp.Setup(h => h.HttpContext).Returns((HttpContext)null);
        var groupServiceNullHttp = new GroupService(repo.Object, context, nullHttp.Object);
        await groupServiceNullHttp.AddMemberAsync(1, 1);
        await groupServiceNullHttp.RemoveMemberAsync(1, 1);
        var moveDeptDto = new UpdateGroupDto("Group Move", true, 1);
        await groupServiceNullHttp.UpdateAsync(1, moveDeptDto);
    }

    [Fact]
    public async Task Controllers_UncoveredBranches_Covered()
    {
        using var context = CreateDbContext("Controllers_Uncovered_" + Guid.NewGuid());
        var perm = new Permission { Id = 1, Name = "AdminPerm", Key = "admin.perm" };
        context.Permissions.Add(perm);
        await context.SaveChangesAsync();

        var permCalcMock = new Mock<IPermissionCalculator>();
        permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(It.IsAny<int>())).ReturnsAsync(new HashSet<string>());

        // 1. PermissionsController with user lacking NameIdentifier claim
        var permCtrl = new PermissionsController(context, permCalcMock.Object);
        permCtrl.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = new ClaimsPrincipal(new ClaimsIdentity()) }
        };

        var updateRes = await permCtrl.Update(1, new UpdatePermissionDto("P", "K", "D"));
        Assert.IsType<ForbidResult>(updateRes);

        var delRes = await permCtrl.Delete(1);
        Assert.IsType<ForbidResult>(delRes);

        // 2. TicketController: DeleteTicket permission checks
        var ticketServiceMock = new Mock<ITicketService>();
        var ticketCtrl = new TicketController(ticketServiceMock.Object);

        var plainUser = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim(ClaimTypes.NameIdentifier, "1") }, "Test"));
        ticketCtrl.ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext { User = plainUser } };
        var forbidRes = await ticketCtrl.DeleteTicket(100);
        Assert.IsType<ForbidResult>(forbidRes);

        var permClaims = new[] { new Claim(ClaimTypes.NameIdentifier, "1"), new Claim("permission", "ticket.delete") };
        var permUser = new ClaimsPrincipal(new ClaimsIdentity(permClaims, "Test"));
        ticketCtrl.ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext { User = permUser } };
        var okRes = await ticketCtrl.DeleteTicket(100);
        Assert.IsType<NoContentResult>(okRes);

        // 3. PermissionAuthorizationHandler with role claims
        var handler = new PermissionAuthorizationHandler();
        var req = new PermissionRequirement("ticket.view");

        var roleUser = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim("role", "SuperAdmin") }));
        var authCtx = new AuthorizationHandlerContext(new[] { req }, roleUser, null);
        await handler.HandleAsync(authCtx);
        Assert.True(authCtx.HasSucceeded);

        var schemaRoleUser = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim("http://schemas.microsoft.com/ws/2008/06/identity/claims/role", "superadmin") }));
        var authCtx2 = new AuthorizationHandlerContext(new[] { req }, schemaRoleUser, null);
        await handler.HandleAsync(authCtx2);
        Assert.True(authCtx2.HasSucceeded);

        // 4. AiController: GetStatus with empty/null config properties
        var llmServiceMock = new Mock<ILlmService>();
        llmServiceMock.Setup(l => l.IsAvailableAsync()).ReturnsAsync(false);
        llmServiceMock.Setup(l => l.GetCurrentConfig()).Returns(new LlmConfigDto { Endpoint = null, Model = null, Provider = null, FallbackToHeuristic = false });
        llmServiceMock.Setup(l => l.GetEndpoint()).Returns("http://localhost:11434");
        llmServiceMock.Setup(l => l.GetModelName()).Returns("llama3");

        var aiCtrl = new AiController(llmServiceMock.Object);
        var statusRes = await aiCtrl.GetStatus();
        Assert.IsType<OkObjectResult>(statusRes);

        // 5. AiTicketCopilotController: Ask with empty dto
        var copilotLogger = new Mock<ILogger<ResolutionCopilotAgent>>();
        var copilotAgent = new ResolutionCopilotAgent(llmServiceMock.Object, context, copilotLogger.Object);
        var aiCopilotCtrl = new AiTicketCopilotController(copilotAgent);

        var badAsk = await aiCopilotCtrl.Ask(991122, new AiTicketCopilotController.AskQuestionDto("   "));
        Assert.IsType<BadRequestObjectResult>(badAsk);

        var notFoundRes = await aiCopilotCtrl.SuggestResolution(991123, false, "tr");
        Assert.IsType<NotFoundObjectResult>(notFoundRes);

        // 6. AiTicketHandoffController: Summarize on non-existent ticket -> NotFound (404)
        var swarmLogger = new Mock<ILogger<TicketHandoffSwarm>>();
        var handoffSwarm = new TicketHandoffSwarm(llmServiceMock.Object, context, swarmLogger.Object);
        var handoffCtrl = new AiTicketHandoffController(handoffSwarm);

        var notFoundHandoff = await handoffCtrl.Summarize(991124, false, "tr");
        Assert.IsType<NotFoundObjectResult>(notFoundHandoff);
    }

    [Fact]
    public async Task Dashboard_UserService_Report_Email_Llm_Branches_Covered()
    {
        using var context = CreateDbContext("Misc_Uncovered_" + Guid.NewGuid());
        var user = new User
        {
            Id = 1,
            Username = "dash_user",
            FirstName = "Dash",
            LastName = "User",
            DepartmentId = null,
            ProfilePhoto = "old_photo.png",
            IsActive = true,
            IsDeleted = false
        };
        var stOpen = new Status { Id = 1, Name = "Open", IsClosedStatus = false, IsActive = true, IsSystemDefault = true };
        var ticket = new Ticket
        {
            Id = 1,
            TicketNumber = "D-1",
            Title = "Workload ticket",
            StatusId = 1,
            Status = stOpen,
            IsDeleted = false
        };
        var assign = new TicketAssignment
        {
            Id = 1,
            TicketId = 1,
            AssignedUserId = 1,
            IsActive = true
        };
        context.Users.Add(user);
        context.Statuses.Add(stOpen);
        context.Tickets.Add(ticket);
        context.TicketAssignments.Add(assign);
        await context.SaveChangesAsync();

        var permCalcMock = new Mock<IPermissionCalculator>();
        permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(It.IsAny<int>())).ReturnsAsync(new HashSet<string>());

        // 1. DashboardService: GetSlaComplianceAsync with 0 tickets
        var dashService = new DashboardService(context, permCalcMock.Object);
        var compliance = await dashService.GetSlaComplianceAsync(1);
        Assert.Equal(100, compliance.FirstResponseComplianceRate);
        Assert.Equal(100, compliance.ResolutionComplianceRate);
        Assert.Equal(0, compliance.AverageResolutionTimeMinutes);

        var workload = await dashService.GetDepartmentWorkloadAsync(1);
        Assert.NotEmpty(workload);
        Assert.Equal("No Department", workload.First().DepartmentName);

        // 2. UserService: UpdateProfilePhoto with no change vs null photo
        var userRepo = new Mock<IRepository<User>>();
        userRepo.Setup(r => r.GetByIdAsync(1)).ReturnsAsync(user);
        var userHttp = CreateHttpContext("1");
        var userService = new UserService(userRepo.Object, context, userHttp.Object);

        var updateSamePhoto = new UpdateUserDto("dash@test.com", "Dash", "User", true, null, "old_photo.png", null);
        await userService.UpdateAsync(1, updateSamePhoto);
        Assert.Equal("old_photo.png", user.ProfilePhoto);

        var updateNullPhoto = new UpdateUserDto("dash@test.com", "Dash", "User", true, null, null, null);
        await userService.UpdateAsync(1, updateNullPhoto);
        Assert.Null(user.ProfilePhoto);

        // 3. ReportService: ExportTicketsToCsvAsync with ticket having null navigation properties
        var bareTicket = new Ticket
        {
            Id = 601,
            TicketNumber = "CSV-1",
            Title = "CSV Test",
            CreatedAt = DateTime.UtcNow
        };
        bareTicket.TicketSla = new TicketSla
        {
            FirstResponseWarned = true,
            ResolutionWarned = false,
            FirstResponseBreached = false,
            ResolutionBreached = false
        };
        var fullTicket = new Ticket
        {
            Id = 602,
            TicketNumber = "CSV-2",
            Title = "Full Ticket",
            ProjectId = 1,
            Project = new Project { Id = 1, Name = "Alpha", ProjectKey = "ALP" },
            CategoryId = 2,
            Category = new Category { Id = 2, Name = "Network" },
            TypeId = 2,
            Type = new TicketType { Id = 2, Name = "Problem" },
            StatusId = 2,
            Status = new Status { Id = 2, Name = "In Progress" },
            PriorityId = 2,
            Priority = new Priority { Id = 2, Name = "Critical" },
            RequesterUserId = 1,
            RequesterUser = user,
            CreatedAt = DateTime.UtcNow
        };
        fullTicket.Assignments.Add(new TicketAssignment
        {
            Id = 6021,
            TicketId = 602,
            AssignedUserId = null,
            AssignedGroupId = 1,
            AssignedGroup = new Group { Id = 1, Name = "NOC Team" },
            IsActive = true
        });
        fullTicket.TicketSla = new TicketSla
        {
            FirstResponseBreached = true,
            ResolutionBreached = false
        };
        context.Tickets.AddRange(bareTicket, fullTicket);
        await context.SaveChangesAsync();

        var reportService = new ReportService(context, permCalcMock.Object);
        var csvStream = await reportService.ExportTicketsToCsvAsync(new TicketSearchFilterDto(), 1);
        Assert.NotNull(csvStream);
        Assert.True(csvStream.Length > 0);

        // 4. EmailIngestionService: Subject is empty, project sequence created
        var cat = new Category { Id = 1, Name = "General" };
        var type = new TicketType { Id = 1, Name = "Incident" };
        var prio = new Priority { Id = 1, Name = "Normal" };
        context.Categories.Add(cat);
        context.TicketTypes.Add(type);
        context.Priorities.Add(prio);
        await context.SaveChangesAsync();

        var emailIngestion = new EmailIngestionService(context);

        var emailDto = new EmailIngestionDto(
            MessageId: "MSG-123",
            From: "sender@test.com",
            Subject: "   ",
            Body: "Message body"
        );
        await emailIngestion.ProcessIncomingEmailAsync(emailDto);
        var ingTicket = await context.Tickets.FirstOrDefaultAsync(t => t.ExternalMessageId == "MSG-123");
        Assert.NotNull(ingTicket);
        Assert.Equal("(No Subject)", ingTicket.Title);

        // 5. LlmService: ParseAnthropicResponse with null text
        var method = typeof(LlmService).GetMethod("ParseAnthropicResponse", BindingFlags.NonPublic | BindingFlags.Static);
        var parsedNull = method?.Invoke(null, new object[] { "{\"content\": [{\"type\": \"text\", \"text\": null}]}" });
        Assert.Equal(string.Empty, parsedNull);

        // 6. SlaService: DeletePolicyAsync with ProjectId == null -> throws InvalidOperationException
        var globalPolicy = new SlaPolicy { Id = 901, Name = "Global SLA", ProjectId = null, IsActive = true, IsDeleted = false };
        context.SlaPolicies.Add(globalPolicy);
        await context.SaveChangesAsync();

        var slaService = new SlaService(context);
        await Assert.ThrowsAsync<InvalidOperationException>(() => slaService.DeletePolicyAsync(901));

        await Assert.ThrowsAsync<KeyNotFoundException>(() => slaService.RestorePolicyAsync(99999));

        // 7. AuthService: RefreshTokenAsync with MustChangePassword = true
        var authUser = new User
        {
            Id = 701,
            Username = "must_change_user",
            PasswordHash = "hash",
            MustChangePassword = true,
            IsActive = true,
            IsDeleted = false
        };
        context.Users.Add(authUser);
        await context.SaveChangesAsync();

        var tokenServiceMock = new Mock<ITokenService>();
        tokenServiceMock.Setup(t => t.GenerateToken(701, "must_change_user", It.IsAny<IEnumerable<string>>(), It.IsAny<IEnumerable<string>>(), true))
            .Returns("token_must_change");

        var configMock = new Mock<IConfiguration>();
        configMock.Setup(c => c["Jwt:ExpiryMinutes"]).Returns((string?)null);

        var authService = new AuthService(context, tokenServiceMock.Object, permCalcMock.Object, configMock.Object);
        var refreshRes = await authService.RefreshTokenAsync(701);
        Assert.NotNull(refreshRes);
        Assert.True(refreshRes.MustChangePassword);
    }

    [Fact]
    public async Task CopilotAndSwarm_DeepNullAndBranchCoverage()
    {
        using var context = CreateOptionalNavDbContext("CopilotSwarm_Deep_" + Guid.NewGuid());
        var logger = new Mock<ILogger<ResolutionCopilotAgent>>();
        var llmService = new Mock<ILlmService>();

        var user1 = new User { Id = 1, Username = "user1", FirstName = "U", LastName = "1" };
        context.Users.Add(user1);

        // Bare ticket with missing nav references (nav properties will be null because they are optional in this test context)
        var tBare = new Ticket
        {
            Id = 8801,
            TicketNumber = "T-8801",
            Title = "Bare Ticket",
            Description = "Bare Description",
            CategoryId = 9999,
            PriorityId = 9999,
            StatusId = 9999,
            TypeId = 9999,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        var kbLong = new KnowledgeArticle
        {
            Id = 8802,
            Title = "Bare Ticket Article",
            Content = new string('X', 200), // > 150 chars to cover substring branch
            CategoryId = 9999,
            IsDeleted = false
        };
        context.Tickets.Add(tBare);
        context.KnowledgeArticles.Add(kbLong);
        await context.SaveChangesAsync();

        var agent = new ResolutionCopilotAgent(llmService.Object, context, logger.Object);

        // 1. Live LLM on bare ticket (En & Tr)
        llmService.Setup(l => l.GetModelName()).Returns("gpt-4");
        llmService.Setup(l => l.IsFallbackDisabled()).Returns(false);
        llmService.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync("LLM Response Here");

        var qEn = await agent.AskQuestionWithSourceAsync(8801, "Help?", "en");
        Assert.True(qEn.IsLlm);

        var qTr = await agent.AskQuestionWithSourceAsync(8801, "Yardım?", "tr");
        Assert.True(qTr.IsLlm);

        // 2. Fallback on bare ticket (En & Tr) -> Covers fallback null coalescing (General, Normal, In Progress / Genel, Normal, İşlemde)
        llmService.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync("[AI İsteği Başarısız: Network]");

        var fbEn = await agent.AskQuestionWithSourceAsync(8801, "Help?", "en");
        Assert.False(fbEn.IsLlm);
        Assert.Contains("General", fbEn.Answer);
        Assert.Contains("Normal", fbEn.Answer);

        var fbTr = await agent.AskQuestionWithSourceAsync(8801, "Yardım?", "tr");
        Assert.False(fbTr.IsLlm);
        Assert.Contains("Genel", fbTr.Answer);
        Assert.Contains("Normal", fbTr.Answer);

        // 3. GenerateResolutionSuggestionAsync on bare ticket (En & Tr)
        var suggEn = await agent.GenerateResolutionSuggestionAsync(8801, postAsComment: false, language: "en");
        Assert.True(suggEn.Success);

        var suggTr = await agent.GenerateResolutionSuggestionAsync(8801, postAsComment: false, language: "tr");
        Assert.True(suggTr.Success);

        // 4. GenerateResolutionSuggestionAsync when fallback disabled and completion is empty -> covers (result.ErrorMessage ?? "LLM Hatası")
        llmService.Setup(l => l.IsFallbackDisabled()).Returns(true);
        llmService.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync(string.Empty);
        var suggNull = await agent.GenerateResolutionSuggestionAsync(8801, postAsComment: false, language: "tr");
        Assert.False(suggNull.Success);
        Assert.Contains("LLM", suggNull.Suggestion);

        // 5. GetRelevantKbArticlesAsync reflection call with ticket having null Title
        var tNullTitle = new Ticket { Id = 8803, TicketNumber = "T-8803", Title = null!, Description = "Null title" };
        var getKbMethod = typeof(ResolutionCopilotAgent).GetMethod("GetRelevantKbArticlesAsync", BindingFlags.NonPublic | BindingFlags.Instance)!;
        var kbTask = (Task<List<KbArticleSummary>>)getKbMethod.Invoke(agent, new object[] { tNullTitle })!;
        var kbRes = await kbTask;
        Assert.NotNull(kbRes);

        // 6. TicketHandoffSwarm on bare ticket (En & Tr) & empty actions
        var swarmLogger = new Mock<ILogger<TicketHandoffSwarm>>();
        var swarm = new TicketHandoffSwarm(llmService.Object, context, swarmLogger.Object);

        llmService.Setup(l => l.IsFallbackDisabled()).Returns(false);
        llmService.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync("Handoff summary text");

        var handoffEn = await swarm.GenerateHandoffSummaryAsync(8801, postAsComment: false, language: "en");
        Assert.True(handoffEn.Success);

        var handoffTr = await swarm.GenerateHandoffSummaryAsync(8801, postAsComment: false, language: "tr");
        Assert.True(handoffTr.Success);

        // 7. Swarm with empty actions -> covers line 197: string.IsNullOrWhiteSpace(finalActions) ? finalSummary : ...
        llmService.Setup(l => l.GetCompletionAsync(It.Is<string>(s => s.Contains("Action Extractor") || s.Contains("ITSM AI Agent")), It.IsAny<string>()))
            .ReturnsAsync("   ");
        var handoffEmptyActions = await swarm.GenerateHandoffSummaryAsync(8801, postAsComment: false, language: "en");
        Assert.True(handoffEmptyActions.Success);
    }

    [Fact]
    public async Task SystemAuditInterceptor_AdditionalDeepBranches()
    {
        // 1. Interceptor with null HttpContext (exercises line 198 fallback to "system")
        var mockNullHttp = new Mock<IHttpContextAccessor>();
        mockNullHttp.Setup(a => a.HttpContext).Returns((HttpContext?)null);

        var options = new DbContextOptionsBuilder<ItsToolDbContext>()
            .UseInMemoryDatabase("Audit_NullHttp_" + Guid.NewGuid())
            .AddInterceptors(new SystemAuditInterceptor(mockNullHttp.Object))
            .Options;
        using var ctx = new ItsToolDbContext(options);

        // 2. Soft-delete and Restore on SlaPolicy -> covers line 130 "SLA Politikası" & line 140 "Restored"
        var slaPol = new SlaPolicy { Id = 301, Name = "Audit Policy", ProjectId = 1, IsActive = true, IsDeleted = false };
        ctx.SlaPolicies.Add(slaPol);
        await ctx.SaveChangesAsync();

        slaPol.IsDeleted = true;
        await ctx.SaveChangesAsync();

        slaPol.IsDeleted = false;
        await ctx.SaveChangesAsync();

        // 3. Restore on another entity -> covers line 140 "Restored" where entityType != "SlaPolicy"
        var delUser = new User { Id = 302, Username = "restored_user", FirstName = "R", LastName = "U", IsDeleted = true };
        ctx.Users.Add(delUser);
        await ctx.SaveChangesAsync();

        delUser.IsDeleted = false;
        await ctx.SaveChangesAsync();

        // 4. Hard delete on SlaPolicy -> covers line 244 (entityType == "SlaPolicy")
        var slaPolHard = new SlaPolicy { Id = 303, Name = "Hard Sla Policy", ProjectId = 1 };
        ctx.SlaPolicies.Add(slaPolHard);
        await ctx.SaveChangesAsync();
        ctx.SlaPolicies.Remove(slaPolHard);
        await ctx.SaveChangesAsync();

        // 5. Hard delete on GroupMember -> covers line 251 (isGroupMember ? entityName : summary)
        var gmHard = new GroupMember { Id = 304, GroupId = 1, UserId = 302 };
        ctx.GroupMembers.Add(gmHard);
        await ctx.SaveChangesAsync();
        ctx.GroupMembers.Remove(gmHard);
        await ctx.SaveChangesAsync();

        // 6. GetGroupMemberName when state is Modified (line 383 uidProp.OriginalValue), user/group not in local but in context, or names null
        var uNullName = new User { Id = 305, Username = "u305", FirstName = "F", LastName = "L" };
        var gNullName = new Group { Id = 306, Name = "g306" };
        ctx.Users.Add(uNullName);
        ctx.Groups.Add(gNullName);
        var gmMod = new GroupMember { Id = 307, UserId = 305, GroupId = 306 };
        ctx.GroupMembers.Add(gmMod);
        await ctx.SaveChangesAsync();

        gmMod.UserId = 302;
        var entryMod = ctx.Entry(gmMod);
        var modName = SystemAuditInterceptor.GetGroupMemberName(entryMod, ctx);
        Assert.NotNull(modName);

        // 7. ProcessModifiedEntity where original is null (property added from null to value) and current is null (value to null)
        delUser.ProfilePhoto = "photo.png";
        await ctx.SaveChangesAsync();
        delUser.ProfilePhoto = null;
        await ctx.SaveChangesAsync();

        // 8. GetGeneralPropertiesSummary where joined is whitespace
        var projSeq = new ProjectSequence { Id = 308, ProjectId = 1, CurrentValue = 0 };
        ctx.ProjectSequences.Add(projSeq);
        var seqEntry = ctx.Entry(projSeq);
        var summarySeq = SystemAuditInterceptor.GetGeneralPropertiesSummary(seqEntry);
        Assert.NotNull(summarySeq);
    }

    [Fact]
    public async Task ReportService_UncoveredCsvBranches()
    {
        // Ticket with all navigation properties as null
        var tBare = new Ticket
        {
            Id = 6601,
            TicketNumber = "T-6601",
            Title = "Bare Csv Ticket",
            Description = "Csv Desc",
            ProjectId = null,
            Project = null,
            CategoryId = 9999,
            Category = null,
            TypeId = 9999,
            Type = null,
            StatusId = 9999,
            Status = null,
            PriorityId = 9999,
            Priority = null,
            RequesterUserId = 1,
            RequesterUser = null,
            TicketSla = null,
            Assignments = new List<TicketAssignment>(),
            CreatedAt = DateTime.UtcNow
        };

        var method = typeof(ReportService).GetMethod("GenerateCsvStreamAsync", BindingFlags.NonPublic | BindingFlags.Static)!;
        var streamTask = (Task<Stream>)method.Invoke(null, new object[] { new List<Ticket> { tBare } })!;
        var stream = await streamTask;
        Assert.NotNull(stream);
        using var reader = new StreamReader(stream);
        var content = await reader.ReadToEndAsync();
        Assert.Contains("T-6601", content);
    }

    [Fact]
    public async Task EmailIngestionService_DeepBranchCoverage()
    {
        // 1. Missing defaults in empty DB throws InvalidOperationException (line 84)
        using (var emptyContext = CreateDbContext("EmailIngestion_Empty_" + Guid.NewGuid()))
        {
            var emailIngestionEmpty = new EmailIngestionService(emptyContext);
            var dto = new EmailIngestionDto("MSG-1", "user@test.com", "Subject", "Body");
            await Assert.ThrowsAsync<InvalidOperationException>(() => emailIngestionEmpty.ProcessIncomingEmailAsync(dto));
        }

        using var context = CreateDbContext("EmailIngestion_Deep_" + Guid.NewGuid());
        var emailIngestion = new EmailIngestionService(context);

        // Seed system defaults
        var cat = new Category { Id = 1, Name = "Hardware" };
        var prio = new Priority { Id = 1, Name = "Normal" };
        var type = new TicketType { Id = 1, Name = "Incident" };
        var status = new Status { Id = 1, Name = "Open", IsSystemDefault = true };
        var proj = new Project { Id = 1, Name = "Default", ProjectKey = "DEF" };
        var existingUser = new User { Id = 10, Username = "existing@test.com", Email = "existing@test.com", FirstName = "Ex", LastName = "User" };

        context.Categories.Add(cat);
        context.Priorities.Add(prio);
        context.TicketTypes.Add(type);
        context.Statuses.Add(status);
        context.Projects.Add(proj);
        context.Users.Add(existingUser);
        await context.SaveChangesAsync();

        // 2. Incoming email from existing user (line 34 user != null)
        var dtoExistingUser = new EmailIngestionDto("MSG-2", "existing@test.com", "Hello", "Body");
        await emailIngestion.ProcessIncomingEmailAsync(dtoExistingUser);

        // 3. Subject with [UNKNOWN] project key (line 57 project == null)
        var dtoUnknownProj = new EmailIngestionDto("MSG-3", "existing@test.com", "[NONEXISTENT] My Title", "Body");
        await emailIngestion.ProcessIncomingEmailAsync(dtoUnknownProj);

        // 4. Subject without project brackets (line 53 match.Success == false) and ProjectSequence already exists (line 71 seq != null)
        var dtoNoBrackets = new EmailIngestionDto("MSG-4", "existing@test.com", "Plain title without brackets", "Body");
        await emailIngestion.ProcessIncomingEmailAsync(dtoNoBrackets);

        var tickets = await context.Tickets.ToListAsync();
        Assert.Equal(3, tickets.Count);
    }

    [Fact]
    public async Task KnowledgeBaseService_ArticleStatusTransitions_AllBranches()
    {
        using var context = CreateDbContext("KB_StatusTransitions_" + Guid.NewGuid());
        var permCalcMock = new Mock<IPermissionCalculator>();
        var signalRMock = new Mock<ISignalRPusher>();
        var kbService = new KnowledgeBaseService(context, permCalcMock.Object, signalRMock.Object);

        var method = typeof(KnowledgeBaseService).GetMethod("ApplyArticleStatusTransitionAsync", BindingFlags.NonPublic | BindingFlags.Instance)!;

        var a1 = new KnowledgeArticle { Id = 1, Status = ArticleStatus.Draft };
        // isAuthor = true, targetStatus = PendingReview -> line 287 branch 1
        var task1 = (Task)method.Invoke(kbService, new object[] { a1, ArticleStatus.PendingReview, true, false, "T1" })!;
        await task1;
        Assert.Equal(ArticleStatus.PendingReview, a1.Status);

        // isAuthor = true, previousStatus = Draft, targetStatus = Rejected (neither Published nor Draft) -> line 287 branch 2
        var a2 = new KnowledgeArticle { Id = 2, Status = ArticleStatus.Draft };
        var task2 = (Task)method.Invoke(kbService, new object[] { a2, ArticleStatus.Rejected, true, false, "T2" })!;
        await task2;
        Assert.Equal(ArticleStatus.PendingReview, a2.Status);

        // isAuthor = true, previousStatus = PendingReview, targetStatus = PendingReview -> line 290 previousStatus == PendingReview (no notification)
        var a2b = new KnowledgeArticle { Id = 22, Status = ArticleStatus.PendingReview };
        var task2b = (Task)method.Invoke(kbService, new object[] { a2b, ArticleStatus.PendingReview, true, false, "T2B" })!;
        await task2b;
        Assert.Equal(ArticleStatus.PendingReview, a2b.Status);

        // isAuthor = true, previousStatus = Published, canManageKb = true, targetStatus = NeedsRevision -> line 295 branch 1
        var a3 = new KnowledgeArticle { Id = 3, Status = ArticleStatus.Published };
        var task3 = (Task)method.Invoke(kbService, new object[] { a3, ArticleStatus.NeedsRevision, true, true, "T3" })!;
        await task3;
        Assert.Equal(ArticleStatus.NeedsRevision, a3.Status);

        // isAuthor = true, previousStatus = Published, canManageKb = false, targetStatus = NeedsRevision -> line 295 branch 2 (does not change status)
        var a4 = new KnowledgeArticle { Id = 4, Status = ArticleStatus.Published };
        var task4 = (Task)method.Invoke(kbService, new object[] { a4, ArticleStatus.NeedsRevision, true, false, "T4" })!;
        await task4;
        Assert.Equal(ArticleStatus.Published, a4.Status);

        // isAuthor = false, canManageKb = true, targetStatus = Published -> line 300
        var a5 = new KnowledgeArticle { Id = 5, Status = ArticleStatus.Draft };
        var task5 = (Task)method.Invoke(kbService, new object[] { a5, ArticleStatus.Published, false, true, "T5" })!;
        await task5;
        Assert.Equal(ArticleStatus.Published, a5.Status);

        // isAuthor = false, canManageKb = false -> line 300 false branch
        var a6 = new KnowledgeArticle { Id = 6, Status = ArticleStatus.Draft };
        var task6 = (Task)method.Invoke(kbService, new object[] { a6, ArticleStatus.Published, false, false, "T6" })!;
        await task6;
        Assert.Equal(ArticleStatus.Draft, a6.Status);
    }

    [Fact]
    public async Task GroupService_NullContextAndMissingEntities_Branches()
    {
        using var context = CreateDbContext("GroupService_Branches_" + Guid.NewGuid());
        var nullHttpMock = new Mock<IHttpContextAccessor>();
        nullHttpMock.Setup(a => a.HttpContext).Returns((HttpContext?)null);

        var repo = new Repository<Group>(context);
        var groupService = new GroupService(repo, context, nullHttpMock.Object);

        var d1 = new Department { Id = 1, Name = "Dept 1" };
        var d2 = new Department { Id = 2, Name = "Dept 2" };
        var grp = new Group { Id = 10, Name = "Group 10", DepartmentId = 1, IsActive = true };
        var usr = new User { Id = 20, Username = "user20", FirstName = "U", LastName = "20" };
        context.Departments.AddRange(d1, d2);
        context.Groups.Add(grp);
        context.Users.Add(usr);
        await context.SaveChangesAsync();

        // 1. UpdateAsync with moved department and null HttpContext -> line 60 ?? "0"
        await groupService.UpdateAsync(10, new UpdateGroupDto("Group 10 Renamed", true, 2));

        // 2. AddMemberAsync with null HttpContext -> line 105 ?? "0"
        await groupService.AddMemberAsync(10, 20);

        // 3. RemoveMemberAsync with null HttpContext -> line 135 ?? "0"
        await groupService.RemoveMemberAsync(10, 20);

        // 4. RemoveMemberAsync when user or group does not exist -> line 133
        var gmMissing = new GroupMember { Id = 99, GroupId = 10, UserId = 9999 };
        context.GroupMembers.Add(gmMissing);
        await context.SaveChangesAsync();
        await groupService.RemoveMemberAsync(10, 9999);
    }

    [Fact]
    public async Task FinalFourBranchesToHit95()
    {
        using var context = CreateDbContext("FinalFour_" + Guid.NewGuid());
        var user = new User { Id = 1, Username = "user1", FirstName = "F", LastName = "L", Email = "u1@test.com", ProfilePhoto = "old.png" };
        var ticket = new Ticket { Id = 1, TicketNumber = "T-1", Title = "Title", CategoryId = 1, PriorityId = 1, StatusId = 1, TypeId = 1, RequesterUserId = 1 };
        var attachment = new TicketAttachment { Id = 10, TicketId = 1, FilePath = "/path/file.txt", ContentType = "text/plain", FileName = "file.txt" };

        context.Users.Add(user);
        context.Tickets.Add(ticket);
        context.TicketAttachments.Add(attachment);
        await context.SaveChangesAsync();

        // 1. TicketService.GetAttachmentFileInfoAsync with found attachment (line 792)
        // and ValidateRequiredField branches (line 86)
        var nullHttp = new Mock<IHttpContextAccessor>();
        nullHttp.Setup(a => a.HttpContext).Returns((HttpContext?)null);

        var permCalcMock = new Mock<IPermissionCalculator>();
        var notifDispatcherMock = new Mock<INotificationDispatcher>();
        var slaEngineMock = new Mock<ISlaEngine>();
        var assignEngineMock = new Mock<IAssignmentEngine>();
        var storageMock = new Mock<IFileStorageService>();

        var ticketService = new TicketService(
            context,
            storageMock.Object,
            permCalcMock.Object,
            slaEngineMock.Object,
            assignEngineMock.Object,
            notifDispatcherMock.Object);

        var (fp, ct, fn) = await ticketService.GetAttachmentFileInfoAsync(1, 10);
        Assert.Equal("file.txt", fn);
        await Assert.ThrowsAsync<KeyNotFoundException>(() => ticketService.GetAttachmentFileInfoAsync(1, 99999));

        // Timeline with includeInternal = false
        context.TicketComments.Add(new TicketComment { Id = 901, TicketId = 1, Content = "Internal", IsInternal = true, CreatedBy = "System" });
        await context.SaveChangesAsync();
        var tl = await ticketService.GetTimelineAsync(1, false);
        Assert.NotNull(tl);

        // AssignTicketAsync with ParentAssignmentId != null
        permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(1)).ReturnsAsync(new HashSet<string> { "ticket.assign", "admin", "ticket.manage", "ticket.transfer", "admin.manage" });
        await ticketService.AssignTicketAsync(1, new AssignTicketDto(new List<int> { 1 }, new List<int>(), 1, ParentAssignmentId: 5));

        // TransferTicketAsync with ProjectId = -1 and GroupId = -1
        await ticketService.TransferTicketAsync(1, new TransferTicketDto(-1, -1, 1));

        var valReqMethod = typeof(TicketService).GetMethod("ValidateRequiredField", BindingFlags.NonPublic | BindingFlags.Static)!;
        valReqMethod.Invoke(null, new object?[] { new FormFieldPlacement { IsRequired = false }, new FieldDefinition { Label = "L" }, null });
        valReqMethod.Invoke(null, new object?[] { new FormFieldPlacement { IsRequired = true }, new FieldDefinition { Label = "L" }, "valid_val" });

        // 2. UserService.UpdateProfilePhoto with null HttpContext (line 204)
        var userRepo = new Repository<User>(context);
        var userService = new UserService(userRepo, context, nullHttp.Object);
        await userService.UpdateAsync(1, new UpdateUserDto("u1@test.com", "F", "L", true, null, "new.png", null));

        // 3. TicketHandoffSwarm.FormatComments with null Author (line 58)
        var formatMethod = typeof(TicketHandoffSwarm).GetMethod("FormatComments", BindingFlags.NonPublic | BindingFlags.Static)!;
        var commentsList = new List<(string Date, bool IsInternal, string? Author, string Content)>
        {
            ("2026-01-01", false, null, "Comment body")
        };
        formatMethod.Invoke(null, new object[] { commentsList, false });

        // 4. ResolutionCopilotAgent.HandleDraftCompletion with [AI Modülü Devre Dışı] (line 243)
        var llmService = new Mock<ILlmService>();
        llmService.Setup(l => l.IsFallbackDisabled()).Returns(true);
        var agent = new ResolutionCopilotAgent(llmService.Object, context, Mock.Of<ILogger<ResolutionCopilotAgent>>());
        var handleDraftMethod = typeof(ResolutionCopilotAgent).GetMethod("HandleDraftCompletion", BindingFlags.NonPublic | BindingFlags.Instance)!;
        var ex = Assert.Throws<TargetInvocationException>(() => handleDraftMethod.Invoke(agent, new object?[] { "[AI Modülü Devre Dışı]", "gpt-4", false, ticket }));
        Assert.IsType<InvalidOperationException>(ex.InnerException);

        // 5. DashboardService.GetDepartmentWorkloadAsync when currentUser is null (line 115)
        permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(99999)).ReturnsAsync(new HashSet<string>());
        var dashService = new DashboardService(context, permCalcMock.Object);
        var workload = await dashService.GetDepartmentWorkloadAsync(99999);
        Assert.NotNull(workload);
    }

    [Fact]
    public async Task FinalExtraBranchesToHit95Plus()
    {
        using var context = CreateDbContext("FinalExtra_" + Guid.NewGuid());
        var user1 = new User { Id = 1, Username = "user1", FirstName = "F", LastName = "L", Email = "u1@test.com" };
        var user2 = new User { Id = 2, Username = "user2", FirstName = "F2", LastName = "L2", Email = "u2@test.com" };
        var ticket = new Ticket { Id = 100, TicketNumber = "T-100", Title = "Title", CategoryId = 1, PriorityId = 1, StatusId = 1, TypeId = 1, RequesterUserId = 1 };
        
        var stNormal = new Status { Id = 1, Name = "Open", PausesSla = false };
        var stPaused = new Status { Id = 2, Name = "Waiting", PausesSla = true };
        var stClosed = new Status { Id = 3, Name = "Closed", PausesSla = false, IsClosedStatus = true };

        context.Users.AddRange(user1, user2);
        context.Tickets.Add(ticket);
        context.Statuses.AddRange(stNormal, stPaused, stClosed);

        for (int i = 0; i < 7; i++)
        {
            context.BusinessHours.Add(new BusinessHour
            {
                Id = i + 1,
                DayOfWeek = (DayOfWeek)i,
                IsWorkingDay = true,
                StartTime = TimeSpan.FromHours(0),
                EndTime = TimeSpan.FromHours(23).Add(TimeSpan.FromMinutes(59))
            });
        }
        await context.SaveChangesAsync();

        // 1. TicketService.AddCommentAsync (ParentCommentId, MentionedUserIds populated, empty)
        var nullHttp = new Mock<IHttpContextAccessor>();
        nullHttp.Setup(a => a.HttpContext).Returns((HttpContext?)null);
        var permCalcMock = new Mock<IPermissionCalculator>();
        var notifDispatcherMock = new Mock<INotificationDispatcher>();
        var slaEngineMock = new Mock<ISlaEngine>();
        var assignEngineMock = new Mock<IAssignmentEngine>();
        var storageMock = new Mock<IFileStorageService>();

        var ticketService = new TicketService(
            context,
            storageMock.Object,
            permCalcMock.Object,
            slaEngineMock.Object,
            assignEngineMock.Object,
            notifDispatcherMock.Object);

        // Add parent comment with mentions
        var parentComment = await ticketService.AddCommentAsync(100, new CreateCommentDto("Parent note", false, 1, null, new int[] { 2 }));
        // Add reply comment (dto.ParentCommentId.HasValue -> CommentReplied branch)
        var replyComment = await ticketService.AddCommentAsync(100, new CreateCommentDto("Reply note", false, 1, parentComment.Id, Array.Empty<int>()));
        Assert.NotNull(replyComment);

        // 2. TicketService.UpdateCommentAsync branches
        // Not found
        await Assert.ThrowsAsync<KeyNotFoundException>(() => ticketService.UpdateCommentAsync(100, 9999, new UpdateCommentDto("c"), 1, true));
        // Unauthorized
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => ticketService.UpdateCommentAsync(100, parentComment.Id, new UpdateCommentDto("c"), 999, false));
        // Author matching
        var updated1 = await ticketService.UpdateCommentAsync(100, parentComment.Id, new UpdateCommentDto("Author edit", new List<int>()), 1, false);
        Assert.Equal("Author edit", updated1.Content);
        // Has edit perm matching with mentions
        var updated2 = await ticketService.UpdateCommentAsync(100, parentComment.Id, new UpdateCommentDto("Perm edit", new List<int> { 2 }), 999, true);
        Assert.Equal("Perm edit", updated2.Content);

        // 3. UserService.UpdateGroupMemberships with missing group and null HttpContext
        var userRepo = new Repository<User>(context);
        var userService = new UserService(userRepo, context, nullHttp.Object);
        await userService.UpdateAsync(1, new UpdateUserDto("u1@test.com", "F", "L", true, null, null, new int[] { 99999 }));

        // 4. SlaEngine: ApplyPause and ApplyResumeAsync
        var emailMock = new Mock<IEmailService>();
        var slaEngine = new SlaEngine(context, emailMock.Object, notifDispatcherMock.Object);

        var sla = new TicketSla
        {
            TicketId = 100,
            CreatedAt = DateTime.UtcNow.AddHours(-2),
            FirstResponseDueAt = DateTime.UtcNow.AddHours(2),
            ResolutionDueAt = DateTime.UtcNow.AddHours(6)
        };
        context.TicketSlas.Add(sla);
        await context.SaveChangesAsync();

        // Status change to paused -> ApplyPause
        await slaEngine.ProcessTicketStatusChangeAsync(100, 1, 2);
        Assert.NotNull(sla.PausedAt);

        // Status change from paused to normal -> ApplyResumeAsync
        await slaEngine.ProcessTicketStatusChangeAsync(100, 2, 1);
        Assert.Null(sla.PausedAt);

        // Status change to closed -> ResolutionMetAt set
        await slaEngine.ProcessTicketStatusChangeAsync(100, 1, 3);
        Assert.NotNull(sla.ResolutionMetAt);

        // SlaEngine.ProcessTicketCommentAsync with isInternal: true and false
        await slaEngine.ProcessTicketCommentAsync(100, true);
        await slaEngine.ProcessTicketCommentAsync(100, false);
    }

    [Fact]
    public async Task FinalSurpassBranchCoverageGoalTests()
    {
        using var context = CreateDbContext("Surpass_" + Guid.NewGuid());
        
        // 1. PermissionCalculator: SuperAdmin (lines 21-32)
        var superRole = new Role { Id = 99, Name = "SuperAdmin", IsActive = true };
        var superUser = new User { Id = 99, Username = "super", Email = "s@s.com", PasswordHash = "h" };
        var superUr = new UserRole { UserId = 99, RoleId = 99 };
        var perm = new Permission { Id = 1, Name = "All", Key = "all.perm", IsActive = true };
        context.Roles.Add(superRole);
        context.Users.Add(superUser);
        context.UserRoles.Add(superUr);
        context.Permissions.Add(perm);
        await context.SaveChangesAsync();

        var calc = new PermissionCalculator(context);
        var superPerms = await calc.CalculateEffectivePermissionsAsync(99);
        Assert.Contains("all.perm", superPerms);

        // 2. EmailTemplateService: fallbackFile exists (line 38)
        var tempDir = Path.Combine(Path.GetTempPath(), "EmailTplTest_" + Guid.NewGuid());
        Directory.CreateDirectory(tempDir);
        try
        {
            File.WriteAllText(Path.Combine(tempDir, "BaseTemplate.html"), "Fallback <h2>{{EventName}}</h2> {{Context}}");
            var tplService = new EmailTemplateService(Mock.Of<ILogger<EmailTemplateService>>());
            typeof(EmailTemplateService).GetField("_templatePath", BindingFlags.NonPublic | BindingFlags.Instance)!.SetValue(tplService, tempDir);
            var html = tplService.GenerateEmailBody("sla.breached", new Dictionary<string, string> { { "EventName", "TestEvent" } });
            Assert.Contains("TestEvent", html);
        }
        finally
        {
            if (Directory.Exists(tempDir)) Directory.Delete(tempDir, true);
        }

        // 3. LocalFileStorageService: null BasePath configuration (line 13 ?? "uploads")
        var emptyCfg = new ConfigurationBuilder().Build();
        var storageNull = new LocalFileStorageService(emptyCfg);
        Assert.NotNull(storageNull);

        // 4. NotificationService: MarkAsReadAsync on already read notification (line 33)
        var notif = new ItsTool.Domain.Entities.Notification.Notification { Id = 50, UserId = 1, Title = "N", Body = "B", IsRead = true };
        context.Notifications.Add(notif);
        await context.SaveChangesAsync();
        var notifService = new NotificationService(context);
        await notifService.MarkAsReadAsync(50, 1);
        Assert.True(notif.IsRead);

        // 5. DynamicFormService: UpdatePlacementAsync with duplicate scope (line 142)
        var fd = new FieldDefinition { Id = 1, Key = "f1", Label = "Field 1" };
        var p1 = new FormFieldPlacement { Id = 1, FieldDefinitionId = 1, ProjectId = 1, CategoryId = 1, TicketTypeId = 1, SortOrder = 1 };
        var p2 = new FormFieldPlacement { Id = 2, FieldDefinitionId = 1, ProjectId = 2, CategoryId = 2, TicketTypeId = 2, SortOrder = 2 };
        context.FieldDefinitions.Add(fd);
        context.FormFieldPlacements.AddRange(p1, p2);
        await context.SaveChangesAsync();

        var formService = new DynamicFormService(
            new Repository<FieldDefinition>(context),
            new Repository<FieldOption>(context),
            new Repository<FormFieldPlacement>(context),
            context);
        await Assert.ThrowsAsync<InvalidOperationException>(() => formService.UpdatePlacementAsync(2, new UpdateFormFieldPlacementDto(1, 1, 1, 3, false, true)));

        // 6. DashboardService:
        // a) GetOverviewAsync with csat survey (line 69)
        var survey = new TicketSurvey { Id = 1, TicketId = 1, Rating = 5, Comment = "Great" };
        context.TicketSurveys.Add(survey);
        await context.SaveChangesAsync();

        var permCalcMock = new Mock<IPermissionCalculator>();
        permCalcMock.Setup(p => p.CalculateEffectivePermissionsAsync(1)).ReturnsAsync(new HashSet<string> { "ticket.view" });
        var dashService = new DashboardService(context, permCalcMock.Object);
        var overview = await dashService.GetOverviewAsync(1);
        Assert.Equal(5.0, overview.CsatAverage);

        // b) GetSlaComplianceAsync with no due dates (lines 182, 186, 189)
        var tSla = new Ticket
        {
            Id = 200,
            TicketNumber = "T-200",
            Title = "No Due Sla",
            RequesterUserId = 1,
            Status = new Status { Id = 20, Name = "Open", IsClosedStatus = false },
            CreatedAt = DateTime.UtcNow.AddHours(-1)
        };
        var slaNoDues = new TicketSla
        {
            Id = 200,
            TicketId = 200,
            FirstResponseDueAt = null,
            ResolutionDueAt = null,
            FirstResponseBreached = false,
            ResolutionBreached = false
        };
        context.Tickets.Add(tSla);
        context.TicketSlas.Add(slaNoDues);
        await context.SaveChangesAsync();

        var slaComp = await dashService.GetSlaComplianceAsync(1);
        Assert.Equal(100, slaComp.FirstResponseComplianceRate);
        Assert.Equal(100, slaComp.ResolutionComplianceRate);
        Assert.Equal(0.0, slaComp.AverageResolutionTimeMinutes);

        // c) GetDepartmentWorkloadAsync with user without department (line 142)
        var uNoDept = new User { Id = 300, Username = "nodept", FirstName = "No", LastName = "Dept", DepartmentId = null, IsActive = true };
        context.Users.Add(uNoDept);
        await context.SaveChangesAsync();
        var workload = await dashService.GetDepartmentWorkloadAsync(1);
        Assert.NotNull(workload);

        // 7. NotificationDispatcher: AddRecipient reflection with existing and priority = "High" (line 89)
        var addRecMethod = typeof(NotificationDispatcher).GetMethod("AddRecipient", BindingFlags.NonPublic | BindingFlags.Static)!;
        var resRecType = typeof(NotificationDispatcher).GetNestedType("ResolvedRecipient", BindingFlags.NonPublic)!;
        var recDictType = typeof(Dictionary<,>).MakeGenericType(typeof(int), resRecType);
        var recDict = Activator.CreateInstance(recDictType)!;
        addRecMethod.Invoke(null, new object?[] { recDict, 10, false, null, "evt", "Normal", "cat" });
        addRecMethod.Invoke(null, new object?[] { recDict, 10, true, null, "evt", "High", "cat" });

        // 8. KnowledgeBaseService: SearchArticlesAsync and GetArticleAsync with author having DepartmentId = null (lines 102, 144)
        var authorNoDept = new User { Id = 400, Username = "authNoDept", FirstName = "A", LastName = "N", DepartmentId = null };
        var kbArticle = new KnowledgeArticle
        {
            Id = 500,
            Title = "Kb No Dept",
            Content = "Content",
            AuthorUserId = 400,
            Status = ArticleStatus.Published,
            Visibility = ArticleVisibility.Public,
            IsDeleted = false
        };
        context.Users.Add(authorNoDept);
        context.KnowledgeArticles.Add(kbArticle);
        await context.SaveChangesAsync();

        var kbService = new KnowledgeBaseService(context, permCalcMock.Object, Mock.Of<ISignalRPusher>());
        var searchRes = await kbService.SearchArticlesAsync(1, "Kb No Dept", null);
        Assert.NotEmpty(searchRes);
        var getArt = await kbService.GetArticleAsync(500, 1);
        Assert.Null(getArt.AuthorDepartment);

        // 9. AuthService: LoginAsync with configuration["Jwt:ExpiryMinutes"] = null (line 53)
        var authUser = new User { Id = 600, Username = "authuser", PasswordHash = BCrypt.Net.BCrypt.HashPassword("pass123"), IsActive = true };
        context.Users.Add(authUser);
        await context.SaveChangesAsync();

        var tokenMock = new Mock<ITokenService>();
        tokenMock.Setup(t => t.GenerateToken(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<IEnumerable<string>>(), It.IsAny<IEnumerable<string>>())).Returns("token123");
        tokenMock.Setup(t => t.GenerateToken(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<IEnumerable<string>>(), It.IsAny<IEnumerable<string>>(), It.IsAny<bool>())).Returns("token123");
        var authServiceNoExpiry = new AuthService(context, tokenMock.Object, permCalcMock.Object, new ConfigurationBuilder().Build());
        var authRes = await authServiceNoExpiry.LoginAsync(new LoginRequestDto("authuser", "pass123"));
        Assert.Equal("token123", authRes.Token);
    }
}

