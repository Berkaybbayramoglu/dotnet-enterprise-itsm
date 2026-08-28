using System;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using ItsTool.Infrastructure.Data;

var options = new DbContextOptionsBuilder<ItsToolDbContext>()
    .UseNpgsql("Host=localhost;Database=itsm;Username=postgres;Password=postgres")
    .Options;

using var db = new ItsToolDbContext(options);
var rules = db.AssignmentRules.ToList();
Console.WriteLine($"Total Rules: {rules.Count}");
foreach(var r in rules) {
    Console.WriteLine($"Rule: {r.Name}, Proj: {r.ProjectId}, Cat: {r.CategoryId}, Type: {r.TicketTypeId}, Prio: {r.PriorityId}, Grp: {r.TargetGroupId}, Usr: {r.TargetUserId}, Active: {r.IsActive}, Del: {r.IsDeleted}");
}
