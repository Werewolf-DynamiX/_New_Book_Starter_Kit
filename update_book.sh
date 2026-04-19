#!/bin/bash
set -e

# ============================================================
# update_book.sh — Sync a book project to the latest Starter Kit
# ============================================================
#
# WHAT THIS DOES:
#   Brings your project's shared infrastructure up to date with
#   the central Starter Kit, without touching your story content.
#
# THREE CATEGORIES OF FILES:
#
#   1. SHARED INFRASTRUCTURE (auto-synced, always safe)
#      Hooks, rules, review prompts, reference docs.
#      These have no project-specific content. The kit version
#      is always correct. Overwritten automatically.
#
#   2. SKILL TEMPLATES (auto-synced if new, prompted if changed)
#      Claude and Gemini skill definitions. New skills are copied
#      automatically. If a skill you already have changed in the
#      kit, you're asked before overwriting.
#
#   3. YOUR FILES (never overwritten)
#      CLAUDE.md, GEMINI.md, PROJECT_IDENTITY.md, FACTS_SHEET,
#      WRITER_VOICE, etc. These contain your story's characters,
#      tone, session history, and other customizations. The script
#      will TELL you if the kit template changed (so you can
#      manually merge new framework features), but it will never
#      touch them.
#
# STRUCTURAL CONSISTENCY:
#   Ensures every project has the same directory layout —
#   creates any missing folders and verifies symlinks to the
#   shared modules/ and .vale/ directories.
#
# Usage: Run from inside your book project directory.
#   bash update_book.sh
#
# ============================================================

PROJECT_DIR="$(pwd)"
MANIFEST="$PROJECT_DIR/.sync/manifest.json"

# --- Preflight: check manifest ---
if [ ! -f "$MANIFEST" ]; then
  echo "ERROR: No .sync/manifest.json found."
  echo "This project wasn't initialized with init_book.sh."
  echo ""
  echo "To retrofit this project, create a manifest first."
  echo "See reference/CENTRAL_FRAMEWORK_SETUP.md for instructions."
  exit 1
fi

# --- Parse manifest ---
KIT_DIR=$(python3 -c "import json; print(json.load(open('$MANIFEST'))['kit_path'])" 2>/dev/null || \
  grep -o '"kit_path"[[:space:]]*:[[:space:]]*"[^"]*"' "$MANIFEST" | sed 's/.*: *"//;s/"$//')

if [ ! -d "$KIT_DIR" ]; then
  echo "ERROR: Starter kit not found at: $KIT_DIR"
  echo "Has it been moved? Update kit_path in .sync/manifest.json"
  exit 1
fi

CURRENT_VERSION=$(python3 -c "import json; print(json.load(open('$MANIFEST'))['kit_version'])" 2>/dev/null || \
  grep -o '"kit_version"[[:space:]]*:[[:space:]]*"[^"]*"' "$MANIFEST" | sed 's/.*: *"//;s/"$//')

KIT_VERSION=$(python3 -c "import json; print(json.load(open('$KIT_DIR/.sync/manifest.json'))['kit_version'])" 2>/dev/null || \
  grep -o '"kit_version"[[:space:]]*:[[:space:]]*"[^"]*"' "$KIT_DIR/.sync/manifest.json" | sed 's/.*: *"//;s/"$//')

PROJECT_NAME=$(basename "$PROJECT_DIR")

echo "============================================"
echo "  Update: $PROJECT_NAME"
echo "  $CURRENT_VERSION -> $KIT_VERSION"
echo "============================================"
echo ""

# ==========================================================
# PHASE 0: DEPRECATION CLEANUP — Remove files retired in
#   previous kit versions. Only targets empty skill dirs
#   and orphan files known to be removed upstream; never
#   touches manuscripts, FACTS_SHEET, or user-owned files.
# ==========================================================
echo "PHASE 0: Clean up deprecated files"
echo "-----------------------------------"

DEPRECATED_PATHS=(
  # Retired skills (adversarial review pipeline)
  ".claude/skills/scene-brief"
  ".claude/skills/revision-guide"
  ".claude/skills/chapter-done"
  ".gemini/skills/adversarial-review"
  # Retired hooks (PostToolUse vocab scanner was noisy)
  ".claude/hooks/banned-vocab.sh"
  ".claude/hooks/deai-quick-scan.sh"
  # Retired root docs (redundant with CLAUDE.md/GEMINI.md/README)
  "PROJECT_COMPENDIUM.md"
  "CONTINUITY_AUDIT_PROMPT.md"
  "GEMINI_REVIEW.md"
  "MASTER_BOOK_REVIEW_PROMPT.md"
  # Retired modules (consolidated into WRITER_VOICE_CORE + _PROSE)
  "modules/_WRITING_WORKFLOW.md"
  "modules/_MASTER_STORYTELLER_CORE.md"
  "modules/_AUTHOR_VOICE_BUILDER.md"
  "modules/KDP_BOOK_FORMATTING_SKILL.md"
  # Retired gemini skill references (files were integrated into _PROSE)
  ".gemini/skills/de-ai-audit/references/_HUMAN_PATTERNS.md"
  ".gemini/skills/de-ai-audit/references/MASTER_BOOK_REVIEW_PROMPT.md"
  ".gemini/skills/de-ai-audit/references/_STYLE_AUTHORITY.md"
  ".gemini/skills/adversarial-review/references/_ADVERSARIAL_REVIEW_ENGINE.md"
)

REMOVED=0
for p in "${DEPRECATED_PATHS[@]}"; do
  if [ -e "$PROJECT_DIR/$p" ] || [ -L "$PROJECT_DIR/$p" ]; then
    rm -rf "$PROJECT_DIR/$p"
    echo "  - Removed deprecated: $p"
    REMOVED=$((REMOVED + 1))
  fi
done
if [ $REMOVED -eq 0 ]; then
  echo "  No deprecated files to remove."
fi
echo ""

# ==========================================================
# PHASE 1: STRUCTURE — Ensure consistent directory layout
# ==========================================================
echo "PHASE 1: Verify project structure"
echo "----------------------------------"

# Required directories
REQUIRED_DIRS=(
  "manuscript"
  "context"
  "reference"
  "output"
  "docs"
  "archive"
  ".claude/hooks"
  ".claude/rules"
  ".claude/scripts"
  ".claude/skills/de-ai-audit"
  ".claude/skills/draft"
  ".claude/skills/holistic-audit"
  ".claude/skills/holistic-pass"
  ".claude/skills/prose-scan"
  ".claude/skills/pre-publish"
  ".claude/skills/review-chapter"
  ".claude/skills/feedback-digest"
  ".gemini/skills/continuity-audit"
  ".gemini/skills/de-ai-audit"
  ".gemini/skills/kdp-format"
  ".gemini/skills/voice-lint"
  ".gemini/skills/holistic-audit"
  ".gemini/skills/holistic-pass"
  ".gemini/skills/research-brief"
  ".gemini/skills/logic-check"
)

DIRS_CREATED=0
for d in "${REQUIRED_DIRS[@]}"; do
  if [ ! -d "$PROJECT_DIR/$d" ]; then
    mkdir -p "$PROJECT_DIR/$d"
    echo "  + Created $d/"
    DIRS_CREATED=$((DIRS_CREATED + 1))
  fi
done
if [ $DIRS_CREATED -eq 0 ]; then
  echo "  All directories present."
fi

# Check symlinks (modules/ and .vale/ should point to the kit)
for link in modules .vale; do
  if [ -L "$PROJECT_DIR/$link" ]; then
    TARGET=$(readlink -f "$PROJECT_DIR/$link" 2>/dev/null || readlink "$PROJECT_DIR/$link")
    EXPECTED=$(readlink -f "$KIT_DIR/$link" 2>/dev/null || echo "$KIT_DIR/$link")
    if [ "$TARGET" = "$EXPECTED" ]; then
      echo "  $link/ -> OK"
    else
      echo "  $link/ -> WARNING: points to $TARGET (expected $EXPECTED)"
    fi
  elif [ -d "$PROJECT_DIR/$link" ]; then
    echo "  $link/ -> WARNING: regular directory, should be a symlink"
    echo "    Fix: rm -rf $link && ln -s $KIT_DIR/$link ./$link"
  else
    echo "  $link/ -> MISSING — creating symlink"
    ln -s "$KIT_DIR/$link" "$PROJECT_DIR/$link"
    echo "  $link/ -> Created"
  fi
done
echo ""

# ==========================================================
# PHASE 2: SHARED INFRASTRUCTURE — Auto-sync (always safe)
# ==========================================================
echo "PHASE 2: Sync shared infrastructure (auto-updated)"
echo "---------------------------------------------------"
echo "  These files have no project-specific content."
echo ""

SYNC_ALWAYS=(
  "context/WRITER_VOICE_CORE.md"
  "reference/collaboration_workflow.md"
  "reference/CENTRAL_FRAMEWORK_SETUP.md"
  "reference/MODEL_SELECTION_GUIDE.md"
  "reference/art_brief.md"
  "reference/KDP_BOOK_FORMATTING_SKILL.md"
  ".claude/settings.json"
  ".claude/hooks/prose-checklist-reminder.sh"
  ".claude/hooks/save-critical-context.sh"
  ".claude/hooks/version-check.sh"
  ".claude/rules/manuscript-prose.md"
  ".claude/scripts/gemini-continuity-audit-spec.md"
  ".claude/scripts/prose-scan.sh"
  ".claude/scripts/prose_scan.py"
)

SYNCED=0
SKIPPED=0

for f in "${SYNC_ALWAYS[@]}"; do
  if [ ! -f "$KIT_DIR/$f" ]; then
    continue
  fi
  if [ ! -f "$PROJECT_DIR/$f" ]; then
    mkdir -p "$(dirname "$PROJECT_DIR/$f")"
    cp "$KIT_DIR/$f" "$PROJECT_DIR/$f"
    echo "  + $f (new)"
    SYNCED=$((SYNCED + 1))
  elif diff -q "$KIT_DIR/$f" "$PROJECT_DIR/$f" > /dev/null 2>&1; then
    SKIPPED=$((SKIPPED + 1))
  else
    cp "$KIT_DIR/$f" "$PROJECT_DIR/$f"
    echo "  ~ $f (updated)"
    SYNCED=$((SYNCED + 1))
  fi
done

chmod +x "$PROJECT_DIR/.claude/hooks/"*.sh 2>/dev/null || true
chmod +x "$PROJECT_DIR/.claude/scripts/"*.sh 2>/dev/null || true

echo "  $SYNCED updated, $SKIPPED already current"
echo ""

# ==========================================================
# PHASE 3: SKILL TEMPLATES — New skills auto-copy, existing
#           skills prompt before overwriting
# ==========================================================
echo "PHASE 3: Sync skill templates"
echo "------------------------------"

SKILL_FILES=(
  # Claude skills
  ".claude/skills/de-ai-audit/SKILL.md"
  ".claude/skills/draft/SKILL.md"
  ".claude/skills/holistic-audit/SKILL.md"
  ".claude/skills/holistic-pass/SKILL.md"
  ".claude/skills/prose-scan/SKILL.md"
  ".claude/skills/pre-publish/SKILL.md"
  ".claude/skills/review-chapter/SKILL.md"
  ".claude/skills/feedback-digest/SKILL.md"
  # Gemini skills
  ".gemini/skills/continuity-audit/SKILL.md"
  ".gemini/skills/de-ai-audit/SKILL.md"
  ".gemini/skills/kdp-format/SKILL.md"
  ".gemini/skills/voice-lint/SKILL.md"
  ".gemini/skills/holistic-audit/SKILL.md"
  ".gemini/skills/holistic-pass/SKILL.md"
  ".gemini/skills/research-brief/SKILL.md"
  ".gemini/skills/logic-check/SKILL.md"
  # Gemini skill reference files
  ".gemini/skills/kdp-format/references/KDP_BOOK_FORMATTING_SKILL.md"
  ".gemini/skills/research-brief/references/_PLANNING_PROTOCOL.md"
  ".gemini/skills/logic-check/references/_LOGIC_CHECK.md"
  # Doc templates
  "docs/HOLISTIC_PASSES.md"
  "docs/characters.md"
  ".claude/scripts/notebooklm-prep.sh"
)

SKILL_NEW=0
SKILL_UPDATED=0
SKILL_CURRENT=0

for f in "${SKILL_FILES[@]}"; do
  if [ ! -f "$KIT_DIR/$f" ]; then
    continue
  fi
  if [ ! -f "$PROJECT_DIR/$f" ]; then
    mkdir -p "$(dirname "$PROJECT_DIR/$f")"
    cp "$KIT_DIR/$f" "$PROJECT_DIR/$f"
    echo "  + $f (new)"
    SKILL_NEW=$((SKILL_NEW + 1))
  elif diff -q "$KIT_DIR/$f" "$PROJECT_DIR/$f" > /dev/null 2>&1; then
    SKILL_CURRENT=$((SKILL_CURRENT + 1))
  else
    echo "  ? $f differs from kit"
    read -p "    Overwrite with kit version? [y/N]: " yn
    case $yn in
      [Yy]*)
        cp "$KIT_DIR/$f" "$PROJECT_DIR/$f"
        echo "    Updated."
        SKILL_UPDATED=$((SKILL_UPDATED + 1))
        ;;
      *) echo "    Kept yours.";;
    esac
  fi
done

echo "  $SKILL_NEW new, $SKILL_UPDATED updated, $SKILL_CURRENT already current"
echo ""

# ==========================================================
# PHASE 4: YOUR FILES — Never overwritten, diff report only
# ==========================================================
echo "PHASE 4: Project-owned files (never overwritten)"
echo "-------------------------------------------------"

PROJECT_OWNED=(
  "CLAUDE.md"
  "GEMINI.md"
  "PROJECT_IDENTITY.md"
  "TODO.md"
  ".gitignore"
  ".claude/settings.local.json"
  ".gemini/settings.json"
  "context/FACTS_SHEET.md"
  "context/WRITER_VOICE.md"
  "context/LESSONS_LEARNED.md"
)

MIGRATION_FILE="$PROJECT_DIR/.sync/migration_guide.md"
DIFFS_FOUND=0

# Start building the migration guide
cat > "$MIGRATION_FILE" <<'HEADER'
# Migration Guide

**Generated by `update_book.sh`** — delete this file after applying changes.

This file contains diffs between the kit templates and your project files.
Your project files have story-specific content (characters, tone, session
history, etc.) that must be preserved. Only merge in **new framework
features** — do not replace project-specific content with template
placeholders.

## Instructions

For each file below, merge the additions from the kit template into the
project file. Ignore any lines where the kit has a generic placeholder
(like `[Define Tone Here]`) and your file has real content.

---

HEADER

for f in "${PROJECT_OWNED[@]}"; do
  if [ ! -f "$KIT_DIR/$f" ] || [ ! -f "$PROJECT_DIR/$f" ]; then
    continue
  fi
  if ! diff -q "$KIT_DIR/$f" "$PROJECT_DIR/$f" > /dev/null 2>&1; then
    DIFFS_FOUND=$((DIFFS_FOUND + 1))
    {
      echo "## \`$f\`"
      echo ""
      echo '```diff'
      diff -u "$KIT_DIR/$f" "$PROJECT_DIR/$f" || true
      echo '```'
      echo ""
      echo "---"
      echo ""
    } >> "$MIGRATION_FILE"
  fi
done

if [ $DIFFS_FOUND -gt 0 ]; then
  echo "  $DIFFS_FOUND file(s) differ from kit templates."
  echo "  Migration guide written to: .sync/migration_guide.md"
  echo ""
  echo "  To apply, tell Claude or Gemini:"
  echo "    \"Read .sync/migration_guide.md and merge the framework changes.\""
  echo ""
  echo "  Delete .sync/migration_guide.md when done."
else
  echo "  All project files up to date."
  rm -f "$MIGRATION_FILE"
fi
echo ""

# ==========================================================
# PHASE 5: NEW KIT FILES — Copy anything the kit added
# ==========================================================
echo "PHASE 5: Check for new files in kit"
echo "------------------------------------"

NEW_FILES=0
for dir in reference context docs; do
  if [ ! -d "$KIT_DIR/$dir" ]; then continue; fi
  for f in "$KIT_DIR/$dir"/*.md; do
    [ -f "$f" ] || continue
    fname=$(basename "$f")
    if [ ! -f "$PROJECT_DIR/$dir/$fname" ]; then
      mkdir -p "$PROJECT_DIR/$dir"
      cp "$f" "$PROJECT_DIR/$dir/$fname"
      echo "  + $dir/$fname"
      NEW_FILES=$((NEW_FILES + 1))
    fi
  done
done

if [ $NEW_FILES -eq 0 ]; then
  echo "  No new files."
fi
echo ""

# ==========================================================
# FINISH: Update manifest and self-update
# ==========================================================

# Self-update this script
if [ -f "$KIT_DIR/update_book.sh" ]; then
  if ! diff -q "$KIT_DIR/update_book.sh" "$PROJECT_DIR/update_book.sh" > /dev/null 2>&1; then
    cp "$KIT_DIR/update_book.sh" "$PROJECT_DIR/update_book.sh"
    chmod +x "$PROJECT_DIR/update_book.sh"
    echo "  Note: update_book.sh itself was updated from kit."
    echo ""
  fi
fi

# Update manifest version
NOW=$(date +%Y-%m-%d)
if command -v python3 > /dev/null 2>&1; then
  python3 -c "
import json
with open('$MANIFEST', 'r') as f:
    m = json.load(f)
m['kit_version'] = '$KIT_VERSION'
m['last_sync'] = '$NOW'
with open('$MANIFEST', 'w') as f:
    json.dump(m, f, indent=2)
    f.write('\n')
"
else
  sed -i.bak "s/\"kit_version\": \"[^\"]*\"/\"kit_version\": \"$KIT_VERSION\"/" "$MANIFEST" && rm -f "$MANIFEST.bak"
  sed -i.bak "s/\"last_sync\": \"[^\"]*\"/\"last_sync\": \"$NOW\"/" "$MANIFEST" && rm -f "$MANIFEST.bak"
fi

echo "============================================"
echo "  Done! $PROJECT_NAME synced to v$KIT_VERSION"
echo "  ($NOW)"
echo "============================================"
