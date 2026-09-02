#!/bin/bash
echo "=== RUNNING TESTS ==="
dotnet test tests/ItsTool.UnitTests/ItsTool.UnitTests.csproj --no-restore --nologo -v q
echo ""

echo "=== STARTING API ==="
fuser -k 5246/tcp
dotnet run --project src/ItsTool.API/ItsTool.API.csproj --launch-profile "http" > api.log 2>&1 &
PID=$!
sleep 15

TOKEN=$(curl -s -X POST http://localhost:5246/api/auth/login -H "Content-Type: application/json" -d '{"username":"admin","password":"Admin123!"}' | grep -oP '"token":"\K[^"]+')

echo "=== SEEDING WORKFLOW MATRICES ==="
curl -s -w "\nHTTP: %{http_code}\n" -X POST -H "Authorization: Bearer $TOKEN" http://localhost:5246/api/system/seed

echo "=== WORKFLOW TRANSITION COUNT ==="
PGPASSWORD="${PGPASSWORD:?HATA: PGPASSWORD env değişkeni gerekli}" psql -h localhost -U postgres -d itsm_tool -c "SELECT count(*)::int FROM \"WorkflowTransitions\" WHERE \"WorkflowId\" = 1;"
echo ""

echo "=== TRANSITION OPEN -> RESOLVED ==="
# Just in case it's not Resolved
curl -s -w "\nHTTP: %{http_code}\n" -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '4' http://localhost:5246/api/Ticket/1/status
echo ""

echo "=== TICKET 1 ALLOWED TRANSITIONS ==="
curl -s -H "Authorization: Bearer $TOKEN" http://localhost:5246/api/Ticket/1/allowed-transitions | jq '.[].name'
echo -e "\n"

echo "=== TRANSITION RESOLVED -> PENDING ==="
# Ticket 1 is "Resolved" (StatusId = 4), let's change it to "Pending" (StatusId = 3)
curl -s -w "\nHTTP: %{http_code}\n" -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '3' http://localhost:5246/api/Ticket/1/status
echo ""

kill $PID
