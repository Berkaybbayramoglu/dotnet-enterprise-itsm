using System;
using System.Threading.Tasks;
using ItsTool.Application.Interfaces;

namespace ItsTool.Infrastructure.Services;

public class StubEmailService : IEmailService
{
    public Task SendEmailAsync(string to, string subject, string body)
    {
        Console.WriteLine($"[EMAIL STUB] To: {to}, Subject: {subject}");
        Console.WriteLine($"[EMAIL STUB] Body: {body}");
        return Task.CompletedTask;
    }
}
