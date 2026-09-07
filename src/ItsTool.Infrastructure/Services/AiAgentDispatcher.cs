using System;
using System.Threading.Tasks;
using ItsTool.Application.Interfaces;
using ItsTool.Domain.Entities.Ticket;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace ItsTool.Infrastructure.Services;

public class AiAgentDispatcher : IAiAgentDispatcher
{
    private readonly IServiceProvider _serviceProvider;
    private readonly ILogger<AiAgentDispatcher> _logger;

    public AiAgentDispatcher(IServiceProvider serviceProvider, ILogger<AiAgentDispatcher> logger)
    {
        _serviceProvider = serviceProvider;
        _logger = logger;
    }

    public Task DispatchAsync(string eventKey, Ticket ticket)
    {
        // Run completely in background so it doesn't block the caller
        _ = Task.Run(async () =>
        {
            try
            {
                using var scope = _serviceProvider.CreateScope();
                
                if (eventKey == "ticket.assigned")
                {
                    // Resolution Copilot Agent
                    var copilot = scope.ServiceProvider.GetRequiredService<ItsTool.Infrastructure.Agents.ResolutionCopilotAgent>();
                    await copilot.RunAsync(ticket);
                }
                else if (eventKey == "ticket.transferred")
                {
                    // Handoff Swarm
                    var swarm = scope.ServiceProvider.GetRequiredService<ItsTool.Infrastructure.Agents.TicketHandoffSwarm>();
                    await swarm.RunAsync(ticket);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to run AI Agent for event {EventKey} on Ticket {TicketId}", eventKey, ticket.Id);
            }
        });

        return Task.CompletedTask;
    }
}
