using System.Threading;
using System.Threading.Tasks;

namespace ItsTool.Application.Interfaces;

public class EmailMessage
{
    public string To { get; set; } = string.Empty;
    public string Subject { get; set; } = string.Empty;
    public string Body { get; set; } = string.Empty;
    public bool IsHtml { get; set; } = true;
}

public interface IEmailQueue
{
    ValueTask QueueEmailAsync(EmailMessage message);
    ValueTask<EmailMessage> DequeueEmailAsync(CancellationToken cancellationToken);
}
