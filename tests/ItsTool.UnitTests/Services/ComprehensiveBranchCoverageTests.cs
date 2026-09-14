using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Claims;
using System.Text;
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
using ItsTool.Infrastructure.Helpers;
using ItsTool.Infrastructure.Security;
using ItsTool.Infrastructure.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Abstractions;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class ComprehensiveBranchCoverageTests : TestBase
{
    private readonly Mock<IHttpContextAccessor> _httpContextAccessorMock;
    private readonly Mock<IWebhookDispatcher> _webhookDispatcherMock;
    private readonly Mock<ISignalRPusher> _signalRPusherMock;
    private readonly Mock<IEmailQueue> _emailQueueMock;
    private readonly Mock<IEmailTemplateService> _emailTemplateServiceMock;
    private readonly Mock<IAiAgentDispatcher> _aiAgentDispatcherMock;
    private readonly Mock<IConfiguration> _configMock;

    private class RefreshToken : BaseEntity { }

    public ComprehensiveBranchCoverageTests() : base()
    {
        _httpContextAccessorMock = new Mock<IHttpContextAccessor>();
        _webhookDispatcherMock = new Mock<IWebhookDispatcher>();
        _signalRPusherMock = new Mock<ISignalRPusher>();
        _emailQueueMock = new Mock<IEmailQueue>();
        _emailTemplateServiceMock = new Mock<IEmailTemplateService>();
        _aiAgentDispatcherMock = new Mock<IAiAgentDispatcher>();
        _configMock = new Mock<IConfiguration>();

        _configMock.Setup(c => c["AppBaseUrl"]).Returns("http://localhost:5000");
    }

    [Fact]
    public void NotificationDispatcher_GetHumanReadableEventName_AllCases()
    {
        Assert.Equal("Bilet Oluşturuldu", NotificationDispatcher.GetHumanReadableEventName("ticket.created"));
        Assert.Equal("Bilet Atandı", NotificationDispatcher.GetHumanReadableEventName("ticket.assigned"));
        Assert.Equal("Bilet Aktarıldı", NotificationDispatcher.GetHumanReadableEventName("ticket.transferred"));
        Assert.Equal("Yeni Yorum", NotificationDispatcher.GetHumanReadableEventName("comment.added"));
        Assert.Equal("Yeni Yorum", NotificationDispatcher.GetHumanReadableEventName("ticket.comment.added"));
        Assert.Equal("Etiketlendiniz", NotificationDispatcher.GetHumanReadableEventName("comment.mention"));
        Assert.Equal("Bilet Durumu Değişti", NotificationDispatcher.GetHumanReadableEventName("status.changed"));
        Assert.Equal("Bilet Yeniden Açıldı", NotificationDispatcher.GetHumanReadableEventName("ticket.reopened"));
        Assert.Equal("Bilet Çözüldü", NotificationDispatcher.GetHumanReadableEventName("ticket.resolved"));
        Assert.Equal("Bilet Kapatıldı", NotificationDispatcher.GetHumanReadableEventName("ticket.closed"));
        Assert.Equal("Memnuniyet Anketi", NotificationDispatcher.GetHumanReadableEventName("ticket.closed.survey"));
        Assert.Equal("SLA Riski", NotificationDispatcher.GetHumanReadableEventName("sla.risk"));
        Assert.Equal("SLA İhlali", NotificationDispatcher.GetHumanReadableEventName("sla.breached"));
        Assert.Equal("SLA İhlali", NotificationDispatcher.GetHumanReadableEventName("sla.breach"));
        Assert.Equal("SLA Uyarısı", NotificationDispatcher.GetHumanReadableEventName("sla.warning"));
        Assert.Equal("Kritik Bilet Atanmadı", NotificationDispatcher.GetHumanReadableEventName("critical.unassigned"));
        Assert.Equal("Düşük Anket Puanı", NotificationDispatcher.GetHumanReadableEventName("survey.low"));
        Assert.Equal("Yeni Makale Önerisi", NotificationDispatcher.GetHumanReadableEventName("kb.suggested"));
        Assert.Equal("Makale İncelendi", NotificationDispatcher.GetHumanReadableEventName("kb.reviewed"));
        Assert.Equal("Sistem Bildirimi", NotificationDispatcher.GetHumanReadableEventName("unknown.event"));
    }

    [Fact]
    public async Task NotificationDispatcher_DispatchEventAsync_AllEventTypesAndBranches()
    {
        var dispatcher = new NotificationDispatcher(
            _context,
            _webhookDispatcherMock.Object,
            _signalRPusherMock.Object,
            _emailQueueMock.Object,
            _emailTemplateServiceMock.Object,
            _configMock.Object,
            _aiAgentDispatcherMock.Object
        );

        // 1. Ticket not found -> returns early
        await dispatcher.DispatchEventAsync("ticket.created", 999999);

        // Setup common entities
        var dept = new Department { Name = "IT Support" };
        _context.Departments.Add(dept);
        var managerRole = new Role { Name = "Manager" };
        _context.Roles.Add(managerRole);
        await _context.SaveChangesAsync();

        var requester = new User { Username = "req", Email = "req@test.com", DepartmentId = dept.Id };
        var agent = new User { Username = "agent", Email = "agent@test.com", DepartmentId = dept.Id };
        var manager = new User { Username = "mgr", Email = "mgr@test.com", DepartmentId = dept.Id };
        _context.Users.AddRange(requester, agent, manager);
        await _context.SaveChangesAsync();

        _context.UserRoles.Add(new UserRole { UserId = manager.Id, RoleId = managerRole.Id });

        var group = new Group { Name = "L1 Support", DepartmentId = dept.Id };
        _context.Groups.Add(group);
        await _context.SaveChangesAsync();

        _context.GroupMembers.Add(new GroupMember { UserId = agent.Id, GroupId = group.Id });
        _context.GroupMembers.Add(new GroupMember { UserId = manager.Id, GroupId = group.Id });

        var prio = new Priority { Name = "Urgent", SeverityLevel = 1 };
        var stat = new Status { Name = "Open" };
        _context.Priorities.Add(prio);
        _context.Statuses.Add(stat);
        await _context.SaveChangesAsync();

        var ticket = new Ticket
        {
            TicketNumber = "T-DISP-1",
            Title = "Notification Dispatch Test",
            RequesterUserId = requester.Id,
            PriorityId = prio.Id,
            Priority = prio,
            StatusId = stat.Id,
            Status = stat
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        ticket.Assignments.Add(new TicketAssignment { TicketId = ticket.Id, AssignedUserId = agent.Id, IsActive = true });
        ticket.Assignments.Add(new TicketAssignment { TicketId = ticket.Id, AssignedGroupId = group.Id, IsActive = true });
        await _context.SaveChangesAsync();

        // Email disabled in preferences for requester to test preference branch
        _context.NotificationPreferences.Add(new NotificationPreference
        {
            UserId = requester.Id,
            Category = "StatusUpdates",
            EmailEnabled = false
        });
        await _context.SaveChangesAsync();

        // 2. ticket.created
        await dispatcher.DispatchEventAsync("ticket.created", ticket.Id, triggerUserId: requester.Id);

        // 3. ticket.assigned & ticket.transferred
        await dispatcher.DispatchEventAsync("ticket.assigned", ticket.Id, triggerUserId: requester.Id);
        await dispatcher.DispatchEventAsync("ticket.transferred", ticket.Id, triggerUserId: requester.Id);

        // 4. comment.added with participants
        _context.TicketComments.Add(new TicketComment { TicketId = ticket.Id, CreatedBy = agent.Id.ToString(), Content = "Working on it" });
        _context.TicketComments.Add(new TicketComment { TicketId = ticket.Id, CreatedBy = "system_non_int", Content = "Auto note" });
        await _context.SaveChangesAsync();
        await dispatcher.DispatchEventAsync("comment.added", ticket.Id, triggerUserId: agent.Id);

        // 5. comment.mention with pipe and without pipe
        await dispatcher.DispatchEventAsync("comment.mention", ticket.Id, triggerUserId: requester.Id, additionalContext: $"{agent.Id}|Mentioned you in comment");
        await dispatcher.DispatchEventAsync("comment.mention", ticket.Id, triggerUserId: requester.Id, additionalContext: "no pipe context");

        // 6. status.changed
        await dispatcher.DispatchEventAsync("status.changed", ticket.Id, triggerUserId: agent.Id);

        // 7. ticket.reopened
        await dispatcher.DispatchEventAsync("ticket.reopened", ticket.Id, triggerUserId: requester.Id);

        // 8. sla.risk
        await dispatcher.DispatchEventAsync("sla.risk", ticket.Id, additionalContext: "Approaching breach");

        // 9. sla.breached (badge breach color)
        await dispatcher.DispatchEventAsync("sla.breached", ticket.Id, additionalContext: "SLA breached");

        // 10. sla.warning (badge warning color)
        await dispatcher.DispatchEventAsync("sla.warning", ticket.Id, additionalContext: "SLA warning");

        // 11. critical.unassigned
        await dispatcher.DispatchEventAsync("critical.unassigned", ticket.Id);

        // 12. survey.low
        await dispatcher.DispatchEventAsync("survey.low", ticket.Id);

        // 13. Null priority & null status on ticket (covers DB lookup branches in EnqueueEmailAsync)
        var ticket2 = new Ticket
        {
            TicketNumber = "T-DISP-2",
            Title = "Ticket Without Nav Props",
            RequesterUserId = requester.Id,
            PriorityId = prio.Id,
            Priority = null,
            StatusId = stat.Id,
            Status = null
        };
        _context.Tickets.Add(ticket2);
        ticket2.Assignments.Add(new TicketAssignment { TicketId = ticket2.Id, AssignedUserId = agent.Id, IsActive = true });
        await _context.SaveChangesAsync();

        await dispatcher.DispatchEventAsync("ticket.created", ticket2.Id, triggerUserId: null);

        // 14. Unknown event with no recipients
        await dispatcher.DispatchEventAsync("non.existent.event", ticket.Id, triggerUserId: requester.Id);

        var notifs = await _context.Notifications.ToListAsync();
        Assert.NotEmpty(notifs);
    }

    [Fact]
    public void SystemAuditInterceptor_ShouldSkipAudit_CoversAllEntityTypes()
    {
        Assert.True(SystemAuditInterceptor.ShouldSkipAudit(new SystemAuditLog()));
        Assert.True(SystemAuditInterceptor.ShouldSkipAudit(new Ticket()));
        Assert.True(SystemAuditInterceptor.ShouldSkipAudit(new TicketSla()));
        Assert.True(SystemAuditInterceptor.ShouldSkipAudit(new ProjectSequence()));
        Assert.True(SystemAuditInterceptor.ShouldSkipAudit(new RolePermission()));
        Assert.True(SystemAuditInterceptor.ShouldSkipAudit(new UserRole()));
        Assert.True(SystemAuditInterceptor.ShouldSkipAudit(new GroupRole()));
        Assert.True(SystemAuditInterceptor.ShouldSkipAudit(new WorkflowTransition()));
        Assert.True(SystemAuditInterceptor.ShouldSkipAudit(new BusinessHour()));
        Assert.True(SystemAuditInterceptor.ShouldSkipAudit(new FormFieldPlacement()));
        Assert.True(SystemAuditInterceptor.ShouldSkipAudit(new SlaTarget()));
        Assert.True(SystemAuditInterceptor.ShouldSkipAudit(new TicketFieldValue()));
        Assert.True(SystemAuditInterceptor.ShouldSkipAudit(new TicketAttachment()));
        Assert.True(SystemAuditInterceptor.ShouldSkipAudit(new TicketWatcher()));
        Assert.True(SystemAuditInterceptor.ShouldSkipAudit(new TicketAssignment()));
        Assert.True(SystemAuditInterceptor.ShouldSkipAudit(new RefreshToken()));
        Assert.True(SystemAuditInterceptor.ShouldSkipAudit(new TicketHistory()));
        Assert.True(SystemAuditInterceptor.ShouldSkipAudit(new TicketComment()));
        Assert.True(SystemAuditInterceptor.ShouldSkipAudit(new Notification()));
        Assert.True(SystemAuditInterceptor.ShouldSkipAudit(new NotificationPreference()));

        Assert.False(SystemAuditInterceptor.ShouldSkipAudit(new Category()));
        Assert.False(SystemAuditInterceptor.ShouldSkipAudit(new Department()));
        Assert.False(SystemAuditInterceptor.ShouldSkipAudit(new User()));
        Assert.False(SystemAuditInterceptor.ShouldSkipAudit(new Group()));
        Assert.False(SystemAuditInterceptor.ShouldSkipAudit(new Role()));
        Assert.False(SystemAuditInterceptor.ShouldSkipAudit(new SlaPolicy()));
    }

    [Fact]
    public void SystemAuditInterceptor_GetSpecificEntitySummary_CoversAllBranches()
    {
        // 1. SlaPolicy with Project & Targets & without description & EscalateOnBreach false
        var p = new Project { Id = 10, Name = "P10", ProjectKey = "PK" };
        var prio = new Priority { Id = 5, Name = "Prio5" };
        _context.Projects.Add(p);
        _context.Priorities.Add(prio);
        _context.SaveChanges();

        var sla1 = new SlaPolicy { Id = 1, Name = "SLA1", ProjectId = 10, EscalateOnBreach = false, Description = null };
        _context.SlaPolicies.Add(sla1);
        _context.SlaTargets.Add(new SlaTarget { SlaPolicyId = sla1.Id, PriorityId = 5, FirstResponseMinutes = 10, ResolutionMinutes = 30 });
        _context.SlaTargets.Add(new SlaTarget { SlaPolicyId = sla1.Id, PriorityId = 999, FirstResponseMinutes = 20, ResolutionMinutes = 40 }); // unknown priority
        _context.SaveChanges();

        var slaSum1 = SystemAuditInterceptor.GetSpecificEntitySummary(sla1, _context);
        Assert.Contains("SLA1", slaSum1);
        Assert.Contains("Eskalasyon: Kapalı", slaSum1);
        Assert.Contains("Hedefler:", slaSum1);

        // SlaPolicy without ProjectId and without targets
        var sla2 = new SlaPolicy { Id = 2, Name = "SLA2", ProjectId = null, EscalateOnBreach = true, Description = "Desc" };
        var slaSum2 = SystemAuditInterceptor.GetSpecificEntitySummary(sla2, null);
        Assert.Contains("Genel Sistem", slaSum2);
        Assert.Contains("Eskalasyon: Açık", slaSum2);

        // 2. User with names vs without names
        var u1 = new User { Username = "u1", FirstName = "John", LastName = "Doe", Email = "j@d.com", DepartmentId = 3 };
        var uSum1 = SystemAuditInterceptor.GetUserSummary(u1);
        Assert.Contains("John Doe", uSum1);
        Assert.Contains("Departman ID: 3", uSum1);

        var u2 = new User { Username = "u2", FirstName = "", LastName = null, Email = "u2@d.com", DepartmentId = null };
        var uSum2 = SystemAuditInterceptor.GetUserSummary(u2);
        Assert.Contains("@u2", uSum2);
        Assert.Contains("Departman ID: Yok", uSum2);

        // 3. Project with and without description
        var proj1 = new Project { Name = "Prj1", ProjectKey = "P1", Description = "Some description" };
        Assert.Contains("Açıklama: Some description", SystemAuditInterceptor.GetProjectSummary(proj1));
        var proj2 = new Project { Name = "Prj2", ProjectKey = "P2", Description = null };
        Assert.DoesNotContain("Açıklama:", SystemAuditInterceptor.GetProjectSummary(proj2));

        // 4. Category with and without description
        var cat1 = new Category { Name = "Cat1", Description = "CatDesc" };
        Assert.Contains("Açıklama: CatDesc", SystemAuditInterceptor.GetSpecificEntitySummary(cat1, _context));
        var cat2 = new Category { Name = "Cat2", Description = "" };
        Assert.DoesNotContain("Açıklama:", SystemAuditInterceptor.GetSpecificEntitySummary(cat2, _context));

        // 5. Department with and without description & manager
        var d1 = new Department { Name = "D1", Description = "Desc", ManagerUserId = 99 };
        var dSum1 = SystemAuditInterceptor.GetSpecificEntitySummary(d1, _context);
        Assert.Contains("Açıklama: Desc", dSum1);
        Assert.Contains("Yönetici ID: 99", dSum1);
        var d2 = new Department { Name = "D2", Description = null, ManagerUserId = null };
        var dSum2 = SystemAuditInterceptor.GetSpecificEntitySummary(d2, _context);
        Assert.DoesNotContain("Yönetici ID", dSum2);

        // 6. Group with and without DepartmentId
        var g1 = new Group { Name = "G1", DepartmentId = 5 };
        Assert.Contains("Departman ID: 5", SystemAuditInterceptor.GetSpecificEntitySummary(g1, _context));
        var g2 = new Group { Name = "G2", DepartmentId = null };
        Assert.DoesNotContain("Departman ID", SystemAuditInterceptor.GetSpecificEntitySummary(g2, _context));

        // 7. Role with and without description
        var r1 = new Role { Name = "R1", Description = "RoleDesc" };
        Assert.Contains("Açıklama: RoleDesc", SystemAuditInterceptor.GetSpecificEntitySummary(r1, _context));
        var r2 = new Role { Name = "R2", Description = null };
        Assert.DoesNotContain("Açıklama:", SystemAuditInterceptor.GetSpecificEntitySummary(r2, _context));

        // 8. KnowledgeArticle, AssignmentRule, WebhookSubscription
        var ka = new KnowledgeArticle { Title = "KB Title", CategoryId = 2, Status = ArticleStatus.Published };
        Assert.Contains("KB Title", SystemAuditInterceptor.GetSpecificEntitySummary(ka, _context));

        var ar = new AssignmentRule { Name = "Rule 1", SortOrder = 10 };
        Assert.Contains("Sıra: 10", SystemAuditInterceptor.GetSpecificEntitySummary(ar, _context));

        var ws = new WebhookSubscription { Url = "http://hook.test", EventsCsv = "ticket.created" };
        Assert.Contains("http://hook.test", SystemAuditInterceptor.GetSpecificEntitySummary(ws, _context));

        // Unknown entity returns null
        Assert.Null(SystemAuditInterceptor.GetSpecificEntitySummary(new object(), _context));
    }

    [Fact]
    public void LlmService_ParseResponses_And_HelperMethods()
    {
        // 1. ParseOpenAiResponse
        Assert.Equal(string.Empty, LlmService.ParseOpenAiResponse(""));
        Assert.Equal(string.Empty, LlmService.ParseOpenAiResponse("   "));
        Assert.Equal(string.Empty, LlmService.ParseOpenAiResponse("invalid json"));
        Assert.Equal(string.Empty, LlmService.ParseOpenAiResponse("{}"));
        Assert.Equal(string.Empty, LlmService.ParseOpenAiResponse("{\"choices\": []}"));
        Assert.Equal(string.Empty, LlmService.ParseOpenAiResponse("{\"choices\": [{}]}"));
        Assert.Equal(string.Empty, LlmService.ParseOpenAiResponse("{\"choices\": [{\"message\": {}}]}"));
        Assert.Equal(string.Empty, LlmService.ParseOpenAiResponse("{\"choices\": [{\"message\": {\"content\": null}}]}"));
        Assert.Equal("OpenAI Success", LlmService.ParseOpenAiResponse("{\"choices\": [{\"message\": {\"content\": \"OpenAI Success\"}}]}"));

        // 2. ParseAnthropicResponse
        Assert.Equal(string.Empty, LlmService.ParseAnthropicResponse(""));
        Assert.Equal(string.Empty, LlmService.ParseAnthropicResponse("invalid json"));
        Assert.Equal(string.Empty, LlmService.ParseAnthropicResponse("{}"));
        Assert.Equal(string.Empty, LlmService.ParseAnthropicResponse("{\"content\": []}"));
        Assert.Equal(string.Empty, LlmService.ParseAnthropicResponse("{\"content\": [{\"type\": \"image\"}]}"));
        Assert.Equal(string.Empty, LlmService.ParseAnthropicResponse("{\"content\": [{\"type\": \"text\"}]}"));
        Assert.Equal("Claude Success", LlmService.ParseAnthropicResponse("{\"content\": [{\"type\": \"text\", \"text\": \"Claude Success\"}]}"));

        // 3. FormatErrorMessage
        Assert.Equal("HTTP 500", LlmService.FormatErrorMessage("", HttpStatusCode.InternalServerError));
        Assert.Equal("HTTP 404", LlmService.FormatErrorMessage("   ", HttpStatusCode.NotFound));
        Assert.Equal("Raw Error", LlmService.FormatErrorMessage("Raw Error", HttpStatusCode.BadRequest));
        Assert.Equal("Error string message", LlmService.FormatErrorMessage("{\"error\": \"Error string message\"}", HttpStatusCode.BadRequest));
        Assert.Equal("Nested error message", LlmService.FormatErrorMessage("{\"error\": {\"message\": \"Nested error message\"}}", HttpStatusCode.BadRequest));
        Assert.Contains("other", LlmService.FormatErrorMessage("{\"error\": {\"other\": 123}}", HttpStatusCode.BadRequest));
        var longError = new string('A', 250);
        var formattedLong = LlmService.FormatErrorMessage(longError, HttpStatusCode.BadRequest);
        Assert.EndsWith("...", formattedLong);

        // 4. TranslateHttpException
        var exRefused = new HttpRequestException("Connection refused");
        Assert.Contains("Bağlantı reddedildi", LlmService.TranslateHttpException(exRefused, "http://localhost:1234"));

        var exSocket = new HttpRequestException("Error", new System.Net.Sockets.SocketException());
        Assert.Contains("Bağlantı reddedildi", LlmService.TranslateHttpException(exSocket, "http://localhost:1234"));

        var exHost = new HttpRequestException("Name or service not known");
        Assert.Contains("Sunucu adresi çözülemedi", LlmService.TranslateHttpException(exHost, "http://bad.domain"));

        var exHost2 = new HttpRequestException("No such host");
        Assert.Contains("Sunucu adresi çözülemedi", LlmService.TranslateHttpException(exHost2, "http://bad.domain"));

        var exGeneric = new HttpRequestException("The request timed out");
        Assert.Contains("Ağ bağlantı hatası", LlmService.TranslateHttpException(exGeneric, "http://localhost"));

        // 5. MaskApiKey
        Assert.Equal(string.Empty, LlmService.MaskApiKey(null));
        Assert.Equal(string.Empty, LlmService.MaskApiKey("   "));
        Assert.Equal("********", LlmService.MaskApiKey("12345678"));
        Assert.Equal("1234****cdef", LlmService.MaskApiKey("1234567890abcdef"));

        // 6. ParseV1ModelsJson
        var v1Json = "{\"data\": [{\"id\": \"gpt-4\"}, {\"id\": \"\"}, {\"other\": \"val\"}]}";
        var v1Models = LlmService.ParseV1ModelsJson(v1Json);
        Assert.Single(v1Models);
        Assert.Equal("gpt-4", v1Models[0].Id);
        Assert.Empty(LlmService.ParseV1ModelsJson("{}"));

        // 7. ParseOllamaTagsJson
        var ollamaJson = "{\"models\": [{\"name\": \"llama3:8b\"}, {\"name\": \"  \"}, {\"val\": 1}]}";
        var ollamaModels = LlmService.ParseOllamaTagsJson(ollamaJson);
        Assert.Single(ollamaModels);
        Assert.Equal("llama3:8b", ollamaModels[0].Name);
        Assert.Empty(LlmService.ParseOllamaTagsJson("{}"));
    }

    [Fact]
    public void ResolutionCopilotAgent_CleanPlainText_And_HeuristicBuilders()
    {
        // 1. CleanPlainText
        Assert.Equal(string.Empty, ResolutionCopilotAgent.CleanPlainText(null));
        Assert.Equal(string.Empty, ResolutionCopilotAgent.CleanPlainText("   "));
        var cleaned = ResolutionCopilotAgent.CleanPlainText("**bold** `code`\n- bullet item");
        Assert.DoesNotContain("**", cleaned);
        Assert.DoesNotContain("`", cleaned);

        // 2. BuildSmartHeuristicSuggestionEn with null category & priority, and empty lists
        var t1 = new Ticket { TicketNumber = "T-EN-1", Title = "Title 1", Category = null, Priority = null };
        var enSug1 = ResolutionCopilotAgent.BuildSmartHeuristicSuggestionEn(t1, new List<SimilarTicketSummary>(), new List<KbArticleSummary>());
        Assert.Contains("Category: General", enSug1);
        Assert.Contains("Priority Level: Normal", enSug1);
        Assert.DoesNotContain("Past Similar Resolved Tickets", enSug1);

        // with category, priority, similar tickets and kb articles
        var cat = new Category { Name = "Network" };
        var prio = new Priority { Name = "Critical" };
        var t2 = new Ticket { TicketNumber = "T-EN-2", Title = "Title 2", Category = cat, Priority = prio };
        var similar = new List<SimilarTicketSummary> { new SimilarTicketSummary(1, "T-SIM-1", "Similar Title", "Cat") };
        var kb = new List<KbArticleSummary> { new KbArticleSummary(10, "KB Guide", "Network") };
        var enSug2 = ResolutionCopilotAgent.BuildSmartHeuristicSuggestionEn(t2, similar, kb);
        Assert.Contains("Category: Network", enSug2);
        Assert.Contains("Priority Level: Critical", enSug2);
        Assert.Contains("Past Similar Resolved Tickets", enSug2);
        Assert.Contains("Related Knowledge Base Articles", enSug2);

        // 3. BuildSmartHeuristicSuggestion (TR) with nulls vs populated
        var trSug1 = ResolutionCopilotAgent.BuildSmartHeuristicSuggestion(t1, new List<SimilarTicketSummary>(), new List<KbArticleSummary>());
        Assert.Contains("Kategori: Genel", trSug1);
        Assert.Contains("Öncelik Düzeyi: Normal", trSug1);

        var trSug2 = ResolutionCopilotAgent.BuildSmartHeuristicSuggestion(t2, similar, kb);
        Assert.Contains("Kategori: Network", trSug2);
        Assert.Contains("Öncelik Düzeyi: Critical", trSug2);
        Assert.Contains("Geçmiş Benzer Çözülmüş Biletler", trSug2);
        Assert.Contains("İlgili Bilgi Bankası Makaleleri", trSug2);
    }

    [Fact]
    public void TicketHandoffSwarm_BuildSmartHeuristicHandoff_AllBranches()
    {
        // 1. CleanPlainText
        Assert.Equal(string.Empty, TicketHandoffSwarm.CleanPlainText(null));
        Assert.Equal(string.Empty, TicketHandoffSwarm.CleanPlainText("  "));

        // 2. BuildSmartHeuristicHandoffEn
        var t1 = new Ticket { TicketNumber = "SW-1", Title = "Test Swarm", Description = null, Priority = null };
        var (sumEn1, actEn1) = TicketHandoffSwarm.BuildSmartHeuristicHandoffEn(t1, 0, null);
        Assert.Contains("No description provided.", sumEn1);
        Assert.Contains("Normal priority", actEn1);

        var prio = new Priority { Name = "High" };
        var t2 = new Ticket { TicketNumber = "SW-2", Title = "Test Swarm 2", Description = "Custom Description", Priority = prio };
        var (sumEn2, actEn2) = TicketHandoffSwarm.BuildSmartHeuristicHandoffEn(t2, 2, new List<string> { "Action 1", "Action 2" });
        Assert.Contains("Custom Description", sumEn2);
        Assert.Contains("Recent Actions and Comments", actEn2);
        Assert.Contains("High priority", actEn2);

        // 3. BuildSmartHeuristicHandoff (TR)
        var (sumTr1, actTr1) = TicketHandoffSwarm.BuildSmartHeuristicHandoff(t1, 0, new List<string>());
        Assert.Contains("Açıklama girilmemiş", sumTr1);
        Assert.Contains("Normal seviyesinde", actTr1);

        var (sumTr2, actTr2) = TicketHandoffSwarm.BuildSmartHeuristicHandoff(t2, 1, new List<string> { "Yorum yapıldı" });
        Assert.Contains("Custom Description", sumTr2);
        Assert.Contains("Son Yapılan İşlemler", actTr2);
        Assert.Contains("High seviyesinde", actTr2);
    }

    [Fact]
    public async Task AssignmentEngine_IsRuleMatch_And_AssignTicketAsync()
    {
        var ticket = new Ticket
        {
            Id = 50,
            ProjectId = 1,
            CategoryId = 2,
            TypeId = 3,
            PriorityId = 4,
            RequesterUserId = 99
        };

        // 1. IsRuleMatch permutations
        var rMatch = new AssignmentRule { ProjectId = 1, CategoryId = 2, TicketTypeId = 3, PriorityId = 4 };
        Assert.True(AssignmentEngine.IsRuleMatch(rMatch, ticket));

        var rDiffProj = new AssignmentRule { ProjectId = 999 };
        Assert.False(AssignmentEngine.IsRuleMatch(rDiffProj, ticket));

        var rDiffCat = new AssignmentRule { CategoryId = 999 };
        Assert.False(AssignmentEngine.IsRuleMatch(rDiffCat, ticket));

        var rDiffType = new AssignmentRule { TicketTypeId = 999 };
        Assert.False(AssignmentEngine.IsRuleMatch(rDiffType, ticket));

        var rDiffPrio = new AssignmentRule { PriorityId = 999 };
        Assert.False(AssignmentEngine.IsRuleMatch(rDiffPrio, ticket));

        // 2. AssignTicketAsync: rule with group only, rule with user only, rule with both
        var engine = new AssignmentEngine(_context);

        // Rule with both target group and target user
        var ruleBoth = new AssignmentRule
        {
            Name = "Rule Both",
            ProjectId = ticket.ProjectId,
            TargetGroupId = 10,
            TargetUserId = 20,
            SortOrder = 1,
            IsActive = true
        };
        _context.AssignmentRules.Add(ruleBoth);
        await _context.SaveChangesAsync();

        await engine.AssignTicketAsync(ticket);
        Assert.Equal(2, ticket.Assignments.Count);
    }

    [Fact]
    public async Task SlaEngine_AllBranchesCoverage()
    {
        // 1. IsWorkingDay
        var hol = new List<Holiday> { new Holiday { Date = new DateTime(2026, 1, 1) } };
        var bh = new List<BusinessHour>
        {
            new BusinessHour { DayOfWeek = DayOfWeek.Monday, IsWorkingDay = true },
            new BusinessHour { DayOfWeek = DayOfWeek.Sunday, IsWorkingDay = false }
        };

        Assert.False(SlaEngine.IsWorkingDay(new DateTime(2026, 1, 1), hol, bh));
        Assert.True(SlaEngine.IsWorkingDay(new DateTime(2026, 1, 5), hol, bh)); // Monday
        Assert.False(SlaEngine.IsWorkingDay(new DateTime(2026, 1, 4), hol, bh)); // Sunday
        Assert.False(SlaEngine.IsWorkingDay(new DateTime(2026, 1, 6), hol, bh)); // Tuesday (missing in bh)

        // 2. ConsumeMinutesWithinDay
        var start = new TimeSpan(9, 0, 0);
        var end = new TimeSpan(17, 0, 0);
        var earlyTime = new DateTime(2026, 1, 5, 8, 0, 0);
        var (tEarly, remEarly) = SlaEngine.ConsumeMinutesWithinDay(earlyTime, 60, start, end);
        Assert.Equal(9, tEarly.Hour);
        Assert.Equal(60, remEarly);

        var lateTime = new DateTime(2026, 1, 5, 18, 0, 0);
        var (tLate, remLate) = SlaEngine.ConsumeMinutesWithinDay(lateTime, 60, start, end);
        Assert.Equal(6, tLate.Day);
        Assert.Equal(60, remLate);

        var midTime = new DateTime(2026, 1, 5, 10, 0, 0);
        var (tMid, remMid) = SlaEngine.ConsumeMinutesWithinDay(midTime, 30, start, end);
        Assert.Equal(30, tMid.Minute);
        Assert.Equal(0, remMid);

        var (tOver, remOver) = SlaEngine.ConsumeMinutesWithinDay(midTime, 600, start, end);
        Assert.True(remOver > 0);

        // 3. EvaluateMetric
        var now = DateTime.UtcNow;
        // Breached, not yet marked
        var res1 = SlaEngine.EvaluateMetric(now.AddMinutes(-5), false, false, now);
        Assert.Equal((false, true), res1);

        // Breached, already marked
        var res2 = SlaEngine.EvaluateMetric(now.AddMinutes(-5), false, true, now);
        Assert.Equal((false, false), res2);

        // Warning triggered (due within warning threshold)
        var res3 = SlaEngine.EvaluateMetric(now.AddMinutes(10), false, false, now, now.AddMinutes(-110));
        Assert.Equal((true, false), res3);

        // Warning already sent
        var res4 = SlaEngine.EvaluateMetric(now.AddMinutes(10), true, false, now);
        Assert.Equal((false, false), res4);

        // Far away from due date
        var res5 = SlaEngine.EvaluateMetric(now.AddHours(20), false, false, now);
        Assert.Equal((false, false), res5);

        // createdAt null branch
        var res6 = SlaEngine.EvaluateMetric(now.AddMinutes(15), false, false, now, null);
        Assert.Equal((true, false), res6);

        // 4. ProcessTicketStatusChangeAsync
        var engine = new SlaEngine(_context, _emailQueueMock.Object as IEmailService ?? Mock.Of<IEmailService>(), Mock.Of<INotificationDispatcher>());

        // Non-existent SLA -> returns early
        await engine.ProcessTicketStatusChangeAsync(999999, 1, 2);

        var sActive = new Status { Name = "Active", PausesSla = false };
        var sPause = new Status { Name = "Paused", PausesSla = true };
        var sClosed = new Status { Name = "Closed", IsClosedStatus = true };
        _context.Statuses.AddRange(sActive, sPause, sClosed);
        await _context.SaveChangesAsync();

        for (int i = 1; i <= 5; i++)
        {
            _context.BusinessHours.Add(new BusinessHour
            {
                DayOfWeek = (DayOfWeek)i,
                IsWorkingDay = true,
                StartTime = new TimeSpan(9, 0, 0),
                EndTime = new TimeSpan(18, 0, 0)
            });
        }
        await _context.SaveChangesAsync();

        var t = new Ticket { TicketNumber = "T-PAUSE-1", Title = "Pause Test", Description = "Desc" };
        _context.Tickets.Add(t);
        await _context.SaveChangesAsync();

        var ticketSla = new TicketSla
        {
            TicketId = t.Id,
            CreatedAt = DateTime.UtcNow.AddHours(-1),
            FirstResponseDueAt = DateTime.UtcNow.AddHours(1),
            ResolutionDueAt = DateTime.UtcNow.AddHours(2)
        };
        _context.TicketSlas.Add(ticketSla);
        await _context.SaveChangesAsync();

        // Pause SLA
        await engine.ProcessTicketStatusChangeAsync(t.Id, sActive.Id, sPause.Id);
        Assert.NotNull(ticketSla.PausedAt);

        // Resume SLA
        await engine.ProcessTicketStatusChangeAsync(t.Id, sPause.Id, sActive.Id);
        Assert.Null(ticketSla.PausedAt);

        // Close ticket -> sets ResolutionMetAt
        await engine.ProcessTicketStatusChangeAsync(t.Id, sActive.Id, sClosed.Id);
        Assert.NotNull(ticketSla.ResolutionMetAt);
    }

    [Fact]
    public async Task UserService_UpdateProfilePhoto_And_GroupMemberships()
    {
        var userRepoMock = new Mock<IRepository<User>>();
        var userService = new UserService(userRepoMock.Object, _context, _httpContextAccessorMock.Object);

        var g1 = new Group { Name = "Group 1" };
        var g2 = new Group { Name = "Group 2" };
        _context.Groups.AddRange(g1, g2);

        var u = new User
        {
            Username = "photo_user",
            Email = "pu@test.com",
            ProfilePhoto = null,
            IsActive = true
        };
        _context.Users.Add(u);
        await _context.SaveChangesAsync();

        // 1. Photo: null -> photo.jpg
        var dto1 = new UpdateUserDto(u.Email, "First", "Last", true, null, "photo.jpg", new[] { g1.Id });
        await userService.UpdateAsync(u.Id, dto1);
        Assert.Equal("photo.jpg", u.ProfilePhoto);

        // 2. Photo: photo.jpg -> photo2.jpg, and change group to g2 (tests added and removed)
        var dto2 = new UpdateUserDto(u.Email, "First", "Last", true, null, "photo2.jpg", new[] { g2.Id, 99999 });
        await userService.UpdateAsync(u.Id, dto2);
        Assert.Equal("photo2.jpg", u.ProfilePhoto);

        // 3. Photo: photo2.jpg -> null, and empty groups
        var dto3 = new UpdateUserDto(u.Email, "First", "Last", true, null, null, Array.Empty<int>());
        await userService.UpdateAsync(u.Id, dto3);
        Assert.Null(u.ProfilePhoto);

        // 4. Same photo (no change branch)
        var dto4 = new UpdateUserDto(u.Email, "First", "Last", true, null, null, Array.Empty<int>());
        await userService.UpdateAsync(u.Id, dto4);
    }

    [Fact]
    public void EmailTemplateService_FileExists_And_Fallback_Branches()
    {
        var service = new EmailTemplateService(NullLogger<EmailTemplateService>.Instance);

        var templateDir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Templates", "Email");
        Directory.CreateDirectory(templateDir);
        var slaPath = Path.Combine(templateDir, "SlaEmailTemplate.html");
        var basePath = Path.Combine(templateDir, "BaseTemplate.html");

        try
        {
            File.WriteAllText(slaPath, "<h1>{{EventName}}</h1><p>{{Context}}</p>");
            File.WriteAllText(basePath, "<h2>{{EventName}}</h2><p>{{Context}}</p>");

            var data = new Dictionary<string, string>
            {
                { "EventName", "SLA Test" },
                { "Context", "Details here" },
                { "AppUrl", "http://test" },
                { "TicketNumber", "T-1" }
            };

            var slaResult = service.GenerateEmailBody("sla.breach", data);
            Assert.Contains("<h1>SLA Test</h1>", slaResult);

            var baseResult = service.GenerateEmailBody("ticket.created", data);
            Assert.Contains("<h2>SLA Test</h2>", baseResult);
        }
        finally
        {
            if (File.Exists(slaPath)) File.Delete(slaPath);
            if (File.Exists(basePath)) File.Delete(basePath);
        }
    }

    [Fact]
    public async Task LocalFileStorageService_And_TokenService_Branches()
    {
        // 1. LocalFileStorageService
        var configMock = new Mock<IConfiguration>();
        var tempDir = Path.Combine(Path.GetTempPath(), Guid.NewGuid().ToString());
        configMock.Setup(c => c["FileStorage:BasePath"]).Returns(tempDir);

        var storage = new LocalFileStorageService(configMock.Object);

        // Disallowed extension throws
        var badFile = new Mock<IFormFile>();
        badFile.Setup(f => f.FileName).Returns("malicious.exe");
        await Assert.ThrowsAsync<InvalidOperationException>(() => storage.SaveFileAsync(badFile.Object, 1));

        // File too large throws
        var largeFile = new Mock<IFormFile>();
        largeFile.Setup(f => f.FileName).Returns("huge.png");
        largeFile.Setup(f => f.Length).Returns(11 * 1024 * 1024);
        await Assert.ThrowsAsync<InvalidOperationException>(() => storage.SaveFileAsync(largeFile.Object, 1));

        // Valid file save
        var validFile = new Mock<IFormFile>();
        validFile.Setup(f => f.FileName).Returns("valid.txt");
        validFile.Setup(f => f.Length).Returns(100);
        validFile.Setup(f => f.CopyToAsync(It.IsAny<Stream>(), It.IsAny<CancellationToken>()))
            .Returns(Task.CompletedTask);

        var savedPath = await storage.SaveFileAsync(validFile.Object, 10);
        Assert.NotNull(savedPath);

        // Delete non-existent file
        await storage.DeleteFileAsync("/non/existent/file.txt");

        // 2. TokenService ExpiryMinutes null fallback & mustChangePassword
        var jwtConfigMock = new Mock<IConfiguration>();
        jwtConfigMock.Setup(c => c["Jwt:Secret"]).Returns("super_secret_jwt_key_that_is_long_enough_for_sha256_32bytes");
        jwtConfigMock.Setup(c => c["Jwt:Issuer"]).Returns("ItsTool");
        jwtConfigMock.Setup(c => c["Jwt:Audience"]).Returns("ItsToolUsers");
        jwtConfigMock.Setup(c => c["Jwt:ExpiryMinutes"]).Returns((string?)null); // tests ?? "120"

        var tokenService = new TokenService(jwtConfigMock.Object);
        var token = tokenService.GenerateToken(1, "user", new[] { "Admin" }, new[] { "ticket.view" }, true);
        Assert.NotNull(token);
    }

    [Fact]
    public async Task TicketQueryHelpers_AllBranchesCoverage()
    {
        var u1 = new User { Id = 1, Username = "u1" };
        var u2 = new User { Id = 2, Username = "u2" };
        _context.Users.AddRange(u1, u2);
        var group = new Group { Id = 1, Name = "G1" };
        _context.Groups.Add(group);
        _context.GroupMembers.Add(new GroupMember { UserId = 1, GroupId = 1 });
        await _context.SaveChangesAsync();

        var t1 = new Ticket { Id = 1, TicketNumber = "T-001", Title = "Alpha Issue", Description = "Alpha Desc", RequesterUserId = 1, ProjectId = 1, CategoryId = 1, TypeId = 1, StatusId = 1, PriorityId = 1, CreatedAt = new DateTime(2026, 1, 1) };
        var t2 = new Ticket { Id = 2, TicketNumber = "T-002", Title = "Beta Issue", Description = "Beta Desc", RequesterUserId = 2, ProjectId = 2, CategoryId = 2, TypeId = 2, StatusId = 2, PriorityId = 2, CreatedAt = new DateTime(2026, 2, 1) };
        _context.Tickets.AddRange(t1, t2);
        await _context.SaveChangesAsync();

        // 1. ApplySecurityScopeAsync
        var q = _context.Tickets.AsQueryable();

        // with report.view perm
        var resAll = await TicketQueryHelpers.ApplySecurityScopeAsync(q, new HashSet<string> { "report.view" }, 1, _context);
        Assert.Equal(2, await resAll.CountAsync());

        // with agent perms (ticket.manage)
        var resAgent = await TicketQueryHelpers.ApplySecurityScopeAsync(q, new HashSet<string> { "ticket.manage" }, 1, _context);
        Assert.NotNull(resAgent);

        // normal user (no agent perms)
        var resUser = await TicketQueryHelpers.ApplySecurityScopeAsync(q, new HashSet<string>(), 1, _context);
        Assert.Single(await resUser.ToListAsync());

        // 2. ApplyBasicFilters with all parameters
        var filterAll = new TicketSearchFilterDto
        {
            ProjectId = 1,
            CategoryId = 1,
            TypeId = 1,
            StatusId = 1,
            PriorityId = 1,
            AssigneeUserId = 1,
            RequesterUserId = 1,
            FromDate = new DateTime(2025, 1, 1),
            ToDate = new DateTime(2027, 1, 1),
            Unassigned = true,
            ExcludeStatusId = 5
        };
        var filteredBasic = TicketQueryHelpers.ApplyBasicFilters(q, filterAll);
        Assert.NotNull(filteredBasic);

        // 3. ApplyKeywordAndSlaFilters
        var filterKw = new TicketSearchFilterDto { Keyword = "Alpha" };
        var resKw = TicketQueryHelpers.ApplyKeywordAndSlaFilters(q, filterKw);
        Assert.Single(resKw);

        var filterBreached = new TicketSearchFilterDto { SlaStatus = "breached" };
        Assert.NotNull(TicketQueryHelpers.ApplyKeywordAndSlaFilters(q, filterBreached));

        var filterWarning = new TicketSearchFilterDto { SlaStatus = "warning" };
        Assert.NotNull(TicketQueryHelpers.ApplyKeywordAndSlaFilters(q, filterWarning));

        var filterOnTrack = new TicketSearchFilterDto { SlaStatus = "ontrack" };
        Assert.NotNull(TicketQueryHelpers.ApplyKeywordAndSlaFilters(q, filterOnTrack));

        var filterOther = new TicketSearchFilterDto { SlaStatus = "unknown_status" };
        Assert.NotNull(TicketQueryHelpers.ApplyKeywordAndSlaFilters(q, filterOther));
    }

    [Fact]
    public async Task PermissionAuthorizationHandler_AllClaimAndRoleBranches()
    {
        var handler = new PermissionAuthorizationHandler();
        var requirement = new PermissionRequirement("ticket.view");

        // 1. IsInRole("SuperAdmin")
        var userInRole = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim(ClaimTypes.Role, "SuperAdmin") }, "test", ClaimTypes.Name, ClaimTypes.Role));
        var ctx1 = new AuthorizationHandlerContext(new[] { requirement }, userInRole, null);
        await handler.HandleAsync(ctx1);
        Assert.True(ctx1.HasSucceeded);

        // 2. Claim "role" = "SuperAdmin"
        var userRoleClaim = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim("role", "superadmin") }));
        var ctx2 = new AuthorizationHandlerContext(new[] { requirement }, userRoleClaim, null);
        await handler.HandleAsync(ctx2);
        Assert.True(ctx2.HasSucceeded);

        // 3. Ws-Fed role claim = "SuperAdmin"
        var userWsRole = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim("http://schemas.microsoft.com/ws/2008/06/identity/claims/role", "SuperAdmin") }));
        var ctx3 = new AuthorizationHandlerContext(new[] { requirement }, userWsRole, null);
        await handler.HandleAsync(ctx3);
        Assert.True(ctx3.HasSucceeded);

        // 4. Matching permission claim
        var userPerm = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim("permission", "ticket.view") }));
        var ctx4 = new AuthorizationHandlerContext(new[] { requirement }, userPerm, null);
        await handler.HandleAsync(ctx4);
        Assert.True(ctx4.HasSucceeded);

        // 5. Non-matching permission claim
        var userBadPerm = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim("permission", "other.action"), new Claim("role", "Agent") }));
        var ctx5 = new AuthorizationHandlerContext(new[] { requirement }, userBadPerm, null);
        await handler.HandleAsync(ctx5);
        Assert.False(ctx5.HasSucceeded);
    }

    [Fact]
    public async Task Controllers_GetCurrentUserId_And_RolePermissionBranches()
    {
        // 1. KnowledgeBaseController GetCurrentUserId
        var kbServiceMock = new Mock<IKnowledgeBaseService>();
        var kbController = new KnowledgeBaseController(kbServiceMock.Object);

        // No claims -> id = 0
        kbController.ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext { User = new ClaimsPrincipal() } };
        await kbController.SearchArticles("test", null);
        kbServiceMock.Verify(s => s.SearchArticlesAsync(0, "test", null), Times.Once);

        // Sub claim non-int -> id = 0
        var userBadSub = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim(ClaimTypes.NameIdentifier, "non_int") }));
        kbController.ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext { User = userBadSub } };
        await kbController.SearchArticles("test", null);

        // Sub claim valid int via UserId claim -> id = 42
        var userGoodSub = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim("UserId", "42") }));
        kbController.ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext { User = userGoodSub } };
        await kbController.SearchArticles("test", null);
        kbServiceMock.Verify(s => s.SearchArticlesAsync(42, "test", null), Times.Once);

        // 2. TicketController GetCurrentUserId & Delete/Restore permission branches
        var ticketServiceMock = new Mock<ITicketService>();
        var ticketController = new TicketController(ticketServiceMock.Object);

        // Empty user -> GetCurrentUserId returns 0, DeleteTicket forbidden
        ticketController.ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext { User = new ClaimsPrincipal() } };
        var delForbid = await ticketController.DeleteTicket(1);
        Assert.IsType<ForbidResult>(delForbid);

        var resForbid = await ticketController.RestoreTicket(1);
        Assert.IsType<ForbidResult>(resForbid);

        // User with Manager role
        var userMgr = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim(ClaimTypes.Role, "Manager"), new Claim(ClaimTypes.NameIdentifier, "100") }, "test", ClaimTypes.Name, ClaimTypes.Role));
        ticketController.ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext { User = userMgr } };
        var delSuccess = await ticketController.DeleteTicket(1);
        Assert.IsType<NoContentResult>(delSuccess);
        var resSuccess = await ticketController.RestoreTicket(1);
        Assert.IsType<NoContentResult>(resSuccess);

        // User with permission claim "ticket.delete"
        var userPerm = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim("permissions", "ticket.delete"), new Claim(ClaimTypes.NameIdentifier, "abc") })); // non-int claim
        ticketController.ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext { User = userPerm } };
        await ticketController.DeleteTicket(1);

        // AssignTicket with null UserIds and null GroupIds
        await ticketController.AssignTicket(1, new TicketController.AssignTicketRequest(null!, null!, null));
        ticketServiceMock.Verify(s => s.AssignTicketAsync(1, It.IsAny<AssignTicketDto>()), Times.Once);

        // 3. SavedFilterController GetCurrentUserId
        var filterController = new SavedFilterController(_context);
        filterController.ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext { User = new ClaimsPrincipal() } };
        var myFilters = await filterController.GetMyFilters();
        Assert.NotNull(myFilters);

        // 4. NotificationsController GetCurrentUserId
        var notifServiceMock = new Mock<INotificationService>();
        notifServiceMock.Setup(s => s.GetUserNotificationsAsync(It.IsAny<int>())).ReturnsAsync(new List<NotificationDto>());
        var notifController = new NotificationsController(notifServiceMock.Object);
        notifController.ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext { User = new ClaimsPrincipal() } };
        await notifController.GetMyNotifications();
        notifServiceMock.Verify(s => s.GetUserNotificationsAsync(0), Times.Once);

        // 5. ReportsController GetCurrentUserId
        var reportServiceMock = new Mock<IReportService>();
        reportServiceMock.Setup(s => s.ExportTicketsToCsvAsync(It.IsAny<TicketSearchFilterDto>(), It.IsAny<int>()))
            .ReturnsAsync(new MemoryStream(Encoding.UTF8.GetBytes("CSV,Data")));
        var reportController = new ReportsController(reportServiceMock.Object);
        reportController.ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext { User = new ClaimsPrincipal() } };
        await reportController.ExportTicketsCsv(new TicketSearchFilterDto());
        reportServiceMock.Verify(s => s.ExportTicketsToCsvAsync(It.IsAny<TicketSearchFilterDto>(), 0), Times.Once);

        // 6. DashboardController GetCurrentUserId
        var dashServiceMock = new Mock<IDashboardService>();
        var dashController = new DashboardController(dashServiceMock.Object);
        dashController.ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext { User = new ClaimsPrincipal() } };
        await dashController.GetOverview();
        dashServiceMock.Verify(s => s.GetOverviewAsync(0), Times.Once);

        // 7. SystemController TestDatabaseConnection
        var seeder = new DataSeeder(_context);
        var sysController = new SystemController(seeder, _context);
        var dbRes = sysController.TestDatabaseConnection();
        Assert.NotNull(dbRes);
    }
}
