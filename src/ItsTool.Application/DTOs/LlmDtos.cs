namespace ItsTool.Application.DTOs;

public class LlmConfigDto
{
    public string Provider { get; set; } = "Custom"; // OpenAI, Anthropic, Ollama, LMStudio, Custom
    public string Endpoint { get; set; } = "http://127.0.0.1:1234/v1/chat/completions";
    public string? ApiKey { get; set; }
    public string Model { get; set; } = "nvidia/nemotron-3-nano-4b";
    public bool FallbackToHeuristic { get; set; } = true;
    public int TimeoutSeconds { get; set; } = 30;
}

public class LlmModelDto
{
    public string Id { get; set; } = string.Empty;
    public string? Name { get; set; }
    public string? Description { get; set; }
}

public class LlmTestResultDto
{
    public bool Success { get; set; }
    public string Message { get; set; } = string.Empty;
    public string? Endpoint { get; set; }
    public string? Model { get; set; }
    public string? TestResponse { get; set; }
    public long LatencyMs { get; set; }
}
