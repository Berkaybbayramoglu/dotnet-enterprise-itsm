using System.Threading.Tasks;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Agents;
using Microsoft.Extensions.Logging.Abstractions;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class ResolutionCopilotAgentTests : TestBase
{
    private readonly Mock<ILlmService> _mockLlm;
    private readonly ResolutionCopilotAgent _agent;

    public ResolutionCopilotAgentTests() : base()
    {
        _mockLlm = new Mock<ILlmService>();
        _mockLlm.Setup(l => l.GetModelName()).Returns("mock-model");
        _agent = new ResolutionCopilotAgent(_mockLlm.Object, _context, NullLogger<ResolutionCopilotAgent>.Instance);

        _context.Categories.Add(new Category { Id = 1, Name = "Hardware" });
        _context.Statuses.Add(new Status { Id = 1, Name = "Open", IsClosedStatus = false });
        _context.Priorities.Add(new Priority { Id = 1, Name = "Normal", SeverityLevel = 1 });
        _context.TicketTypes.Add(new TicketType { Id = 1, Name = "Incident" });
        _context.Users.Add(new ItsTool.Domain.Entities.Organization.User { Id = 1, Email = "test@test.com", FirstName = "Test", LastName = "User", PasswordHash = "hash" });
        _context.SaveChanges();
    }

    [Fact]
    public async Task GenerateResolutionSuggestionAsync_ShouldReturnNotFound_WhenTicketDoesNotExist()
    {
        var result = await _agent.GenerateResolutionSuggestionAsync(999);

        Assert.False(result.Success);
        Assert.Equal("Bilet bulunamadı.", result.Suggestion);
    }

    [Fact]
    public async Task GenerateResolutionSuggestionAsync_ShouldUseLlm_WhenLlmReturnsValidSuggestion()
    {
        var ticket = new Ticket
        {
            TicketNumber = "T-1",
            Title = "Cannot login",
            Description = "Getting password error",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            RequesterUserId = 1
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        _mockLlm.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync("1. Check account lockout status.\n2. Reset user password.");

        var result = await _agent.GenerateResolutionSuggestionAsync(ticket.Id, postAsComment: true);

        Assert.True(result.Success);
        Assert.Contains("Check account lockout status", result.Suggestion);
        Assert.Equal("Canlı LLM (mock-model)", result.Source);
    }

    [Fact]
    public async Task GenerateResolutionSuggestionAsync_ShouldFallbackToHeuristic_WhenLlmFails()
    {
        var ticket = new Ticket
        {
            TicketNumber = "T-2",
            Title = "Database timeout",
            Description = "App pool recycling",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            RequesterUserId = 1
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        _mockLlm.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync("[AI İsteği Başarısız] Connection refused");

        var result = await _agent.GenerateResolutionSuggestionAsync(ticket.Id, postAsComment: false);

        Assert.True(result.Success);
        Assert.Equal("Akıllı Yerel Asistan", result.Source);
        Assert.Contains("Önerilen Çözüm ve Teşhis Adımları", result.Suggestion);
    }

    [Fact]
    public async Task DraftReplyAsync_ShouldReturnDraft()
    {
        var ticket = new Ticket
        {
            TicketNumber = "T-3",
            Title = "VPN connection failed",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            RequesterUserId = 1
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        _mockLlm.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync("Merhaba, talebiniz incelenmektedir.");

        var draft = await _agent.DraftReplyAsync(ticket.Id);

        Assert.NotNull(draft);
        Assert.Contains("talebiniz incelenmektedir", draft);
    }

    [Fact]
    public async Task AskQuestionAsync_ShouldReturnAnswer()
    {
        var ticket = new Ticket
        {
            TicketNumber = "T-4",
            Title = "Slow network",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            RequesterUserId = 1
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        _mockLlm.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync("Ağ trafiği kontrol ediliyor.");

        var answer = await _agent.AskQuestionAsync(ticket.Id, "Neden yavaş?");

        Assert.NotNull(answer);
        Assert.Contains("Ağ trafiği kontrol ediliyor", answer);
    }

    [Fact]
    public async Task DraftReplyAsync_ShouldReturnNotFound_WhenTicketDoesNotExist()
    {
        var draft = await _agent.DraftReplyAsync(999);
        Assert.Equal("Bilet bulunamadı.", draft);
    }

    [Fact]
    public async Task AskQuestionAsync_ShouldReturnNotFound_WhenTicketDoesNotExist()
    {
        var answer = await _agent.AskQuestionAsync(999, "Herhangi bir soru");
        Assert.Equal("Bilet bulunamadı.", answer);
    }

    [Fact]
    public async Task DraftReplyAsync_ShouldFallback_WhenLlmFails()
    {
        var ticket = new Ticket
        {
            TicketNumber = "T-5",
            Title = "Printer error",
            Description = "Paper jam",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            RequesterUserId = 1
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        _mockLlm.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync("[AI İsteği Başarısız] Timeout");

        var draft = await _agent.DraftReplyAsync(ticket.Id);
        Assert.NotNull(draft);
        Assert.Contains("incelemeye alınmıştır", draft);
        Assert.Contains("Printer error", draft);
    }

    [Fact]
    public async Task GenerateResolutionSuggestionAsync_ShouldPostBotComment_WhenPostAsCommentIsTrue()
    {
        var ticket = new Ticket
        {
            TicketNumber = "T-6",
            Title = "Outlook sync issue",
            Description = "Emails not updating",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            RequesterUserId = 1
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        _mockLlm.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync("1. Check cached exchange mode.\n2. Restart Outlook.");

        var result = await _agent.GenerateResolutionSuggestionAsync(ticket.Id, postAsComment: true);

        Assert.True(result.Success);
        var comment = _context.TicketComments.FirstOrDefault(c => c.TicketId == ticket.Id);
        Assert.NotNull(comment);
        Assert.True(comment.IsInternal);
        Assert.Contains("Check cached exchange mode", comment.Content);
    }

    [Theory]
    [InlineData("**Bold text**", "Bold text")]
    [InlineData("# Header Title", "Header Title")]
    [InlineData("[Link text](https://test.com)", "Link text (https://test.com)")]
    [InlineData("Clean text with emoji 😊 and 👍", "Clean text with emoji  and ")]
    public void CleanPlainText_ShouldStripFormattingAndEmojis(string input, string expected)
    {
        var cleaned = ResolutionCopilotAgent.CleanPlainText(input);
        Assert.Equal(expected.Trim(), cleaned);
    }
}
