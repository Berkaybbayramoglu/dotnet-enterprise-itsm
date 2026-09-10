using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Application.Interfaces;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace ItsTool.Infrastructure.Services;

public class LlmService : ILlmService
{
    private readonly HttpClient _httpClient;
    private readonly IConfiguration _config;
    private readonly ILogger<LlmService> _logger;

    private static readonly object s_lock = new();
    private static LlmConfigDto? s_runtimeOverride;

    private readonly LlmConfigDto _instanceConfig;

    public LlmService(HttpClient httpClient, IConfiguration config, ILogger<LlmService> logger)
    {
        _httpClient = httpClient;
        _config = config;
        _logger = logger;

        _instanceConfig = new LlmConfigDto
        {
            Provider = _config["AI:Provider"] ?? "LMStudio",
            Endpoint = _config["AI:Endpoint"] ?? "http://127.0.0.1:1234/v1/chat/completions",
            ApiKey = _config["AI:ApiKey"] ?? string.Empty,
            Model = _config["AI:Model"] ?? "nvidia/nemotron-3-nano-4b",
            TimeoutSeconds = int.TryParse(_config["AI:TimeoutSeconds"], out var t) ? t : 20,
            FallbackToHeuristic = !bool.TryParse(_config["AI:FallbackToHeuristic"], out var fb) || fb
        };
    }

    public static void ResetRuntimeConfig()
    {
        lock (s_lock)
        {
            s_runtimeOverride = null;
        }
    }

    private LlmConfigDto GetEffectiveConfig()
    {
        lock (s_lock)
        {
            return s_runtimeOverride ?? _instanceConfig;
        }
    }

    public string GetModelName()
    {
        return GetEffectiveConfig().Model;
    }

    public string GetEndpoint()
    {
        return GetEffectiveConfig().Endpoint;
    }

    public bool IsFallbackEnabled()
    {
        return GetEffectiveConfig().FallbackToHeuristic;
    }

    public bool IsFallbackDisabled()
    {
        return !GetEffectiveConfig().FallbackToHeuristic;
    }

    public LlmConfigDto GetCurrentConfig()
    {
        var cfg = GetEffectiveConfig();
        return new LlmConfigDto
        {
            Provider = cfg.Provider,
            Endpoint = cfg.Endpoint,
            ApiKey = MaskApiKey(cfg.ApiKey),
            Model = cfg.Model,
            FallbackToHeuristic = cfg.FallbackToHeuristic,
            TimeoutSeconds = cfg.TimeoutSeconds
        };
    }

    public void UpdateConfig(LlmConfigDto newConfig)
    {
        if (newConfig == null) return;
        lock (s_lock)
        {
            var baseConfig = s_runtimeOverride ?? _instanceConfig;
            var updated = new LlmConfigDto
            {
                Provider = newConfig.Provider ?? baseConfig.Provider,
                Endpoint = (newConfig.Endpoint ?? baseConfig.Endpoint).Trim(),
                ApiKey = (!string.IsNullOrWhiteSpace(newConfig.ApiKey) && !newConfig.ApiKey.Contains("***"))
                    ? newConfig.ApiKey.Trim()
                    : (newConfig.ApiKey == "" ? string.Empty : baseConfig.ApiKey),
                Model = (newConfig.Model ?? baseConfig.Model).Trim(),
                FallbackToHeuristic = newConfig.FallbackToHeuristic,
                TimeoutSeconds = newConfig.TimeoutSeconds > 0 ? newConfig.TimeoutSeconds : baseConfig.TimeoutSeconds
            };

            s_runtimeOverride = updated;

            _logger.LogInformation("LLM configuration updated. Provider: {Provider}, Model: {Model}, Endpoint: {Endpoint}", 
                updated.Provider, updated.Model, updated.Endpoint);
        }
    }

    public async Task<bool> IsAvailableAsync()
    {
        var endpoint = GetEndpoint();
        if (string.IsNullOrEmpty(endpoint)) return false;
        try
        {
            using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(3));
            var uri = new Uri(endpoint);
            var baseUrl = $"{uri.Scheme}://{uri.Authority}/v1/models";
            var req = new HttpRequestMessage(HttpMethod.Get, baseUrl);
            var apiKey = GetCurrentEffectiveConfig().ApiKey;
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

    public async Task<List<LlmModelDto>> GetAvailableModelsAsync(string? overrideEndpoint = null, string? overrideApiKey = null)
    {
        var models = new List<LlmModelDto>();
        var cur = GetEffectiveConfig();
        var cfg = new LlmConfigDto
        {
            Provider = cur.Provider,
            Endpoint = overrideEndpoint ?? cur.Endpoint,
            ApiKey = (!string.IsNullOrWhiteSpace(overrideApiKey) && !overrideApiKey.Contains("***")) ? overrideApiKey : cur.ApiKey,
            Model = cur.Model
        };

        if (cfg.Provider.Equals("Anthropic", StringComparison.OrdinalIgnoreCase))
        {
            models.Add(new LlmModelDto { Id = "claude-3-5-sonnet-20241022", Name = "Claude 3.5 Sonnet (Önerilen)", Description = "En gelişmiş ve dengeli model" });
            models.Add(new LlmModelDto { Id = "claude-3-5-haiku-20241022", Name = "Claude 3.5 Haiku", Description = "Çok hızlı ve hafif model" });
            models.Add(new LlmModelDto { Id = "claude-3-opus-20240229", Name = "Claude 3 Opus", Description = "En yüksek akıl yürütme kapasitesi" });
            return models;
        }

        // Try /v1/models (OpenAI / Ollama / LM Studio standard)
        try
        {
            var uri = new Uri(cfg.Endpoint);
            var modelsUrl = $"{uri.Scheme}://{uri.Authority}/v1/models";

            using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(5));
            var req = new HttpRequestMessage(HttpMethod.Get, modelsUrl);
            if (!string.IsNullOrEmpty(cfg.ApiKey) && cfg.ApiKey != "none")
            {
                req.Headers.Add("Authorization", $"Bearer {cfg.ApiKey}");
            }

            var resp = await _httpClient.SendAsync(req, cts.Token);
            if (resp.IsSuccessStatusCode)
            {
                var json = await resp.Content.ReadAsStringAsync(cts.Token);
                using var doc = JsonDocument.Parse(json);
                if (doc.RootElement.TryGetProperty("data", out var dataArr) && dataArr.ValueKind == JsonValueKind.Array)
                {
                    foreach (var item in dataArr.EnumerateArray())
                    {
                        if (item.TryGetProperty("id", out var idProp))
                        {
                            var modelId = idProp.GetString();
                            if (!string.IsNullOrWhiteSpace(modelId))
                            {
                                models.Add(new LlmModelDto { Id = modelId, Name = modelId, Description = "Aktif LLM sunucusundan tespit edildi" });
                            }
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogDebug("Could not fetch /v1/models: {Message}", ex.Message);
        }

        // If models list is still empty and it might be Ollama, try /api/tags
        if (models.Count == 0)
        {
            try
            {
                var uri = new Uri(cfg.Endpoint);
                var tagsUrl = $"{uri.Scheme}://{uri.Authority}/api/tags";

                using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(3));
                var req = new HttpRequestMessage(HttpMethod.Get, tagsUrl);
                var resp = await _httpClient.SendAsync(req, cts.Token);
                if (resp.IsSuccessStatusCode)
                {
                    var json = await resp.Content.ReadAsStringAsync(cts.Token);
                    using var doc = JsonDocument.Parse(json);
                    if (doc.RootElement.TryGetProperty("models", out var modelsArr) && modelsArr.ValueKind == JsonValueKind.Array)
                    {
                        foreach (var item in modelsArr.EnumerateArray())
                        {
                            if (item.TryGetProperty("name", out var nameProp))
                            {
                                var modelName = nameProp.GetString();
                                if (!string.IsNullOrWhiteSpace(modelName))
                                {
                                    models.Add(new LlmModelDto { Id = modelName, Name = modelName, Description = "Ollama yerel modeli" });
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogDebug("Could not fetch /api/tags: {Message}", ex.Message);
            }
        }

        // Fallback default suggestions if empty
        if (models.Count == 0)
        {
            if (cfg.Provider.Equals("OpenAI", StringComparison.OrdinalIgnoreCase))
            {
                models.Add(new LlmModelDto { Id = "gpt-4o", Name = "GPT-4o (Önerilen)", Description = "En popüler multimodal model" });
                models.Add(new LlmModelDto { Id = "gpt-4o-mini", Name = "GPT-4o-mini", Description = "Hızlı ve ekonomik model" });
                models.Add(new LlmModelDto { Id = "o1-mini", Name = "o1-mini (Akıl Yürütme)", Description = "Gelişmiş problem çözme" });
            }
            else
            {
                models.Add(new LlmModelDto { Id = cfg.Model, Name = cfg.Model, Description = "Varsayılan Model" });
            }
        }

        return models;
    }

    public async Task<LlmTestResultDto> TestConnectionAsync(LlmConfigDto? customConfig = null)
    {
        var cfg = customConfig ?? GetCurrentEffectiveConfig();
        var sw = Stopwatch.StartNew();

        if (string.IsNullOrWhiteSpace(cfg.Endpoint))
        {
            return new LlmTestResultDto
            {
                Success = false,
                Message = "LLM Endpoint URL adresi belirtilmemiş.",
                Endpoint = cfg.Endpoint,
                Model = cfg.Model
            };
        }

        try
        {
            var timeoutSeconds = cfg.TimeoutSeconds > 0 ? Math.Min(cfg.TimeoutSeconds, 15) : 10;
            using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(timeoutSeconds));

            if (cfg.Provider.Equals("Anthropic", StringComparison.OrdinalIgnoreCase))
            {
                var reqBody = new
                {
                    model = cfg.Model,
                    max_tokens = 20,
                    messages = new[] { new { role = "user", content = "Ping. Answer with 'PONG'." } }
                };

                var req = new HttpRequestMessage(HttpMethod.Post, cfg.Endpoint)
                {
                    Content = new StringContent(JsonSerializer.Serialize(reqBody), Encoding.UTF8, "application/json")
                };

                if (!string.IsNullOrEmpty(cfg.ApiKey))
                {
                    req.Headers.Add("x-api-key", cfg.ApiKey);
                }
                req.Headers.Add("anthropic-version", "2023-06-01");

                var resp = await _httpClient.SendAsync(req, cts.Token);
                sw.Stop();

                if (!resp.IsSuccessStatusCode)
                {
                    var errBody = await resp.Content.ReadAsStringAsync(cts.Token);
                    return new LlmTestResultDto
                    {
                        Success = false,
                        Message = $"Anthropic API Hatası ({(int)resp.StatusCode} {resp.ReasonPhrase}): {FormatErrorMessage(errBody, resp.StatusCode)}",
                        Endpoint = cfg.Endpoint,
                        Model = cfg.Model,
                        LatencyMs = sw.ElapsedMilliseconds
                    };
                }

                var respJson = await resp.Content.ReadAsStringAsync(cts.Token);
                var reply = ParseAnthropicResponse(respJson);

                return new LlmTestResultDto
                {
                    Success = true,
                    Message = $"Bağlantı başarılı! ({sw.ElapsedMilliseconds} ms)",
                    Endpoint = cfg.Endpoint,
                    Model = cfg.Model,
                    TestResponse = reply,
                    LatencyMs = sw.ElapsedMilliseconds
                };
            }
            else
            {
                // OpenAI-compatible format
                var reqBody = new
                {
                    model = cfg.Model,
                    messages = new[] { new { role = "user", content = "Ping. Answer with 'PONG'." } },
                    max_tokens = 20,
                    temperature = 0.1
                };

                var req = new HttpRequestMessage(HttpMethod.Post, cfg.Endpoint)
                {
                    Content = new StringContent(JsonSerializer.Serialize(reqBody), Encoding.UTF8, "application/json")
                };

                if (!string.IsNullOrWhiteSpace(cfg.ApiKey) && cfg.ApiKey != "none" && cfg.ApiKey != "YOUR_API_KEY")
                {
                    req.Headers.Add("Authorization", $"Bearer {cfg.ApiKey}");
                }

                var resp = await _httpClient.SendAsync(req, cts.Token);
                sw.Stop();

                if (!resp.IsSuccessStatusCode)
                {
                    var errBody = await resp.Content.ReadAsStringAsync(cts.Token);
                    return new LlmTestResultDto
                    {
                        Success = false,
                        Message = $"LLM Sunucu Hatası ({(int)resp.StatusCode} {resp.ReasonPhrase}): {FormatErrorMessage(errBody, resp.StatusCode)}",
                        Endpoint = cfg.Endpoint,
                        Model = cfg.Model,
                        LatencyMs = sw.ElapsedMilliseconds
                    };
                }

                var respJson = await resp.Content.ReadAsStringAsync(cts.Token);
                var reply = ParseOpenAiResponse(respJson);

                return new LlmTestResultDto
                {
                    Success = true,
                    Message = $"Bağlantı başarılı! ({sw.ElapsedMilliseconds} ms)",
                    Endpoint = cfg.Endpoint,
                    Model = cfg.Model,
                    TestResponse = reply,
                    LatencyMs = sw.ElapsedMilliseconds
                };
            }
        }
        catch (OperationCanceledException)
        {
            sw.Stop();
            return new LlmTestResultDto
            {
                Success = false,
                Message = $"Zaman Aşımı (Timeout): LLM servisi {cfg.TimeoutSeconds} saniye içinde yanıt vermedi. Sunucunun açık ve modelin yüklü olduğundan emin olun.",
                Endpoint = cfg.Endpoint,
                Model = cfg.Model,
                LatencyMs = sw.ElapsedMilliseconds
            };
        }
        catch (HttpRequestException ex)
        {
            sw.Stop();
            var friendly = TranslateHttpException(ex, cfg.Endpoint);
            return new LlmTestResultDto
            {
                Success = false,
                Message = friendly,
                Endpoint = cfg.Endpoint,
                Model = cfg.Model,
                LatencyMs = sw.ElapsedMilliseconds
            };
        }
        catch (Exception ex)
        {
            sw.Stop();
            return new LlmTestResultDto
            {
                Success = false,
                Message = $"Bağlantı hatası: {ex.Message}",
                Endpoint = cfg.Endpoint,
                Model = cfg.Model,
                LatencyMs = sw.ElapsedMilliseconds
            };
        }
    }

    public async Task<string> GetCompletionAsync(string systemPrompt, string userMessage)
    {
        var cfg = GetCurrentEffectiveConfig();

        if (string.IsNullOrWhiteSpace(cfg.Endpoint))
        {
            _logger.LogWarning("AI Endpoint is not configured.");
            return "[AI Modülü yapılandırılmadı: Lütfen geçerli bir LLM Endpoint adresi girin.]";
        }

        try
        {
            var timeoutSeconds = cfg.TimeoutSeconds > 0 ? cfg.TimeoutSeconds : 30;
            using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(timeoutSeconds));

            if (cfg.Provider.Equals("Anthropic", StringComparison.OrdinalIgnoreCase))
            {
                var reqBody = new
                {
                    model = cfg.Model,
                    max_tokens = 1500,
                    system = systemPrompt,
                    messages = new[] { new { role = "user", content = userMessage } }
                };

                var req = new HttpRequestMessage(HttpMethod.Post, cfg.Endpoint)
                {
                    Content = new StringContent(JsonSerializer.Serialize(reqBody), Encoding.UTF8, "application/json")
                };

                if (!string.IsNullOrEmpty(cfg.ApiKey))
                {
                    req.Headers.Add("x-api-key", cfg.ApiKey);
                }
                req.Headers.Add("anthropic-version", "2023-06-01");

                var response = await _httpClient.SendAsync(req, cts.Token);
                if (!response.IsSuccessStatusCode)
                {
                    var errContent = await response.Content.ReadAsStringAsync(cts.Token);
                    var msg = $"[AI İsteği Başarısız: Anthropic API {(int)response.StatusCode} {response.ReasonPhrase} - {FormatErrorMessage(errContent, response.StatusCode)}]";
                    _logger.LogWarning(msg);
                    return msg;
                }

                var respJson = await response.Content.ReadAsStringAsync(cts.Token);
                return ParseAnthropicResponse(respJson);
            }
            else
            {
                // OpenAI-compatible
                var reqBody = new
                {
                    model = cfg.Model,
                    messages = new[]
                    {
                        new { role = "system", content = systemPrompt },
                        new { role = "user", content = userMessage }
                    },
                    temperature = 0.7,
                    max_tokens = 1500
                };

                var req = new HttpRequestMessage(HttpMethod.Post, cfg.Endpoint)
                {
                    Content = new StringContent(JsonSerializer.Serialize(reqBody), Encoding.UTF8, "application/json")
                };

                if (!string.IsNullOrWhiteSpace(cfg.ApiKey) && cfg.ApiKey != "none" && cfg.ApiKey != "YOUR_API_KEY")
                {
                    req.Headers.Add("Authorization", $"Bearer {cfg.ApiKey}");
                }

                var response = await _httpClient.SendAsync(req, cts.Token);
                if (!response.IsSuccessStatusCode)
                {
                    var errContent = await response.Content.ReadAsStringAsync(cts.Token);
                    var msg = $"[AI İsteği Başarısız: LLM Sunucusu {(int)response.StatusCode} {response.ReasonPhrase} - {FormatErrorMessage(errContent, response.StatusCode)}]";
                    _logger.LogWarning(msg);
                    return msg;
                }

                var respJson = await response.Content.ReadAsStringAsync(cts.Token);
                return ParseOpenAiResponse(respJson);
            }
        }
        catch (OperationCanceledException)
        {
            var msg = $"[AI İsteği Başarısız: İstek zaman aşımına uğradı ({cfg.TimeoutSeconds} sn). Model yanıt veremedi veya sunucu meşgul.]";
            _logger.LogWarning(msg);
            return msg;
        }
        catch (HttpRequestException ex)
        {
            var friendly = TranslateHttpException(ex, cfg.Endpoint);
            var msg = $"[AI İsteği Başarısız: {friendly}]";
            _logger.LogWarning(ex, msg);
            return msg;
        }
        catch (Exception ex)
        {
            var msg = $"[AI İsteği Başarısız: Beklenmeyen hata: {ex.Message}]";
            _logger.LogWarning(ex, msg);
            return msg;
        }
    }

    private LlmConfigDto GetCurrentEffectiveConfig()
    {
        return GetEffectiveConfig();
    }

    private static string ParseOpenAiResponse(string json)
    {
        if (string.IsNullOrWhiteSpace(json)) return string.Empty;
        try
        {
            using var doc = JsonDocument.Parse(json);
            if (doc.RootElement.TryGetProperty("choices", out var choices) && choices.GetArrayLength() > 0)
            {
                var firstChoice = choices[0];
                if (firstChoice.TryGetProperty("message", out var msg) && msg.TryGetProperty("content", out var content))
                {
                    return content.GetString() ?? string.Empty;
                }
            }
        }
        catch { }
        return string.Empty;
    }

    private static string ParseAnthropicResponse(string json)
    {
        if (string.IsNullOrWhiteSpace(json)) return string.Empty;
        try
        {
            using var doc = JsonDocument.Parse(json);
            if (doc.RootElement.TryGetProperty("content", out var contentArr) && contentArr.GetArrayLength() > 0)
            {
                foreach (var item in contentArr.EnumerateArray())
                {
                    if (item.TryGetProperty("type", out var type) && type.GetString() == "text" && item.TryGetProperty("text", out var text))
                    {
                        return text.GetString() ?? string.Empty;
                    }
                }
            }
        }
        catch { }
        return string.Empty;
    }

    private static string TranslateHttpException(HttpRequestException ex, string endpoint)
    {
        var msg = ex.Message;
        if (msg.Contains("Connection refused") || ex.InnerException is System.Net.Sockets.SocketException)
        {
            return $"Bağlantı reddedildi: '{endpoint}' adresinde çalışan bir LLM servisi bulunamadı. Lütfen yerel LM Studio / Ollama uygulamasının açık olduğundan veya endpoint portunun doğruluğundan emin olun.";
        }
        if (msg.Contains("Name or service not known") || msg.Contains("No such host"))
        {
            return $"Sunucu adresi çözülemedi: '{endpoint}' alan adı veya IP adresi geçersiz.";
        }
        return $"Ağ bağlantı hatası: {msg}";
    }

    private static string FormatErrorMessage(string rawError, System.Net.HttpStatusCode statusCode)
    {
        if (string.IsNullOrWhiteSpace(rawError)) return $"HTTP {(int)statusCode}";
        try
        {
            using var doc = JsonDocument.Parse(rawError);
            if (doc.RootElement.TryGetProperty("error", out var errProp))
            {
                if (errProp.ValueKind == JsonValueKind.String) return errProp.GetString()!;
                if (errProp.TryGetProperty("message", out var msgProp)) return msgProp.GetString()!;
            }
        }
        catch { }
        return rawError.Length > 200 ? rawError.Substring(0, 200) + "..." : rawError;
    }

    private static string MaskApiKey(string? apiKey)
    {
        if (string.IsNullOrWhiteSpace(apiKey)) return string.Empty;
        if (apiKey.Length <= 8) return "********";
        return apiKey.Substring(0, 4) + "****" + apiKey.Substring(apiKey.Length - 4);
    }
}
