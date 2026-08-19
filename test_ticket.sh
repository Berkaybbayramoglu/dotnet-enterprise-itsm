#!/bin/bash
TOKEN=$(curl -s -X POST http://localhost:5246/api/auth/login -H "Content-Type: application/json" -d '{"username":"admin","password":"Admin123!"}' | grep -oP '"token":"\K[^"]+')

# Create a basic ticket
TICKET_ID=$(curl -s -X POST http://localhost:5246/api/tickets \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Ticket","description":"Test","projectId":1,"categoryId":1,"ticketTypeId":1,"priorityId":2}' | grep -oP '"id":\K\d+')

if [ -z "$TICKET_ID" ]; then
  # Fallback to existing ticket ID 1 if possible
  TICKET_ID=1
fi

echo "Ticket ID: $TICKET_ID"

echo "Test 1: Binding Doğru (int gönder) -> 400 Invalid transition"
curl -s -w "\nHTTP: %{http_code}\n" -X POST http://localhost:5246/api/tickets/$TICKET_ID/status \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '2'

echo "Test 2: Binding Yanlış (object gönder) -> 400 Validation Error"
curl -s -w "\nHTTP: %{http_code}\n" -X POST http://localhost:5246/api/tickets/$TICKET_ID/status \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"newStatusId": 2}'
