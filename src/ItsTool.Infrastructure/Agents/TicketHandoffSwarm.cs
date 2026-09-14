using System;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Ticket;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace ItsTool.Infrastructure.Agents;

public record AiHandoffResult(bool Success, string Summary, string Actions, string Formatted, string Source, bool IsLlm = false);

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

    private const string DefaultPriorityNormal = "Normal";

    private static string GetCommentTypeLabel(bool isInternal, bool isEn)
    {
        if (isInternal)
        {
            return isEn ? "Internal Note" : "Dahili Not";
        }
        return isEn ? "User Comment" : "Kullanıcı Yorumu";
    }

    private static (string CommentsText, List<string> RecentCommentSnippets) FormatComments(
        List<(string? Author, bool IsInternal, string Content, string Date)> comments, bool isEn)
    {
        var recentCommentSnippets = new List<string>();
        if (comments.Count == 0)
        {
            var noCommentsText = isEn
                ? "There are currently no comments or additional action records on this ticket."
                : "Bu bilet üzerinde henüz herhangi bir yorum veya ek işlem kaydı bulunmamaktadır.";
            return (noCommentsText, recentCommentSnippets);
        }

        var sb = new StringBuilder();
        int idx = 1;
        foreach (var c in comments)
        {
            var typeStr = GetCommentTypeLabel(c.IsInternal, isEn);
            var author = c.Author ?? "Kullanıcı";
            var line = $"[{c.Date}] {author} ({typeStr}): {c.Content}";
            sb.AppendLine($"{idx++}. {line}");
            recentCommentSnippets.Add(line);
        }

        return (sb.ToString().TrimEnd(), recentCommentSnippets);
    }

    private static string GetTicketDescriptionText(string? description, bool isEn)
    {
        if (!string.IsNullOrWhiteSpace(description))
        {
            return description;
        }
        return isEn ? "No description entered by user." : "Kullanıcı tarafından açıklama girilmemiş.";
    }

    private (string Summary, string Actions, string Source, bool IsLlm) ResolveHandoffOutcome(
        string? summary,
        string? extractedActions,
        Ticket ticket,
        int commentsCount,
        List<string> recentCommentSnippets,
        bool isEn)
    {
        bool summaryValid = !string.IsNullOrEmpty(summary) && !summary.StartsWith("[AI İsteği Başarısız") && !summary.StartsWith("[AI Modülü");
        bool actionsValid = !string.IsNullOrEmpty(extractedActions) && !extractedActions.StartsWith("[AI İsteği Başarısız") && !extractedActions.StartsWith("[AI Modülü");

        if (summaryValid && actionsValid)
        {
            return (CleanPlainText(summary!), CleanPlainText(extractedActions!), $"Canlı LLM Swarm ({_llmService.GetModelName()})", true);
        }

        _logger.LogInformation("Using smart heuristic handoff summary for ticket {TicketId}", ticket.Id);
        var (hSummary, hActions) = isEn
            ? BuildSmartHeuristicHandoffEn(ticket, commentsCount, recentCommentSnippets)
            : BuildSmartHeuristicHandoff(ticket, commentsCount, recentCommentSnippets);

        return (CleanPlainText(hSummary), CleanPlainText(hActions), "Akıllı Yerel Asistan", false);
    }

    public async Task<AiHandoffResult> GenerateHandoffSummaryAsync(int ticketId, bool postAsComment = false, string language = "tr")
    {
        _logger.LogInformation("TicketHandoffSwarm generating summary for ticket {TicketId} (lang: {Language})", ticketId, language);

        var ticket = await _context.Tickets
            .Include(t => t.Category)
            .Include(t => t.Priority)
            .Include(t => t.Status)
            .FirstOrDefaultAsync(t => t.Id == ticketId);

        if (ticket == null)
        {
            return new AiHandoffResult(false, "Bilet bulunamadı.", "", "", "Sistem", false);
        }

        var isEn = string.Equals(language, "en", StringComparison.OrdinalIgnoreCase);

        var rawComments = await _context.TicketComments
            .Where(c => c.TicketId == ticket.Id && !c.IsDeleted)
            .OrderBy(c => c.CreatedAt)
            .Select(c => new { 
                Author = c.CreatedBy, 
                IsInternal = c.IsInternal, 
                Content = c.Content, 
                Date = c.CreatedAt.ToString("yyyy-MM-dd HH:mm") 
            })
            .ToListAsync();

        var comments = rawComments.Select(c => (c.Author, c.IsInternal, c.Content, c.Date)).ToList();
        var (commentsText, recentCommentSnippets) = FormatComments(comments, isEn);
        var ticketDesc = GetTicketDescriptionText(ticket.Description, isEn);

        // Agent 1: Summarizer
        var summarizerPrompt = isEn
            ? @"You are an IT Service Management (ITSM) AI Assistant.
Your task is to carefully read the entire history of a ticket (title, description, and all comments/updates) and summarize the technical status into a clear and professional 3-4 sentence paragraph in plain English.
IMPORTANT: If there are actions, solutions attempted, or discussions in the comment history, include them in the summary.
RULES:
1. Absolutely do NOT use any emojis.
2. Absolutely do NOT use markdown formatting (no asterisks *, no double asterisks **, no dashes -, no hashtags #, no backticks ` etc.).
3. Write completely clean, plain English text."
            : @"Sen bir BT Destek Yönetimi (ITSM) yapay zeka asistanısın.
Görevin, bir biletin tüm geçmişini (başlık, açıklama ve bilet üzerindeki tüm yorumları/gelişmeleri) dikkatlice okuyup teknik durumu 3-4 cümlelik net ve profesyonel bir paragrafa özetlemektir.
ÖNEMLİ: Eğer yorum geçmişinde yaşanan gelişmeler, denenen çözümler veya yapılan konuşmalar varsa, bunları mutlaka özetin içine 'şu işlemler yapıldı / şu durum bildirildi' şeklinde dahil et.
KURALLAR:
1. Kesinlikle hiçbir emoji kullanma.
2. Kesinlikle markdown formatı kullanma (yıldız *, çift yıldız **, tire -, diyez #, ters tırnak ` vb. işaretler olmamalıdır).
3. Tamamen sade, temiz ve akıcı düz Türkçe metin olarak yaz.";

        var summarizerMsg = isEn
            ? $"Ticket No: {ticket.TicketNumber}\nTitle: {ticket.Title}\nPriority: {ticket.Priority?.Name ?? DefaultPriorityNormal}\nCategory: {ticket.Category?.Name ?? "General"}\nDescription: {ticketDesc}\n\nComment and Action History:\n{commentsText}\n\nPlease generate a technical summary covering the description and developments in comments. Provide plain text without emojis or markdown in English."
            : $"Bilet No: {ticket.TicketNumber}\nBaşlık: {ticket.Title}\nÖncelik: {ticket.Priority?.Name ?? DefaultPriorityNormal}\nKategori: {ticket.Category?.Name ?? "Genel"}\nAçıklama: {ticketDesc}\n\nYorum ve İşlem Geçmişi:\n{commentsText}\n\nLütfen biletin açıklamasını ve yorum geçmişinde yaşanan gelişmeleri kapsayan teknik özeti çıkar. Emojisiz ve markdownsız düz metin olarak ver.";
        
        var summaryTask = _llmService.GetCompletionAsync(summarizerPrompt, summarizerMsg);

        // Agent 2: Action Extractor
        var extractorPrompt = isEn
            ? @"You are an ITSM AI Agent.
Your task is to analyze the ticket details and comment history to extract:
1. Completed Actions and Discussion: What steps have been attempted or discussed so far? (If no comments, say 'No actions taken yet')
2. Pending Action: What is the next required step and from whom?
RULES:
1. Absolutely do NOT use any emojis.
2. Absolutely do NOT use markdown formatting.
3. Number items using plain numbers like 1., 2. instead of dashes or bullets.
4. Write completely clean, plain English text."
            : @"Sen bir ITSM yapay zeka ajanısın.
Görevin, biletin detaylarını ve özellikle varsa yorum geçmişini inceleyip şu iki temel bilgiyi net maddeler halinde çıkarmaktır:
1. Yapılan İşlemler ve Konuşulanlar: Bilette şu ana kadar hangi adımlar denendi, neler konuşuldu? (Yorum yoksa 'Henüz bir işlem yapılmadı' de)
2. Bekleyen Aksiyon: Şu an kimden ne bekleniyor, sıradaki adım nedir?
KURALLAR:
1. Kesinlikle hiçbir emoji kullanma.
2. Kesinlikle markdown formatı kullanma (yıldız *, çift yıldız **, tire -, diyez #, ters tırnak ` vb. işaretler olmamalıdır).
3. Maddeleri tire veya yıldız yerine sadece 1., 2. gibi düz sayılarla numaralandır.
4. Tamamen sade ve temiz düz Türkçe metin olarak yaz.";

        var extractorMsg = isEn
            ? $"Ticket No: {ticket.TicketNumber}\nTitle: {ticket.Title}\nDescription: {ticketDesc}\n\nComment and Action History:\n{commentsText}\n\nPlease extract attempted steps, discussed points and next pending action. Plain text without emojis or markdown in English."
            : $"Bilet No: {ticket.TicketNumber}\nBaşlık: {ticket.Title}\nAçıklama: {ticketDesc}\n\nYorum ve İşlem Geçmişi:\n{commentsText}\n\nLütfen denenen adımları, yorumlarda konuşulanları ve bekleyen sonraki aksiyonu çıkar. Emojisiz ve markdownsız düz metin olarak ver.";

        var extractorTask = _llmService.GetCompletionAsync(extractorPrompt, extractorMsg);

        await Task.WhenAll(summaryTask, extractorTask);

        var (finalSummary, finalActions, source, isLlm) = ResolveHandoffOutcome(
            summaryTask.Result,
            extractorTask.Result,
            ticket,
            comments.Count,
            recentCommentSnippets,
            isEn);

        finalSummary = CleanPlainText(finalSummary);
        finalActions = CleanPlainText(finalActions);

        var headerLabel = isEn ? "Summary:" : "Özet:";
        var actionsLabel = isEn ? "Developments and Pending Actions:" : "Gelişmeler ve Bekleyen Aksiyonlar:";
        var finalCombined = string.IsNullOrWhiteSpace(finalActions)
            ? finalSummary
            : $"{headerLabel}\n{finalSummary}\n\n{actionsLabel}\n{finalActions}";

        var sourceLabel = isEn ? "Source:" : "Kaynak:";
        var finalFormatted = $"{finalCombined}\n\n{sourceLabel} {source}";

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

        return new AiHandoffResult(true, finalCombined, finalActions, finalCombined, source, isLlm);
    }

    internal static (string Summary, string Actions) BuildSmartHeuristicHandoffEn(Ticket ticket, int commentCount, List<string>? recentComments = null)
    {
        var desc = string.IsNullOrWhiteSpace(ticket.Description) ? "No description provided." : ticket.Description;
        var summary = $"Ticket #{ticket.TicketNumber} titled \"{ticket.Title}\" was created on {ticket.CreatedAt:dd.MM.yyyy HH:mm}. Ticket description: \"{desc}\". There are currently {commentCount} actions or comments recorded on this ticket.";

        var actions = new StringBuilder();
        if (recentComments != null && recentComments.Count > 0)
        {
            actions.AppendLine("1. Recent Actions and Comments:");
            foreach (var rc in recentComments.Take(3))
            {
                actions.AppendLine($"   {rc}");
            }
            actions.AppendLine($"2. Priority Level: Being handled at {ticket.Priority?.Name ?? DefaultPriorityNormal} priority.");
            actions.AppendLine("3. Next Pending Action: The assigned specialist is expected to continue investigation and update the user.");
        }
        else
        {
            actions.AppendLine("1. Current Status: Ticket is currently in review and handoff process.");
            actions.AppendLine($"2. Priority Level: Being handled at {ticket.Priority?.Name ?? DefaultPriorityNormal} priority.");
            actions.AppendLine("3. Next Pending Action: Newly assigned team should review logs and provide initial technical update.");
        }

        return (CleanPlainText(summary), CleanPlainText(actions.ToString()));
    }

    public virtual async Task RunAsync(Ticket ticket)
    {
        await GenerateHandoffSummaryAsync(ticket.Id, postAsComment: true);
    }

    internal static (string Summary, string Actions) BuildSmartHeuristicHandoff(Ticket ticket, int commentCount, List<string>? recentComments = null)
    {
        var desc = string.IsNullOrWhiteSpace(ticket.Description) ? "Açıklama girilmemiş" : ticket.Description;
        var summary = $"#{ticket.TicketNumber} numaralı \"{ticket.Title}\" talebi {ticket.CreatedAt:dd.MM.yyyy HH:mm} tarihinde oluşturulmuştur. Talep açıklaması: \"{desc}\". Bilet üzerinde şu ana kadar {commentCount} adet işlem veya yorum kaydı bulunmaktadır.";

        var actions = new StringBuilder();
        if (recentComments != null && recentComments.Count > 0)
        {
            actions.AppendLine("1. Son Yapılan İşlemler ve Yorumlar:");
            foreach (var rc in recentComments.Take(3))
            {
                actions.AppendLine($"   {rc}");
            }
            actions.AppendLine($"2. Öncelik Seviyesi: {ticket.Priority?.Name ?? DefaultPriorityNormal} seviyesinde ele alınmaktadır.");
            actions.AppendLine("3. Sıradaki Bekleyen Aksiyon: İlgili teknik uzmanın incelemeyi sürdürmesi ve kullanıcıya geri bildirim sağlaması beklenmektedir.");
        }
        else
        {
            actions.AppendLine("1. Mevcut Durum: Bilet halihazırda inceleme ve devir sürecindedir.");
            actions.AppendLine($"2. Öncelik Seviyesi: {ticket.Priority?.Name ?? DefaultPriorityNormal} seviyesinde ele alınmaktadır.");
            actions.AppendLine("3. Sıradaki Bekleyen Aksiyon: Yeni atanan teknik ekibin logları kontrol ederek ilk teknik geri bildirimi sağlaması veya kullanıcıdan bilgi talep etmesi gerekmektedir.");
        }

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
        text = Regex.Replace(text, @"(?m)^[\s]*[-\*]\s+", "", RegexOptions.None, TimeSpan.FromSeconds(2));

        // Remove standalone asterisks
        text = text.Replace("*", "");

        // Remove markdown headers (### Header -> Header)
        text = Regex.Replace(text, @"(?m)^[\s]*#+\s*", "", RegexOptions.None, TimeSpan.FromSeconds(2));

        // Convert markdown links [Text](url) -> Text (url)
        text = Regex.Replace(text, @"\[([^\]]+)\]\(([^)]+)\)", "$1 ($2)", RegexOptions.None, TimeSpan.FromSeconds(2));

        // Remove all emojis using unicode categories and surrogate pairs
        text = Regex.Replace(text, @"[\u2700-\u27BF]|[\uE000-\uF8FF]|\uD83C[\uDC00-\uDFFF]|\uD83D[\uDC00-\uDFFF]|[\u2011-\u26FF]|\uD83E[\uDD10-\uDDFF]", "", RegexOptions.None, TimeSpan.FromSeconds(2));
        text = Regex.Replace(text, @"\p{Cs}|\p{So}|\p{Sk}", "", RegexOptions.None, TimeSpan.FromSeconds(2));

        // Clean up any double blank lines
        text = Regex.Replace(text, @"\n{3,}", "\n\n", RegexOptions.None, TimeSpan.FromSeconds(2));

        return text.Trim();
    }
}
