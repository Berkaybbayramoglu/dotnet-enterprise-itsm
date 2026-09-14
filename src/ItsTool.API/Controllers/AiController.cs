using System;
using System.Collections.Concurrent;
using System.Threading;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
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
        var config = _llmService.GetCurrentConfig() ?? new LlmConfigDto();
        var endpoint = config.Endpoint ?? _llmService.GetEndpoint();
        var model = config.Model ?? _llmService.GetModelName();

        string mode;
        if (isAvailable)
        {
            mode = $"Live LLM ({model})";
        }
        else if (config.FallbackToHeuristic)
        {
            mode = "Smart Heuristic Engine";
        }
        else
        {
            mode = "LLM Offline";
        }

        return Ok(new
        {
            configured = !string.IsNullOrEmpty(endpoint),
            isConfigured = !string.IsNullOrEmpty(endpoint),
            endpoint = endpoint,
            model = model,
            provider = config.Provider ?? "Custom",
            fallbackToHeuristic = config.FallbackToHeuristic,
            isAvailable = isAvailable,
            isEndpointReachable = isAvailable,
            mode = mode
        });
    }

    [HttpGet("config")]
    [ProducesResponseType(typeof(object), StatusCodes.Status200OK)]
    public IActionResult GetConfig()
    {
        return Ok(new { success = true, config = _llmService.GetCurrentConfig() });
    }

    [HttpPost("config")]
    [ProducesResponseType(typeof(object), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(object), StatusCodes.Status400BadRequest)]
    public IActionResult UpdateConfig([FromBody] LlmConfigDto dto)
    {
        if (dto == null) return BadRequest(new { success = false, message = "Geçersiz yapılandırma verisi." });
        _llmService.UpdateConfig(dto);
        return Ok(new { success = true, message = "LLM ayarları başarıyla güncellendi.", config = _llmService.GetCurrentConfig() });
    }

    [HttpGet("models")]
    public async Task<IActionResult> GetModels([FromQuery] string? endpoint = null, [FromQuery] string? apiKey = null)
    {
        var models = await _llmService.GetAvailableModelsAsync(endpoint, apiKey);
        return Ok(new { success = true, models });
    }

    [HttpPost("test")]
    public async Task<IActionResult> TestConnection([FromBody] LlmConfigDto? customConfig = null)
    {
        if (customConfig != null)
        {
            var result = await _llmService.TestConnectionAsync(customConfig);
            return Ok(result);
        }

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

    public record AskQuestionDto(string Question, string? Language = "tr");

    [HttpPost("{id}/suggest-resolution")]
    public async Task<IActionResult> SuggestResolution(int id, [FromQuery] bool postAsComment = false, [FromQuery] string language = "tr")
    {
        var sem = AiControllerHelper.GetLock(id);
        if (!await sem.WaitAsync(0))
        {
            return StatusCode(429, new { success = false, message = AiControllerHelper.AnalysisInProgressMessage });
        }

        try
        {
            var result = await _copilotAgent.GenerateResolutionSuggestionAsync(id, postAsComment, language);
            if (!result.Success)
            {
                if (result.Suggestion == "Bilet bulunamadı." || result.Source == "Sistem")
                {
                    return NotFound(new { message = result.Suggestion });
                }
                return BadRequest(new { success = false, message = result.Suggestion, error = result.Suggestion, source = result.Source, isLlm = result.IsLlm });
            }
            return Ok(result);
        }
        catch (Exception ex)
        {
            return BadRequest(new { success = false, message = ex.Message, error = ex.Message });
        }
        finally
        {
            sem.Release();
        }
    }

    [HttpPost("{id}/draft-reply")]
    public async Task<IActionResult> DraftReply(int id, [FromQuery] string language = "tr")
    {
        var sem = AiControllerHelper.GetLock(id);
        if (!await sem.WaitAsync(0))
        {
            return StatusCode(429, new { success = false, message = AiControllerHelper.AnalysisInProgressMessage });
        }

        try
        {
            var (draft, source, isLlm) = await _copilotAgent.DraftReplyWithSourceAsync(id, language);
            return Ok(new { success = true, draft, reply = draft, source, isLlm });
        }
        catch (Exception ex)
        {
            return BadRequest(new { success = false, message = ex.Message, error = ex.Message });
        }
        finally
        {
            sem.Release();
        }
    }

    [HttpPost("{id}/ask")]
    public async Task<IActionResult> Ask(int id, [FromBody] AskQuestionDto dto, [FromQuery] string? language = null)
    {
        if (string.IsNullOrWhiteSpace(dto?.Question))
        {
            return BadRequest(new { success = false, message = "Soru metni boş olamaz." });
        }

        var sem = AiControllerHelper.GetLock(id);
        if (!await sem.WaitAsync(0))
        {
            return StatusCode(429, new { success = false, message = AiControllerHelper.AnalysisInProgressMessage });
        }

        try
        {
            string lang = "tr";
            if (!string.IsNullOrWhiteSpace(dto.Language))
            {
                lang = dto.Language;
            }
            else if (!string.IsNullOrWhiteSpace(language))
            {
                lang = language;
            }

            var (answer, source, isLlm) = await _copilotAgent.AskQuestionWithSourceAsync(id, dto.Question, lang);
            return Ok(new { success = true, answer, source, isLlm });
        }
        catch (Exception ex)
        {
            return BadRequest(new { success = false, message = ex.Message, error = ex.Message });
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
    public async Task<IActionResult> Summarize(int id, [FromQuery] bool postAsComment = false, [FromQuery] string language = "tr")
    {
        var sem = AiControllerHelper.GetLock(id);
        if (!await sem.WaitAsync(0))
        {
            return StatusCode(429, new { success = false, message = AiControllerHelper.AnalysisInProgressMessage });
        }

        try
        {
            var result = await _handoffSwarm.GenerateHandoffSummaryAsync(id, postAsComment, language);
            if (!result.Success)
            {
                if (result.Summary == "Bilet bulunamadı." || result.Source == "Sistem")
                {
                    return NotFound(new { message = result.Summary });
                }
                return BadRequest(new { success = false, message = result.Summary, error = result.Summary, isLlm = result.IsLlm });
            }
            return Ok(result);
        }
        catch (Exception ex)
        {
            return BadRequest(new { success = false, message = ex.Message, error = ex.Message });
        }
        finally
        {
            sem.Release();
        }
    }
}
