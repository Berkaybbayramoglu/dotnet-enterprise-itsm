using System;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using ItsTool.Application.Interfaces;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace ItsTool.Infrastructure.Services;

public class LlmService : ILlmService
{
    private readonly HttpClient _httpClient;
    private readonly IConfiguration _config;
    private readonly ILogger<LlmService> _logger;

    public LlmService(HttpClient httpClient, IConfiguration config, ILogger<LlmService> logger)
    {
        _httpClient = httpClient;
        _config = config;
        _logger = logger;
    }

    public string GetModelName() => _config["AI:Model"] ?? "nvidia/nemotron-3-nano-4b";

    public string GetEndpoint() => _config["AI:Endpoint"] ?? "http://127.0.0.1:1234/v1/chat/completions";

    public async Task<bool> IsAvailableAsync()
    {
        var endpoint = GetEndpoint();
        if (string.IsNullOrEmpty(endpoint)) return false;
        try
        {
            using var cts = new System.Threading.CancellationTokenSource(TimeSpan.FromSeconds(2));
            var uri = new Uri(endpoint);
            var baseUrl = $"{uri.Scheme}://{uri.Authority}/v1/models";
            var req = new HttpRequestMessage(HttpMethod.Get, baseUrl);
            var apiKey = _config["AI:ApiKey"];
            if (!string.IsNullOrEmpty(apiKey) && apiKey != "YOUR_API_KEY")
            {
                req.Headers.Add("Authorization", $"Bearer {apiKey}");
            }
            var resp = await _httpClient.SendAsync(req, cts.Token);
            return resp.IsSuccessStatusCode;
        }
        catch
        {
            return false;
        }
    }

    public async Task<string> GetCompletionAsync(string systemPrompt, string userMessage)
    {
        var endpoint = GetEndpoint();
        var apiKey = _config["AI:ApiKey"];
        var model = GetModelName();

        if (string.IsNullOrEmpty(endpoint))
        {
            _logger.LogWarning("AI:Endpoint is not configured. Returning fallback response.");
            return "[AI Modülü yapılandırılmadı. Lütfen appsettings.json içerisindeki AI ayarlarını yapın.]";
        }

        var requestBody = new
        {
            model = model,
            messages = new[]
            {
                new { role = "system", content = systemPrompt },
                new { role = "user", content = userMessage }
            },
            temperature = 0.7,
            max_tokens = 1500
        };

        var requestMessage = new HttpRequestMessage(HttpMethod.Post, endpoint)
        {
            Content = new StringContent(JsonSerializer.Serialize(requestBody), Encoding.UTF8, "application/json")
        };

        if (!string.IsNullOrEmpty(apiKey) && apiKey != "YOUR_API_KEY")
        {
            requestMessage.Headers.Add("Authorization", $"Bearer {apiKey}");
        }

        try
        {
            using var cts = new System.Threading.CancellationTokenSource(TimeSpan.FromSeconds(20));
            var response = await _httpClient.SendAsync(requestMessage, cts.Token);
            response.EnsureSuccessStatusCode();

            var responseJson = await response.Content.ReadAsStringAsync();
            using var doc = JsonDocument.Parse(responseJson);
            
            var content = doc.RootElement
                .GetProperty("choices")[0]
                .GetProperty("message")
                .GetProperty("content")
                .GetString();

            return content ?? string.Empty;
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Failed to get AI completion from {Endpoint}.", endpoint);
            return $"[AI İsteği Başarısız: {ex.Message}]";
        }
    }
}
