using System;
using System.Threading;
using System.Threading.Tasks;
using ItsTool.Application.Interfaces;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace ItsTool.Infrastructure.BackgroundServices;

public class EmailBackgroundService : BackgroundService
{
    private readonly IEmailQueue _emailQueue;
    private readonly IEmailService _emailService;
    private readonly ILogger<EmailBackgroundService> _logger;

    public EmailBackgroundService(IEmailQueue emailQueue, IEmailService emailService, ILogger<EmailBackgroundService> logger)
    {
        _emailQueue = emailQueue;
        _emailService = emailService;
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
                    await _emailService.SendEmailAsync(emailMessage.To, emailMessage.Subject, emailMessage.Body, emailMessage.IsHtml);
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
