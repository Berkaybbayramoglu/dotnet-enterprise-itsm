using System.IO;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.Configuration;

namespace ItsTool.Infrastructure.Data;

public class ItsToolDbContextFactory : IDesignTimeDbContextFactory<ItsToolDbContext>
{
    public ItsToolDbContext CreateDbContext(string[] args)
    {
        // Get the environment variable or default to Development
        var environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") ?? "Development";

        // Build config reading from the API project
        var basePath = Path.Combine(Directory.GetCurrentDirectory(), "../ItsTool.API");
        
        // If not running from Infrastructure folder (e.g., from solution root), adjust path
        if (!Directory.Exists(basePath))
        {
            basePath = Path.Combine(Directory.GetCurrentDirectory(), "src/ItsTool.API");
        }
        
        var configuration = new ConfigurationBuilder()
            .SetBasePath(basePath)
            .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
            .AddJsonFile($"appsettings.{environment}.json", optional: true)
            .AddEnvironmentVariables()
            .Build();

        var optionsBuilder = new DbContextOptionsBuilder<ItsToolDbContext>();
        
        var connectionString = configuration.GetConnectionString("DefaultConnection");
        if (string.IsNullOrEmpty(connectionString))
        {
            throw new InvalidOperationException("Connection string 'DefaultConnection' not found.");
        }

        optionsBuilder.UseNpgsql(connectionString);

        return new ItsToolDbContext(optionsBuilder.Options);
    }
}
