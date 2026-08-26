using System;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using ItsTool.Domain.Entities.Config;
using ItsTool.Infrastructure.Services;
using Microsoft.Extensions.Logging;
using Moq;
using Moq.Protected;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class WebhookDispatcherTests : TestBase
{
    private readonly Mock<HttpMessageHandler> _httpMessageHandlerMock;
    private readonly HttpClient _httpClient;
    private readonly WebhookDispatcher _dispatcher;

    public WebhookDispatcherTests() : base()
    {
        _httpMessageHandlerMock = new Mock<HttpMessageHandler>();
        
        _httpMessageHandlerMock.Protected()
            .Setup<Task<HttpResponseMessage>>("SendAsync", ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>())
            .ReturnsAsync(new HttpResponseMessage { StatusCode = HttpStatusCode.OK });

        _httpClient = new HttpClient(_httpMessageHandlerMock.Object);
        var loggerMock = new Mock<ILogger<WebhookDispatcher>>();

        _dispatcher = new WebhookDispatcher(_context, _httpClient, loggerMock.Object);
    }

    [Fact]
    public async Task DispatchEventAsync_ShouldSkipInactiveSubscriptions()
    {
        _context.WebhookSubscriptions.Add(new WebhookSubscription { Url = "http://test.com", EventsCsv = "ticket.created", IsActive = false });
        await _context.SaveChangesAsync();

        await _dispatcher.DispatchEventAsync("ticket.created", new { id = 1 });
        await Task.Delay(100); // Allow fire-and-forget to run

        _httpMessageHandlerMock.Protected().Verify("SendAsync", Times.Never(), ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>());
    }

    [Fact]
    public async Task DispatchEventAsync_ShouldSendPostRequestWithHmac()
    {
        _context.WebhookSubscriptions.Add(new WebhookSubscription { Url = "http://test.com", EventsCsv = "ticket.created", IsActive = true, Secret = "mysecret" });
        await _context.SaveChangesAsync();

        await _dispatcher.DispatchEventAsync("ticket.created", new { id = 1 });
        await Task.Delay(1000); // Allow fire-and-forget to run

        _httpMessageHandlerMock.Protected().Verify("SendAsync", Times.Once(), ItExpr.Is<HttpRequestMessage>(req => 
            req.Method == HttpMethod.Post && 
            req.Headers.Contains("X-ITSM-Signature") &&
            req.RequestUri!.ToString() == "http://test.com/"
        ), ItExpr.IsAny<CancellationToken>());
    }
}
