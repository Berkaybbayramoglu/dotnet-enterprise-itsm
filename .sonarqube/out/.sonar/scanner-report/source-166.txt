using System;
using System.Collections.Generic;
using System.IO;
using ItsTool.Application.Interfaces;
using Microsoft.Extensions.Logging;

namespace ItsTool.Infrastructure.Services;

public class EmailTemplateService : IEmailTemplateService
{
    private readonly ILogger<EmailTemplateService> _logger;
    private readonly string _templatePath;

    public EmailTemplateService(ILogger<EmailTemplateService> logger)
    {
        _logger = logger;
        // In a real application, you might want to configure this path or use embedded resources.
        _templatePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Templates", "Email");
    }

    public string GenerateEmailBody(string eventKey, Dictionary<string, string> templateData)
    {
        var templateFile = Path.Combine(_templatePath, "BaseTemplate.html");
        
        string templateContent;
        try
        {
            if (File.Exists(templateFile))
            {
                templateContent = File.ReadAllText(templateFile);
            }
            else
            {
                _logger.LogWarning("Email template {TemplateFile} not found. Using fallback text.", templateFile);
                templateContent = "<h2>{{EventName}}</h2><p>{{Context}}</p><p><a href=\"{{AppUrl}}\">View Ticket {{TicketNumber}}</a></p>";
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to read email template from {TemplateFile}", templateFile);
            templateContent = "<h2>{{EventName}}</h2><p>{{Context}}</p><p><a href=\"{{AppUrl}}\">View Ticket {{TicketNumber}}</a></p>";
        }

        foreach (var kvp in templateData)
        {
            templateContent = templateContent.Replace($"{{{{{kvp.Key}}}}}", kvp.Value);
        }

        return templateContent;
    }
}
