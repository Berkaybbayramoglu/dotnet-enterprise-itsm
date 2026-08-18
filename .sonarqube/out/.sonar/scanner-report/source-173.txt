using System.Threading.Tasks;

namespace ItsTool.Application.Interfaces;

public interface IEmailService
{
    Task SendEmailAsync(string to, string subject, string body);
}
