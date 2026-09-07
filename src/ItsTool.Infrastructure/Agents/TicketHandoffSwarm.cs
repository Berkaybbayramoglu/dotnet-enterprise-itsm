using System;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace ItsTool.Infrastructure.Agents;

public record AiHandoffResult(bool Success, string Summary, string Actions, string Formatted, string Source);

public class TicketHandoffSwarm
{
    private readonly ILlmService _llmService;
    private readonly ItsToolDbContext _context;
    private readonly ILogger<TicketHandoffSwarm> _logger;

    public TicketHandoffSwarm(ILlmService llmService, ItsToolDbContext context, ILogger<TicketHandoffSwarm> logger)
    {
        _llmService = llmService;
        _context = context;
        _logger = logger;
    }

    public async Task<AiHandoffResult> GenerateHandoffSummaryAsync(int ticketId, bool postAsComment = false)
    {
        _logger.LogInformation("TicketHandoffSwarm generating summary for ticket {TicketId}", ticketId);

        var ticket = await _context.Tickets
            .Include(t => t.Category)
            .Include(t => t.Priority)
            .Include(t => t.Status)
            .FirstOrDefaultAsync(t => t.Id == ticketId);

        if (ticket == null)
        {
            return new AiHandoffResult(false, "Bilet bulunamadı.", "", "", "Sistem");
        }

        var comments = await _context.TicketComments
            .Where(c => c.TicketId == ticket.Id && !c.IsDeleted)
            .OrderBy(c => c.CreatedAt)
            .Select(c => new { 
                Author = c.CreatedBy, 
                IsInternal = c.IsInternal, 
                Content = c.Content, 
                Date = c.CreatedAt.ToString("yyyy-MM-dd HH:mm") 
            })
            .ToListAsync();

        var commentsJson = JsonSerializer.Serialize(comments, new JsonSerializerOptions { WriteIndented = true });

        // Agent 1: Summarizer
        var summarizerPrompt = @"Sen bir ITSM yapay zeka ajanısın.
Görevin, başka bir gruba veya uzmana devredilen bu biletin geçmişini ve detaylarını okuyup, teknik süreci 3-4 cümlelik net ve profesyonel bir paragrafa özetlemektir.
Sadece teknik detaylara, kullanıcı şikayetine ve gelinen aşamaya odaklan (Türkçe).
KURALLAR:
1. Kesinlikle hiçbir emoji kullanma.
2. Kesinlikle markdown formatı kullanma (yıldız *, çift yıldız **, tire -, diyez #, ters tırnak ` vb. işaretler olmamalıdır).
3. Tamamen sade ve temiz düz Türkçe metin olarak yaz.";

        var summarizerMsg = $"Bilet No: {ticket.TicketNumber}\nBaşlık: {ticket.Title}\nAçıklama: {ticket.Description}\n\nYorum Geçmişi:\n{commentsJson}\n\nLütfen bu biletin teknik özetini çıkar. Emojisiz ve markdownsız düz metin olarak ver.";
        
        var summaryTask = _llmService.GetCompletionAsync(summarizerPrompt, summarizerMsg);

        // Agent 2: Action Extractor
        var extractorPrompt = @"Sen bir ITSM yapay zeka ajanısın.
Görevin, devredilen biletin tüm geçmişini inceleyip şu iki bilgiyi çıkarmaktır:
1. Neler denendi veya konuşuldu?
2. Şu an tam olarak kimden ne bekleniyor (bekleyen sonraki aksiyon nedir)?
KURALLAR:
1. Kesinlikle hiçbir emoji kullanma.
2. Kesinlikle markdown formatı kullanma (yıldız *, çift yıldız **, tire -, diyez #, ters tırnak ` vb. işaretler olmamalıdır).
3. Maddeleri tire veya yıldız yerine sadece 1., 2. gibi düz sayılarla numaralandır.
4. Tamamen sade ve temiz düz Türkçe metin olarak yaz.";

        var extractorMsg = $"Bilet No: {ticket.TicketNumber}\nBaşlık: {ticket.Title}\nAçıklama: {ticket.Description}\n\nYorum Geçmişi:\n{commentsJson}\n\nLütfen denenen adımları ve bekleyen aksiyonları çıkar. Emojisiz ve markdownsız düz metin olarak ver.";

        var extractorTask = _llmService.GetCompletionAsync(extractorPrompt, extractorMsg);

        await Task.WhenAll(summaryTask, extractorTask);

        var summary = summaryTask.Result;
        var extractedActions = extractorTask.Result;

        string finalSummary;
        string finalActions;
        string source;

        if (!string.IsNullOrEmpty(summary) && !summary.StartsWith("[AI İsteği Başarısız") && !summary.StartsWith("[AI Modülü") &&
            !string.IsNullOrEmpty(extractedActions) && !extractedActions.StartsWith("[AI İsteği Başarısız") && !extractedActions.StartsWith("[AI Modülü"))
        {
            finalSummary = CleanPlainText(summary);
            finalActions = CleanPlainText(extractedActions);
            source = $"Canlı LLM Swarm ({_llmService.GetModelName()})";
        }
        else
        {
            _logger.LogInformation("Using smart heuristic handoff summary for ticket {TicketId}", ticketId);
            var (hSummary, hActions) = BuildSmartHeuristicHandoff(ticket, comments.Count);
            finalSummary = hSummary;
            finalActions = hActions;
            source = "Akıllı Yerel Asistan";
        }

        finalSummary = CleanPlainText(finalSummary);
        finalActions = CleanPlainText(finalActions);

        var finalFormatted = $"Özet:\n{finalSummary}\n\nAksiyonlar ve Durum:\n{finalActions}\n\nKaynak: {source}";

        if (postAsComment)
        {
            var botNote = new TicketComment
            {
                TicketId = ticket.Id,
                AuthorUserId = 1,
                Content = $"AI Multi-Agent Handoff Özeti (Görev Devri):\n\n{finalFormatted}",
                IsInternal = true,
                CreatedBy = "AI Swarm", 
                CreatedAt = DateTime.UtcNow
            };

            _context.TicketComments.Add(botNote);
            await _context.SaveChangesAsync();
            _logger.LogInformation("TicketHandoffSwarm added handoff summary for ticket {TicketId}", ticket.Id);
        }

        return new AiHandoffResult(true, finalSummary, finalActions, finalFormatted, source);
    }

    public async Task RunAsync(Ticket ticket)
    {
        await GenerateHandoffSummaryAsync(ticket.Id, postAsComment: true);
    }

    private static (string Summary, string Actions) BuildSmartHeuristicHandoff(Ticket ticket, int commentCount)
    {
        var summary = $"#{ticket.TicketNumber} numaralı \"{ticket.Title}\" talebi {ticket.CreatedAt:dd.MM.yyyy HH:mm} tarihinde oluşturulmuştur. Talep kapsamında kullanıcı tarafından bildirilen sorun: \"{ticket.Description}\". Bilet üzerinde şu ana kadar {commentCount} adet işlem veya yorum kaydı bulunmaktadır.";

        var actions = new StringBuilder();
        actions.AppendLine("1. Mevcut Durum: Bilet halihazırda inceleme ve devir sürecindedir.");
        actions.AppendLine($"2. Öncelik Seviyesi: {ticket.Priority?.Name ?? "Normal"} seviyesinde ele alınmaktadır.");
        actions.AppendLine("3. Sıradaki Beklenen Aksiyon: Yeni atanan teknik ekibin logları kontrol ederek ilk teknik geri bildirimi sağlaması veya kullanıcıdan bilgi talep etmesi gerekmektedir.");

        return (CleanPlainText(summary), CleanPlainText(actions.ToString()));
    }

    public static string CleanPlainText(string? input)
    {
        if (string.IsNullOrWhiteSpace(input)) return string.Empty;

        var text = input;

        // Remove markdown bold/italic (**text** -> text, *text* -> text, __text__ -> text, _text_ -> text)
        text = text.Replace("**", "").Replace("__", "");
        text = text.Replace("`", "");
        
        // Remove markdown list bullets (- item -> item, * item -> item)
        text = System.Text.RegularExpressions.Regex.Replace(text, @"(?m)^[\s]*[-\*]\s+", "");

        // Remove standalone asterisks
        text = text.Replace("*", "");

        // Remove markdown headers (### Header -> Header)
        text = System.Text.RegularExpressions.Regex.Replace(text, @"(?m)^[\s]*#+\s*", "");

        // Convert markdown links [Text](url) -> Text (url)
        text = System.Text.RegularExpressions.Regex.Replace(text, @"\[([^\]]+)\]\(([^)]+)\)", "$1 ($2)");

        // Remove all emojis using unicode categories and surrogate pairs
        text = System.Text.RegularExpressions.Regex.Replace(text, @"[\u2700-\u27BF]|[\uE000-\uF8FF]|\uD83C[\uDC00-\uDFFF]|\uD83D[\uDC00-\uDFFF]|[\u2011-\u26FF]|\uD83E[\uDD10-\uDDFF]", "");
        text = System.Text.RegularExpressions.Regex.Replace(text, @"\p{Cs}|\p{So}|\p{Sk}", "");

        // Clean up any double blank lines
        text = System.Text.RegularExpressions.Regex.Replace(text, @"\n{3,}", "\n\n");

        return text.Trim();
    }
}
