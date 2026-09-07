using System;
using System.Threading.Tasks;
using ItsTool.Application.Interfaces;
using ItsTool.Infrastructure.Agents;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ItsTool.API.Controllers;

[ApiController]
[Route("api/ai")]
[Authorize]
public class AiController : ControllerBase
{
    private readonly ILlmService _llmService;
    private readonly ResolutionCopilotAgent _copilotAgent;
    private readonly TicketHandoffSwarm _handoffSwarm;

    public AiController(
        ILlmService llmService,
        ResolutionCopilotAgent copilotAgent,
        TicketHandoffSwarm handoffSwarm)
    {
        _llmService = llmService;
        _copilotAgent = copilotAgent;
        _handoffSwarm = handoffSwarm;
    }

    public record AskQuestionDto(string Question);

    [AllowAnonymous]
    [HttpGet("status")]
    public async Task<IActionResult> GetStatus()
    {
        bool isAvailable = await _llmService.IsAvailableAsync();
        return Ok(new
        {
            configured = !string.IsNullOrEmpty(_llmService.GetEndpoint()),
            isConfigured = !string.IsNullOrEmpty(_llmService.GetEndpoint()),
            endpoint = _llmService.GetEndpoint(),
            model = _llmService.GetModelName(),
            isAvailable = isAvailable,
            isEndpointReachable = isAvailable,
            mode = isAvailable ? "Live LLM" : "Smart Heuristic Engine"
        });
    }

    private static readonly System.Collections.Concurrent.ConcurrentDictionary<int, System.Threading.SemaphoreSlim> _ticketLocks = new();

    private static System.Threading.SemaphoreSlim GetLock(int ticketId) =>
        _ticketLocks.GetOrAdd(ticketId, _ => new System.Threading.SemaphoreSlim(1, 1));

    [HttpPost("tickets/{id}/suggest-resolution")]
    public async Task<IActionResult> SuggestResolution(int id, [FromQuery] bool postAsComment = false)
    {
        var sem = GetLock(id);
        if (!await sem.WaitAsync(0))
        {
            return StatusCode(429, new { success = false, message = "Bu bilet için bir yapay zeka analizi zaten devam ediyor. Lütfen önceki işlemin tamamlanmasını bekleyin." });
        }

        try
        {
            var result = await _copilotAgent.GenerateResolutionSuggestionAsync(id, postAsComment);
            if (!result.Success)
            {
                return NotFound(new { message = result.Suggestion });
            }
            return Ok(result);
        }
        finally
        {
            sem.Release();
        }
    }

    [HttpPost("tickets/{id}/summarize")]
    public async Task<IActionResult> Summarize(int id, [FromQuery] bool postAsComment = false)
    {
        var sem = GetLock(id);
        if (!await sem.WaitAsync(0))
        {
            return StatusCode(429, new { success = false, message = "Bu bilet için bir yapay zeka analizi zaten devam ediyor. Lütfen önceki işlemin tamamlanmasını bekleyin." });
        }

        try
        {
            var result = await _handoffSwarm.GenerateHandoffSummaryAsync(id, postAsComment);
            if (!result.Success)
            {
                return NotFound(new { message = result.Summary });
            }
            return Ok(result);
        }
        finally
        {
            sem.Release();
        }
    }

    [HttpPost("tickets/{id}/draft-reply")]
    public async Task<IActionResult> DraftReply(int id)
    {
        var sem = GetLock(id);
        if (!await sem.WaitAsync(0))
        {
            return StatusCode(429, new { success = false, message = "Bu bilet için bir yapay zeka analizi zaten devam ediyor. Lütfen önceki işlemin tamamlanmasını bekleyin." });
        }

        try
        {
            var draft = await _copilotAgent.DraftReplyAsync(id);
            return Ok(new { success = true, draft, reply = draft });
        }
        finally
        {
            sem.Release();
        }
    }

    [HttpPost("tickets/{id}/ask")]
    public async Task<IActionResult> Ask(int id, [FromBody] AskQuestionDto dto)
    {
        if (string.IsNullOrWhiteSpace(dto?.Question))
        {
            return BadRequest(new { message = "Soru metni boş olamaz." });
        }

        var sem = GetLock(id);
        if (!await sem.WaitAsync(0))
        {
            return StatusCode(429, new { success = false, message = "Bu bilet için bir yapay zeka analizi zaten devam ediyor. Lütfen önceki işlemin tamamlanmasını bekleyin." });
        }

        try
        {
            var answer = await _copilotAgent.AskQuestionAsync(id, dto.Question);
            return Ok(new { success = true, answer });
        }
        finally
        {
            sem.Release();
        }
    }

    [HttpPost("test")]
    public async Task<IActionResult> TestConnection()
    {
        var isOnline = await _llmService.IsAvailableAsync();
        if (!isOnline)
        {
            return Ok(new
            {
                success = false,
                message = $"LLM servisine ulaşılamadı ({_llmService.GetEndpoint()}). LM Studio veya harici LLM servisinin çalıştığından emin olun. Yerel Akıllı Asistan motoru devrede.",
                endpoint = _llmService.GetEndpoint(),
                model = _llmService.GetModelName()
            });
        }

        var completion = await _llmService.GetCompletionAsync("You are a test assistant.", "Respond with: ITSM AI connection OK.");
        return Ok(new
        {
            success = true,
            message = "LLM bağlantısı başarılı!",
            endpoint = _llmService.GetEndpoint(),
            model = _llmService.GetModelName(),
            testResponse = completion
        });
    }
}
