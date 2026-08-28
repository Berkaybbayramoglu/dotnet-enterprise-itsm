using System;
using System.Threading.Tasks;
using ItsTool.Application.Interfaces;
using MailKit.Net.Smtp;
using MimeKit;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace ItsTool.Infrastructure.Services;

public class SmtpEmailService : IEmailService
{
    private readonly IConfiguration _config;
    private readonly ILogger<SmtpEmailService> _logger;

    public SmtpEmailService(IConfiguration config, ILogger<SmtpEmailService> logger)
    {
        _config = config;
        _logger = logger;
    }

    public async Task SendEmailAsync(string to, string subject, string body, bool isHtml = true)
    {
        var host = _config["Smtp:Host"];
        var portStr = _config["Smtp:Port"];
        var user = _config["Smtp:Username"];
        var pass = _config["Smtp:Password"];

        if (string.IsNullOrEmpty(host) || string.IsNullOrEmpty(portStr))
        {
            _logger.LogWarning("SMTP Configuration missing, skipping email to {To}", to);
            return;
        }

        try
        {
            var message = new MimeMessage();
            message.From.Add(new MailboxAddress("ITSM Tool", user ?? "noreply@itsm.local"));
            message.To.Add(new MailboxAddress("", to));
            message.Subject = subject;

            message.Body = new TextPart(isHtml ? "html" : "plain")
            {
                Text = body
            };

            using var client = new SmtpClient();
            await client.ConnectAsync(host, int.Parse(portStr), MailKit.Security.SecureSocketOptions.Auto);

            if (!string.IsNullOrEmpty(user) && !string.IsNullOrEmpty(pass))
            {
                await client.AuthenticateAsync(user, pass);
            }

            await client.SendAsync(message);
            await client.DisconnectAsync(true);
            _logger.LogInformation("Sent email to {To} with subject {Subject}", to, subject);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to send email to {To}", to);
        }
    }
}
