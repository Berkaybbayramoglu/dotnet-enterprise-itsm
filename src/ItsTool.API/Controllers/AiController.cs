using System;
using System.Collections.Concurrent;
using System.Threading;
using System.Threading.Tasks;
using ItsTool.Application.Interfaces;
using ItsTool.Infrastructure.Agents;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ItsTool.API.Controllers;

internal static class AiControllerHelper
{
    public const string AnalysisInProgressMessage = "Bu bilet için bir yapay zeka analizi zaten devam ediyor. Lütfen önceki işlemin tamamlanmasını bekleyin.";
    
    private static readonly ConcurrentDictionary<int, SemaphoreSlim> TicketLocks = new();

    public static SemaphoreSlim GetLock(int ticketId) =>
        TicketLocks.GetOrAdd(ticketId, _ => new SemaphoreSlim(1, 1));
}

[ApiController]
[Route("api/ai")]
[Authorize]
public class AiController : ControllerBase
{
    private readonly ILlmService _llmService;

    public AiController(ILlmService llmService)
    {
        _llmService = llmService;
    }

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

[ApiController]
[Route("api/ai/tickets")]
[Authorize]
public class AiTicketCopilotController : ControllerBase
{
    private readonly ResolutionCopilotAgent _copilotAgent;

    public AiTicketCopilotController(ResolutionCopilotAgent copilotAgent)
    {
        _copilotAgent = copilotAgent;
    }

    public record AskQuestionDto(string Question);

    [HttpPost("{id}/suggest-resolution")]
    public async Task<IActionResult> SuggestResolution(int id, [FromQuery] bool postAsComment = false)
    {
        var sem = AiControllerHelper.GetLock(id);
        if (!await sem.WaitAsync(0))
        {
            return StatusCode(429, new { success = false, message = AiControllerHelper.AnalysisInProgressMessage });
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

    [HttpPost("{id}/draft-reply")]
    public async Task<IActionResult> DraftReply(int id)
    {
        var sem = AiControllerHelper.GetLock(id);
        if (!await sem.WaitAsync(0))
        {
            return StatusCode(429, new { success = false, message = AiControllerHelper.AnalysisInProgressMessage });
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

    [HttpPost("{id}/ask")]
    public async Task<IActionResult> Ask(int id, [FromBody] AskQuestionDto dto)
    {
        if (string.IsNullOrWhiteSpace(dto?.Question))
        {
            return BadRequest(new { message = "Soru metni boş olamaz." });
        }

        var sem = AiControllerHelper.GetLock(id);
        if (!await sem.WaitAsync(0))
        {
            return StatusCode(429, new { success = false, message = AiControllerHelper.AnalysisInProgressMessage });
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
}

[ApiController]
[Route("api/ai/tickets")]
[Authorize]
public class AiTicketHandoffController : ControllerBase
{
    private readonly TicketHandoffSwarm _handoffSwarm;

    public AiTicketHandoffController(TicketHandoffSwarm handoffSwarm)
    {
        _handoffSwarm = handoffSwarm;
    }

    [HttpPost("{id}/summarize")]
    public async Task<IActionResult> Summarize(int id, [FromQuery] bool postAsComment = false)
    {
        var sem = AiControllerHelper.GetLock(id);
        if (!await sem.WaitAsync(0))
        {
            return StatusCode(429, new { success = false, message = AiControllerHelper.AnalysisInProgressMessage });
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
}
