using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace ItsTool.Infrastructure.Data;

public class ItsToolDbContextFactory : IDesignTimeDbContextFactory<ItsToolDbContext>
{
    public ItsToolDbContext CreateDbContext(string[] args)
    {
        var optionsBuilder = new DbContextOptionsBuilder<ItsToolDbContext>();
        optionsBuilder.UseNpgsql("Host=localhost;Database=itsm_tool;Username=postgres;Password=fake_password");

        return new ItsToolDbContext(optionsBuilder.Options);
    }
}
