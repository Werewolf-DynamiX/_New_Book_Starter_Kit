#!/bin/bash
# version-check.sh — Notify if project is behind the starter kit.
# Runs on Stop hook. Silent if up to date.

MANIFEST=".sync/manifest.json"
[ ! -f "$MANIFEST" ] && exit 0

# Get kit path from manifest
KIT_PATH=$(python3 -c "import json; print(json.load(open('$MANIFEST'))['kit_path'])" 2>/dev/null)
[ -z "$KIT_PATH" ] || [ ! -d "$KIT_PATH" ] && exit 0

KIT_MANIFEST="$KIT_PATH/.sync/manifest.json"
[ ! -f "$KIT_MANIFEST" ] && exit 0

# Compare versions
PROJECT_VERSION=$(python3 -c "import json; print(json.load(open('$MANIFEST'))['kit_version'])" 2>/dev/null)
KIT_VERSION=$(python3 -c "import json; print(json.load(open('$KIT_MANIFEST'))['kit_version'])" 2>/dev/null)

if [ "$PROJECT_VERSION" != "$KIT_VERSION" ]; then
  echo "Starter kit update available: $PROJECT_VERSION -> $KIT_VERSION. Run: bash update_book.sh"
fi
