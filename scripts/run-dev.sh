#!/bin/bash
# ITSM Tool - Development Environment Launcher
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=================================================="
echo "  ITSM Tool — Starting Local Development Servers"
echo "=================================================="

cd "$ROOT_DIR"

echo "[1/2] Launching ItsTool.API on http://localhost:5246..."
dotnet run --project src/ItsTool.API/ItsTool.API.csproj --launch-profile "http" &
API_PID=$!

cleanup() {
    echo ""
    echo "Stopping servers..."
    kill $API_PID 2>/dev/null || true
    exit 0
}

trap cleanup SIGINT SIGTERM EXIT

echo "[2/2] API started (PID: $API_PID)."
echo "  - Swagger UI: http://localhost:5246/swagger"
echo "  - Web App:    http://localhost:5246/index.html"
echo ""
echo "Press Ctrl+C to stop the server."

wait $API_PID
