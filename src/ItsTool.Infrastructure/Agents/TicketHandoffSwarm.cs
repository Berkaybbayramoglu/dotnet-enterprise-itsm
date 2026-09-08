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

        string commentsText;
        var recentCommentSnippets = new List<string>();
        if (comments.Count > 0)
        {
            var sbComments = new StringBuilder();
            int idx = 1;
            foreach (var c in comments)
            {
                var typeStr = c.IsInternal ? "Dahili Not" : "Kullanıcı Yorumu";
                var line = $"[{c.Date}] {c.Author} ({typeStr}): {c.Content}";
                sbComments.AppendLine($"{idx++}. {line}");
                recentCommentSnippets.Add(line);
            }
            commentsText = sbComments.ToString().TrimEnd();
        }
        else
        {
            commentsText = "Bu bilet üzerinde henüz herhangi bir yorum veya ek işlem kaydı bulunmamaktadır.";
        }

        var ticketDesc = string.IsNullOrWhiteSpace(ticket.Description) ? "Kullanıcı tarafından açıklama girilmemiş." : ticket.Description;

        // Agent 1: Summarizer
        var summarizerPrompt = @"Sen bir BT Destek Yönetimi (ITSM) yapay zeka asistanısın.
Görevin, bir biletin tüm geçmişini (başlık, açıklama ve bilet üzerindeki tüm yorumları/gelişmeleri) dikkatlice okuyup teknik durumu 3-4 cümlelik net ve profesyonel bir paragrafa özetlemektir.
ÖNEMLİ: Eğer yorum geçmişinde yaşanan gelişmeler, denenen çözümler veya yapılan konuşmalar varsa, bunları mutlaka özetin içine 'şu işlemler yapıldı / şu durum bildirildi' şeklinde dahil et.
KURALLAR:
1. Kesinlikle hiçbir emoji kullanma.
2. Kesinlikle markdown formatı kullanma (yıldız *, çift yıldız **, tire -, diyez #, ters tırnak ` vb. işaretler olmamalıdır).
3. Tamamen sade, temiz ve akıcı düz Türkçe metin olarak yaz.";

        var summarizerMsg = $"Bilet No: {ticket.TicketNumber}\nBaşlık: {ticket.Title}\nÖncelik: {ticket.Priority?.Name ?? "Normal"}\nKategori: {ticket.Category?.Name ?? "Genel"}\nAçıklama: {ticketDesc}\n\nYorum ve İşlem Geçmişi:\n{commentsText}\n\nLütfen biletin açıklamasını ve yorum geçmişinde yaşanan gelişmeleri kapsayan teknik özeti çıkar. Emojisiz ve markdownsız düz metin olarak ver.";
        
        var summaryTask = _llmService.GetCompletionAsync(summarizerPrompt, summarizerMsg);

        // Agent 2: Action Extractor
        var extractorPrompt = @"Sen bir ITSM yapay zeka ajanısın.
Görevin, biletin detaylarını ve özellikle varsa yorum geçmişini inceleyip şu iki temel bilgiyi net maddeler halinde çıkarmaktır:
1. Yapılan İşlemler ve Konuşulanlar: Bilette şu ana kadar hangi adımlar denendi, neler konuşuldu? (Yorum yoksa 'Henüz bir işlem yapılmadı' de)
2. Bekleyen Aksiyon: Şu an kimden ne bekleniyor, sıradaki adım nedir?
KURALLAR:
1. Kesinlikle hiçbir emoji kullanma.
2. Kesinlikle markdown formatı kullanma (yıldız *, çift yıldız **, tire -, diyez #, ters tırnak ` vb. işaretler olmamalıdır).
3. Maddeleri tire veya yıldız yerine sadece 1., 2. gibi düz sayılarla numaralandır.
4. Tamamen sade ve temiz düz Türkçe metin olarak yaz.";

        var extractorMsg = $"Bilet No: {ticket.TicketNumber}\nBaşlık: {ticket.Title}\nAçıklama: {ticketDesc}\n\nYorum ve İşlem Geçmişi:\n{commentsText}\n\nLütfen denenen adımları, yorumlarda konuşulanları ve bekleyen sonraki aksiyonu çıkar. Emojisiz ve markdownsız düz metin olarak ver.";

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
            var (hSummary, hActions) = BuildSmartHeuristicHandoff(ticket, comments.Count, recentCommentSnippets);
            finalSummary = hSummary;
            finalActions = hActions;
            source = "Akıllı Yerel Asistan";
        }

        finalSummary = CleanPlainText(finalSummary);
        finalActions = CleanPlainText(finalActions);

        var finalCombined = string.IsNullOrWhiteSpace(finalActions)
            ? finalSummary
            : $"Özet:\n{finalSummary}\n\nGelişmeler ve Bekleyen Aksiyonlar:\n{finalActions}";

        var finalFormatted = $"{finalCombined}\n\nKaynak: {source}";

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

        return new AiHandoffResult(true, finalCombined, finalActions, finalCombined, source);
    }

    public async Task RunAsync(Ticket ticket)
    {
        await GenerateHandoffSummaryAsync(ticket.Id, postAsComment: true);
    }

    private static (string Summary, string Actions) BuildSmartHeuristicHandoff(Ticket ticket, int commentCount, List<string>? recentComments = null)
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
            actions.AppendLine($"2. Öncelik Seviyesi: {ticket.Priority?.Name ?? "Normal"} seviyesinde ele alınmaktadır.");
            actions.AppendLine("3. Sıradaki Bekleyen Aksiyon: İlgili teknik uzmanın incelemeyi sürdürmesi ve kullanıcıya geri bildirim sağlaması beklenmektedir.");
        }
        else
        {
            actions.AppendLine("1. Mevcut Durum: Bilet halihazırda inceleme ve devir sürecindedir.");
            actions.AppendLine($"2. Öncelik Seviyesi: {ticket.Priority?.Name ?? "Normal"} seviyesinde ele alınmaktadır.");
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
