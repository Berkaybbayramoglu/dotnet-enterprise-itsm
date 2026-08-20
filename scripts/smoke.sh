#!/bin/bash

# Configuration
API_URL="http://localhost:5033/api"
EMAIL="superadmin@itstool.local"
PASSWORD="SecretPassword123!"

echo "======================================"
echo " ITSM-TOOL SMOKE TEST SCRIPT"
echo "======================================"

# 1. Login
echo -n "POST /api/auth/login → "
LOGIN_RESPONSE=$(curl -s -w "%{http_code}" -X POST "$API_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"email\": \"$EMAIL\", \"password\": \"$PASSWORD\"}")

LOGIN_STATUS=${LOGIN_RESPONSE: -3}
LOGIN_BODY=${LOGIN_RESPONSE:0:${#LOGIN_RESPONSE}-3}

if [ "$LOGIN_STATUS" != "200" ]; then
    echo "FAILED ($LOGIN_STATUS)"
    echo "Body: $LOGIN_BODY"
    exit 1
fi
echo "$LOGIN_STATUS"

# Extract Token
TOKEN=$(echo "$LOGIN_BODY" | grep -o '"token":"[^"]*' | grep -o '[^"]*$')

# Function to test endpoint
test_endpoint() {
    local method=$1
    local endpoint=$2
    local body=$3
    
    echo -n "$method $endpoint → "
    
    local cmd="curl -s -w \"%{http_code}\" -X $method \"$API_URL$endpoint\" -H \"Authorization: Bearer $TOKEN\""
    
    if [ ! -z "$body" ]; then
        cmd="$cmd -H \"Content-Type: application/json\" -d '$body'"
    fi
    
    local response=$(eval $cmd)
    local status=${response: -3}
    echo "$status"
    return 0
}

# 2. Endpoints
test_endpoint "GET" "/lookup"
test_endpoint "GET" "/tickets?pageSize=10"
test_endpoint "GET" "/audit-log"

# Rules Lifecycle
echo -n "POST /rules/assignment → "
RULE_RESPONSE=$(curl -s -w "%{http_code}" -X POST "$API_URL/rules/assignment" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name": "Smoke Test Rule", "sortOrder": 99, "isActive": true}')
RULE_STATUS=${RULE_RESPONSE: -3}
RULE_BODY=${RULE_RESPONSE:0:${#RULE_RESPONSE}-3}
echo "$RULE_STATUS"

RULE_ID=$(echo "$RULE_BODY" | grep -o '"id":[0-9]*' | grep -o '[0-9]*')

if [ ! -z "$RULE_ID" ]; then
    test_endpoint "PUT" "/rules/assignment/$RULE_ID" '{"name": "Updated Smoke Rule", "sortOrder": 99, "isActive": false}'
    test_endpoint "PUT" "/rules/assignment/$RULE_ID/toggle"
    test_endpoint "DELETE" "/rules/assignment/$RULE_ID"
else
    echo "Could not extract RULE_ID for PUT/DELETE tests."
fi

# Webhooks
test_endpoint "GET" "/webhook"
echo -n "POST /webhook → "
WEBHOOK_RESPONSE=$(curl -s -w "%{http_code}" -X POST "$API_URL/webhook" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://smoke.test/hook", "eventsCsv": "ticket.created", "isActive": true}')
WEBHOOK_STATUS=${WEBHOOK_RESPONSE: -3}
WEBHOOK_BODY=${WEBHOOK_RESPONSE:0:${#WEBHOOK_RESPONSE}-3}
echo "$WEBHOOK_STATUS"

WEBHOOK_ID=$(echo "$WEBHOOK_BODY" | grep -o '"id":[0-9]*' | grep -o '[0-9]*')
if [ ! -z "$WEBHOOK_ID" ]; then
    test_endpoint "DELETE" "/webhook/$WEBHOOK_ID"
fi

# Overview
test_endpoint "GET" "/dashboard/overview"

# Ticket transitions (assuming ticket ID 1 exists and is closed, or just checking endpoint)
test_endpoint "GET" "/tickets/1/allowed-transitions"

echo "======================================"
echo " SMOKE TEST COMPLETE"
echo "======================================"
