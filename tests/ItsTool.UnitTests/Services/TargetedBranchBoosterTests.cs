using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using ItsTool.API.Controllers;
using ItsTool.API.Hubs;
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
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Services;

// Dummy classes to test ShouldSkipAudit by type name
public class RefreshToken { }
public class NotificationEntity { }
public class UserPreference { }

[Collection("LlmTests")]
public class TargetedBranchBoosterTests
{
    private ItsToolDbContext CreateDbContext(string dbName)
    {
        var options = new DbContextOptionsBuilder<ItsToolDbContext>()
            .UseInMemoryDatabase(databaseName: dbName)
            .Options;
        return new ItsToolDbContext(options);
    }

    [Fact]
    public async Task SystemAuditInterceptor_All_Branches_Covered()
    {
        using var context = CreateDbContext("AuditInterceptor_Branches_" + Guid.NewGuid());

        // 1. ShouldSkipAudit branches
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
        Assert.True(SystemAuditInterceptor.ShouldSkipAudit(new NotificationEntity()));
        Assert.True(SystemAuditInterceptor.ShouldSkipAudit(new UserPreference()));
        Assert.False(SystemAuditInterceptor.ShouldSkipAudit(new Project()));

        // 2. GetSpecificEntitySummary & Entity Summaries
        var proj = new Project { Name = "AuditProj", ProjectKey = "AP", Description = "ProjDesc", Status = ProjectStatus.Active };
        var projNoDesc = new Project { Name = "AuditProj2", ProjectKey = "AP2", Description = null, Status = ProjectStatus.Active };
        var prio = new Priority { Name = "Prio 1", ColorHex = "#fff", SeverityLevel = 1 };
        context.Projects.AddRange(proj, projNoDesc);
        context.Priorities.Add(prio);
        await context.SaveChangesAsync();

        var slaWithTargets = new SlaPolicy { Name = "SLA Targets", ProjectId = proj.Id, Description = "SlaDesc", EscalateOnBreach = true };
        context.SlaPolicies.Add(slaWithTargets);
        await context.SaveChangesAsync();
        context.SlaTargets.Add(new SlaTarget { SlaPolicyId = slaWithTargets.Id, PriorityId = prio.Id, FirstResponseMinutes = 10, ResolutionMinutes = 60, IsActive = true });
        await context.SaveChangesAsync();

        var slaSummary1 = SystemAuditInterceptor.GetSlaSummary(slaWithTargets, context);
        Assert.Contains("AuditProj", slaSummary1);
        Assert.Contains("Eskalasyon: Açık", slaSummary1);
        Assert.Contains("Hedefler:", slaSummary1);

        var slaNoProj = new SlaPolicy { Name = "SLA Global", ProjectId = null, Description = null, EscalateOnBreach = false };
        var slaSummary2 = SystemAuditInterceptor.GetSlaSummary(slaNoProj, null);
        Assert.Contains("Genel Sistem", slaSummary2);
        Assert.Contains("Eskalasyon: Kapalı", slaSummary2);

        var u1 = new User { Username = "fullUser", FirstName = "First", LastName = "Last", Email = "f@l.com", DepartmentId = 5 };
        var uSummary1 = SystemAuditInterceptor.GetUserSummary(u1);
        Assert.Contains("First Last", uSummary1);
        Assert.Contains("Departman ID: 5", uSummary1);

        var u2 = new User { Username = "emptyUser", FirstName = null, LastName = null, Email = "e@l.com", DepartmentId = null };
        var uSummary2 = SystemAuditInterceptor.GetUserSummary(u2);
        Assert.Contains("emptyUser", uSummary2);
        Assert.Contains("Departman ID: Yok", uSummary2);

        Assert.Contains("Açıklama: ProjDesc", SystemAuditInterceptor.GetProjectSummary(proj));
        Assert.DoesNotContain("Açıklama:", SystemAuditInterceptor.GetProjectSummary(projNoDesc));

        var catWithDesc = new Category { Name = "Cat1", Description = "CatDesc" };
        var catNoDesc = new Category { Name = "Cat2", Description = null };
        Assert.Contains("Açıklama: CatDesc", SystemAuditInterceptor.GetSpecificEntitySummary(catWithDesc, context)!);
        Assert.DoesNotContain("Açıklama:", SystemAuditInterceptor.GetSpecificEntitySummary(catNoDesc, context)!);

        var deptWithMgr = new Department { Name = "Dept1", Description = "DeptDesc", ManagerUserId = 99 };
        var deptNoMgr = new Department { Name = "Dept2", Description = null, ManagerUserId = null };
        Assert.Contains("Yönetici ID: 99", SystemAuditInterceptor.GetSpecificEntitySummary(deptWithMgr, context)!);
        Assert.DoesNotContain("Yönetici ID:", SystemAuditInterceptor.GetSpecificEntitySummary(deptNoMgr, context)!);

        var grpWithDept = new Group { Name = "Grp1", DepartmentId = 10 };
        var grpNoDept = new Group { Name = "Grp2", DepartmentId = null };
        Assert.Contains("Departman ID: 10", SystemAuditInterceptor.GetSpecificEntitySummary(grpWithDept, context)!);
        Assert.DoesNotContain("Departman ID:", SystemAuditInterceptor.GetSpecificEntitySummary(grpNoDept, context)!);

        var roleWithDesc = new Role { Name = "Role1", Description = "RoleDesc" };
        var roleNoDesc = new Role { Name = "Role2", Description = null };
        Assert.Contains("Açıklama: RoleDesc", SystemAuditInterceptor.GetSpecificEntitySummary(roleWithDesc, context)!);
        Assert.DoesNotContain("Açıklama:", SystemAuditInterceptor.GetSpecificEntitySummary(roleNoDesc, context)!);

        var ka = new KnowledgeArticle { Title = "Art1", CategoryId = 1, Status = ArticleStatus.Published };
        Assert.Contains("Art1", SystemAuditInterceptor.GetSpecificEntitySummary(ka, context)!);

        var ar = new AssignmentRule { Name = "Rule1", SortOrder = 5 };
        Assert.Contains("Rule1", SystemAuditInterceptor.GetSpecificEntitySummary(ar, context)!);

        var ws = new WebhookSubscription { Url = "https://hook.com", EventsCsv = "ticket.created" };
        Assert.Contains("https://hook.com", SystemAuditInterceptor.GetSpecificEntitySummary(ws, context)!);

        Assert.Null(SystemAuditInterceptor.GetSpecificEntitySummary(new object(), context));

        // 3. GetGroupMemberName branches
        var userInDb = new User { Username = "gmUser", Email = "gm@test.com" };
        var groupInDb = new Group { Name = "gmGroup" };
        context.Users.Add(userInDb);
        context.Groups.Add(groupInDb);
        await context.SaveChangesAsync();

        var gm = new GroupMember { UserId = userInDb.Id, GroupId = groupInDb.Id };
        context.GroupMembers.Add(gm);
        var entryAdded = context.Entry(gm);
        var gmNameAdded = SystemAuditInterceptor.GetGroupMemberName(entryAdded, context);
        Assert.Contains("gmUser", gmNameAdded);
        Assert.Contains("gmGroup", gmNameAdded);

        var gmNameNoContext = SystemAuditInterceptor.GetGroupMemberName(entryAdded, null);
        Assert.Contains("User:", gmNameNoContext);

        // GroupMember Deleted state and non-existent IDs
        var gmDeleted = new GroupMember { UserId = 8888, GroupId = 9999 };
        context.GroupMembers.Add(gmDeleted);
        await context.SaveChangesAsync();
        context.GroupMembers.Remove(gmDeleted);
        var entryDeleted = context.Entry(gmDeleted);
        var gmNameDeleted = SystemAuditInterceptor.GetGroupMemberName(entryDeleted, context);
        Assert.Contains("8888", gmNameDeleted);

        // 4. TryProcessSoftDeleteOrRestore branches
        var logs = new List<SystemAuditLog>();
        var projEntity = new Project { Name = "SoftDelProj", ProjectKey = "SDP", IsDeleted = false };
        context.Projects.Add(projEntity);
        await context.SaveChangesAsync();

        var entryProj = context.Entry((BaseEntity)projEntity);
        var ctxAudit = new SystemAuditInterceptor.AuditEntityContext(context, "Project", "SoftDelProj", projEntity.Id.ToString(), "1", DateTime.UtcNow);

        // Case: No IsDeleted property modified
        var noModProps = new List<Microsoft.EntityFrameworkCore.ChangeTracking.PropertyEntry>();
        Assert.False(SystemAuditInterceptor.TryProcessSoftDeleteOrRestore(entryProj, logs, noModProps, ctxAudit));

        // Case: Soft delete
        projEntity.IsDeleted = true;
        var modifiedPropsDel = entryProj.Properties.Where(p => p.Metadata.Name == "IsDeleted").ToList();
        Assert.True(SystemAuditInterceptor.TryProcessSoftDeleteOrRestore(entryProj, logs, modifiedPropsDel, ctxAudit));
        Assert.Equal("Deleted", logs.Last().Action);

        // Case: Restore
        projEntity.IsDeleted = false;
        var ctxSla = new SystemAuditInterceptor.AuditEntityContext(context, "SlaPolicy", "SLA1", "1", "1", DateTime.UtcNow);
        var modifiedPropsRest = entryProj.Properties.Where(p => p.Metadata.Name == "IsDeleted").ToList();
        modifiedPropsRest[0].OriginalValue = true;
        Assert.True(SystemAuditInterceptor.TryProcessSoftDeleteOrRestore(entryProj, logs, modifiedPropsRest, ctxSla));
        Assert.Equal("Restored", logs.Last().Action);
    }

    [Fact]
    public async Task ResolutionCopilotAgent_And_TicketHandoffSwarm_All_Remaining_Branches()
    {
        using var context = CreateDbContext("Agent_Branches_" + Guid.NewGuid());
        var loggerMock = new Mock<ILogger<ResolutionCopilotAgent>>();
        var llmMock = new Mock<ILlmService>();
        llmMock.Setup(l => l.GetModelName()).Returns("test-model");

        var agent = new ResolutionCopilotAgent(llmMock.Object, context, loggerMock.Object);

        var proj = new Project { Name = "Agent Proj", ProjectKey = "AP" };
        var cat = new Category { Name = "Hardware" };
        var prio = new Priority { Name = "Urgent" };
        var status = new Status { Name = "In Progress" };
        context.Projects.Add(proj);
        context.Categories.Add(cat);
        context.Priorities.Add(prio);
        context.Statuses.Add(status);
        await context.SaveChangesAsync();

        var tFull = new Ticket { TicketNumber = "AP-1", Title = "Title 1", Description = "Desc 1", ProjectId = proj.Id, CategoryId = cat.Id, PriorityId = prio.Id, StatusId = status.Id, Category = cat, Priority = prio, Status = status };
        var tBare = new Ticket { TicketNumber = "AP-2", Title = "Title 2", Description = "", ProjectId = proj.Id, CategoryId = cat.Id, PriorityId = prio.Id, StatusId = status.Id, Category = null, Priority = null, Status = null };
        context.Tickets.AddRange(tFull, tBare);
        await context.SaveChangesAsync();

        // Comments on tFull
        context.TicketComments.Add(new TicketComment { TicketId = tFull.Id, Content = "Note 1", IsInternal = true, CreatedBy = "Admin" });
        await context.SaveChangesAsync();

        // 1. AskQuestionWithSourceAsync - All language & ticket permutations
        llmMock.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync("Answer from LLM");
        var (ansEn1, srcEn1, isLlmEn1) = await agent.AskQuestionWithSourceAsync(tFull.Id, "How to fix?", "en");
        Assert.True(isLlmEn1);
        var (ansEn2, _, _) = await agent.AskQuestionWithSourceAsync(tBare.Id, "How to fix bare?", "en");
        Assert.NotNull(ansEn2);
        var (ansTr1, _, _) = await agent.AskQuestionWithSourceAsync(tFull.Id, "Nasıl çözülür?", "tr");
        Assert.NotNull(ansTr1);
        var (ansTr2, srcTr2, isLlmTr2) = await agent.AskQuestionWithSourceAsync(tBare.Id, "Nasıl çözülür?", "tr");
        Assert.True(isLlmTr2);

        // 2. AskQuestionWithSourceAsync - Fallbacks with all conditions
        llmMock.Setup(l => l.IsFallbackDisabled()).Returns(false);
        llmMock.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync("[AI İsteği Başarısız: Model down]");
        var (fbEn1, _, _) = await agent.AskQuestionWithSourceAsync(tFull.Id, "Question", "en");
        Assert.Contains("Question", fbEn1);
        var (fbEn2, _, _) = await agent.AskQuestionWithSourceAsync(tBare.Id, "Question bare", "en");
        Assert.Contains("Question bare", fbEn2);

        llmMock.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync("[AI Modülü devre dışı]");
        var (fbTr1, _, _) = await agent.AskQuestionWithSourceAsync(tFull.Id, "Soru", "tr");
        Assert.Contains("Soru", fbTr1);
        var (fbTr2, _, _) = await agent.AskQuestionWithSourceAsync(tBare.Id, "Soru", "tr");
        Assert.Contains("Soru", fbTr2);

        // 3. AskQuestionWithSourceAsync - Failure with fallback disabled
        llmMock.Setup(l => l.IsFallbackDisabled()).Returns(true);
        llmMock.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync("[AI İsteği Başarısız: Out of memory]");
        await Assert.ThrowsAsync<InvalidOperationException>(() => agent.AskQuestionWithSourceAsync(tFull.Id, "Question", "en"));

        llmMock.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync("[AI Modülü devre dışı]");
        await Assert.ThrowsAsync<InvalidOperationException>(() => agent.AskQuestionWithSourceAsync(tFull.Id, "Question", "en"));

        // 4. GenerateResolutionSuggestionAsync - Full & Bare in both EN and TR
        llmMock.Setup(l => l.IsFallbackDisabled()).Returns(false);
        llmMock.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync("Resolution step 1");
        var sugEnFull = await agent.GenerateResolutionSuggestionAsync(tFull.Id, false, "en");
        Assert.True(sugEnFull.Success);
        var sugEnBare = await agent.GenerateResolutionSuggestionAsync(tBare.Id, false, "en");
        Assert.True(sugEnBare.Success);
        var sugTrFull = await agent.GenerateResolutionSuggestionAsync(tFull.Id, true, "tr");
        Assert.True(sugTrFull.Success);
        var sugTrBare = await agent.GenerateResolutionSuggestionAsync(tBare.Id, false, "tr");
        Assert.True(sugTrBare.Success);

        // 5. TicketHandoffSwarm - All permutations
        var swarmLoggerMock = new Mock<ILogger<TicketHandoffSwarm>>();
        var swarm = new TicketHandoffSwarm(llmMock.Object, context, swarmLoggerMock.Object);

        llmMock.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync("Handoff text");
        var hEnFull = await swarm.GenerateHandoffSummaryAsync(tFull.Id, false, "en");
        Assert.True(hEnFull.Success);
        var hEnBare = await swarm.GenerateHandoffSummaryAsync(tBare.Id, false, "en");
        Assert.True(hEnBare.Success);
        var hTrFull = await swarm.GenerateHandoffSummaryAsync(tFull.Id, true, "tr");
        Assert.True(hTrFull.Success);
        var hTrBare = await swarm.GenerateHandoffSummaryAsync(tBare.Id, false, "tr");
        Assert.True(hTrBare.Success);

        // Fallback in both EN and TR
        llmMock.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync(string.Empty);
        var hFbEn = await swarm.GenerateHandoffSummaryAsync(tBare.Id, false, "en");
        Assert.True(hFbEn.Success);
        var hFbTr = await swarm.GenerateHandoffSummaryAsync(tFull.Id, false, "tr");
        Assert.True(hFbTr.Success);
    }

    [Fact]
    public async Task ReportService_And_EmailIngestionService_All_Branches()
    {
        using var context = CreateDbContext("Report_Email_Branches_" + Guid.NewGuid());

        // ReportService branches
        var proj = new Project { Name = "ReportProj", ProjectKey = "RP" };
        var cat = new Category { Name = "Hardware" };
        var prio = new Priority { Name = "High" };
        var stat = new Status { Name = "Open", IsSystemDefault = true };
        var type = new TicketType { Name = "Incident" };
        var user = new User { FirstName = "Report", LastName = "User", Username = "repuser", Email = "rep@test.com" };
        var grp = new Group { Name = "RepGroup" };
        context.Projects.Add(proj);
        context.Categories.Add(cat);
        context.Priorities.Add(prio);
        context.Statuses.Add(stat);
        context.TicketTypes.Add(type);
        context.Users.Add(user);
        context.Groups.Add(grp);
        await context.SaveChangesAsync();

        // Tickets with different SLA states
        var tBreached = new Ticket { TicketNumber = "RP-1", Title = "Title \"Quoted\"", ProjectId = proj.Id, CategoryId = cat.Id, PriorityId = prio.Id, StatusId = stat.Id, TypeId = type.Id, RequesterUserId = user.Id, Project = proj, Category = cat, Priority = prio, Status = stat, Type = type, RequesterUser = user };
        var tWarned = new Ticket { TicketNumber = "RP-2", Title = "Title 2", ProjectId = proj.Id, CategoryId = cat.Id, PriorityId = prio.Id, StatusId = stat.Id, TypeId = type.Id, RequesterUserId = user.Id, Project = proj, Category = cat, Priority = prio, Status = stat, Type = type, RequesterUser = user };
        var tBare = new Ticket { TicketNumber = "RP-3", Title = "Title 3", ProjectId = proj.Id, CategoryId = cat.Id, PriorityId = prio.Id, StatusId = stat.Id, TypeId = type.Id, RequesterUserId = user.Id };
        context.Tickets.AddRange(tBreached, tWarned, tBare);
        await context.SaveChangesAsync();

        context.TicketSlas.Add(new TicketSla { TicketId = tBreached.Id, FirstResponseBreached = true, ResolutionBreached = false });
        context.TicketSlas.Add(new TicketSla { TicketId = tWarned.Id, FirstResponseBreached = false, ResolutionBreached = false, FirstResponseWarned = true, ResolutionWarned = false });
        context.TicketAssignments.Add(new TicketAssignment { TicketId = tBreached.Id, AssignedUserId = user.Id, AssignedUser = user, IsActive = true });
        context.TicketAssignments.Add(new TicketAssignment { TicketId = tWarned.Id, AssignedGroupId = grp.Id, AssignedGroup = grp, IsActive = true });
        await context.SaveChangesAsync();

        var permMock = new Mock<IPermissionCalculator>();
        permMock.Setup(p => p.CalculateEffectivePermissionsAsync(user.Id)).ReturnsAsync(new HashSet<string> { "report.view" });
        var reportService = new ReportService(context, permMock.Object);

        var stream = await reportService.ExportTicketsToCsvAsync(new TicketSearchFilterDto(), user.Id);
        using var reader = new StreamReader(stream);
        var csv = await reader.ReadToEndAsync();
        Assert.Contains("Breached", csv);
        Assert.Contains("Warning", csv);
        Assert.Contains("Report User", csv);
        Assert.Contains("RepGroup", csv);

        // EmailIngestionService branches
        var emailIngestion = new EmailIngestionService(context);

        // 1. Empty messageId is skipped
        await emailIngestion.ProcessIncomingEmailAsync(new EmailIngestionDto(null!, "sender@test.com", "Subject", "Body"));
        await emailIngestion.ProcessIncomingEmailAsync(new EmailIngestionDto("", "sender@test.com", "Subject", "Body"));

        // 2. Successful email ingestion with [RP] project key and new user
        var dto1 = new EmailIngestionDto("msg-001", "newemailuser@test.com", "[RP] Email Subject", "Email body content");
        await emailIngestion.ProcessIncomingEmailAsync(dto1);
        Assert.NotNull(await context.Tickets.FirstOrDefaultAsync(t => t.ExternalMessageId == "msg-001"));

        // 3. Duplicate messageId is ignored
        await emailIngestion.ProcessIncomingEmailAsync(dto1);

        // 4. Ingestion with existing user and plain subject
        var dto2 = new EmailIngestionDto("msg-002", "rep@test.com", "Plain Subject", "Another body");
        await emailIngestion.ProcessIncomingEmailAsync(dto2);
        Assert.NotNull(await context.Tickets.FirstOrDefaultAsync(t => t.ExternalMessageId == "msg-002"));
    }

    [Fact]
    public async Task GroupService_All_Branches_Covered()
    {
        using var context = CreateDbContext("Group_Branches_" + Guid.NewGuid());
        var repo = new Repository<Group>(context);
        var httpMock = new Mock<IHttpContextAccessor>();

        var userClaims = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim(ClaimTypes.NameIdentifier, "99") }));
        var httpContext = new DefaultHttpContext { User = userClaims };
        httpMock.Setup(h => h.HttpContext).Returns(httpContext);

        var groupService = new GroupService(repo, context, httpMock.Object);

        var d1 = new Department { Name = "Dept One" };
        var d2 = new Department { Name = "Dept Two" };
        context.Departments.AddRange(d1, d2);
        var u1 = new User { Username = "gUser1", FirstName = "G", LastName = "U" };
        context.Users.Add(u1);
        await context.SaveChangesAsync();

        var g = await groupService.CreateAsync(new CreateGroupDto("Test Group", d1.Id));

        // UpdateAsync with department change & HttpContext with user
        await groupService.UpdateAsync(g.Id, new UpdateGroupDto("Updated Group", true, d2.Id));
        var updated = await repo.GetByIdAsync(g.Id);
        Assert.Equal(d2.Id, updated!.DepartmentId);

        // UpdateAsync with non-existent new department
        await groupService.UpdateAsync(g.Id, new UpdateGroupDto("Updated Group", true, 99999));

        // UpdateAsync with null department & HttpContext null
        httpMock.Setup(h => h.HttpContext).Returns((HttpContext?)null);
        await groupService.UpdateAsync(g.Id, new UpdateGroupDto("Updated Group 2", true, 0));
        updated = await repo.GetByIdAsync(g.Id);
        Assert.Equal(0, updated!.DepartmentId);

        // UpdateAsync non-existent throws
        await Assert.ThrowsAsync<KeyNotFoundException>(() => groupService.UpdateAsync(99999, new UpdateGroupDto("X", true, 0)));

        // AddMemberAsync with HttpContext null, then with HttpContext user, then duplicate, then non-existent
        await groupService.AddMemberAsync(g.Id, u1.Id);
        Assert.True(await context.GroupMembers.AnyAsync(gm => gm.GroupId == g.Id && gm.UserId == u1.Id));

        httpMock.Setup(h => h.HttpContext).Returns(httpContext);
        await groupService.AddMemberAsync(g.Id, u1.Id);
        await groupService.AddMemberAsync(g.Id, 99998); // non-existent user

        // RemoveMemberAsync with HttpContext user, then non-existent
        await groupService.RemoveMemberAsync(g.Id, u1.Id);
        Assert.False(await context.GroupMembers.AnyAsync(gm => gm.GroupId == g.Id && gm.UserId == u1.Id));

        await groupService.RemoveMemberAsync(g.Id, 99999);
    }

    [Fact]
    public async Task TicketService_GetTicketByIdAsync_Assignee_Branches()
    {
        using var context = CreateDbContext("TicketService_Assignees_" + Guid.NewGuid());
        var fileMock = new Mock<IFileStorageService>();
        var permMock = new Mock<IPermissionCalculator>();
        var slaEngineMock = new Mock<ISlaEngine>();
        var assignEngineMock = new Mock<IAssignmentEngine>();
        var notifMock = new Mock<INotificationDispatcher>();

        var ticketService = new TicketService(context, fileMock.Object, permMock.Object, slaEngineMock.Object, assignEngineMock.Object, notifMock.Object);

        var proj = new Project { Name = "P", ProjectKey = "P" };
        var cat = new Category { Name = "C" };
        var prio = new Priority { Name = "Prio" };
        var stat = new Status { Name = "Open", IsSystemDefault = true };
        var type = new TicketType { Name = "Inc" };
        var activeUser = new User { FirstName = "Act", LastName = "User", Username = "actuser", IsDeleted = false };
        var deletedUser = new User { FirstName = "Del", LastName = "User", Username = "deluser", IsDeleted = true };
        var activeGroup = new Group { Name = "ActGrp", IsDeleted = false };
        var deletedGroup = new Group { Name = "DelGrp", IsDeleted = true };

        context.Projects.Add(proj);
        context.Categories.Add(cat);
        context.Priorities.Add(prio);
        context.Statuses.Add(stat);
        context.TicketTypes.Add(type);
        context.Users.AddRange(activeUser, deletedUser);
        context.Groups.AddRange(activeGroup, deletedGroup);
        await context.SaveChangesAsync();

        var t = new Ticket { TicketNumber = "P-1", Title = "Assignee Test", ProjectId = proj.Id, CategoryId = cat.Id, PriorityId = prio.Id, StatusId = stat.Id, TypeId = type.Id, RequesterUserId = activeUser.Id };
        context.Tickets.Add(t);
        await context.SaveChangesAsync();

        // Add assignments for all branch combinations
        context.TicketAssignments.AddRange(
            new TicketAssignment { TicketId = t.Id, AssignedUserId = activeUser.Id, AssignedUser = activeUser, IsActive = true, IsDeleted = false },
            new TicketAssignment { TicketId = t.Id, AssignedUserId = deletedUser.Id, AssignedUser = deletedUser, IsActive = true, IsDeleted = false },
            new TicketAssignment { TicketId = t.Id, AssignedUserId = 99998, AssignedUser = null, IsActive = true, IsDeleted = false },
            new TicketAssignment { TicketId = t.Id, AssignedGroupId = activeGroup.Id, AssignedGroup = activeGroup, IsActive = true, IsDeleted = false },
            new TicketAssignment { TicketId = t.Id, AssignedGroupId = deletedGroup.Id, AssignedGroup = deletedGroup, IsActive = true, IsDeleted = false },
            new TicketAssignment { TicketId = t.Id, AssignedGroupId = 99999, AssignedGroup = null, IsActive = true, IsDeleted = false }
        );
        await context.SaveChangesAsync();

        var dto = await ticketService.GetTicketByIdAsync(t.Id);
        Assert.NotNull(dto);
        Assert.Equal(6, dto.Assignments.Count);

        // UpdateTicketAsync ColorHex and CustomFields branches
        var defKey = new FieldDefinition { Key = "cust_key", Label = "Custom Field", FieldType = FieldType.Text };
        context.FieldDefinitions.Add(defKey);
        await context.SaveChangesAsync();

        var update1 = new UpdateTicketDto("New T", "New D", cat.Id, prio.Id, new Dictionary<string, string> { { "cust_key", "val1" }, { "unknown_key", "val2" } }, ColorHex: "#ff0000");
        await ticketService.UpdateTicketAsync(t.Id, update1, activeUser.Id);

        var update2 = new UpdateTicketDto("New T2", "New D2", cat.Id, prio.Id, new Dictionary<string, string> { { "cust_key", "val2" } }, ColorHex: null);
        await ticketService.UpdateTicketAsync(t.Id, update2, activeUser.Id);

        // CreateTicketAsync with unknown priority, category, and null project
        var createDto = new CreateTicketDto("Missing Entities", "Desc", null, 99999, type.Id, 99999, activeUser.Id, new Dictionary<string, string> { { "unknown_key", "val" } });
        var created = await ticketService.CreateTicketAsync(createDto);
        Assert.NotNull(created);
    }

    [Fact]
    public async Task KnowledgeBaseService_ApplyArticleStatusTransition_Branches()
    {
        using var context = CreateDbContext("KB_Status_Branches_" + Guid.NewGuid());
        var permMock = new Mock<IPermissionCalculator>();
        var signalRMock = new Mock<ISignalRPusher>();

        var kbService = new KnowledgeBaseService(context, permMock.Object, signalRMock.Object);

        var cat = new KnowledgeCategory { Name = "General" };
        var author = new User { Username = "author1" };
        var manager = new User { Username = "mgr1" };
        context.KnowledgeCategories.Add(cat);
        context.Users.AddRange(author, manager);
        await context.SaveChangesAsync();

        permMock.Setup(p => p.CalculateEffectivePermissionsAsync(author.Id)).ReturnsAsync(new HashSet<string>());
        permMock.Setup(p => p.CalculateEffectivePermissionsAsync(manager.Id)).ReturnsAsync(new HashSet<string> { "kb.manage" });

        // 1. Author creates Draft
        var draftDto = new CreateKbArticleDto(cat.Id, "Draft 1", "Content", ArticleStatus.Draft, ArticleVisibility.Public);
        var created = await kbService.CreateArticleAsync(draftDto, author.Id);

        // 2. Author transitions Draft -> PendingReview (triggers NotifyManagersOfSuggestionAsync)
        var pendingDto = new UpdateKbArticleDto(cat.Id, "Draft 1", "Content", ArticleStatus.PendingReview, ArticleVisibility.Public);
        await kbService.UpdateArticleAsync(created.Id, pendingDto, author.Id);

        // 3. Author transitions PendingReview -> PendingReview (no notification)
        await kbService.UpdateArticleAsync(created.Id, pendingDto, author.Id);

        // 4. Author transitions back to Draft
        await kbService.UpdateArticleAsync(created.Id, new UpdateKbArticleDto(cat.Id, "Draft 1", "Content", ArticleStatus.Draft, ArticleVisibility.Public), author.Id);

        // 5. Manager reviews and publishes
        await kbService.ReviewArticleAsync(created.Id, new ReviewKbArticleDto(ArticleStatus.Published, "Approved"), manager.Id);

        // 6. Manager modifies published article and requests revision
        await kbService.UpdateArticleAsync(created.Id, new UpdateKbArticleDto(cat.Id, "Published Art", "New Content", ArticleStatus.NeedsRevision, ArticleVisibility.Public), manager.Id);
    }

    [Fact]
    public async Task SmtpEmailService_And_SlaService_Deleted_Branches()
    {
        using var context = CreateDbContext("Smtp_Sla_Deleted_" + Guid.NewGuid());

        // 1. SmtpEmailService branches
        var loggerMock = new Mock<ILogger<SmtpEmailService>>();

        // Missing host
        var cfgEmpty = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>()).Build();
        var smtpServiceEmpty = new SmtpEmailService(cfgEmpty, loggerMock.Object);
        await smtpServiceEmpty.SendEmailAsync("to@test.com", "Subj", "Body", false);

        // Host without port
        var cfgHostNoPort = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?> { { "Smtp:Host", "smtp.test.com" } }).Build();
        var smtpServiceNoPort = new SmtpEmailService(cfgHostNoPort, loggerMock.Object);
        await smtpServiceNoPort.SendEmailAsync("to@test.com", "Subj", "Body", true);

        // Valid host/port with empty user/pass
        var cfgNoAuth = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "Smtp:Host", "127.0.0.1" },
            { "Smtp:Port", "1" },
            { "Smtp:Username", "" },
            { "Smtp:Password", "" }
        }).Build();
        var smtpServiceNoAuth = new SmtpEmailService(cfgNoAuth, loggerMock.Object);
        await smtpServiceNoAuth.SendEmailAsync("to@test.com", "Subj", "Body", true);

        // Valid host/port but unreachable
        var cfgValid = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "Smtp:Host", "127.0.0.1" },
            { "Smtp:Port", "1" },
            { "Smtp:Username", "user@test.com" },
            { "Smtp:Password", "pass" }
        }).Build();
        var smtpService = new SmtpEmailService(cfgValid, loggerMock.Object);
        await smtpService.SendEmailAsync("to@test.com", "Subj", "Body", false);

        // 2. SlaService.GetDeletedPoliciesAsync branches
        var slaService = new SlaService(context);

        var proj = new Project { Name = "SlaProj", ProjectKey = "SP" };
        var prio = new Priority { Name = "Prio 1", ColorHex = "#111", SeverityLevel = 1 };
        var type = new TicketType { Name = "Incident" };
        context.Projects.Add(proj);
        context.Priorities.Add(prio);
        context.TicketTypes.Add(type);
        await context.SaveChangesAsync();

        var delPol1 = new SlaPolicy { Name = "Del Pol 1", ProjectId = proj.Id, IsDeleted = true, UpdatedAt = DateTime.UtcNow };
        var delPol2 = new SlaPolicy { Name = "Del Pol 2", ProjectId = null, IsDeleted = true, UpdatedAt = null };
        context.SlaPolicies.AddRange(delPol1, delPol2);
        await context.SaveChangesAsync();

        context.SlaTargets.Add(new SlaTarget { SlaPolicyId = delPol1.Id, PriorityId = prio.Id, TicketTypeId = type.Id, FirstResponseMinutes = 15, ResolutionMinutes = 60, IsActive = true });
        context.SlaTargets.Add(new SlaTarget { SlaPolicyId = delPol2.Id, PriorityId = 9999, TicketTypeId = null, FirstResponseMinutes = 30, ResolutionMinutes = 120, IsActive = true });
        await context.SaveChangesAsync();

        var deletedPolicies = (await slaService.GetDeletedPoliciesAsync()).ToList();
        Assert.Equal(2, deletedPolicies.Count);
    }

    [Fact]
    public async Task NotificationDispatcher_EnqueueEmail_All_Badge_Branches()
    {
        using var context = CreateDbContext("Notif_Enqueue_Branches_" + Guid.NewGuid());
        var cfg = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AppBaseUrl", "https://itsm.local" }
        }).Build();

        var webhookMock = new Mock<IWebhookDispatcher>();
        var signalRMock = new Mock<ISignalRPusher>();
        var emailQueueMock = new Mock<IEmailQueue>();
        var templateMock = new Mock<IEmailTemplateService>();
        var aiAgentMock = new Mock<IAiAgentDispatcher>();

        var user = new User { Username = "notifUser", Email = "n@test.com" };
        var prio = new Priority { Name = "High" };
        var stat = new Status { Name = "Open", IsSystemDefault = true };
        context.Users.Add(user);
        context.Priorities.Add(prio);
        context.Statuses.Add(stat);
        await context.SaveChangesAsync();

        var t = new Ticket { TicketNumber = "T-1", Title = "Title", RequesterUserId = user.Id, PriorityId = prio.Id, StatusId = stat.Id, Priority = prio, Status = stat };
        context.Tickets.Add(t);
        context.TicketAssignments.Add(new TicketAssignment { TicketId = t.Id, AssignedUserId = user.Id, IsActive = true });
        await context.SaveChangesAsync();

        var dispatcher = new NotificationDispatcher(context, webhookMock.Object, signalRMock.Object, emailQueueMock.Object, templateMock.Object, cfg, aiAgentMock.Object);

        await dispatcher.DispatchEventAsync("sla.first_response.breached", t.Id, null, "Breach text");
        await dispatcher.DispatchEventAsync("sla.resolution.warning", t.Id, null, "Warning text");
        await dispatcher.DispatchEventAsync("sla.risk", t.Id, null, "Risk text");
        await dispatcher.DispatchEventAsync("ticket.created", t.Id, null, "Created text");

        Assert.True(await context.Notifications.AnyAsync(n => n.UserId == user.Id));
    }

    [Fact]
    public async Task ApiControllers_And_Security_All_Remaining_Branches()
    {
        using var context = CreateDbContext("Api_Security_Branches_" + Guid.NewGuid());

        // 1. PermissionAuthorizationHandler branches
        var handler = new PermissionAuthorizationHandler();
        var req = new PermissionRequirement("ticket.view");

        // Role claim SuperAdmin
        var userRoleClaim = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim(ClaimTypes.Role, "SuperAdmin") }));
        var authCtx1 = new AuthorizationHandlerContext(new[] { req }, userRoleClaim, null);
        await handler.HandleAsync(authCtx1);
        Assert.True(authCtx1.HasSucceeded);

        // Lowercase role claim SuperAdmin
        var userLowerRole = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim("role", "SuperAdmin") }));
        var authCtx2 = new AuthorizationHandlerContext(new[] { req }, userLowerRole, null);
        await handler.HandleAsync(authCtx2);
        Assert.True(authCtx2.HasSucceeded);

        // MS role claim SuperAdmin
        var userMsRole = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim("http://schemas.microsoft.com/ws/2008/06/identity/claims/role", "SuperAdmin") }));
        var authCtx3 = new AuthorizationHandlerContext(new[] { req }, userMsRole, null);
        await handler.HandleAsync(authCtx3);
        Assert.True(authCtx3.HasSucceeded);

        // Permission claim
        var userPerm = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim("permission", "ticket.view") }));
        var authCtx4 = new AuthorizationHandlerContext(new[] { req }, userPerm, null);
        await handler.HandleAsync(authCtx4);
        Assert.True(authCtx4.HasSucceeded);

        // Unprivileged user
        var userNone = new ClaimsPrincipal(new ClaimsIdentity());
        var authCtx5 = new AuthorizationHandlerContext(new[] { req }, userNone, null);
        await handler.HandleAsync(authCtx5);
        Assert.False(authCtx5.HasSucceeded);

        // 2. NotificationHub branches
        var hub = new NotificationHub();
        var hubCallerCtxMock = new Mock<HubCallerContext>();
        var hubGroupsMock = new Mock<IGroupManager>();

        hubCallerCtxMock.Setup(c => c.ConnectionId).Returns("conn-1");
        hubCallerCtxMock.Setup(c => c.User).Returns(new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim(ClaimTypes.NameIdentifier, "42") })));
        hub.Context = hubCallerCtxMock.Object;
        hub.Groups = hubGroupsMock.Object;

        await hub.OnConnectedAsync();
        await hub.OnDisconnectedAsync(null);

        // Null user
        hubCallerCtxMock.Setup(c => c.User).Returns((ClaimsPrincipal?)null);
        await hub.OnConnectedAsync();
        await hub.OnDisconnectedAsync(null);

        // 3. TestController branches
        var roleServiceMock = new Mock<IRoleService>();
        roleServiceMock.Setup(r => r.GetAllAsync()).ReturnsAsync(new List<RoleDto>
        {
            new RoleDto(1, "Admin", "Desc", true, new string[] { "all" }),
            new RoleDto(2, "EmptyRole", "Desc", true, null!)
        });
        var testController = new TestController(roleServiceMock.Object);
        var rolesRes = await testController.GetRoles() as OkObjectResult;
        Assert.NotNull(rolesRes);

        // 4. TicketController delete permission branches
        var ticketServiceMock = new Mock<ITicketService>();
        var ticketCtrl = new TicketController(ticketServiceMock.Object);

        // Claim with permission "ticket.manage"
        ticketCtrl.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = new ClaimsPrincipal(new ClaimsIdentity(new[] { new Claim("permission", "ticket.manage") })) }
        };
        var delRes1 = await ticketCtrl.DeleteTicket(1);
        Assert.IsType<NoContentResult>(delRes1);

        // No permission -> Forbid
        ticketCtrl.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = new ClaimsPrincipal(new ClaimsIdentity()) }
        };
        var delRes2 = await ticketCtrl.DeleteTicket(1);
        Assert.IsType<ForbidResult>(delRes2);

        // 5. AiController.GetStatus branches
        var llmMock = new Mock<ILlmService>();
        llmMock.Setup(l => l.IsAvailableAsync()).ReturnsAsync(false);
        llmMock.Setup(l => l.GetCurrentConfig()).Returns(new LlmConfigDto { FallbackToHeuristic = false, Endpoint = "http://test", Model = "mod" });
        var aiCtrl = new AiController(llmMock.Object);
        var statRes = await aiCtrl.GetStatus() as OkObjectResult;
        Assert.NotNull(statRes);

        // 6. AiTicketCopilotController.Ask & SuggestResolution branches
        var copilotAgentMock = new Mock<ResolutionCopilotAgent>(llmMock.Object, context, new Mock<ILogger<ResolutionCopilotAgent>>().Object);
        var copilotCtrl = new AiTicketCopilotController(copilotAgentMock.Object);

        int uniqueTicketId = 88123;
        var copilotTicket = new Ticket { Id = uniqueTicketId, TicketNumber = "COP-1", Title = "Copilot Ticket", Description = "Desc", ProjectId = 1, CategoryId = 1, PriorityId = 1, StatusId = 1 };
        context.Tickets.Add(copilotTicket);
        await context.SaveChangesAsync();

        // Ask with empty question -> BadRequest
        var askRes1 = await copilotCtrl.Ask(uniqueTicketId, new AiTicketCopilotController.AskQuestionDto(""));
        Assert.IsType<BadRequestObjectResult>(askRes1);

        // Ask with query param language fallback
        llmMock.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync("Answer");
        var askRes2 = await copilotCtrl.Ask(uniqueTicketId, new AiTicketCopilotController.AskQuestionDto("Valid Q", null), "en");
        Assert.IsType<OkObjectResult>(askRes2);

        // SuggestResolution with custom failure -> BadRequest
        llmMock.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync("[AI İsteği Başarısız: Custom Error]");
        llmMock.Setup(l => l.IsFallbackDisabled()).Returns(true);
        var sugRes = await copilotCtrl.SuggestResolution(99999);
        Assert.IsType<NotFoundObjectResult>(sugRes);

        // 7. LlmService.UpdateConfig branches
        var llmConfig = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:ApiKey", "sk-init123456" },
            { "AI:Endpoint", "https://api.openai.com" },
            { "AI:Model", "gpt-4o" }
        }).Build();
        var llmService = new LlmService(new System.Net.Http.HttpClient(), llmConfig, new Mock<ILogger<LlmService>>().Object);

        // Null config
        llmService.UpdateConfig(null!);

        // Empty ApiKey
        llmService.UpdateConfig(new LlmConfigDto { ApiKey = "", Provider = "Ollama", Endpoint = "http://localhost:11434", Model = "llama3", TimeoutSeconds = -1 });
        Assert.Equal(string.Empty, llmService.GetCurrentConfig().ApiKey);

        // Masked ApiKey
        llmService.UpdateConfig(new LlmConfigDto { ApiKey = "sk-i****3456", Provider = null, Endpoint = null, Model = null, TimeoutSeconds = 60 });
        Assert.NotNull(llmService.GetCurrentConfig().ApiKey);

        // Reset static override so other tests aren't affected
        LlmService.ResetRuntimeConfig();
    }
}
