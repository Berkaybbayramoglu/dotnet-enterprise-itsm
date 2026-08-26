using System;
using Npgsql;
using Microsoft.Extensions.Configuration;

var configuration = new ConfigurationBuilder()
    .SetBasePath(Environment.CurrentDirectory + "/src/ItsTool.API")
    .AddJsonFile("appsettings.Development.json")
    .Build();

string connStr = configuration.GetConnectionString("DefaultConnection");

using var conn = new NpgsqlConnection(connStr);
conn.Open();

using var cmd = new NpgsqlCommand("SELECT u.username, r.name FROM \"Users\" u LEFT JOIN \"UserRoles\" ur ON u.\"Id\" = ur.\"UserId\" LEFT JOIN \"Roles\" r ON ur.\"RoleId\" = r.\"Id\" WHERE u.username = 'AI developer 1';", conn);
using var reader = cmd.ExecuteReader();
bool found = false;
while (reader.Read())
{
    found = true;
    Console.WriteLine($"User: {reader.GetString(0)}, Role: {(reader.IsDBNull(1) ? "NULL" : reader.GetString(1))}");
}
if (!found) Console.WriteLine("User 'AI developer 1' not found in DB.");
