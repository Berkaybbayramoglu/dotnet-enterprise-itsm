#!/bin/bash
TOKEN=$(curl -s -X POST http://localhost:5246/api/auth/login -H "Content-Type: application/json" -d '{"username":"admin","password":"Admin123!"}' | jq -r '.token')
curl -s -H "Authorization: Bearer $TOKEN" http://localhost:5246/api/auth/me | jq .
