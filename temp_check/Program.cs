using System;
using System.Linq;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

class Program {
    static void Main(string[] args) {
        var configuration = new ConfigurationBuilder()
            .SetBasePath(Environment.CurrentDirectory + "/src/ItsTool.API")
            .AddJsonFile("appsettings.Development.json")
            .Build();
        
        var optionsBuilder = new DbContextOptionsBuilder<ItsToolDbContext>();
        optionsBuilder.UseNpgsql("Host=localhost;Port=5432;Database=itsm_tool;Username=postgres;Password=Berha6469.");
        
        using var context = new ItsToolDbContext(optionsBuilder.Options);
        var user = context.Users.FirstOrDefault(u => u.Username == "AI developer 1");
        if (user != null) {
            Console.WriteLine($"User Found: {user.Username} (Id: {user.Id})");
            var userRoles = context.UserRoles.Include(ur => ur.Role).Where(ur => ur.UserId == user.Id).ToList();
            Console.WriteLine($"Total UserRoles: {userRoles.Count}");
            foreach(var ur in userRoles) {
                Console.WriteLine($"Role: {ur.Role?.Name} (IsActive: {ur.Role?.IsActive}, IsDeleted: {ur.Role?.IsDeleted})");
                Console.WriteLine($"  ur.IsDeleted = {ur.IsDeleted}");
            }
            
            // Permissions
            var rolePerms = context.RolePermissions.Include(rp => rp.Permission).Where(rp => userRoles.Select(ur => ur.RoleId).Contains(rp.RoleId)).ToList();
            Console.WriteLine($"Total RolePermissions: {rolePerms.Count}");
            foreach(var rp in rolePerms) {
                Console.WriteLine($"Perm: {rp.Permission?.Key} (IsActive: {rp.Permission?.IsActive}, IsDeleted: {rp.Permission?.IsDeleted})");
                Console.WriteLine($"  rp.IsDeleted = {rp.IsDeleted}");
            }
        } else {
            Console.WriteLine("User not found.");
        }
    }
}
