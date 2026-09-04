using System;
using System.Threading;
using System.Threading.Channels;
using System.Threading.Tasks;
using ItsTool.Application.Interfaces;

namespace ItsTool.Infrastructure.Services;

public class InMemoryEmailQueue : IEmailQueue
{
    private readonly Channel<EmailMessage> _queue;

    public InMemoryEmailQueue()
    {
        var options = new BoundedChannelOptions(1000)
        {
            FullMode = BoundedChannelFullMode.Wait
        };
        _queue = Channel.CreateBounded<EmailMessage>(options);
    }

    public async ValueTask QueueEmailAsync(EmailMessage message)
    {
        ArgumentNullException.ThrowIfNull(message);
        await _queue.Writer.WriteAsync(message);
    }

    public async ValueTask<EmailMessage> DequeueEmailAsync(CancellationToken cancellationToken)
    {
        return await _queue.Reader.ReadAsync(cancellationToken);
    }
}
