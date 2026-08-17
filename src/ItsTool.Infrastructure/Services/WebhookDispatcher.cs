using System;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using System.Security.Cryptography;
using ItsTool.Application.Interfaces;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Polly;

namespace ItsTool.Infrastructure.Services;

public class WebhookDispatcher : IWebhookDispatcher
{
    private readonly ItsToolDbContext _context;
    private readonly HttpClient _httpClient;
    private readonly ILogger<WebhookDispatcher> _logger;

    public WebhookDispatcher(ItsToolDbContext context, HttpClient httpClient, ILogger<WebhookDispatcher> logger)
    {
        _context = context;
        _httpClient = httpClient;
        _logger = logger;
    }

    public async Task DispatchEventAsync(string eventKey, object payload)
    {
        var subscriptions = await _context.WebhookSubscriptions
            .Where(w => w.IsActive && !w.IsDeleted)
            .ToListAsync();

        var activeSubs = subscriptions.Where(w => w.EventsCsv.Split(',').Select(e => e.Trim()).Contains(eventKey)).ToList();

        if (!activeSubs.Any()) return;

        var jsonPayload = JsonSerializer.Serialize(new
        {
            @event = eventKey,
            timestamp = DateTime.UtcNow,
            data = payload
        });
        
        var contentBytes = Encoding.UTF8.GetBytes(jsonPayload);

        // Fire-and-forget logic so it doesn't block main thread
        _ = Task.Run(async () =>
        {
            foreach (var sub in activeSubs)
            {
                await SendWebhookAsync(sub, contentBytes, jsonPayload);
            }
        });
    }

    private async Task SendWebhookAsync(Domain.Entities.Config.WebhookSubscription sub, byte[] contentBytes, string jsonPayload)
    {
        var retryPolicy = Policy
            .Handle<HttpRequestException>()
            .Or<TaskCanceledException>()
            .WaitAndRetryAsync(1, retryAttempt => TimeSpan.FromSeconds(2), 
            (exception, timeSpan, retryCount, context) =>
            {
                _logger.LogWarning("Webhook retry {RetryCount} for {Url}", retryCount, sub.Url);
            });

        try
        {
            await retryPolicy.ExecuteAsync(async () =>
            {
                using var request = new HttpRequestMessage(HttpMethod.Post, sub.Url);
                
                request.Content = new StringContent(jsonPayload, Encoding.UTF8, "application/json");

                // Generate HMAC-SHA256 signature
                using (var hmac = new HMACSHA256(Encoding.UTF8.GetBytes(sub.Secret)))
                {
                    var hash = hmac.ComputeHash(contentBytes);
                    var signature = BitConverter.ToString(hash).Replace("-", "").ToLower();
                    request.Headers.Add("X-ITSM-Signature", signature);
                }
                
                // 5 seconds timeout for webhook
                using var cts = new System.Threading.CancellationTokenSource(TimeSpan.FromSeconds(5));
                
                var response = await _httpClient.SendAsync(request, cts.Token);
                response.EnsureSuccessStatusCode();
                
                _logger.LogInformation("Webhook sent successfully to {Url}", sub.Url);
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Webhook failed for {Url} after retries", sub.Url);
        }
    }
}
