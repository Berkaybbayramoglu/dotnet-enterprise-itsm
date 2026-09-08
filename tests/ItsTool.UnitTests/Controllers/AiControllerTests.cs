using System.Threading.Tasks;
using ItsTool.API.Controllers;
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
}
