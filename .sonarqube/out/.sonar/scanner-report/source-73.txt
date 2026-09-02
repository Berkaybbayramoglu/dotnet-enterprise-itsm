using System;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.DependencyInjection;
using ItsTool.Application.Interfaces;
using Microsoft.Extensions.Logging;

namespace ItsTool.API.HostedServices;

public class SlaCheckerService : BackgroundService
{
    private readonly IServiceProvider _services;
    private readonly ILogger<SlaCheckerService> _logger;

    public SlaCheckerService(IServiceProvider services, ILogger<SlaCheckerService> logger)
    {
        _services = services;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("SLA Checker Service running.");

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                using (var scope = _services.CreateScope())
                {
                    var engine = scope.ServiceProvider.GetRequiredService<ISlaEngine>();
                    await engine.CheckBreachesAsync(DateTime.UtcNow);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred executing SLA check.");
            }

            await Task.Delay(TimeSpan.FromMinutes(5), stoppingToken); // Check every 5 minutes
        }
    }
}
