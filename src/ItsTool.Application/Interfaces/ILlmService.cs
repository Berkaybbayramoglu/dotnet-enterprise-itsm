using System.Collections.Generic;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;

namespace ItsTool.Application.Interfaces;

public interface ILlmService
{
    Task<string> GetCompletionAsync(string systemPrompt, string userMessage);
    Task<bool> IsAvailableAsync();
    string GetModelName();
    string GetEndpoint();
    bool IsFallbackEnabled();
    bool IsFallbackDisabled();
    LlmConfigDto GetCurrentConfig();
    void UpdateConfig(LlmConfigDto newConfig);
    Task<List<LlmModelDto>> GetAvailableModelsAsync(string? overrideEndpoint = null, string? overrideApiKey = null);
    Task<LlmTestResultDto> TestConnectionAsync(LlmConfigDto? customConfig = null);
}
