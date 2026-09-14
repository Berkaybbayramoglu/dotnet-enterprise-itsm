using System.Collections.Generic;
using System.Threading.Tasks;
using ItsTool.API.Controllers;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Agents;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging.Abstractions;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Controllers;

public class AiControllerTests : TestBase
{
    private readonly Mock<ILlmService> _mockLlm;
    private readonly ResolutionCopilotAgent _copilotAgent;
    private readonly TicketHandoffSwarm _handoffSwarm;
    private readonly AiController _aiController;
    private readonly AiTicketCopilotController _copilotController;
    private readonly AiTicketHandoffController _handoffController;

    public AiControllerTests() : base()
    {
        _mockLlm = new Mock<ILlmService>();
        _mockLlm.Setup(l => l.GetEndpoint()).Returns("http://localhost:1234/v1");
        _mockLlm.Setup(l => l.GetModelName()).Returns("llama-3");

        _copilotAgent = new ResolutionCopilotAgent(_mockLlm.Object, _context, NullLogger<ResolutionCopilotAgent>.Instance);
        _handoffSwarm = new TicketHandoffSwarm(_mockLlm.Object, _context, NullLogger<TicketHandoffSwarm>.Instance);

        _aiController = new AiController(_mockLlm.Object);
        _copilotController = new AiTicketCopilotController(_copilotAgent);
        _handoffController = new AiTicketHandoffController(_handoffSwarm);

        _context.Categories.Add(new Category { Id = 1, Name = "Hardware" });
        _context.Statuses.Add(new Status { Id = 1, Name = "Open", IsClosedStatus = false });
        _context.Priorities.Add(new Priority { Id = 1, Name = "Normal", SeverityLevel = 1 });
        _context.TicketTypes.Add(new TicketType { Id = 1, Name = "Incident" });
        _context.Users.Add(new ItsTool.Domain.Entities.Organization.User { Id = 1, Email = "test@test.com", FirstName = "Test", LastName = "User", PasswordHash = "hash" });
        _context.SaveChanges();
    }

    [Fact]
    public async Task GetStatus_ShouldReturnConfiguredStatus()
    {
        _mockLlm.Setup(l => l.IsAvailableAsync()).ReturnsAsync(true);

        var result = await _aiController.GetStatus();

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.NotNull(okResult.Value);
    }

    [Fact]
    public async Task TestConnection_ShouldReturnSuccess_WhenOnline()
    {
        _mockLlm.Setup(l => l.IsAvailableAsync()).ReturnsAsync(true);
        _mockLlm.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync("ITSM AI connection OK.");

        var result = await _aiController.TestConnection();

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.NotNull(okResult.Value);
    }

    [Fact]
    public async Task TestConnection_ShouldReturnFallback_WhenOffline()
    {
        _mockLlm.Setup(l => l.IsAvailableAsync()).ReturnsAsync(false);

        var result = await _aiController.TestConnection();

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.NotNull(okResult.Value);
    }

    [Fact]
    public async Task SuggestResolution_ShouldReturnNotFound_WhenTicketDoesNotExist()
    {
        var result = await _copilotController.SuggestResolution(999);

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task SuggestResolution_ShouldReturnOk_WhenTicketExists()
    {
        var ticket = new Ticket
        {
            TicketNumber = "T-10",
            Title = "VPN Issue",
            Description = "Cannot connect to VPN",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            RequesterUserId = 1
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        _mockLlm.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync("Restart VPN service and check credentials.");

        var result = await _copilotController.SuggestResolution(ticket.Id);

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.NotNull(okResult.Value);
    }

    [Fact]
    public async Task DraftReply_ShouldReturnOk()
    {
        var ticket = new Ticket
        {
            TicketNumber = "T-11",
            Title = "Email Error",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            RequesterUserId = 1
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        var result = await _copilotController.DraftReply(ticket.Id);

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.NotNull(okResult.Value);
    }

    [Fact]
    public async Task Ask_ShouldReturnBadRequest_WhenQuestionIsEmpty()
    {
        var result = await _copilotController.Ask(1, new AiTicketCopilotController.AskQuestionDto(""));

        Assert.IsType<BadRequestObjectResult>(result);
    }

    [Fact]
    public async Task Ask_ShouldReturnOk_WhenQuestionIsValid()
    {
        var ticket = new Ticket
        {
            TicketNumber = "T-12",
            Title = "Login issue",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            RequesterUserId = 1
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        var result = await _copilotController.Ask(ticket.Id, new AiTicketCopilotController.AskQuestionDto("What is the status?"));

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.NotNull(okResult.Value);
    }

    [Fact]
    public async Task Summarize_ShouldReturnNotFound_WhenTicketDoesNotExist()
    {
        var result = await _handoffController.Summarize(999);

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task Summarize_ShouldReturnOk_WhenTicketExists()
    {
        var ticket = new Ticket
        {
            TicketNumber = "T-13",
            Title = "Printer Offline",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            RequesterUserId = 1
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        var result = await _handoffController.Summarize(ticket.Id);

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.NotNull(okResult.Value);
    }

    [Fact]
    public async Task ConfigAndModelEndpoints_ShouldReturnExpectedResults()
    {
        // 1. GetConfig
        _mockLlm.Setup(l => l.GetCurrentConfig()).Returns(new LlmConfigDto { Model = "test-model" });
        var getCfgRes = _aiController.GetConfig();
        Assert.IsType<OkObjectResult>(getCfgRes);

        // 2. UpdateConfig null -> BadRequest
        var updateNull = _aiController.UpdateConfig(null!);
        Assert.IsType<BadRequestObjectResult>(updateNull);

        // 3. UpdateConfig valid -> Ok
        var updateValid = _aiController.UpdateConfig(new LlmConfigDto { Model = "new-model" });
        Assert.IsType<OkObjectResult>(updateValid);

        // 4. GetModels
        _mockLlm.Setup(l => l.GetAvailableModelsAsync(It.IsAny<string?>(), It.IsAny<string?>()))
            .ReturnsAsync(new List<LlmModelDto> { new() { Id = "m-1", Name = "Model 1" } });
        var modelsRes = await _aiController.GetModels("http://custom:1234", "key");
        Assert.IsType<OkObjectResult>(modelsRes);

        // 5. TestConnection with custom config
        _mockLlm.Setup(l => l.TestConnectionAsync(It.IsAny<LlmConfigDto>()))
            .ReturnsAsync(new LlmTestResultDto { Success = true, Message = "OK" });
        var testRes = await _aiController.TestConnection(new LlmConfigDto { Endpoint = "http://custom:1234" });
        Assert.IsType<OkObjectResult>(testRes);
    }

    [Fact]
    public async Task GetStatus_WhenOfflineAndFallbackDisabled_ShouldReturnLlmOffline()
    {
        _mockLlm.Setup(l => l.IsAvailableAsync()).ReturnsAsync(false);
        _mockLlm.Setup(l => l.GetCurrentConfig()).Returns(new LlmConfigDto { FallbackToHeuristic = false });

        var res = await _aiController.GetStatus();
        var ok = Assert.IsType<OkObjectResult>(res);
        Assert.NotNull(ok.Value);
    }

    [Fact]
    public async Task SuggestResolution_WhenSemaphoreLocked_ShouldReturn429()
    {
        var sem = AiControllerHelper.GetLock(9999);
        await sem.WaitAsync();
        try
        {
            var res = await _copilotController.SuggestResolution(9999);
            var objRes = Assert.IsType<ObjectResult>(res);
            Assert.Equal(429, objRes.StatusCode);
        }
        finally
        {
            sem.Release();
        }
    }

    [Fact]
    public async Task DraftReply_WhenSemaphoreLocked_ShouldReturn429()
    {
        var sem = AiControllerHelper.GetLock(9998);
        await sem.WaitAsync();
        try
        {
            var res = await _copilotController.DraftReply(9998);
            var objRes = Assert.IsType<ObjectResult>(res);
            Assert.Equal(429, objRes.StatusCode);
        }
        finally
        {
            sem.Release();
        }
    }

    [Fact]
    public async Task Ask_WhenEmptyQuestion_ShouldReturnBadRequest()
    {
        var res = await _copilotController.Ask(1, new AiTicketCopilotController.AskQuestionDto("   "));
        Assert.IsType<BadRequestObjectResult>(res);
    }

    [Fact]
    public async Task Ask_WhenSemaphoreLocked_ShouldReturn429()
    {
        var sem = AiControllerHelper.GetLock(9997);
        await sem.WaitAsync();
        try
        {
            var res = await _copilotController.Ask(9997, new AiTicketCopilotController.AskQuestionDto("What happened?"));
            var objRes = Assert.IsType<ObjectResult>(res);
            Assert.Equal(429, objRes.StatusCode);
        }
        finally
        {
            sem.Release();
        }
    }

    [Fact]
    public async Task HandoffSummarize_WhenSemaphoreLocked_ShouldReturn429()
    {
        var sem = AiControllerHelper.GetLock(9996);
        await sem.WaitAsync();
        try
        {
            var res = await _handoffController.Summarize(9996);
            var objRes = Assert.IsType<ObjectResult>(res);
            Assert.Equal(429, objRes.StatusCode);
        }
        finally
        {
            sem.Release();
        }
    }

    [Fact]
    public async Task HandoffSummarize_WhenTicketMissing_ShouldReturnNotFound()
    {
        var res = await _handoffController.Summarize(99999);
        Assert.IsType<NotFoundObjectResult>(res);
    }
}
