using System;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using ItsTool.Infrastructure.Data;

class Program
{
    static void Main()
    {
        var options = new DbContextOptionsBuilder<ItsToolDbContext>()
            .UseNpgsql("Host=localhost;Database=itsm_db;Username=postgres;Password=postgres")
            .Options;
            
        using var context = new ItsToolDbContext(options);
        var roles = context.Roles.Include(r => r.RolePermissions).ThenInclude(rp => rp.Permission).ToList();
        foreach(var r in roles)
        {
            Console.WriteLine($"Role: {r.Name}, Perms Count: {r.RolePermissions.Count}");
            foreach(var rp in r.RolePermissions)
            {
                Console.WriteLine($"  - {rp.Permission?.Key}");
            }
        }
    }
}
