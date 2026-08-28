using System;
using Microsoft.Data.Sqlite;

var dbPath = "/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Web/app.db";
using var connection = new SqliteConnection($"Data Source={dbPath}");
connection.Open();
var command = connection.CreateCommand();
command.CommandText = "SELECT Id, EntityType, EntityName, Action, OldValue, NewValue FROM SystemAuditLogs ORDER BY Id DESC LIMIT 10;";
using var reader = command.ExecuteReader();
while (reader.Read())
{
    Console.WriteLine($"{reader.GetInt32(0)} | {reader.GetString(1)} | {reader.GetString(2)} | {reader.GetString(3)} | {(reader.IsDBNull(4) ? "null" : reader.GetString(4))} | {(reader.IsDBNull(5) ? "null" : reader.GetString(5))}");
}
