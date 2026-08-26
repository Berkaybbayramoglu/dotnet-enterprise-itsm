using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace ItsTool.UnitTests;

public abstract class TestBase : IDisposable
{
    protected readonly ItsToolDbContext _context;

    protected TestBase()
    {
        var options = new DbContextOptionsBuilder<ItsToolDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        _context = new ItsToolDbContext(options);
    }

    public void Dispose()
    {
        _context.Database.EnsureDeleted();
        _context.Dispose();
        GC.SuppressFinalize(this);
    }
}
