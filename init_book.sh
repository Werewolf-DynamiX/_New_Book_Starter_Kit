#!/bin/bash
set -e

# ============================================================
# init_book.sh — Initialize a new book project from the Starter Kit
# ============================================================
# Usage: Run from inside your new (empty) project directory.
#   bash /path/to/_New_Book_Starter_Kit/init_book.sh
# ============================================================

KIT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(pwd)"

# Sanity checks
if [ "$KIT_DIR" = "$PROJECT_DIR" ]; then
  echo "ERROR: Do not run this inside the starter kit itself."
  echo "Create a new directory for your project first, cd into it, then run this script."
  exit 1
fi

if [ -f ".sync/manifest.json" ]; then
  echo "ERROR: This directory already has a manifest. Use update_book.sh instead."
  exit 1
fi

echo "============================================"
echo "  Book Project Initializer (Kit v1.3.0)"
echo "============================================"
echo ""
echo "Kit location: $KIT_DIR"
echo "Project dir:  $PROJECT_DIR"
echo ""

# --- OS Check for Symlinks ---
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
  echo "WARNING: You are on Windows. Symlinks (ln -s) require Developer Mode"
  echo "to be ENABLED or the script to be run as Administrator."
  echo "If symlinking fails, the project initialization will be incomplete."
  echo ""
fi

# --- Project ID ---
read -p "Project ID (no spaces, e.g. dark_fantasy_01): " PROJ_ID
if [ -z "$PROJ_ID" ]; then
  echo "ERROR: Project ID is required."
  exit 1
fi

# --- Create directory structure ---
echo ""
echo "Creating directory structure..."
mkdir -p manuscript/chapters manuscript/front_matter manuscript/back_matter manuscript/drafts
mkdir -p context reference output research/sources research/reviews
mkdir -p visuals/diagrams visuals/figures visuals/generated
mkdir -p .sync .claude .gemini

# --- Symlink shared resources ---
echo "Linking modules/ -> kit (shared, auto-updating)..."
ln -s "$KIT_DIR/modules" "$PROJECT_DIR/modules"

echo "Linking .vale/ -> kit (shared, auto-updating)..."
ln -s "$KIT_DIR/.vale" "$PROJECT_DIR/.vale"

# --- Copy template files (project will customize these) ---
echo "Copying template files..."
TEMPLATE_COPIES=(
  "CLAUDE.md"
  "GEMINI.md"
  "GEMINI_REVIEW.md"
  "PROJECT_IDENTITY.md"
  "TODO.md"
  "README.md"
  ".gitignore"
  ".claude/settings.local.json"
  ".gemini/settings.json"
  "context/FACTS_SHEET.md"
  "context/WRITER_VOICE.md"
  "context/LESSONS_LEARNED.md"
)
for f in "${TEMPLATE_COPIES[@]}"; do
  if [ -f "$KIT_DIR/$f" ]; then
    cp "$KIT_DIR/$f" "$PROJECT_DIR/$f"
  fi
done

# --- Copy sync-always files (infrastructure, safe to overwrite on update) ---
echo "Copying infrastructure files..."
SYNC_ALWAYS=(
  "PROJECT_COMPENDIUM.md"
  "MASTER_BOOK_REVIEW_PROMPT.md"
  "CONTINUITY_AUDIT_PROMPT.md"
  "reference/collaboration_workflow.md"
  "reference/CENTRAL_FRAMEWORK_SETUP.md"
  "reference/MODEL_SELECTION_GUIDE.md"
  "reference/art_brief.md"
  "reference/KDP_BOOK_FORMATTING_SKILL.md"
)
for f in "${SYNC_ALWAYS[@]}"; do
  if [ -f "$KIT_DIR/$f" ]; then
    cp "$KIT_DIR/$f" "$PROJECT_DIR/$f"
  fi
done

# --- Copy the update script ---
if [ -f "$KIT_DIR/update_book.sh" ]; then
  cp "$KIT_DIR/update_book.sh" "$PROJECT_DIR/update_book.sh"
  chmod +x "$PROJECT_DIR/update_book.sh"
fi

if [ -f "$KIT_DIR/update_bible.sh" ]; then
  cp "$KIT_DIR/update_bible.sh" "$PROJECT_DIR/update_bible.sh"
  chmod +x "$PROJECT_DIR/update_bible.sh"
fi

# --- Copy manuscript outline template ---
if [ -f "$KIT_DIR/manuscript/00_master_outline.md" ]; then
  cp "$KIT_DIR/manuscript/00_master_outline.md" "$PROJECT_DIR/manuscript/00_master_outline.md"
fi

# --- Create the manifest ---
NOW=$(date +%Y-%m-%d)
cat > "$PROJECT_DIR/.sync/manifest.json" << MANIFEST
{
  "kit_version": "1.3.0",
  "kit_path": "$KIT_DIR",
  "project_id": "$PROJ_ID",
  "created": "$NOW",
  "last_sync": "$NOW",
  "files": {
    "linked": [
      "modules/",
      ".vale/"
    ],
    "template_copy": [
      "CLAUDE.md",
      "GEMINI.md",
      "GEMINI_REVIEW.md",
      "PROJECT_IDENTITY.md",
      "TODO.md",
      "README.md",
      ".gitignore",
      ".claude/settings.local.json",
      ".gemini/settings.json",
      "context/FACTS_SHEET.md",
      "context/WRITER_VOICE.md"
    ],
    "sync_always": [
      "PROJECT_COMPENDIUM.md",
      "MASTER_BOOK_REVIEW_PROMPT.md",
      "CONTINUITY_AUDIT_PROMPT.md",
      "GEMINI_REVIEW.md",
      "reference/collaboration_workflow.md",
      "reference/CENTRAL_FRAMEWORK_SETUP.md",
      "reference/MODEL_SELECTION_GUIDE.md",
      "reference/art_brief.md",
      "reference/KDP_BOOK_FORMATTING_SKILL.md"
    ],
    "project_owned": [
      "CLAUDE.md",
      "GEMINI.md",
      "PROJECT_IDENTITY.md",
      "TODO.md",
      "README.md",
      "CHANGELOG.md",
      ".gitignore",
      ".claude/settings.local.json",
      ".gemini/settings.json",
      "context/FACTS_SHEET.md",
      "context/WRITER_VOICE.md",
      "manuscript/",
      "output/",
      "research/",
      "visuals/"
    ]
  }
}
MANIFEST

# --- Create project CHANGELOG ---
cat > "$PROJECT_DIR/CHANGELOG.md" << CHANGELOG
# $PROJ_ID Changelog

## [$NOW] - Project Created
- Initialized from Starter Kit v1.3.0
- Modules linked to: $KIT_DIR/modules
CHANGELOG

# --- Summary ---
echo ""
echo "============================================"
echo "  Project '$PROJ_ID' initialized!"
echo "============================================"
echo ""
echo "  Symlinked (auto-updating):"
echo "    modules/ -> $KIT_DIR/modules"
echo "    .vale/   -> $KIT_DIR/.vale"
echo ""
echo "  Copied (customize these):"
echo "    CLAUDE.md, GEMINI.md, PROJECT_IDENTITY.md"
echo "    context/, reference/, .gitignore"
echo ""
echo "  Next steps:"
echo "    1. Fill out PROJECT_IDENTITY.md"
echo "    2. Customize CLAUDE.md (tone, POV, tense, active modules)"
echo "    3. Customize GEMINI.md (thesis, audience, strategic pillars)"
echo "    4. git init && git add -A && git commit -m 'Initial project setup'"
echo ""
echo "  To update from kit later: bash update_book.sh"
echo "============================================"
