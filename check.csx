using Microsoft.Data.Sqlite;
using System;

using var connection = new SqliteConnection("Data Source=/home/berkay/Desktop/Turkcell_Staj/itsm-tool/src/ItsTool.Web/app.db");
connection.Open();
var command = connection.CreateCommand();
command.CommandText = "SELECT EntityType, EntityName, Action, OldValue, NewValue FROM SystemAuditLogs ORDER BY Id DESC LIMIT 5;";
using var reader = command.ExecuteReader();
while (reader.Read())
{
    Console.WriteLine($"{reader.GetString(0)} | {reader.GetString(1)} | {reader.GetString(2)} | {(!reader.IsDBNull(3) ? reader.GetString(3) : "null")} | {(!reader.IsDBNull(4) ? reader.GetString(4) : "null")}");
}
