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

public record AiSuggestionResult(bool Success, string Suggestion, string Source, string? Model, bool IsLlm = false);
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

    public async Task<AiSuggestionResult> GenerateResolutionSuggestionAsync(int ticketId, bool postAsComment = false, string language = "tr")
    {
        _logger.LogInformation("ResolutionCopilotAgent generating suggestion for ticket {TicketId} (lang: {Language})", ticketId, language);

        var ticket = await _context.Tickets
            .Include(t => t.Category)
            .Include(t => t.Priority)
            .Include(t => t.Status)
            .FirstOrDefaultAsync(t => t.Id == ticketId);

        if (ticket == null)
        {
            return new AiSuggestionResult(false, "Bilet bulunamadı.", "Sistem", null, false);
        }

        var isEn = string.Equals(language, "en", StringComparison.OrdinalIgnoreCase);
        var similarTickets = await GetSimilarTicketsAsync(ticket);
        var kbArticles = await GetRelevantKbArticlesAsync(ticket);

        string systemPrompt = isEn
            ? @"You are an expert AI assistant working in an ITSM (IT Service Management) system.
Your task is to provide an actionable, clear, and professional resolution guide for the IT support specialist assigned to this ticket, based on past resolved tickets, knowledge base articles, and best IT practices.
RULES:
1. Absolutely do NOT use any emojis.
2. Absolutely do NOT use markdown formatting (no asterisks *, no double asterisks **, no dashes -, no hashtags #, no backticks ` etc.).
3. Separate sections with colons. Number items using plain numbers like 1., 2. instead of dashes or bullets.
4. Generate the output entirely in plain, clean, readable English."
            : @"Sen ITSM (BT Hizmet Yönetimi) sisteminde çalışan uzman bir yapay zeka asistanısın.
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

        var commentsStr = comments.Count > 0 ? string.Join("\n", comments) : (isEn ? "No comments or additional actions on this ticket yet." : "Henüz bilet üzerinde yorum veya ek işlem yapılmadı.");
        var ticketDesc = string.IsNullOrWhiteSpace(ticket.Description) ? (isEn ? "No description provided" : "Açıklama girilmemiş") : ticket.Description;

        var pastTicketsStr = similarTickets.Count > 0 ? JsonSerializer.Serialize(similarTickets, s_jsonOptions) : (isEn ? "No similar resolved tickets found." : "Geçmiş benzer bilet bulunamadı.");
        var kbStr = kbArticles.Count > 0 ? JsonSerializer.Serialize(kbArticles, s_jsonOptions) : (isEn ? "No matching knowledge base articles." : "Eşleşen bilgi bankası makalesi yok.");

        var userMessage = isEn
            ? $"Ticket No: {ticket.TicketNumber}\nTitle: {ticket.Title}\nCategory: {ticket.Category?.Name ?? "General"}\nPriority: {ticket.Priority?.Name ?? "Normal"}\nDescription: {ticketDesc}\n\nComment and Action History:\n{commentsStr}\n\nPast Similar Resolved Tickets:\n{pastTicketsStr}\n\nRelated Knowledge Base:\n{kbStr}\n\nPlease prepare a step-by-step resolution recommendation for the IT support technician in light of the ticket details and progress in comments. Provide output as plain text without emojis or markdown in English."
            : $"Bilet No: {ticket.TicketNumber}\nBaşlık: {ticket.Title}\nKategori: {ticket.Category?.Name ?? DefaultGeneralText}\nÖncelik: {ticket.Priority?.Name ?? "Normal"}\nAçıklama: {ticketDesc}\n\nYorum ve İşlem Geçmişi:\n{commentsStr}\n\nGeçmiş Benzer Çözülmüş Biletler:\n{pastTicketsStr}\n\nİlgili Bilgi Bankası:\n{kbStr}\n\nLütfen bilet detayları ve yorum geçmişinde yaşanan gelişmeler ışığında BT destek uzmanı için adım adım çözüm önerisi hazırla. Emojisiz ve markdownsız düz metin olarak ver.";

        string suggestion;
        string source;
        bool isLlm = false;
        string? model = _llmService.GetModelName();

        var completion = await _llmService.GetCompletionAsync(systemPrompt, userMessage);

        if (!string.IsNullOrEmpty(completion) && !completion.StartsWith("[AI İsteği Başarısız") && !completion.StartsWith("[AI Modülü"))
        {
            suggestion = CleanPlainText(completion);
            source = $"Canlı LLM ({model})";
            isLlm = true;
        }
        else
        {
            if (_llmService.IsFallbackDisabled())
            {
                var errMsg = completion.StartsWith("[AI İsteği Başarısız: ")
                    ? completion.Substring("[AI İsteği Başarısız: ".Length).TrimEnd(']')
                    : completion;
                return new AiSuggestionResult(false, $"LLM Bağlantısı Kurulamadı: {errMsg}", "LLM Bağlantı Hatası", model, false);
            }

            // Intelligent Rule-Based Fallback
            _logger.LogInformation("Using smart heuristic resolution suggestion for ticket {TicketId}", ticketId);
            suggestion = isEn 
                ? BuildSmartHeuristicSuggestionEn(ticket, similarTickets, kbArticles) 
                : BuildSmartHeuristicSuggestion(ticket, similarTickets, kbArticles);
            source = "Akıllı Yerel Asistan";
            isLlm = false;
        }

        suggestion = CleanPlainText(suggestion);

        if (postAsComment)
        {
            await PostBotCommentAsync(ticket.Id, suggestion, source);
        }

        return new AiSuggestionResult(true, suggestion, source, model, isLlm);
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
        var titleLower = ticket.Title?.ToLower() ?? string.Empty;
        var rawArticles = await _context.KnowledgeArticles
            .Where(k => !k.IsDeleted && (k.CategoryId == ticket.CategoryId || (!string.IsNullOrEmpty(titleLower) && k.Title.ToLower().Contains(titleLower))))
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

    public virtual async Task RunAsync(Ticket ticket)
    {
        await GenerateResolutionSuggestionAsync(ticket.Id, postAsComment: true);
    }

    public async Task<string> DraftReplyAsync(int ticketId, string language = "tr")
    {
        var (draft, _, _) = await DraftReplyWithSourceAsync(ticketId, language);
        return draft;
    }

    public async Task<(string Draft, string Source, bool IsLlm)> DraftReplyWithSourceAsync(int ticketId, string language = "tr")
    {
        var isEn = string.Equals(language, "en", StringComparison.OrdinalIgnoreCase);
        var ticket = await _context.Tickets.Include(t => t.Category).FirstOrDefaultAsync(t => t.Id == ticketId);
        if (ticket == null) return (isEn ? "Ticket not found." : "Bilet bulunamadı.", "Sistem", false);

        var recentComments = await _context.TicketComments
            .Where(c => c.TicketId == ticketId && !c.IsDeleted)
            .OrderBy(c => c.CreatedAt)
            .Take(5)
            .Select(c => $"[{c.CreatedAt:yyyy-MM-dd HH:mm}] {c.CreatedBy} ({(c.IsInternal ? "Dahili Not" : "Kullanıcı Yorumu")}): {c.Content}")
            .ToListAsync();

        var commentsHistory = recentComments.Count > 0 ? string.Join("\n", recentComments) : (isEn ? "No additional comments yet." : "Henüz ek bir yorum bulunmuyor.");
        var ticketDesc = string.IsNullOrWhiteSpace(ticket.Description) ? (isEn ? "No description provided" : "Açıklama girilmemiş") : ticket.Description;

        string systemPrompt = isEn
            ? @"You are a professional and courteous IT Support Specialist.
Your task is to draft a polite, clear, and corporate email / message template to inform the user that their request has been received, is being worked on, or necessary actions have been started.
RULES:
1. Absolutely do NOT use any emojis.
2. Absolutely do NOT use markdown formatting (no asterisks *, no double asterisks **, no dashes -, no hashtags #, no backticks ` etc.).
3. Produce clean, plain text in English."
            : @"Sen profesyonel ve nazik bir BT Destek Uzmanısın.
Görevin, kullanıcıya talebinin incelendiğini, üzerinde çalışıldığını veya gerekli adımların başlatıldığını bildiren samimi, net ve kurumsal bir e-posta / mesaj taslağı hazırlamaktır.
KURALLAR:
1. Kesinlikle hiçbir emoji kullanma.
2. Kesinlikle markdown formatı kullanma (yıldız *, çift yıldız **, tire -, diyez #, ters tırnak ` vb. işaretler olmamalıdır).
3. Çıktıyı tamamen sade ve temiz düz Türkçe metin olarak üret.";

        string userMessage = isEn
            ? $"Ticket No: {ticket.TicketNumber}\nTitle: {ticket.Title}\nUser Description: {ticketDesc}\n\nRecent Updates and Comments:\n{commentsHistory}\n\nPlease draft a polite reply template in plain English for the requester based on the ticket status and actions taken."
            : $"Bilet No: {ticket.TicketNumber}\nBaşlık: {ticket.Title}\nKullanıcı Açıklaması: {ticketDesc}\n\nBiletteki Son Gelişmeler ve Yorumlar:\n{commentsHistory}\n\nLütfen biletin güncel durumunu ve yapılan işlemleri göz önünde bulundurarak kullanıcı için nazik bir yanıt taslağı hazırla.";

        var completion = await _llmService.GetCompletionAsync(systemPrompt, userMessage);
        if (!string.IsNullOrEmpty(completion) && !completion.StartsWith("[AI İsteği Başarısız") && !completion.StartsWith("[AI Modülü"))
        {
            return (CleanPlainText(completion), $"Canlı LLM ({_llmService.GetModelName()})", true);
        }

        if (_llmService.IsFallbackDisabled())
        {
            var errMsg = completion.StartsWith("[AI İsteği Başarısız: ")
                ? completion.Substring("[AI İsteği Başarısız: ".Length).TrimEnd(']')
                : completion;
            throw new InvalidOperationException($"LLM Bağlantısı Kurulamadı: {errMsg}");
        }

        // Smart fallback template
        var fallback = isEn
            ? $"Hello,\n\nYour request #{ticket.TicketNumber} regarding \"{ticket.Title}\" has been received and is currently being investigated by our technical support team.\n\nAll necessary checks are in progress, and we will update you as soon as possible. If you have any additional details or error screenshots to provide, please reply to this message.\n\nBest regards,\nIT Support Team"
            : $"Merhaba,\n\n#{ticket.TicketNumber} numaralı \"{ticket.Title}\" konulu talebiniz tarafımıza ulaşmış ve teknik ekibimiz tarafından incelemeye alınmıştır.\n\nKonuyla ilgili gerekli kontroller yapılmakta olup, en kısa sürede tarafınıza bilgilendirme yapılacaktır. Eklemek istediğiniz ilave bir detay veya ekran görüntüsü varsa bu mesaja yanıt verebilirsiniz.\n\nİyi çalışmalar dileriz,\nBT Destek Ekibi";
        return (CleanPlainText(fallback), "Akıllı Yerel Asistan", false);
    }

    public async Task<string> AskQuestionAsync(int ticketId, string question, string language = "tr")
    {
        var (answer, _, _) = await AskQuestionWithSourceAsync(ticketId, question, language);
        return answer;
    }

    public async Task<(string Answer, string Source, bool IsLlm)> AskQuestionWithSourceAsync(int ticketId, string question, string language = "tr")
    {
        var isEn = string.Equals(language, "en", StringComparison.OrdinalIgnoreCase);
        var ticket = await _context.Tickets
            .Include(t => t.Category)
            .Include(t => t.Priority)
            .Include(t => t.Status)
            .FirstOrDefaultAsync(t => t.Id == ticketId);

        if (ticket == null) return (isEn ? "Ticket not found." : "Bilet bulunamadı.", "Sistem", false);

        var comments = await _context.TicketComments
            .Where(c => c.TicketId == ticketId && !c.IsDeleted)
            .OrderBy(c => c.CreatedAt)
            .Take(10)
            .Select(c => $"[{c.CreatedBy} - {(c.IsInternal ? "Dahili" : DefaultGeneralText)}]: {c.Content}")
            .ToListAsync();

        string commentsSummary = string.Join("\n", comments);

        string systemPrompt = isEn
            ? @"You are an expert IT Assistant analyzing ticket data in an ITSM system.
Answer the user's question about this ticket accurately, concisely, and helpfully based on ticket details and comment history.
RULES:
1. Absolutely do NOT use any emojis.
2. Absolutely do NOT use markdown formatting (no asterisks *, no double asterisks **, no dashes -, no hashtags #, no backticks ` etc.).
3. Produce clean, plain text in English."
            : @"Sen ITSM sisteminde bilet verilerini analiz eden uzman bir BT Asistanısın.
Kullanıcının bu bilet hakkında sorduğu sorulara bilet detayları ve yorum geçmişine dayanarak net, doğru ve yardımcı yanıtlar ver (Türkçe).
KURALLAR:
1. Kesinlikle hiçbir emoji kullanma.
2. Kesinlikle markdown formatı kullanma (yıldız *, çift yıldız **, tire -, diyez #, ters tırnak ` vb. işaretler olmamalıdır).
3. Çıktıyı tamamen sade ve temiz düz Türkçe metin olarak üret.";

        string userMessage = isEn
            ? $"Ticket Details:\nNo: {ticket.TicketNumber}\nTitle: {ticket.Title}\nCategory: {ticket.Category?.Name}\nPriority: {ticket.Priority?.Name}\nStatus: {ticket.Status?.Name}\nDescription: {ticket.Description}\n\nComment History:\n{commentsSummary}\n\nUser Question: {question}\n\nPlease answer the question in plain English."
            : $"Bilet Bilgileri:\nNo: {ticket.TicketNumber}\nBaşlık: {ticket.Title}\nKategori: {ticket.Category?.Name}\nÖncelik: {ticket.Priority?.Name}\nDurum: {ticket.Status?.Name}\nAçıklama: {ticket.Description}\n\nYorum Geçmişi:\n{commentsSummary}\n\nKullanıcı Sorusu: {question}";

        var completion = await _llmService.GetCompletionAsync(systemPrompt, userMessage);
        if (!string.IsNullOrEmpty(completion) && !completion.StartsWith("[AI İsteği Başarısız") && !completion.StartsWith("[AI Modülü"))
        {
            return (CleanPlainText(completion), $"Canlı LLM ({_llmService.GetModelName()})", true);
        }

        if (_llmService.IsFallbackDisabled())
        {
            var errMsg = completion.StartsWith("[AI İsteği Başarısız: ")
                ? completion.Substring("[AI İsteği Başarısız: ".Length).TrimEnd(']')
                : completion;
            throw new InvalidOperationException($"LLM Bağlantısı Kurulamadı: {errMsg}");
        }

        var fallback = isEn
            ? $"Question: \"{question}\"\n\nTicket Information: #{ticket.TicketNumber} ({ticket.Title})\nCategory: {ticket.Category?.Name ?? "General"}, Priority: {ticket.Priority?.Name ?? "Normal"}, Status: {ticket.Status?.Name ?? "In Progress"}.\n\nAnswer: The situation described for this ticket is currently under technical review."
            : $"Sorunuz: \"{question}\"\n\nBilet Bilgisi: #{ticket.TicketNumber} ({ticket.Title})\nKategori: {ticket.Category?.Name ?? DefaultGeneralText}, Öncelik: {ticket.Priority?.Name ?? "Normal"}, Durum: {ticket.Status?.Name ?? "İşlemde"}.\n\nYanıt: Bu bilet için belirtilen durum teknik incelemededir.";
        return (CleanPlainText(fallback), "Akıllı Yerel Asistan", false);
    }

    private static string BuildSmartHeuristicSuggestionEn(Ticket ticket, IEnumerable<SimilarTicketSummary> similarTickets, IEnumerable<KbArticleSummary> kbArticles)
    {
        var sb = new StringBuilder();
        sb.AppendLine("Category and Status Assessment:");
        sb.AppendLine($"Category: {ticket.Category?.Name ?? "General"}");
        sb.AppendLine($"Priority Level: {ticket.Priority?.Name ?? "Normal"}");
        sb.AppendLine($"Ticket Title: {ticket.Title}");
        sb.AppendLine();

        sb.AppendLine("Recommended Resolution and Diagnostic Steps:");
        sb.AppendLine("1. Initial Investigation and Verification: Reproduce the error scenario described by the user or inspect relevant system logs.");
        sb.AppendLine("2. Access and Permissions: Verify the user account's roles and permissions for the affected service.");
        sb.AppendLine("3. Service Availability: Inspect the operational status of the relevant server, gateway, or database services via the monitoring console.");
        sb.AppendLine("4. User Confirmation: Once the problem is remediated, contact the requester to confirm resolution, then mark the ticket as resolved.");
        sb.AppendLine();

        var ticketList = similarTickets as IList<SimilarTicketSummary> ?? similarTickets.ToList();
        if (ticketList.Count > 0)
        {
            sb.AppendLine("Past Similar Resolved Tickets:");
            int idx = 1;
            foreach (var t in ticketList)
            {
                sb.AppendLine($"{idx++}. Ticket #{t.TicketNumber}: {t.Title}");
            }
            sb.AppendLine();
        }

        var articleList = kbArticles as IList<KbArticleSummary> ?? kbArticles.ToList();
        if (articleList.Count > 0)
        {
            sb.AppendLine("Related Knowledge Base Articles:");
            int idx = 1;
            foreach (var kb in articleList)
            {
                sb.AppendLine($"{idx++}. {kb.Title} (/kb-article.html?id={kb.Id})");
            }
            sb.AppendLine();
        }

        sb.AppendLine("Note: When live AI support is connected, these recommendations are synthesized dynamically by the LLM.");

        return CleanPlainText(sb.ToString());
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
