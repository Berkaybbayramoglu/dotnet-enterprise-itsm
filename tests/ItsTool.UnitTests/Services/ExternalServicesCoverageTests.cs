using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Organization;
using ItsTool.Domain.Entities.SLA;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Agents;
using ItsTool.Infrastructure.Data;
using ItsTool.Infrastructure.Helpers;
using ItsTool.Infrastructure.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Moq;
using Moq.Protected;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class ExternalServicesCoverageTests
{
    private static ItsToolDbContext CreateDbContext(string dbName)
    {
        var options = new DbContextOptionsBuilder<ItsToolDbContext>()
            .UseInMemoryDatabase(databaseName: dbName)
            .Options;
        return new ItsToolDbContext(options);
    }

    [Fact]
    public void LlmService_ConfigProperties_ShouldReturnDefaultsAndConfiguredValues()
    {
        var inMemorySettings = new Dictionary<string, string?>
        {
            { "AI:Model", "custom-model" },
            { "AI:Endpoint", "https://api.ai.local/v1/chat/completions" },
            { "AI:ApiKey", "secret-key" }
        };
        var config = new ConfigurationBuilder().AddInMemoryCollection(inMemorySettings).Build();
        var loggerMock = new Mock<ILogger<LlmService>>();
        var httpClient = new HttpClient();

        var service = new LlmService(httpClient, config, loggerMock.Object);

        Assert.Equal("custom-model", service.GetModelName());
        Assert.Equal("https://api.ai.local/v1/chat/completions", service.GetEndpoint());
    }

    [Fact]
    public async Task LlmService_IsAvailableAsync_ShouldReturnTrueOnSuccess()
    {
        var handlerMock = new Mock<HttpMessageHandler>();
        handlerMock.Protected()
            .Setup<Task<HttpResponseMessage>>(
                "SendAsync",
                ItExpr.IsAny<HttpRequestMessage>(),
                ItExpr.IsAny<CancellationToken>())
            .ReturnsAsync(new HttpResponseMessage(HttpStatusCode.OK));

        var httpClient = new HttpClient(handlerMock.Object);
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:Endpoint", "https://api.ai.local/v1/chat/completions" },
            { "AI:ApiKey", "valid-key" }
        }).Build();

        var loggerMock = new Mock<ILogger<LlmService>>();
        var service = new LlmService(httpClient, config, loggerMock.Object);

        var isAvailable = await service.IsAvailableAsync();
        Assert.True(isAvailable);
    }

    [Fact]
    public async Task LlmService_IsAvailableAsync_ShouldReturnFalseOnEmptyEndpointOrError()
    {
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:Endpoint", "" }
        }).Build();
        var loggerMock = new Mock<ILogger<LlmService>>();
        var service = new LlmService(new HttpClient(), config, loggerMock.Object);

        Assert.False(await service.IsAvailableAsync());
    }

    [Fact]
    public async Task LlmService_GetCompletionAsync_ShouldReturnParsedContent_WhenHttpSucceeds()
    {
        var jsonResponse = "{\"choices\":[{\"message\":{\"content\":\"Harika bir çözüm!\"}}]}";
        var handlerMock = new Mock<HttpMessageHandler>();
        handlerMock.Protected()
            .Setup<Task<HttpResponseMessage>>(
                "SendAsync",
                ItExpr.IsAny<HttpRequestMessage>(),
                ItExpr.IsAny<CancellationToken>())
            .ReturnsAsync(new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new StringContent(jsonResponse, Encoding.UTF8, "application/json")
            });

        var httpClient = new HttpClient(handlerMock.Object);
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:Endpoint", "https://api.ai.local/v1/chat/completions" },
            { "AI:ApiKey", "token" }
        }).Build();

        var loggerMock = new Mock<ILogger<LlmService>>();
        var service = new LlmService(httpClient, config, loggerMock.Object);

        var result = await service.GetCompletionAsync("system prompt", "user message");
        Assert.Equal("Harika bir çözüm!", result);
    }

    [Fact]
    public async Task LlmService_GetCompletionAsync_ShouldReturnFallback_WhenEndpointNotConfiguredOrFails()
    {
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:Endpoint", "" }
        }).Build();
        var loggerMock = new Mock<ILogger<LlmService>>();
        var service = new LlmService(new HttpClient(), config, loggerMock.Object);

        var result = await service.GetCompletionAsync("system", "user");
        Assert.Contains("AI Modülü yapılandırılmadı", result);
    }

    [Fact]
    public async Task SmtpEmailService_ShouldHandleMissingConfigAndExceptionsGracefully()
    {
        var configEmpty = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>()).Build();
        var loggerMock = new Mock<ILogger<SmtpEmailService>>();
        var serviceEmpty = new SmtpEmailService(configEmpty, loggerMock.Object);

        var exEmpty = await Record.ExceptionAsync(() => serviceEmpty.SendEmailAsync("user@test.com", "Subj", "Body"));
        Assert.Null(exEmpty);

        var configInvalid = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "Smtp:Host", "invalid.smtp.local" },
            { "Smtp:Port", "25" }
        }).Build();
        var serviceInvalid = new SmtpEmailService(configInvalid, loggerMock.Object);
        var exInvalid = await Record.ExceptionAsync(() => serviceInvalid.SendEmailAsync("user@test.com", "Subj", "Body"));
        Assert.Null(exInvalid);
    }

    [Fact]
    public async Task LocalFileStorageService_ShouldSaveAndDeleteFiles_AndEnforceRestrictions()
    {
        var tempDir = Path.Combine(Path.GetTempPath(), "itsm_storage_test_" + Guid.NewGuid());
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "FileStorage:BasePath", tempDir }
        }).Build();

        var service = new LocalFileStorageService(config);

        var contentBytes = Encoding.UTF8.GetBytes("Sample content");
        var formFile = new FormFile(new MemoryStream(contentBytes), 0, contentBytes.Length, "file", "document.pdf");

        var savedPath = await service.SaveFileAsync(formFile, 101);
        Assert.True(File.Exists(savedPath));

        await service.DeleteFileAsync(savedPath);
        Assert.False(File.Exists(savedPath));

        // Invalid extension
        var invalidFile = new FormFile(new MemoryStream(contentBytes), 0, contentBytes.Length, "file", "script.exe");
        await Assert.ThrowsAsync<InvalidOperationException>(() => service.SaveFileAsync(invalidFile, 101));

        // File size limit (>10MB)
        var largeFileMock = new Mock<IFormFile>();
        largeFileMock.Setup(f => f.FileName).Returns("large.zip");
        largeFileMock.Setup(f => f.Length).Returns(11 * 1024 * 1024);
        await Assert.ThrowsAsync<InvalidOperationException>(() => service.SaveFileAsync(largeFileMock.Object, 101));

        if (Directory.Exists(tempDir)) Directory.Delete(tempDir, true);
    }

    [Fact]
    public async Task TicketQueryHelpers_ApplySecurityScopeAsync_ShouldFilterByRoles()
    {
        var db = CreateDbContext("TicketSecurityDb");
        db.GroupMembers.Add(new GroupMember { UserId = 2, GroupId = 10 });
        await db.SaveChangesAsync();

        var tickets = new List<Ticket>
        {
            new() { Id = 1, RequesterUserId = 1 },
            new() { Id = 2, RequesterUserId = 2, Assignments = new List<TicketAssignment> { new() { AssignedUserId = 2, IsActive = true } } },
            new() { Id = 3, RequesterUserId = 3, Assignments = new List<TicketAssignment> { new() { AssignedGroupId = 10, IsActive = true } } },
            new() { Id = 4, RequesterUserId = 4 }
        }.AsQueryable();

        // 1. Admin with report.view -> sees all
        var adminQuery = await TicketQueryHelpers.ApplySecurityScopeAsync(tickets, new HashSet<string> { "report.view" }, 1, db);
        Assert.Equal(4, adminQuery.Count());

        // 2. Agent with ticket.manage -> sees own, assigned, and group
        var agentQuery = await TicketQueryHelpers.ApplySecurityScopeAsync(tickets, new HashSet<string> { "ticket.manage" }, 2, db);
        Assert.Equal(2, agentQuery.Count());

        // 3. End user -> sees only own requested
        var endUserQuery = await TicketQueryHelpers.ApplySecurityScopeAsync(tickets, new HashSet<string>(), 4, db);
        Assert.Single(endUserQuery);
        Assert.Equal(4, endUserQuery.First().Id);
    }

    [Fact]
    public void TicketQueryHelpers_ApplyBasicFilters_ShouldApplyAllFilterProperties()
    {
        var now = DateTime.UtcNow;
        var tickets = new List<Ticket>
        {
            new() { Id = 1, ProjectId = 1, CategoryId = 2, TypeId = 3, StatusId = 4, PriorityId = 5, RequesterUserId = 6, CreatedAt = now, Assignments = new List<TicketAssignment> { new() { AssignedUserId = 7, IsActive = true } } },
            new() { Id = 2, ProjectId = 9, CategoryId = 9, TypeId = 9, StatusId = 9, PriorityId = 9, RequesterUserId = 9, CreatedAt = now.AddDays(-10) }
        }.AsQueryable();

        var filter = new TicketSearchFilterDto
        {
            ProjectId = 1,
            CategoryId = 2,
            TypeId = 3,
            StatusId = 4,
            PriorityId = 5,
            AssigneeUserId = 7,
            RequesterUserId = 6,
            FromDate = now.AddHours(-1),
            ToDate = now.AddHours(1),
            Unassigned = false,
            ExcludeStatusId = 99,
            Page = 1,
            PageSize = 10
        };

        var filtered = TicketQueryHelpers.ApplyBasicFilters(tickets, filter);
        Assert.Single(filtered);
        Assert.Equal(1, filtered.First().Id);

        // Unassigned filter
        var unassignedFilter = new TicketSearchFilterDto { Unassigned = true };
        var unassignedResult = TicketQueryHelpers.ApplyBasicFilters(tickets, unassignedFilter);
        Assert.Single(unassignedResult);
        Assert.Equal(2, unassignedResult.First().Id);
    }

    [Fact]
    public void TicketQueryHelpers_ApplyKeywordAndSlaFilters_ShouldFilterKeywordsAndSlaStatuses()
    {
        var tickets = new List<Ticket>
        {
            new() { Id = 1, TicketNumber = "TCK-100", Title = "Server down", Description = "Urgent", TicketSla = new TicketSla { FirstResponseBreached = true } },
            new() { Id = 2, TicketNumber = "TCK-200", Title = "Mouse broken", Description = "Hardware", TicketSla = new TicketSla { FirstResponseWarned = true, FirstResponseBreached = false } },
            new() { Id = 3, TicketNumber = "TCK-300", Title = "Keyboard issue", Description = "Normal", TicketSla = new TicketSla { FirstResponseWarned = false, FirstResponseBreached = false } }
        }.AsQueryable();

        // Keyword
        var kwFilter = new TicketSearchFilterDto { Keyword = "Server" };
        var kwResult = TicketQueryHelpers.ApplyKeywordAndSlaFilters(tickets, kwFilter);
        Assert.Single(kwResult);
        Assert.Equal(1, kwResult.First().Id);

        // Breached SLA
        var breachedFilter = new TicketSearchFilterDto { SlaStatus = "breached" };
        var breachedResult = TicketQueryHelpers.ApplyKeywordAndSlaFilters(tickets, breachedFilter);
        Assert.Single(breachedResult);
        Assert.Equal(1, breachedResult.First().Id);

        // Warning SLA
        var warningFilter = new TicketSearchFilterDto { SlaStatus = "warning" };
        var warningResult = TicketQueryHelpers.ApplyKeywordAndSlaFilters(tickets, warningFilter);
        Assert.Single(warningResult);
        Assert.Equal(2, warningResult.First().Id);

        // OnTrack SLA
        var ontrackFilter = new TicketSearchFilterDto { SlaStatus = "ontrack" };
        var ontrackResult = TicketQueryHelpers.ApplyKeywordAndSlaFilters(tickets, ontrackFilter);
        Assert.Single(ontrackResult);
        Assert.Equal(3, ontrackResult.First().Id);
    }

    [Fact]
    public async Task TicketHandoffSwarm_ShouldGenerateSummaryAndCleanMarkdown()
    {
        var db = CreateDbContext(Guid.NewGuid().ToString());
        db.Categories.Add(new Category { Id = 1, Name = "Hardware" });
        db.Statuses.Add(new Status { Id = 1, Name = "Open" });
        db.Priorities.Add(new Priority { Id = 1, Name = "Normal", SeverityLevel = 1 });
        db.TicketTypes.Add(new TicketType { Id = 1, Name = "Incident" });
        var user = new User { Id = 1, Username = "admin", Email = "admin@example.com", PasswordHash = "hash" };
        db.Users.Add(user);
        await db.SaveChangesAsync();

        var ticket = new Ticket
        {
            TicketNumber = "TCK-HANDOFF-1",
            Title = "Network Switch Port Failure",
            Description = "Port 4 is inactive.",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            RequesterUserId = 1,
            CreatedAt = DateTime.UtcNow
        };
        db.Tickets.Add(ticket);
        await db.SaveChangesAsync();

        db.TicketComments.Add(new TicketComment { TicketId = ticket.Id, Content = "Swapped cables, no link light.", CreatedBy = "Agent 1", CreatedAt = DateTime.UtcNow });
        await db.SaveChangesAsync();

        var llmMock = new Mock<ILlmService>();
        llmMock.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync("**Özet:** Switch portu arızalı. *İnceleme* sürüyor.");

        var loggerMock = new Mock<ILogger<TicketHandoffSwarm>>();
        var swarm = new TicketHandoffSwarm(llmMock.Object, db, loggerMock.Object);

        var result = await swarm.GenerateHandoffSummaryAsync(ticket.Id, postAsComment: true);
        Assert.True(result.Success);
        Assert.Contains("Switch portu arızalı", result.Summary);

        // CleanPlainText verification
        var cleaned = TicketHandoffSwarm.CleanPlainText("### Başlık **Kalın** [Link](http://test.com) 🚀");
        Assert.DoesNotContain("###", cleaned);
        Assert.DoesNotContain("**", cleaned);
        Assert.DoesNotContain("🚀", cleaned);
        Assert.Contains("Başlık Kalın Link (http://test.com)", cleaned);

        // Ticket not found
        var notFoundResult = await swarm.GenerateHandoffSummaryAsync(999);
        Assert.False(notFoundResult.Success);
    }
}
