using System;
using System.Threading;
using System.Threading.Tasks;
using ItsTool.Application.Interfaces;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace ItsTool.Infrastructure.BackgroundServices;

public class EmailBackgroundService : BackgroundService
{
    private readonly IEmailQueue _emailQueue;
    private readonly IServiceProvider _serviceProvider;
    private readonly ILogger<EmailBackgroundService> _logger;

    public EmailBackgroundService(IEmailQueue emailQueue, IServiceProvider serviceProvider, ILogger<EmailBackgroundService> logger)
    {
        _emailQueue = emailQueue;
        _serviceProvider = serviceProvider;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("Email Background Service is starting.");

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                var emailMessage = await _emailQueue.DequeueEmailAsync(stoppingToken);
                
                try
                {
                    _logger.LogInformation("Sending background email to {To} - {Subject}", emailMessage.To, emailMessage.Subject);
                    using var scope = _serviceProvider.CreateScope();
                    var emailService = scope.ServiceProvider.GetRequiredService<IEmailService>();
                    await emailService.SendEmailAsync(emailMessage.To, emailMessage.Subject, emailMessage.Body, emailMessage.IsHtml);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Failed to send background email to {To}", emailMessage.To);
                }
            }
            catch (OperationCanceledException)
            {
                // Prevent throwing if stoppingToken is canceled
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in Email Background Service queue reader.");
            }
        }
        
        _logger.LogInformation("Email Background Service is stopping.");
    }
}
