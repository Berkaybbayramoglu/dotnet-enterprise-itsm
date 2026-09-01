using System;
using System.Linq;
using ItsTool.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

class Program {
    static void Main() {
        var options = new DbContextOptionsBuilder<ItsToolDbContext>()
            .UseNpgsql("Host=localhost;Database=itsm;Username=postgres;Password=postgres")
            .Options;
        using var db = new ItsToolDbContext(options);
        var hist = db.TicketHistories.Where(x => x.Action == "CommentEdited").ToList();
        Console.WriteLine($"Total CommentEdited: {hist.Count}");
        foreach(var r in hist) {
            Console.WriteLine($"ID: {r.Id}, TicketId: {r.TicketId}, Action: {r.Action}, Old: {r.OldValue}, New: {r.NewValue}, CreatedAt: {r.CreatedAt}");
        }
    }
}
