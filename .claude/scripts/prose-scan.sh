#!/bin/bash
# prose-scan.sh — run seven mechanical prose diagnostics on a markdown chapter.
# Usage: bash .claude/scripts/prose-scan.sh path/to/chapter.md

set -e

if [ $# -lt 1 ]; then
  echo "Usage: bash .claude/scripts/prose-scan.sh <chapter.md>"
  exit 1
fi

FILE="$1"
if [ ! -f "$FILE" ]; then
  echo "ERROR: file not found: $FILE"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PY="$SCRIPT_DIR/prose_scan.py"

if [ ! -f "$PY" ]; then
  echo "ERROR: prose_scan.py not found at $PY"
  exit 1
fi

# Prefer `py` launcher (Windows), then `python`, then `python3`.
# On Windows the `python3` alias is often a Microsoft Store stub that exits
# with a "not found" error instead of running Python.
if command -v py >/dev/null 2>&1; then
  py "$PY" "$FILE"
elif command -v python >/dev/null 2>&1 && python -c "import sys" >/dev/null 2>&1; then
  python "$PY" "$FILE"
elif command -v python3 >/dev/null 2>&1 && python3 -c "import sys" >/dev/null 2>&1; then
  python3 "$PY" "$FILE"
else
  echo "ERROR: python required (tried py, python, python3)."
  exit 1
fi
