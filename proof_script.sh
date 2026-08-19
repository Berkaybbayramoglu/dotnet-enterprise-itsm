#!/bin/bash
fuser -k 5246/tcp
dotnet run --project src/ItsTool.API/ItsTool.API.csproj --launch-profile "http" > api.log 2>&1 &
PID=$!
sleep 15

TOKEN=$(curl -s -X POST http://localhost:5246/api/auth/login -H "Content-Type: application/json" -d '{"username":"admin","password":"Admin123!"}' | grep -oP '"token":"\K[^"]+')

echo "=== TICKET 1 ALLOWED TRANSITIONS ==="
curl -s -w "\nHTTP: %{http_code}\n" -H "Authorization: Bearer $TOKEN" http://localhost:5246/api/Ticket/1/allowed-transitions

echo "=== TRANSITION IN PROGRESS -> OPEN ==="
# Ticket 1 is "In Progress" (StatusId = 2), let's change it to "Open" (StatusId = 1)
curl -s -w "\nHTTP: %{http_code}\n" -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '1' http://localhost:5246/api/Ticket/1/status

echo "=== TRANSITION OPEN -> RESOLVED ==="
# Ticket 1 is "Open" (StatusId = 1), let's change it to "Resolved" (StatusId = 4)
curl -s -w "\nHTTP: %{http_code}\n" -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '4' http://localhost:5246/api/Ticket/1/status

kill $PID
