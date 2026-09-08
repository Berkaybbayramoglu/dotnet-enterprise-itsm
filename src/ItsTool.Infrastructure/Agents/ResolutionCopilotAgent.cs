using System;
using System.Collections.Generic;
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

public record AiSuggestionResult(bool Success, string Suggestion, string Source, string? Model);
public record SimilarTicketSummary(int Id, string TicketNumber, string Title, string? Description);
public record KbArticleSummary(int Id, string Title, string Content);

public class ResolutionCopilotAgent
{
    private const string DefaultGeneralText = "Genel";
    private static readonly JsonSerializerOptions s_jsonOptions = new() { WriteIndented = true };

    private readonly ILlmService _llmService;
    private readonly ItsToolDbContext _context;
    private readonly ILogger<ResolutionCopilotAgent> _logger;

    public ResolutionCopilotAgent(ILlmService llmService, ItsToolDbContext context, ILogger<ResolutionCopilotAgent> logger)
    {
        _llmService = llmService;
        _context = context;
        _logger = logger;
    }

    public async Task<AiSuggestionResult> GenerateResolutionSuggestionAsync(int ticketId, bool postAsComment = false)
    {
        _logger.LogInformation("ResolutionCopilotAgent generating suggestion for ticket {TicketId}", ticketId);

        var ticket = await _context.Tickets
            .Include(t => t.Category)
            .Include(t => t.Priority)
            .Include(t => t.Status)
            .FirstOrDefaultAsync(t => t.Id == ticketId);

        if (ticket == null)
        {
            return new AiSuggestionResult(false, "Bilet bulunamadı.", "Sistem", null);
        }

        var similarTickets = await GetSimilarTicketsAsync(ticket);
        var kbArticles = await GetRelevantKbArticlesAsync(ticket);

        string systemPrompt = @"Sen ITSM (BT Hizmet Yönetimi) sisteminde çalışan uzman bir yapay zeka asistanısın.
Görevin, BT destek uzmanına atanmış bu bilet için geçmiş çözülmüş biletlere, bilgi bankasına ve en iyi BT pratiklerine dayanarak uygulanabilir, net ve profesyonel bir çözüm rehberi sunmaktır.
KURALLAR:
1. Kesinlikle hiçbir emoji kullanma.
2. Kesinlikle markdown formatı kullanma (yıldız *, çift yıldız **, tire -, diyez #, ters tırnak ` vb. işaretler olmamalıdır).
3. Başlıkları iki nokta üst üste ile ayır. Maddeleri tire veya yıldız yerine sadece 1., 2. gibi düz sayılarla numaralandır.
4. Çıktıyı tamamen temiz, sade ve okunabilir düz Türkçe metin olarak üret.";

        // Fetch comments to know what happened so far
        var comments = await _context.TicketComments
            .Where(c => c.TicketId == ticketId && !c.IsDeleted)
            .OrderBy(c => c.CreatedAt)
            .Take(10)
            .Select(c => $"[{c.CreatedAt:yyyy-MM-dd HH:mm}] {c.CreatedBy} ({(c.IsInternal ? "Dahili Not" : "Kullanıcı Yorumu")}): {c.Content}")
            .ToListAsync();

        var commentsStr = comments.Count > 0 ? string.Join("\n", comments) : "Henüz bilet üzerinde yorum veya ek işlem yapılmadı.";
        var ticketDesc = string.IsNullOrWhiteSpace(ticket.Description) ? "Açıklama girilmemiş" : ticket.Description;

        var pastTicketsStr = similarTickets.Count > 0 ? JsonSerializer.Serialize(similarTickets, s_jsonOptions) : "Geçmiş benzer bilet bulunamadı.";
        var kbStr = kbArticles.Count > 0 ? JsonSerializer.Serialize(kbArticles, s_jsonOptions) : "Eşleşen bilgi bankası makalesi yok.";

        var userMessage = $"Bilet No: {ticket.TicketNumber}\nBaşlık: {ticket.Title}\nKategori: {ticket.Category?.Name ?? DefaultGeneralText}\nÖncelik: {ticket.Priority?.Name ?? "Normal"}\nAçıklama: {ticketDesc}\n\nYorum ve İşlem Geçmişi:\n{commentsStr}\n\nGeçmiş Benzer Çözülmüş Biletler:\n{pastTicketsStr}\n\nİlgili Bilgi Bankası:\n{kbStr}\n\nLütfen bilet detayları ve yorum geçmişinde yaşanan gelişmeler ışığında BT destek uzmanı için adım adım çözüm önerisi hazırla. Emojisiz ve markdownsız düz metin olarak ver.";

        string suggestion;
        string source;
        string? model = _llmService.GetModelName();

        var completion = await _llmService.GetCompletionAsync(systemPrompt, userMessage);

        if (!string.IsNullOrEmpty(completion) && !completion.StartsWith("[AI İsteği Başarısız") && !completion.StartsWith("[AI Modülü"))
        {
            suggestion = CleanPlainText(completion);
            source = $"Canlı LLM ({model})";
        }
        else
        {
            // Intelligent Rule-Based Fallback
            _logger.LogInformation("Using smart heuristic resolution suggestion for ticket {TicketId}", ticketId);
            suggestion = BuildSmartHeuristicSuggestion(ticket, similarTickets, kbArticles);
            source = "Akıllı Yerel Asistan";
        }

        suggestion = CleanPlainText(suggestion);

        if (postAsComment)
        {
            await PostBotCommentAsync(ticket.Id, suggestion, source);
        }

        return new AiSuggestionResult(true, suggestion, source, model);
    }

    private async Task<List<SimilarTicketSummary>> GetSimilarTicketsAsync(Ticket ticket)
    {
        var closedStatusIds = await _context.Statuses
            .Where(s => s.IsClosedStatus)
            .Select(s => s.Id)
            .ToListAsync();

        return await _context.Tickets
            .Where(t => t.CategoryId == ticket.CategoryId && closedStatusIds.Contains(t.StatusId) && t.Id != ticket.Id)
            .OrderByDescending(t => t.CreatedAt)
            .Take(3)
            .Select(t => new SimilarTicketSummary(t.Id, t.TicketNumber, t.Title, t.Description))
            .ToListAsync();
    }

    private async Task<List<KbArticleSummary>> GetRelevantKbArticlesAsync(Ticket ticket)
    {
        var rawArticles = await _context.KnowledgeArticles
            .Where(k => !k.IsDeleted && (k.CategoryId == ticket.CategoryId || k.Title.Contains(ticket.Title, StringComparison.OrdinalIgnoreCase)))
            .Take(3)
            .Select(k => new { k.Id, k.Title, k.Content })
            .ToListAsync();

        return rawArticles
            .Select(k => new KbArticleSummary(
                k.Id,
                k.Title,
                k.Content.Length > 150 ? string.Concat(k.Content.AsSpan(0, 150), "...") : k.Content))
            .ToList();
    }

    private async Task PostBotCommentAsync(int ticketId, string suggestion, string source)
    {
        var botNote = new TicketComment
        {
            TicketId = ticketId,
            AuthorUserId = 1, // Admin / Bot user
            Content = $"AI Copilot Çözüm Önerisi:\n\n{suggestion}\n\nKaynak: {source}",
            IsInternal = true,
            CreatedBy = "AI Copilot",
            CreatedAt = DateTime.UtcNow
        };

        _context.TicketComments.Add(botNote);
        await _context.SaveChangesAsync();
        _logger.LogInformation("ResolutionCopilotAgent added internal note for ticket {TicketId}", ticketId);
    }

    public async Task RunAsync(Ticket ticket)
    {
        await GenerateResolutionSuggestionAsync(ticket.Id, postAsComment: true);
    }

    public async Task<string> DraftReplyAsync(int ticketId)
    {
        var ticket = await _context.Tickets.Include(t => t.Category).FirstOrDefaultAsync(t => t.Id == ticketId);
        if (ticket == null) return "Bilet bulunamadı.";

        var recentComments = await _context.TicketComments
            .Where(c => c.TicketId == ticketId && !c.IsDeleted)
            .OrderBy(c => c.CreatedAt)
            .Take(5)
            .Select(c => $"[{c.CreatedAt:yyyy-MM-dd HH:mm}] {c.CreatedBy} ({(c.IsInternal ? "Dahili Not" : "Kullanıcı Yorumu")}): {c.Content}")
            .ToListAsync();

        var commentsHistory = recentComments.Count > 0 ? string.Join("\n", recentComments) : "Henüz ek bir yorum bulunmuyor.";
        var ticketDesc = string.IsNullOrWhiteSpace(ticket.Description) ? "Açıklama girilmemiş" : ticket.Description;

        string systemPrompt = @"Sen profesyonel ve nazik bir BT Destek Uzmanısın.
Görevin, kullanıcıya talebinin incelendiğini, üzerinde çalışıldığını veya gerekli adımların başlatıldığını bildiren samimi, net ve kurumsal bir e-posta / mesaj taslağı hazırlamaktır.
KURALLAR:
1. Kesinlikle hiçbir emoji kullanma.
2. Kesinlikle markdown formatı kullanma (yıldız *, çift yıldız **, tire -, diyez #, ters tırnak ` vb. işaretler olmamalıdır).
3. Çıktıyı tamamen sade ve temiz düz Türkçe metin olarak üret.";

        string userMessage = $"Bilet No: {ticket.TicketNumber}\nBaşlık: {ticket.Title}\nKullanıcı Açıklaması: {ticketDesc}\n\nBiletteki Son Gelişmeler ve Yorumlar:\n{commentsHistory}\n\nLütfen biletin güncel durumunu ve yapılan işlemleri göz önünde bulundurarak kullanıcı için nazik bir yanıt taslağı hazırla.";

        var completion = await _llmService.GetCompletionAsync(systemPrompt, userMessage);
        if (!string.IsNullOrEmpty(completion) && !completion.StartsWith("[AI İsteği Başarısız") && !completion.StartsWith("[AI Modülü"))
        {
            return CleanPlainText(completion);
        }

        // Smart fallback template
        var fallback = $"Merhaba,\n\n#{ticket.TicketNumber} numaralı \"{ticket.Title}\" konulu talebiniz tarafımıza ulaşmış ve teknik ekibimiz tarafından incelemeye alınmıştır.\n\nKonuyla ilgili gerekli kontroller yapılmakta olup, en kısa sürede tarafınıza bilgilendirme yapılacaktır. Eklemek istediğiniz ilave bir detay veya ekran görüntüsü varsa bu mesaja yanıt verebilirsiniz.\n\nİyi çalışmalar dileriz,\nBT Destek Ekibi";
        return CleanPlainText(fallback);
    }

    public async Task<string> AskQuestionAsync(int ticketId, string question)
    {
        var ticket = await _context.Tickets
            .Include(t => t.Category)
            .Include(t => t.Priority)
            .Include(t => t.Status)
            .FirstOrDefaultAsync(t => t.Id == ticketId);

        if (ticket == null) return "Bilet bulunamadı.";

        var comments = await _context.TicketComments
            .Where(c => c.TicketId == ticketId && !c.IsDeleted)
            .OrderBy(c => c.CreatedAt)
            .Take(10)
            .Select(c => $"[{c.CreatedBy} - {(c.IsInternal ? "Dahili" : DefaultGeneralText)}]: {c.Content}")
            .ToListAsync();

        string commentsSummary = string.Join("\n", comments);

        string systemPrompt = @"Sen ITSM sisteminde bilet verilerini analiz eden uzman bir BT Asistanısın.
Kullanıcının bu bilet hakkında sorduğu sorulara bilet detayları ve yorum geçmişine dayanarak net, doğru ve yardımcı yanıtlar ver (Türkçe).
KURALLAR:
1. Kesinlikle hiçbir emoji kullanma.
2. Kesinlikle markdown formatı kullanma (yıldız *, çift yıldız **, tire -, diyez #, ters tırnak ` vb. işaretler olmamalıdır).
3. Çıktıyı tamamen sade ve temiz düz Türkçe metin olarak üret.";

        string userMessage = $"Bilet Bilgileri:\nNo: {ticket.TicketNumber}\nBaşlık: {ticket.Title}\nKategori: {ticket.Category?.Name}\nÖncelik: {ticket.Priority?.Name}\nDurum: {ticket.Status?.Name}\nAçıklama: {ticket.Description}\n\nYorum Geçmişi:\n{commentsSummary}\n\nKullanıcı Sorusu: {question}";

        var completion = await _llmService.GetCompletionAsync(systemPrompt, userMessage);
        if (!string.IsNullOrEmpty(completion) && !completion.StartsWith("[AI İsteği Başarısız") && !completion.StartsWith("[AI Modülü"))
        {
            return CleanPlainText(completion);
        }

        var fallback = $"Sorunuz: \"{question}\"\n\nBilet Bilgisi: #{ticket.TicketNumber} ({ticket.Title})\nKategori: {ticket.Category?.Name ?? DefaultGeneralText}, Öncelik: {ticket.Priority?.Name ?? "Normal"}, Durum: {ticket.Status?.Name ?? "İşlemde"}.\n\nYanıt: Bu bilet için belirtilen durum teknik incelemededir.";
        return CleanPlainText(fallback);
    }

    private static string BuildSmartHeuristicSuggestion(Ticket ticket, IEnumerable<SimilarTicketSummary> similarTickets, IEnumerable<KbArticleSummary> kbArticles)
    {
        var sb = new StringBuilder();
        sb.AppendLine("Kategori ve Durum Değerlendirmesi:");
        sb.AppendLine($"Kategori: {ticket.Category?.Name ?? DefaultGeneralText}");
        sb.AppendLine($"Öncelik Düzeyi: {ticket.Priority?.Name ?? "Normal"}");
        sb.AppendLine($"Talep Başlığı: {ticket.Title}");
        sb.AppendLine();

        sb.AppendLine("Önerilen Çözüm ve Teşhis Adımları:");
        sb.AppendLine("1. İlk İnceleme ve Doğrulama: Kullanıcının belirttiği hata senaryosunu yeniden üretin veya ilgili sistem loglarını kontrol edin.");
        sb.AppendLine("2. Erişim ve Yetki Kontrolü: Kullanıcı hesabının ilgili servis üzerindeki rol ve yetki tanımlarını doğrulayın.");
        sb.AppendLine("3. Servis Durumu: İlgili sunucu, ağ geçidi veya veri tabanı servislerinin çalışma durumunu izleme panelinden gözden geçirin.");
        sb.AppendLine("4. Kullanıcı Onayı: Sorun giderildikten sonra kullanıcı ile iletişime geçerek test etmesini isteyin ve ardından bileti çözüldü olarak işaretleyin.");
        sb.AppendLine();

        var ticketList = similarTickets as IList<SimilarTicketSummary> ?? similarTickets.ToList();
        if (ticketList.Count > 0)
        {
            sb.AppendLine("Geçmiş Benzer Çözülmüş Biletler:");
            int idx = 1;
            foreach (var t in ticketList)
            {
                sb.AppendLine($"{idx++}. Bilet #{t.TicketNumber}: {t.Title}");
            }
            sb.AppendLine();
        }

        var articleList = kbArticles as IList<KbArticleSummary> ?? kbArticles.ToList();
        if (articleList.Count > 0)
        {
            sb.AppendLine("İlgili Bilgi Bankası Makaleleri:");
            int idx = 1;
            foreach (var kb in articleList)
            {
                sb.AppendLine($"{idx++}. {kb.Title} (/kb-article.html?id={kb.Id})");
            }
            sb.AppendLine();
        }

        sb.AppendLine("Not: Canlı yapay zeka desteği açık olduğunda bu öneriler model tarafından derinlemesine üretilir.");

        return CleanPlainText(sb.ToString());
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
