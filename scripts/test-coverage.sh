#!/bin/bash
# ITSM Tool - Test & Coverage Runner
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=================================================="
echo "  ITSM Tool — Unit Test & Coverage Execution"
echo "=================================================="

cd "$ROOT_DIR"

dotnet test tests/ItsTool.UnitTests/ItsTool.UnitTests.csproj \
  --nologo \
  /p:CollectCoverage=true \
  /p:CoverletOutputFormat=opencover \
  /p:CoverletOutput=./coverage.opencover.xml

echo ""
echo "Coverage report generated at tests/ItsTool.UnitTests/coverage.opencover.xml"
