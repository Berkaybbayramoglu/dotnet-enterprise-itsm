using System;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using ItsTool.Infrastructure.Data;
var options = new DbContextOptionsBuilder<ItsToolDbContext>().UseNpgsql("Host=localhost;Database=itsm;Username=postgres;Password=postgres").Options;
using var db = new ItsToolDbContext(options);
var ticket = db.Tickets.Include(t => t.Assignments).OrderByDescending(t => t.Id).FirstOrDefault();
Console.WriteLine($"Ticket: {ticket?.Id}");
foreach(var a in ticket?.Assignments ?? new List<ItsTool.Domain.Entities.Ticket.TicketAssignment>()) {
    Console.WriteLine($"Assign: ID={a.Id}, UID={a.AssignedUserId}, GID={a.AssignedGroupId}");
}
