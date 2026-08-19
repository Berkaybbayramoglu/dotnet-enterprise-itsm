#!/bin/bash
fuser -k 5246/tcp
sleep 2
dotnet run --project src/ItsTool.API/ItsTool.API.csproj --launch-profile "http" > api.log 2>&1 &
PID=$!
sleep 15

TOKEN=$(curl -s -X POST http://localhost:5246/api/auth/login -H "Content-Type: application/json" -d '{"username":"admin","password":"Admin123!"}' | grep -oP '"token":"\K[^"]+')

echo "=== ALLOWED TRANSITIONS ==="
curl -s -H "Authorization: Bearer $TOKEN" http://localhost:5246/api/tickets/1/allowed-transitions
echo -e "\n=== DASHBOARD OVERVIEW ==="
curl -s -H "Authorization: Bearer $TOKEN" http://localhost:5246/api/dashboard/overview
echo -e "\n=== ALL TICKETS ==="
curl -s -H "Authorization: Bearer $TOKEN" http://localhost:5246/api/tickets | jq '.totalCount, .items[].id, .items[].status.name'

kill $PID
