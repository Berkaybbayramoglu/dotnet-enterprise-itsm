using System;
using System.Linq;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

var configuration = new ConfigurationBuilder()
    .SetBasePath(Environment.CurrentDirectory + "/src/ItsTool.API")
    .AddJsonFile("appsettings.Development.json")
    .Build();

var optionsBuilder = new DbContextOptionsBuilder<ItsToolDbContext>();
optionsBuilder.UseNpgsql(configuration.GetConnectionString("DefaultConnection"));

using var context = new ItsToolDbContext(optionsBuilder.Options);

var user = context.Users.FirstOrDefault(u => u.Username == "AI developer 1");
if (user != null) {
    Console.WriteLine($"User Found: {user.Username} (Id: {user.Id})");
    var userRoles = context.UserRoles.Include(ur => ur.Role).Where(ur => ur.UserId == user.Id).ToList();
    Console.WriteLine($"Total UserRoles: {userRoles.Count}");
    foreach(var ur in userRoles) {
        Console.WriteLine($"Role: {ur.Role?.Name} (IsActive: {ur.Role?.IsActive}, IsDeleted: {ur.Role?.IsDeleted})");
    }
} else {
    Console.WriteLine("User not found.");
}
