using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using ItsTool.Application.DTOs;
using ItsTool.Infrastructure.Services;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Moq;
using Moq.Protected;
using Xunit;

namespace ItsTool.UnitTests.Services;

[Collection("LlmTests")]
public class LlmServiceTests : IDisposable
{
    private readonly Mock<ILogger<LlmService>> _loggerMock = new();

    public LlmServiceTests()
    {
        LlmService.ResetRuntimeConfig();
    }

    public void Dispose()
    {
        LlmService.ResetRuntimeConfig();
        GC.SuppressFinalize(this);
    }

    private static HttpClient CreateMockHttpClient(Func<HttpRequestMessage, HttpResponseMessage> responder)
    {
        var handlerMock = new Mock<HttpMessageHandler>();
        handlerMock.Protected()
            .Setup<Task<HttpResponseMessage>>(
                "SendAsync",
                ItExpr.IsAny<HttpRequestMessage>(),
                ItExpr.IsAny<CancellationToken>())
            .ReturnsAsync((HttpRequestMessage req, CancellationToken _) => responder(req));

        return new HttpClient(handlerMock.Object);
    }

    private static HttpClient CreateThrowingHttpClient(Exception ex)
    {
        var handlerMock = new Mock<HttpMessageHandler>();
        handlerMock.Protected()
            .Setup<Task<HttpResponseMessage>>(
                "SendAsync",
                ItExpr.IsAny<HttpRequestMessage>(),
                ItExpr.IsAny<CancellationToken>())
            .ThrowsAsync(ex);

        return new HttpClient(handlerMock.Object);
    }

    [Fact]
    public void Constructor_WithDefaults_ShouldUseLMStudioDefaults()
    {
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>()).Build();
        var service = new LlmService(new HttpClient(), config, _loggerMock.Object);

        Assert.Equal("LMStudio", service.GetCurrentConfig().Provider);
        Assert.Equal("http://127.0.0.1:1234/v1/chat/completions", service.GetEndpoint());
        Assert.Equal("nvidia/nemotron-3-nano-4b", service.GetModelName());
        Assert.True(service.IsFallbackEnabled());
        Assert.False(service.IsFallbackDisabled());
        Assert.Equal(20, service.GetCurrentConfig().TimeoutSeconds);
    }

    [Fact]
    public void Constructor_WithCustomConfig_ShouldApplyValues()
    {
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:Provider", "OpenAI" },
            { "AI:Endpoint", "https://api.openai.com/v1/chat/completions" },
            { "AI:ApiKey", "sk-1234567890abcdef" },
            { "AI:Model", "gpt-4o" },
            { "AI:TimeoutSeconds", "45" },
            { "AI:FallbackToHeuristic", "false" }
        }).Build();

        var service = new LlmService(new HttpClient(), config, _loggerMock.Object);

        Assert.Equal("OpenAI", service.GetCurrentConfig().Provider);
        Assert.Equal("https://api.openai.com/v1/chat/completions", service.GetEndpoint());
        Assert.Equal("gpt-4o", service.GetModelName());
        Assert.False(service.IsFallbackEnabled());
        Assert.True(service.IsFallbackDisabled());
        Assert.Equal(45, service.GetCurrentConfig().TimeoutSeconds);
    }

    [Fact]
    public void UpdateConfig_ShouldUpdateRuntimeOverride_AndHandleEdgeCases()
    {
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:ApiKey", "sk-original-key-12345" }
        }).Build();

        var service = new LlmService(new HttpClient(), config, _loggerMock.Object);

        // Null config should be ignored
        service.UpdateConfig(null!);
        Assert.Equal("http://127.0.0.1:1234/v1/chat/completions", service.GetEndpoint());

        // Update with new key
        service.UpdateConfig(new LlmConfigDto
        {
            Provider = "Anthropic",
            Endpoint = "https://api.anthropic.com/v1/messages",
            ApiKey = "sk-ant-new-key-12345",
            Model = "claude-3-5-sonnet-20241022",
            FallbackToHeuristic = false,
            TimeoutSeconds = 50
        });

        var updated = service.GetCurrentConfig();
        Assert.Equal("Anthropic", updated.Provider);
        Assert.Equal("https://api.anthropic.com/v1/messages", updated.Endpoint);
        Assert.False(updated.FallbackToHeuristic);
        Assert.Equal(50, updated.TimeoutSeconds);

        // Update with masked key (containing ***) should keep previous key
        service.UpdateConfig(new LlmConfigDto
        {
            Endpoint = "https://api.anthropic.com/v1/messages",
            ApiKey = "sk-a****2345",
            Model = "claude-3-5-haiku-20241022",
            TimeoutSeconds = -1
        });

        var keptKeyConfig = service.GetCurrentConfig();
        Assert.Equal("claude-3-5-haiku-20241022", keptKeyConfig.Model);
        Assert.Equal(50, keptKeyConfig.TimeoutSeconds); // Timeout retained because <= 0

        // Update with empty key should clear it
        service.UpdateConfig(new LlmConfigDto
        {
            Endpoint = "https://api.anthropic.com/v1/messages",
            ApiKey = "",
            Model = "claude-3-5-haiku-20241022"
        });

        var emptyKeyConfig = service.GetCurrentConfig();
        Assert.Equal(string.Empty, emptyKeyConfig.ApiKey);

        // Reset runtime config returns back to instance config
        LlmService.ResetRuntimeConfig();
        Assert.Equal("LMStudio", service.GetCurrentConfig().Provider);
    }

    [Theory]
    [InlineData(null, "")]
    [InlineData("", "")]
    [InlineData("   ", "")]
    [InlineData("1234", "********")]
    [InlineData("12345678", "********")]
    [InlineData("123456789", "1234****6789")]
    [InlineData("sk-proj-supersecretkey123456", "sk-p****3456")]
    public void MaskApiKey_TheoryTests(string? key, string expectedMasked)
    {
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:ApiKey", key }
        }).Build();

        var service = new LlmService(new HttpClient(), config, _loggerMock.Object);
        var current = service.GetCurrentConfig();
        Assert.Equal(expectedMasked, current.ApiKey);
    }

    [Fact]
    public async Task IsAvailableAsync_ShouldHandleVariousResponses()
    {
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:Endpoint", "http://127.0.0.1:1234/v1/chat/completions" },
            { "AI:ApiKey", "valid-key" }
        }).Build();

        // 200 OK
        var clientOk = CreateMockHttpClient(_ => new HttpResponseMessage(HttpStatusCode.OK));
        var serviceOk = new LlmService(clientOk, config, _loggerMock.Object);
        Assert.True(await serviceOk.IsAvailableAsync());

        // 500 Internal Error
        var clientErr = CreateMockHttpClient(_ => new HttpResponseMessage(HttpStatusCode.InternalServerError));
        var serviceErr = new LlmService(clientErr, config, _loggerMock.Object);
        Assert.False(await serviceErr.IsAvailableAsync());

        // Exception thrown
        var clientThrow = CreateThrowingHttpClient(new HttpRequestException("network down"));
        var serviceThrow = new LlmService(clientThrow, config, _loggerMock.Object);
        Assert.False(await serviceThrow.IsAvailableAsync());

        // Empty endpoint
        var emptyConfig = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:Endpoint", "" }
        }).Build();
        var serviceEmpty = new LlmService(new HttpClient(), emptyConfig, _loggerMock.Object);
        Assert.False(await serviceEmpty.IsAvailableAsync());
    }

    [Fact]
    public async Task GetAvailableModelsAsync_AnthropicProvider_ReturnsPredefinedModels()
    {
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:Provider", "Anthropic" }
        }).Build();

        var service = new LlmService(new HttpClient(), config, _loggerMock.Object);
        var models = await service.GetAvailableModelsAsync();

        Assert.Equal(3, models.Count);
        Assert.Contains(models, m => m.Id == "claude-3-5-sonnet-20241022");
        Assert.Contains(models, m => m.Id == "claude-3-5-haiku-20241022");
        Assert.Contains(models, m => m.Id == "claude-3-opus-20240229");
    }

    [Fact]
    public async Task GetAvailableModelsAsync_V1ModelsSuccess_ReturnsParsedModels()
    {
        var jsonResponse = "{\"data\":[{\"id\":\"local-model-1\"},{\"id\":\"local-model-2\"}]}";
        var client = CreateMockHttpClient(req =>
        {
            if (req.RequestUri!.AbsolutePath.Contains("/v1/models"))
            {
                return new HttpResponseMessage(HttpStatusCode.OK)
                {
                    Content = new StringContent(jsonResponse, Encoding.UTF8, "application/json")
                };
            }
            return new HttpResponseMessage(HttpStatusCode.NotFound);
        });

        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:Provider", "LMStudio" },
            { "AI:Endpoint", "http://127.0.0.1:1234/v1/chat/completions" },
            { "AI:ApiKey", "token" }
        }).Build();

        var service = new LlmService(client, config, _loggerMock.Object);
        var models = await service.GetAvailableModelsAsync("http://127.0.0.1:1234/v1/chat/completions", "override-token");

        Assert.Equal(2, models.Count);
        Assert.Equal("local-model-1", models[0].Id);
        Assert.Equal("local-model-2", models[1].Id);
    }

    [Fact]
    public async Task GetAvailableModelsAsync_OllamaTagsSuccess_WhenV1ModelsFails()
    {
        var jsonOllama = "{\"models\":[{\"name\":\"llama3.1:8b\"},{\"name\":\"mistral:7b\"}]}";
        var client = CreateMockHttpClient(req =>
        {
            if (req.RequestUri!.AbsolutePath.Contains("/api/tags"))
            {
                return new HttpResponseMessage(HttpStatusCode.OK)
                {
                    Content = new StringContent(jsonOllama, Encoding.UTF8, "application/json")
                };
            }
            return new HttpResponseMessage(HttpStatusCode.NotFound);
        });

        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:Provider", "Ollama" },
            { "AI:Endpoint", "http://localhost:11434/v1/chat/completions" }
        }).Build();

        var service = new LlmService(client, config, _loggerMock.Object);
        var models = await service.GetAvailableModelsAsync();

        Assert.Equal(2, models.Count);
        Assert.Equal("llama3.1:8b", models[0].Id);
        Assert.Equal("mistral:7b", models[1].Id);
    }

    [Fact]
    public async Task GetAvailableModelsAsync_FallsBackToDefaultModels_ForOpenAiAndOthers()
    {
        var client = CreateMockHttpClient(_ => new HttpResponseMessage(HttpStatusCode.NotFound));

        // OpenAI default fallback
        var openAiConfig = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:Provider", "OpenAI" },
            { "AI:Endpoint", "https://api.openai.com/v1/chat/completions" }
        }).Build();

        var openAiService = new LlmService(client, openAiConfig, _loggerMock.Object);
        var openAiModels = await openAiService.GetAvailableModelsAsync();
        Assert.Equal(3, openAiModels.Count);
        Assert.Contains(openAiModels, m => m.Id == "gpt-4o");

        // Custom default fallback
        var customConfig = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:Provider", "Custom" },
            { "AI:Model", "my-custom-model" },
            { "AI:Endpoint", "http://localhost:8000/v1/chat/completions" }
        }).Build();

        var customService = new LlmService(client, customConfig, _loggerMock.Object);
        var customModels = await customService.GetAvailableModelsAsync();
        Assert.Single(customModels);
        Assert.Equal("my-custom-model", customModels[0].Id);
    }

    [Fact]
    public async Task TestConnectionAsync_EmptyEndpoint_ReturnsFailure()
    {
        var service = new LlmService(new HttpClient(), new ConfigurationBuilder().Build(), _loggerMock.Object);
        var result = await service.TestConnectionAsync(new LlmConfigDto { Endpoint = "" });

        Assert.False(result.Success);
        Assert.Contains("Endpoint URL adresi belirtilmemiş", result.Message);
    }

    [Fact]
    public async Task TestConnectionAsync_AnthropicSuccessAndFailure()
    {
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:Provider", "Anthropic" },
            { "AI:Endpoint", "https://api.anthropic.com/v1/messages" },
            { "AI:ApiKey", "sk-ant-test-key" },
            { "AI:Model", "claude-3-5-sonnet-20241022" }
        }).Build();

        // Success
        var clientSuccess = CreateMockHttpClient(_ => new HttpResponseMessage(HttpStatusCode.OK)
        {
            Content = new StringContent("{\"content\":[{\"type\":\"text\",\"text\":\"PONG\"}]}", Encoding.UTF8, "application/json")
        });
        var serviceSuccess = new LlmService(clientSuccess, config, _loggerMock.Object);
        var resOk = await serviceSuccess.TestConnectionAsync();
        Assert.True(resOk.Success);
        Assert.Equal("PONG", resOk.TestResponse);

        // Failure with JSON error
        var clientFail = CreateMockHttpClient(_ => new HttpResponseMessage(HttpStatusCode.BadRequest)
        {
            Content = new StringContent("{\"error\":{\"message\":\"Invalid credit balance\"}}", Encoding.UTF8, "application/json")
        });
        var serviceFail = new LlmService(clientFail, config, _loggerMock.Object);
        var resFail = await serviceFail.TestConnectionAsync();
        Assert.False(resFail.Success);
        Assert.Contains("Invalid credit balance", resFail.Message);
    }

    [Fact]
    public async Task TestConnectionAsync_OpenAiSuccessAndFailure_ErrorFormatting()
    {
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:Provider", "LMStudio" },
            { "AI:Endpoint", "http://127.0.0.1:1234/v1/chat/completions" },
            { "AI:ApiKey", "none" },
            { "AI:Model", "test-model" }
        }).Build();

        // Success
        var clientSuccess = CreateMockHttpClient(_ => new HttpResponseMessage(HttpStatusCode.OK)
        {
            Content = new StringContent("{\"choices\":[{\"message\":{\"content\":\"PONG\"}}]}", Encoding.UTF8, "application/json")
        });
        var serviceSuccess = new LlmService(clientSuccess, config, _loggerMock.Object);
        var resOk = await serviceSuccess.TestConnectionAsync();
        Assert.True(resOk.Success);
        Assert.Equal("PONG", resOk.TestResponse);

        // Failure with raw string error
        var clientFailStr = CreateMockHttpClient(_ => new HttpResponseMessage(HttpStatusCode.InternalServerError)
        {
            Content = new StringContent("{\"error\":\"Internal model failure\"}", Encoding.UTF8, "application/json")
        });
        var serviceFailStr = new LlmService(clientFailStr, config, _loggerMock.Object);
        var resFailStr = await serviceFailStr.TestConnectionAsync();
        Assert.False(resFailStr.Success);
        Assert.Contains("Internal model failure", resFailStr.Message);

        // Failure with plain text / HTML error
        var clientFailHtml = CreateMockHttpClient(_ => new HttpResponseMessage(HttpStatusCode.BadGateway)
        {
            Content = new StringContent("<html><body>502 Bad Gateway</body></html>", Encoding.UTF8, "text/html")
        });
        var serviceFailHtml = new LlmService(clientFailHtml, config, _loggerMock.Object);
        var resFailHtml = await serviceFailHtml.TestConnectionAsync();
        Assert.False(resFailHtml.Success);
        Assert.Contains("502 Bad Gateway", resFailHtml.Message);

        // Failure with empty body
        var clientFailEmpty = CreateMockHttpClient(_ => new HttpResponseMessage(HttpStatusCode.ServiceUnavailable)
        {
            Content = new StringContent("", Encoding.UTF8, "text/plain")
        });
        var serviceFailEmpty = new LlmService(clientFailEmpty, config, _loggerMock.Object);
        var resFailEmpty = await serviceFailEmpty.TestConnectionAsync();
        Assert.False(resFailEmpty.Success);
        Assert.Contains("HTTP 503", resFailEmpty.Message);
    }

    [Fact]
    public async Task TestConnectionAsync_Exceptions_ShouldFormatFriendlyMessages()
    {
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:Endpoint", "http://127.0.0.1:1234/v1/chat/completions" }
        }).Build();

        // Timeout
        var serviceTimeout = new LlmService(CreateThrowingHttpClient(new OperationCanceledException()), config, _loggerMock.Object);
        var resTimeout = await serviceTimeout.TestConnectionAsync();
        Assert.False(resTimeout.Success);
        Assert.Contains("Zaman Aşımı", resTimeout.Message);

        // Connection refused
        var serviceRefused = new LlmService(CreateThrowingHttpClient(new HttpRequestException("Connection refused")), config, _loggerMock.Object);
        var resRefused = await serviceRefused.TestConnectionAsync();
        Assert.False(resRefused.Success);
        Assert.Contains("Bağlantı reddedildi", resRefused.Message);

        // Host not found
        var serviceHostNotFound = new LlmService(CreateThrowingHttpClient(new HttpRequestException("Name or service not known")), config, _loggerMock.Object);
        var resHost = await serviceHostNotFound.TestConnectionAsync();
        Assert.False(resHost.Success);
        Assert.Contains("Sunucu adresi çözülemedi", resHost.Message);

        // Generic HTTP exception
        var serviceHttp = new LlmService(CreateThrowingHttpClient(new HttpRequestException("SSL connection error")), config, _loggerMock.Object);
        var resHttp = await serviceHttp.TestConnectionAsync();
        Assert.False(resHttp.Success);
        Assert.Contains("Ağ bağlantı hatası", resHttp.Message);

        // Generic exception
        var serviceGen = new LlmService(CreateThrowingHttpClient(new InvalidOperationException("Fatal crash")), config, _loggerMock.Object);
        var resGen = await serviceGen.TestConnectionAsync();
        Assert.False(resGen.Success);
        Assert.Contains("Bağlantı hatası: Fatal crash", resGen.Message);
    }

    [Fact]
    public async Task GetCompletionAsync_Anthropic_SuccessAndFailure()
    {
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:Provider", "Anthropic" },
            { "AI:Endpoint", "https://api.anthropic.com/v1/messages" },
            { "AI:ApiKey", "sk-ant-test" }
        }).Build();

        // Success
        var clientOk = CreateMockHttpClient(_ => new HttpResponseMessage(HttpStatusCode.OK)
        {
            Content = new StringContent("{\"content\":[{\"type\":\"text\",\"text\":\"Claude çözümü: Yeniden başlatın.\"}]}", Encoding.UTF8, "application/json")
        });
        var serviceOk = new LlmService(clientOk, config, _loggerMock.Object);
        var replyOk = await serviceOk.GetCompletionAsync("system", "user");
        Assert.Equal("Claude çözümü: Yeniden başlatın.", replyOk);

        // Failure
        var clientFail = CreateMockHttpClient(_ => new HttpResponseMessage(HttpStatusCode.Unauthorized)
        {
            Content = new StringContent("{\"error\":{\"message\":\"Invalid key\"}}", Encoding.UTF8, "application/json")
        });
        var serviceFail = new LlmService(clientFail, config, _loggerMock.Object);
        var replyFail = await serviceFail.GetCompletionAsync("system", "user");
        Assert.Contains("Anthropic API 401 Unauthorized", replyFail);
    }

    [Fact]
    public async Task GetCompletionAsync_OpenAi_SuccessAndFailure()
    {
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:Provider", "OpenAI" },
            { "AI:Endpoint", "https://api.openai.com/v1/chat/completions" },
            { "AI:ApiKey", "sk-test" }
        }).Build();

        // Success
        var clientOk = CreateMockHttpClient(_ => new HttpResponseMessage(HttpStatusCode.OK)
        {
            Content = new StringContent("{\"choices\":[{\"message\":{\"content\":\"OpenAI yanıtı.\"}}]}", Encoding.UTF8, "application/json")
        });
        var serviceOk = new LlmService(clientOk, config, _loggerMock.Object);
        var replyOk = await serviceOk.GetCompletionAsync("system", "user");
        Assert.Equal("OpenAI yanıtı.", replyOk);

        // Failure
        var clientFail = CreateMockHttpClient(_ => new HttpResponseMessage(HttpStatusCode.GatewayTimeout)
        {
            Content = new StringContent("Gateway timeout", Encoding.UTF8, "text/plain")
        });
        var serviceFail = new LlmService(clientFail, config, _loggerMock.Object);
        var replyFail = await serviceFail.GetCompletionAsync("system", "user");
        Assert.Contains("LLM Sunucusu 504 Gateway Timeout", replyFail);
    }

    [Fact]
    public async Task GetCompletionAsync_Exceptions_ShouldReturnDescriptiveMessages()
    {
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:Endpoint", "http://127.0.0.1:1234/v1/chat/completions" }
        }).Build();

        // Timeout
        var serviceTimeout = new LlmService(CreateThrowingHttpClient(new OperationCanceledException()), config, _loggerMock.Object);
        var msgTimeout = await serviceTimeout.GetCompletionAsync("system", "user");
        Assert.Contains("İstek zaman aşımına uğradı", msgTimeout);

        // HttpRequestException
        var serviceHttp = new LlmService(CreateThrowingHttpClient(new HttpRequestException("Connection refused")), config, _loggerMock.Object);
        var msgHttp = await serviceHttp.GetCompletionAsync("system", "user");
        Assert.Contains("Bağlantı reddedildi", msgHttp);

        // Generic Exception
        var serviceGen = new LlmService(CreateThrowingHttpClient(new Exception("Generic system error")), config, _loggerMock.Object);
        var msgGen = await serviceGen.GetCompletionAsync("system", "user");
        Assert.Contains("Beklenmeyen hata: Generic system error", msgGen);
    }

    [Fact]
    public async Task ParseResponses_MalformedJson_ShouldReturnEmptyStringGracefully()
    {
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:Endpoint", "http://127.0.0.1:1234/v1/chat/completions" }
        }).Build();

        // Invalid JSON body for OpenAI
        var clientInvalidJson = CreateMockHttpClient(_ => new HttpResponseMessage(HttpStatusCode.OK)
        {
            Content = new StringContent("NOT VALID JSON {{{{", Encoding.UTF8, "application/json")
        });
        var service = new LlmService(clientInvalidJson, config, _loggerMock.Object);
        var completion = await service.GetCompletionAsync("system", "user");
        Assert.Equal(string.Empty, completion);

        // Anthropic provider with empty content
        var anthropicConfig = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            { "AI:Provider", "Anthropic" },
            { "AI:Endpoint", "https://api.anthropic.com/v1/messages" }
        }).Build();
        var clientAnthropicInvalid = CreateMockHttpClient(_ => new HttpResponseMessage(HttpStatusCode.OK)
        {
            Content = new StringContent("NOT JSON", Encoding.UTF8, "application/json")
        });
        var serviceAnthropic = new LlmService(clientAnthropicInvalid, anthropicConfig, _loggerMock.Object);
        var completionAnthropic = await serviceAnthropic.GetCompletionAsync("system", "user");
        Assert.Equal(string.Empty, completionAnthropic);
    }
}
