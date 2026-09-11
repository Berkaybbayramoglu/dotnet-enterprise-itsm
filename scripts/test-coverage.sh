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

if command -v node >/dev/null 2>&1; then
  echo ""
  echo "=================================================="
  echo "  Frontend & Keyboard Shortcuts Unit Tests"
  echo "=================================================="
  node --test tests/frontend/keyboard-shortcuts.test.js
fi
