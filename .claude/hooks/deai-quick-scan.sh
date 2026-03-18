#!/bin/bash
# =============================================================================
# deai-quick-scan.sh — PostToolUse hook for Write/Edit/MultiEdit
# Scans manuscript files for AI vocabulary clusters. Warns but does not block.
# =============================================================================

# Read hook input from stdin
INPUT=$(cat)

# Extract the file path from the tool input
# PostToolUse provides tool_input with file_path
FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    # Try tool_input.file_path first, then tool_input.path
    ti = data.get('tool_input', {})
    print(ti.get('file_path', ti.get('path', '')))
except:
    print('')
" 2>/dev/null || echo "")

# Only fire on manuscript/**/*.md files
if [[ ! "$FILE_PATH" =~ ^manuscript/.*\.md$ ]] && [[ ! "$FILE_PATH" =~ manuscript/.*\.md$ ]]; then
  exit 0
fi

# Check that the file exists
if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# --- Banned vocabulary (sourced from single file for consistency) ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/banned-vocab.sh"

# Count matches (case-insensitive)
HITS=0
FOUND_WORDS=()
for word in "${BANNED_WORDS[@]}"; do
  COUNT=$(grep -oi "$word" "$FILE_PATH" 2>/dev/null | wc -l)
  if [ "$COUNT" -gt 0 ]; then
    HITS=$((HITS + COUNT))
    FOUND_WORDS+=("$word($COUNT)")
  fi
done

# Only warn when 3+ banned words cluster
if [ "$HITS" -ge 3 ]; then
  echo ""
  echo "⚠ DE-AI SCAN: $HITS AI-vocabulary hits in $FILE_PATH"
  echo "  Found: ${FOUND_WORDS[*]}"
  echo "  Run /de-ai-audit for full analysis."
  echo ""
fi

exit 0
