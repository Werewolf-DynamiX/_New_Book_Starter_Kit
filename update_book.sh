#!/bin/bash
set -e

# ============================================================
# update_book.sh — Sync a book project to the latest Starter Kit
# ============================================================
# Usage: Run from inside your book project directory.
#   bash update_book.sh
# ============================================================

PROJECT_DIR="$(pwd)"
MANIFEST="$PROJECT_DIR/.sync/manifest.json"

# --- Check manifest exists ---
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

echo "============================================"
echo "  Book Project Updater"
echo "============================================"
echo ""
echo "Kit location:    $KIT_DIR"
echo "Project dir:     $PROJECT_DIR"
echo "Project version: $CURRENT_VERSION"
echo "Kit version:     $KIT_VERSION"
echo ""

# --- Check symlinks ---
echo "--- Checking symlinks ---"
LINKS_OK=true
for link in modules .vale; do
  if [ -L "$PROJECT_DIR/$link" ]; then
    TARGET=$(readlink -f "$PROJECT_DIR/$link" 2>/dev/null || readlink "$PROJECT_DIR/$link")
    EXPECTED=$(readlink -f "$KIT_DIR/$link" 2>/dev/null || echo "$KIT_DIR/$link")
    if [ "$TARGET" = "$EXPECTED" ]; then
      echo "  $link/ -> OK (linked to kit)"
    else
      echo "  $link/ -> WARNING: points to $TARGET (expected $EXPECTED)"
      LINKS_OK=false
    fi
  elif [ -d "$PROJECT_DIR/$link" ]; then
    echo "  $link/ -> NOT LINKED (is a regular directory)"
    echo "    Consider: rm -rf $link && ln -s $KIT_DIR/$link ./$link"
    LINKS_OK=false
  else
    echo "  $link/ -> MISSING"
    read -p "    Create symlink? [Y/n]: " yn
    case ${yn:-Y} in
      [Yy]*) ln -s "$KIT_DIR/$link" "$PROJECT_DIR/$link"; echo "    Created.";;
      *) echo "    Skipped.";;
    esac
  fi
done
echo ""

# --- Sync "sync_always" files ---
echo "--- Syncing infrastructure files ---"
SYNC_ALWAYS=(
  "PROJECT_COMPENDIUM.md"
  "MASTER_BOOK_REVIEW_PROMPT.md"
  "CONTINUITY_AUDIT_PROMPT.md"
  "GEMINI_REVIEW.md"
  "reference/collaboration_workflow.md"
  "reference/CENTRAL_FRAMEWORK_SETUP.md"
  "reference/MODEL_SELECTION_GUIDE.md"
  "reference/art_brief.md"
  "reference/KDP_BOOK_FORMATTING_SKILL.md"
  ".claude/settings.json"
  ".claude/hooks/banned-vocab.sh"
  ".claude/hooks/deai-quick-scan.sh"
  ".claude/hooks/prose-checklist-reminder.sh"
  ".claude/hooks/save-critical-context.sh"
  ".claude/hooks/version-check.sh"
  ".claude/rules/manuscript-prose.md"
  ".claude/scripts/gemini-continuity-audit-spec.md"
)

SYNCED=0
SKIPPED=0

# Ensure Claude Code and Gemini directories exist
mkdir -p "$PROJECT_DIR/.claude/hooks" "$PROJECT_DIR/.claude/rules" "$PROJECT_DIR/.claude/scripts"
mkdir -p "$PROJECT_DIR/.claude/skills"/{de-ai-audit,scene-brief,revision-guide,draft,chapter-done,holistic-audit,holistic-pass}
mkdir -p "$PROJECT_DIR/.gemini/skills"/{adversarial-review/references,continuity-audit,de-ai-audit/references,kdp-format/references,voice-lint,holistic-audit,holistic-pass}
mkdir -p "$PROJECT_DIR/docs"

for f in "${SYNC_ALWAYS[@]}"; do
  if [ ! -f "$KIT_DIR/$f" ]; then
    continue
  fi

  if [ ! -f "$PROJECT_DIR/$f" ]; then
    # New file in kit, copy it
    mkdir -p "$(dirname "$PROJECT_DIR/$f")"
    cp "$KIT_DIR/$f" "$PROJECT_DIR/$f"
    echo "  + $f (new file, copied)"
    SYNCED=$((SYNCED + 1))
  elif diff -q "$KIT_DIR/$f" "$PROJECT_DIR/$f" > /dev/null 2>&1; then
    # Already identical
    SKIPPED=$((SKIPPED + 1))
  else
    # Changed — auto-update (these are safe to overwrite)
    cp "$KIT_DIR/$f" "$PROJECT_DIR/$f"
    echo "  ~ $f (updated)"
    SYNCED=$((SYNCED + 1))
  fi
done

# Make hook and script files executable
chmod +x "$PROJECT_DIR/.claude/hooks/"*.sh 2>/dev/null || true
chmod +x "$PROJECT_DIR/.claude/scripts/"*.sh 2>/dev/null || true

echo "  Infrastructure: $SYNCED updated, $SKIPPED already current"
echo ""

# --- Sync skill templates (diff-check, don't auto-overwrite) ---
echo "--- Checking Claude skill templates ---"
SKILL_TEMPLATES=(
  ".claude/skills/de-ai-audit/SKILL.md"
  ".claude/skills/scene-brief/SKILL.md"
  ".claude/skills/revision-guide/SKILL.md"
  ".claude/skills/draft/SKILL.md"
  ".claude/skills/chapter-done/SKILL.md"
  ".claude/skills/holistic-audit/SKILL.md"
  ".claude/skills/holistic-pass/SKILL.md"
  ".gemini/skills/adversarial-review/SKILL.md"
  ".gemini/skills/continuity-audit/SKILL.md"
  ".gemini/skills/de-ai-audit/SKILL.md"
  ".gemini/skills/kdp-format/SKILL.md"
  ".gemini/skills/voice-lint/SKILL.md"
  ".gemini/skills/holistic-audit/SKILL.md"
  ".gemini/skills/holistic-pass/SKILL.md"
  ".gemini/skills/adversarial-review/references/_ADVERSARIAL_REVIEW_ENGINE.md"
  ".gemini/skills/de-ai-audit/references/CLAUDE.md"
  ".gemini/skills/de-ai-audit/references/_HUMAN_PATTERNS.md"
  ".gemini/skills/de-ai-audit/references/MASTER_BOOK_REVIEW_PROMPT.md"
  ".gemini/skills/de-ai-audit/references/_STYLE_AUTHORITY.md"
  ".gemini/skills/kdp-format/references/KDP_BOOK_FORMATTING_SKILL.md"
  "docs/HOLISTIC_PASSES.md"
  "docs/characters.md"
  ".claude/scripts/notebooklm-prep.sh"
)
SKILL_SYNCED=0
for f in "${SKILL_TEMPLATES[@]}"; do
  if [ ! -f "$KIT_DIR/$f" ]; then
    continue
  fi
  if [ ! -f "$PROJECT_DIR/$f" ]; then
    mkdir -p "$(dirname "$PROJECT_DIR/$f")"
    cp "$KIT_DIR/$f" "$PROJECT_DIR/$f"
    echo "  + $f (new skill, copied)"
    SKILL_SYNCED=$((SKILL_SYNCED + 1))
  elif ! diff -q "$KIT_DIR/$f" "$PROJECT_DIR/$f" > /dev/null 2>&1; then
    echo "  $f differs from kit."
    read -p "    Overwrite with kit version? [y/N]: " yn
    case $yn in
      [Yy]*)
        cp "$KIT_DIR/$f" "$PROJECT_DIR/$f"
        echo "    Updated."
        SKILL_SYNCED=$((SKILL_SYNCED + 1))
        ;;
      *) echo "    Kept your version.";;
    esac
  fi
done
if [ $SKILL_SYNCED -eq 0 ]; then
  echo "  All skills current."
fi
echo ""

# --- Check project-owned files for kit changes ---
echo "--- Checking project-owned files for kit updates ---"
echo "(These files are yours. Showing diffs for review only.)"
echo ""

PROJECT_OWNED_FROM_KIT=(
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

DIFFS_FOUND=0
for f in "${PROJECT_OWNED_FROM_KIT[@]}"; do
  if [ ! -f "$KIT_DIR/$f" ] || [ ! -f "$PROJECT_DIR/$f" ]; then
    continue
  fi
  if ! diff -q "$KIT_DIR/$f" "$PROJECT_DIR/$f" > /dev/null 2>&1; then
    DIFFS_FOUND=$((DIFFS_FOUND + 1))
    echo "  $f differs from kit template."
    read -p "    View diff? [y/N]: " yn
    case $yn in
      [Yy]*)
        echo "    --- Kit version vs. Your version ---"
        diff --color=auto "$KIT_DIR/$f" "$PROJECT_DIR/$f" || true
        echo ""
        read -p "    Overwrite with kit version? (YOUR CHANGES WILL BE LOST) [y/N]: " ow
        case $ow in
          [Yy]*)
            cp "$KIT_DIR/$f" "$PROJECT_DIR/$f"
            echo "    Overwritten."
            ;;
          *) echo "    Kept your version.";;
        esac
        ;;
      *) echo "    Skipped.";;
    esac
  fi
done

if [ $DIFFS_FOUND -eq 0 ]; then
  echo "  No differences found in project-owned files."
fi
echo ""

# --- Check for new files in kit that project doesn't have ---
echo "--- Checking for new kit files ---"
NEW_FILES=0
# Check reference/ for new files
for f in "$KIT_DIR"/reference/*.md; do
  fname=$(basename "$f")
  if [ ! -f "$PROJECT_DIR/reference/$fname" ]; then
    echo "  New in kit: reference/$fname"
    read -p "    Copy to project? [Y/n]: " yn
    case ${yn:-Y} in
      [Yy]*) cp "$f" "$PROJECT_DIR/reference/$fname"; echo "    Copied.";;
      *) echo "    Skipped.";;
    esac
    NEW_FILES=$((NEW_FILES + 1))
  fi
done

# Check context/ for new files
for f in "$KIT_DIR"/context/*.md; do
  fname=$(basename "$f")
  if [ ! -f "$PROJECT_DIR/context/$fname" ]; then
    echo "  New in kit: context/$fname"
    read -p "    Copy to project? [Y/n]: " yn
    case ${yn:-Y} in
      [Yy]*) cp "$f" "$PROJECT_DIR/context/$fname"; echo "    Copied.";;
      *) echo "    Skipped.";;
    esac
    NEW_FILES=$((NEW_FILES + 1))
  fi
done

if [ $NEW_FILES -eq 0 ]; then
  echo "  No new files found."
fi
echo ""

# --- Update the update script itself ---
if [ -f "$KIT_DIR/update_book.sh" ]; then
  if ! diff -q "$KIT_DIR/update_book.sh" "$PROJECT_DIR/update_book.sh" > /dev/null 2>&1; then
    cp "$KIT_DIR/update_book.sh" "$PROJECT_DIR/update_book.sh"
    chmod +x "$PROJECT_DIR/update_book.sh"
    echo "  update_book.sh itself was updated from kit."
    echo ""
  fi
fi

# --- Update manifest ---
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
  # Fallback: sed-based update (portable across macOS and Linux)
  sed -i.bak "s/\"kit_version\": \"[^\"]*\"/\"kit_version\": \"$KIT_VERSION\"/" "$MANIFEST" && rm -f "$MANIFEST.bak"
  sed -i.bak "s/\"last_sync\": \"[^\"]*\"/\"last_sync\": \"$NOW\"/" "$MANIFEST" && rm -f "$MANIFEST.bak"
fi

echo "============================================"
echo "  Sync complete! ($NOW)"
echo "  Project now at kit version: $KIT_VERSION"
echo "============================================"
