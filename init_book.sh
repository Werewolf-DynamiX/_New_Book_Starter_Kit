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
echo "  Book Project Initializer (Kit v1.5.0)"
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
mkdir -p .sync .claude/hooks .claude/rules .claude/scripts
mkdir -p .claude/skills/{de-ai-audit,scene-brief,revision-guide,draft,chapter-done,holistic-audit,holistic-pass}
mkdir -p .gemini/skills/{adversarial-review/references,continuity-audit,de-ai-audit/references,kdp-format/references,voice-lint,holistic-audit,holistic-pass}
mkdir -p docs

# --- Symlink shared resources ---
echo "Linking modules/ -> kit (shared, auto-updating)..."
ln -s "$KIT_DIR/modules" "$PROJECT_DIR/modules" || {
  echo "ERROR: Symlink failed for modules/. On Windows, enable Developer Mode or run as Administrator."
  exit 1
}

echo "Linking .vale/ -> kit (shared, auto-updating)..."
ln -s "$KIT_DIR/.vale" "$PROJECT_DIR/.vale" || {
  echo "ERROR: Symlink failed for .vale/. On Windows, enable Developer Mode or run as Administrator."
  exit 1
}

# --- Copy template files (project will customize these) ---
echo "Copying template files..."
TEMPLATE_COPIES=(
  "CLAUDE.md"
  "GEMINI.md"
  "PROJECT_IDENTITY.md"
  "TODO.md"
  "README.md"
  ".gitignore"
  ".claude/settings.local.json"
  ".gemini/settings.json"
  "context/FACTS_SHEET.md"
  "context/WRITER_VOICE.md"
  "context/LESSONS_LEARNED.md"
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
  "docs/HOLISTIC_PASSES.md"
  ".gemini/skills/adversarial-review/references/_ADVERSARIAL_REVIEW_ENGINE.md"
  ".gemini/skills/de-ai-audit/references/CLAUDE.md"
  ".gemini/skills/de-ai-audit/references/_HUMAN_PATTERNS.md"
  ".gemini/skills/de-ai-audit/references/MASTER_BOOK_REVIEW_PROMPT.md"
  ".gemini/skills/de-ai-audit/references/_STYLE_AUTHORITY.md"
  ".gemini/skills/kdp-format/references/KDP_BOOK_FORMATTING_SKILL.md"
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
  "GEMINI_REVIEW.md"
  "reference/collaboration_workflow.md"
  "reference/CENTRAL_FRAMEWORK_SETUP.md"
  "reference/MODEL_SELECTION_GUIDE.md"
  "reference/art_brief.md"
  "reference/KDP_BOOK_FORMATTING_SKILL.md"
  ".claude/settings.json"
  ".claude/hooks/deai-quick-scan.sh"
  ".claude/hooks/prose-checklist-reminder.sh"
  ".claude/hooks/save-critical-context.sh"
  ".claude/hooks/version-check.sh"
  ".claude/rules/manuscript-prose.md"
  ".claude/scripts/notebooklm-prep.sh"
  ".claude/scripts/gemini-continuity-audit-spec.md"
)
for f in "${SYNC_ALWAYS[@]}"; do
  if [ -f "$KIT_DIR/$f" ]; then
    cp "$KIT_DIR/$f" "$PROJECT_DIR/$f"
  fi
done

# --- Make hook and script files executable ---
chmod +x "$PROJECT_DIR/.claude/hooks/"*.sh 2>/dev/null || true
chmod +x "$PROJECT_DIR/.claude/scripts/"*.sh 2>/dev/null || true

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
  "kit_version": "1.5.0",
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
      "PROJECT_IDENTITY.md",
      "TODO.md",
      "README.md",
      ".gitignore",
      ".claude/settings.local.json",
      ".gemini/settings.json",
      "context/FACTS_SHEET.md",
      "context/WRITER_VOICE.md",
      "context/LESSONS_LEARNED.md",
      ".claude/skills/de-ai-audit/SKILL.md",
      ".claude/skills/scene-brief/SKILL.md",
      ".claude/skills/revision-guide/SKILL.md",
      ".claude/skills/draft/SKILL.md",
      ".claude/skills/chapter-done/SKILL.md",
      ".claude/skills/holistic-audit/SKILL.md",
      ".claude/skills/holistic-pass/SKILL.md",
      ".gemini/skills/adversarial-review/SKILL.md",
      ".gemini/skills/continuity-audit/SKILL.md",
      ".gemini/skills/de-ai-audit/SKILL.md",
      ".gemini/skills/kdp-format/SKILL.md",
      ".gemini/skills/voice-lint/SKILL.md",
      ".gemini/skills/holistic-audit/SKILL.md",
      ".gemini/skills/holistic-pass/SKILL.md",
      "docs/HOLISTIC_PASSES.md"
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
      "reference/KDP_BOOK_FORMATTING_SKILL.md",
      ".claude/settings.json",
      ".claude/hooks/deai-quick-scan.sh",
      ".claude/hooks/prose-checklist-reminder.sh",
      ".claude/hooks/save-critical-context.sh",
      ".claude/hooks/version-check.sh",
      ".claude/rules/manuscript-prose.md",
      ".claude/scripts/notebooklm-prep.sh",
      ".claude/scripts/gemini-continuity-audit-spec.md"
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
- Initialized from Starter Kit v1.5.0
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
echo "  Claude Code automation:"
echo "    .claude/hooks/     — 3 automatic hooks (de-ai scan, checklist, context)"
echo "    .claude/rules/     — Auto-loaded prose rules for manuscript files"
echo "    .claude/skills/    — 7 slash commands (/scene-brief, /draft, /holistic-audit, etc.)"
echo "    .claude/scripts/   — NotebookLM prep + Gemini audit spec"
echo "    .gemini/skills/    — 7 Gemini skills (adversarial-review, holistic-audit, etc.)"
echo "    docs/              — Holistic passes template"
echo ""
echo "  Next steps:"
echo "    1. Fill out PROJECT_IDENTITY.md"
echo "    2. Customize CLAUDE.md (tone, POV, tense, active modules)"
echo "    3. Customize GEMINI.md (thesis, audience, strategic pillars)"
echo "    4. git init && git add -A && git commit -m 'Initial project setup'"
echo ""
echo "  To update from kit later: bash update_book.sh"
echo "============================================"
