#!/bin/bash
TOKEN=$(curl -s -X POST http://localhost:5246/api/Auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"Admin123!"}' | grep -oP '"token":"\K[^"]+')

echo "Token obtained. Testing endpoints..."

endpoints=(
  "/api/Projects"
  "/api/Categories"
  "/api/Departments"
  "/api/Groups"
  "/api/Users"
  "/api/Roles"
)

echo "| Endpoint | GET Status | POST Status |"
echo "|---|---|---|"

for endpoint in "${endpoints[@]}"; do
  # GET
  get_status=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $TOKEN" "http://localhost:5246$endpoint")
  
  # POST (Dummy payload, might return 400 but we check if endpoint exists)
  post_status=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{}' "http://localhost:5246$endpoint")
  
  echo "| $endpoint | $get_status | $post_status |"
done
