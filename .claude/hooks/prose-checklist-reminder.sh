#!/bin/bash
# =============================================================================
# prose-checklist-reminder.sh — Stop hook
# If manuscript files were modified during this session, remind the user to
# run the Self-Editing Checklist and /de-ai-audit before finalizing.
# =============================================================================

# Read hook input from stdin
INPUT=$(cat)

# Check if we're in a git repo first
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  exit 0
fi

# Check if any manuscript files have been modified (git-tracked changes)
# Use --diff-filter to handle repos with no commits yet
MODIFIED=$(git diff --name-only HEAD 2>/dev/null | grep "^manuscript/.*\.md$" || true)
STAGED=$(git diff --cached --name-only 2>/dev/null | grep "^manuscript/.*\.md$" || true)
UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | grep "^manuscript/.*\.md$" || true)

CHANGED_FILES=""
[ -n "$MODIFIED" ] && CHANGED_FILES="$MODIFIED"
[ -n "$STAGED" ] && CHANGED_FILES="$CHANGED_FILES $STAGED"
[ -n "$UNTRACKED" ] && CHANGED_FILES="$CHANGED_FILES $UNTRACKED"

# Deduplicate
CHANGED_FILES=$(echo "$CHANGED_FILES" | tr ' ' '\n' | sort -u | grep -v '^$')

if [ -n "$CHANGED_FILES" ]; then
  FILE_COUNT=$(echo "$CHANGED_FILES" | wc -l)
  echo ""
  echo "────────────────────────────────────────"
  echo "PROSE QC REMINDER: $FILE_COUNT manuscript file(s) modified this session."
  echo ""
  echo "Before finalizing:"
  echo "  1. Run Self-Editing Checklist (filter words, wan intensifiers, burstiness)"
  echo "  2. Run /de-ai-audit on modified files"
  echo "  3. Update FACTS_SHEET.md if new names/dates/places were introduced"
  echo "────────────────────────────────────────"
  echo ""
fi

exit 0
