using System;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using ItsTool.Infrastructure.Data;

var options = new DbContextOptionsBuilder<ItsToolDbContext>()
    .UseNpgsql("Host=localhost;Port=5432;Database=itsm_tool;Username=postgres;Password=mysecretpassword")
    .Options;

// I don't know the password. Let's extract it from dotnet user-secrets!
