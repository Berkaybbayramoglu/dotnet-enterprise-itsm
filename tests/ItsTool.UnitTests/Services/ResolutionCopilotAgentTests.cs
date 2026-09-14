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

    [Fact]
    public async Task GenerateResolutionSuggestionAsync_EnglishLanguage_ShouldGenerateAndFallback()
    {
        var ticket = new Ticket
        {
            TicketNumber = "T-EN",
            Title = "VPN connection drops",
            Description = "User cannot maintain connection",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            RequesterUserId = 1
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        _mockLlm.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync("1. Reinstall VPN client.\n2. Verify network configuration.");

        var res = await _agent.GenerateResolutionSuggestionAsync(ticket.Id, postAsComment: false, language: "en");
        Assert.True(res.Success);
        Assert.Contains("Reinstall VPN", res.Suggestion);

        // RunAsync virtual method test
        await _agent.RunAsync(ticket);
        Assert.Contains(_context.TicketComments, c => c.TicketId == ticket.Id && c.IsInternal);
    }

    [Fact]
    public async Task DraftReplyWithSourceAsync_ShouldHandleSuccessAndDisabledFallback()
    {
        var ticket = new Ticket
        {
            TicketNumber = "T-DRAFT",
            Title = "Network slow",
            Description = "General slowness",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            RequesterUserId = 1
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        // Successful live LLM
        _mockLlm.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync("Değerli kullanıcımız, talebiniz üzerinde çalışıyoruz.");
        var (draft, source, isLlm) = await _agent.DraftReplyWithSourceAsync(ticket.Id, "tr");
        Assert.True(isLlm);
        Assert.Contains("Değerli kullanıcımız", draft);

        // Disabled fallback throws exception
        _mockLlm.Setup(l => l.IsFallbackDisabled()).Returns(true);
        _mockLlm.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync("[AI İsteği Başarısız: Sunucu kapalı]");

        await Assert.ThrowsAsync<InvalidOperationException>(() => _agent.DraftReplyWithSourceAsync(ticket.Id, "tr"));
    }

    [Fact]
    public async Task GenerateResolutionSuggestionAsync_EnHeuristic_WithSimilarTicketsAndKbArticles()
    {
        // 1. Closed status
        _context.Statuses.Add(new Status { Id = 2, Name = "Closed", IsClosedStatus = true });

        // 2. Similar resolved ticket
        _context.Tickets.Add(new Ticket
        {
            TicketNumber = "T-PAST",
            Title = "Similar printer failure",
            Description = "Replaced paper roller",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 2,
            TypeId = 1,
            RequesterUserId = 1
        });

        // 3. Relevant KB article with content > 150 chars
        _context.KnowledgeArticles.Add(new ItsTool.Domain.Entities.KnowledgeBase.KnowledgeArticle
        {
            CategoryId = 1,
            Title = "Printer Troubleshooting Guide",
            Content = new string('x', 200),
            AuthorUserId = 1,
            Status = ItsTool.Domain.Entities.KnowledgeBase.ArticleStatus.Published,
            Visibility = ItsTool.Domain.Entities.KnowledgeBase.ArticleVisibility.Public
        });

        // 4. Current ticket with comments
        var currentTicket = new Ticket
        {
            TicketNumber = "T-CURR",
            Title = "Printer Troubleshooting Guide Issue",
            Description = "Paper jam in tray 2",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            RequesterUserId = 1
        };
        _context.Tickets.Add(currentTicket);
        await _context.SaveChangesAsync();

        _context.TicketComments.Add(new TicketComment
        {
            TicketId = currentTicket.Id,
            Content = "Tech inspected tray 2",
            IsInternal = true,
            AuthorUserId = 1,
            CreatedAt = System.DateTime.UtcNow
        });
        await _context.SaveChangesAsync();

        // Failure completion with fallback enabled
        _mockLlm.Setup(l => l.IsFallbackDisabled()).Returns(false);
        _mockLlm.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync("[AI İsteği Başarısız]");

        // EN suggestion
        var enRes = await _agent.GenerateResolutionSuggestionAsync(currentTicket.Id, postAsComment: true, language: "en");
        Assert.True(enRes.Success);
        Assert.Contains("Category and Status Assessment", enRes.Suggestion);
        Assert.Contains("Past Similar Resolved Tickets", enRes.Suggestion);
        Assert.Contains("Related Knowledge Base Articles", enRes.Suggestion);

        // TR suggestion
        var trRes = await _agent.GenerateResolutionSuggestionAsync(currentTicket.Id, postAsComment: false, language: "tr");
        Assert.True(trRes.Success);
        Assert.Contains("Geçmiş Benzer Çözülmüş Biletler", trRes.Suggestion);
        Assert.Contains("İlgili Bilgi Bankası Makaleleri", trRes.Suggestion);

        // Failure with fallback disabled
        _mockLlm.Setup(l => l.IsFallbackDisabled()).Returns(true);
        _mockLlm.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync("[AI İsteği Başarısız: Connection timeout]");
        var failedRes = await _agent.GenerateResolutionSuggestionAsync(currentTicket.Id, postAsComment: false, language: "en");
        Assert.False(failedRes.Success);
    }

    [Fact]
    public async Task AskQuestionAndDraftReply_MissingTicket_ShouldReturnNotFound()
    {
        var (draft, source, isLlm) = await _agent.DraftReplyWithSourceAsync(99999, "tr");
        Assert.Contains("Bilet bulunamadı", draft);
        Assert.False(isLlm);

        var (answer, qSource, qLlm) = await _agent.AskQuestionWithSourceAsync(99999, "What to do?", "en");
        Assert.Contains("Ticket not found", answer);
        Assert.False(qLlm);
    }

    [Fact]
    public async Task AskQuestionWithSourceAsync_EnLiveAndHeuristic()
    {
        var ticket = new Ticket
        {
            TicketNumber = "T-ASK",
            Title = "Account blocked",
            Description = "Multiple failed attempts",
            CategoryId = 1,
            PriorityId = 1,
            StatusId = 1,
            TypeId = 1,
            RequesterUserId = 1
        };
        _context.Tickets.Add(ticket);
        await _context.SaveChangesAsync();

        // 1. Live LLM EN
        _mockLlm.Setup(l => l.IsFallbackDisabled()).Returns(false);
        _mockLlm.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync("You should unlock the account in AD console.");
        var (ans1, src1, llm1) = await _agent.AskQuestionWithSourceAsync(ticket.Id, "How to fix?", "en");
        Assert.True(llm1);
        Assert.Contains("AD console", ans1);

        // 2. Fallback heuristic EN
        _mockLlm.Setup(l => l.GetCompletionAsync(It.IsAny<string>(), It.IsAny<string>()))
            .ReturnsAsync("[AI İsteği Başarısız]");
        var (ans2, src2, llm2) = await _agent.AskQuestionWithSourceAsync(ticket.Id, "How to fix?", "en");
        Assert.False(llm2);
        Assert.Contains("Ticket Information", ans2);

        // 3. Fallback disabled throws
        _mockLlm.Setup(l => l.IsFallbackDisabled()).Returns(true);
        await Assert.ThrowsAsync<InvalidOperationException>(() => _agent.AskQuestionWithSourceAsync(ticket.Id, "How to fix?", "en"));
    }
}
