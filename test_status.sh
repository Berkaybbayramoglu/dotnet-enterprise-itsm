#!/bin/bash
TOKEN=$(curl -s -X POST http://localhost:5246/api/auth/login -H "Content-Type: application/json" -d '{"username":"admin","password":"Admin123!"}' | grep -oP '"token":"\K[^"]+')

echo "Test 1: Binding Doğru (int gönder) -> 400 veya 204"
curl -s -w "\nHTTP: %{http_code}\n" -X POST http://localhost:5246/api/tickets/1/status -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '2'

echo "Test 2: Binding Yanlış (object gönder) -> 400 Validation Error"
curl -s -w "\nHTTP: %{http_code}\n" -X POST http://localhost:5246/api/tickets/1/status -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{"newStatusId": 2}'
