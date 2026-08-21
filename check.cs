using System;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using ItsTool.Infrastructure.Data;

var options = new DbContextOptionsBuilder<ItsToolDbContext>()
    .UseSqlite("Data Source=src/ItsTool.Infrastructure/Data/itsm.db")
    .Options;

using var db = new ItsToolDbContext(options);
var transitions = db.WorkflowTransitions
    .Where(t => t.FromStatusId == 5 && t.ToStatusId == 4)
    .ToList();

Console.WriteLine($"Found {transitions.Count} transitions from 5 to 4.");
foreach(var t in transitions) {
    Console.WriteLine($"ID: {t.Id}, Name: {t.TransitionName}, Active: {t.IsActive}");
}
