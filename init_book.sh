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
echo "  Book Project Initializer (Kit v1.6.0)"
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
mkdir -p build scripts kdp release
mkdir -p .sync .claude/hooks .claude/rules .claude/scripts
mkdir -p .claude/skills/{de-ai-audit,draft,holistic-audit,holistic-pass}
mkdir -p .gemini/skills/{continuity-audit,de-ai-audit,kdp-format/references,voice-lint,holistic-audit,holistic-pass,logic-check/references,research-brief/references}
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
  "book.yaml"
  "progress.json"
  "build/metadata.yaml"
  "build/canonical_chapters.txt.example"
  "manuscript/front_matter/01_title.md"
  "manuscript/front_matter/02_copyright.md"
  "manuscript/front_matter/03_dedication.md"
  "manuscript/front_matter/04_epigraph.md"
  "manuscript/front_matter/05_content_notes.md"
  "manuscript/back_matter/01_author_note.md"
  "manuscript/back_matter/02_also_by.md"
  "manuscript/back_matter/03_about_author.md"
  "manuscript/back_matter/04_coming_soon.md"
  "manuscript/back_matter/05_review_request.md"
  "kdp/README.md"
  ".claude/settings.local.json"
  ".gemini/settings.json"
  "context/FACTS_SHEET.md"
  "context/WRITER_VOICE.md"
  "context/WRITER_VOICE_CORE.md"
  "context/LESSONS_LEARNED.md"
  ".claude/skills/de-ai-audit/SKILL.md"
  ".claude/skills/draft/SKILL.md"
  ".claude/skills/holistic-audit/SKILL.md"
  ".claude/skills/holistic-pass/SKILL.md"
  ".claude/skills/prose-scan/SKILL.md"
  ".claude/skills/pre-publish/SKILL.md"
  ".claude/skills/review-chapter/SKILL.md"
  ".claude/skills/feedback-digest/SKILL.md"
  ".gemini/skills/continuity-audit/SKILL.md"
  ".gemini/skills/de-ai-audit/SKILL.md"
  ".gemini/skills/kdp-format/SKILL.md"
  ".gemini/skills/voice-lint/SKILL.md"
  ".gemini/skills/holistic-audit/SKILL.md"
  ".gemini/skills/holistic-pass/SKILL.md"
  ".gemini/skills/logic-check/SKILL.md"
  ".gemini/skills/research-brief/SKILL.md"
  "docs/HOLISTIC_PASSES.md"
  "docs/characters.md"
  ".claude/scripts/notebooklm-prep.sh"
  "reviewer_complaints.md"
  ".gemini/skills/kdp-format/references/KDP_BOOK_FORMATTING_SKILL.md"
  ".gemini/skills/logic-check/references/_LOGIC_CHECK.md"
  ".gemini/skills/research-brief/references/_PLANNING_PROTOCOL.md"
)
for f in "${TEMPLATE_COPIES[@]}"; do
  if [ -f "$KIT_DIR/$f" ]; then
    cp "$KIT_DIR/$f" "$PROJECT_DIR/$f"
  fi
done

# --- Copy sync-always files (infrastructure, safe to overwrite on update) ---
echo "Copying infrastructure files..."
SYNC_ALWAYS=(
  "Makefile"
  "scripts/compile.sh"
  "scripts/compile.ps1"
  "build/print.latex"
  "build/epub.css"
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
for f in "${SYNC_ALWAYS[@]}"; do
  if [ -f "$KIT_DIR/$f" ]; then
    cp "$KIT_DIR/$f" "$PROJECT_DIR/$f"
  fi
done

# --- Make hook and script files executable ---
chmod +x "$PROJECT_DIR/.claude/hooks/"*.sh 2>/dev/null || true
chmod +x "$PROJECT_DIR/.claude/scripts/"*.sh 2>/dev/null || true
chmod +x "$PROJECT_DIR/scripts/"*.sh 2>/dev/null || true

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
  "kit_version": "1.6.0",
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
      "book.yaml",
      "progress.json",
      "build/metadata.yaml",
      "build/canonical_chapters.txt.example",
      "manuscript/front_matter/01_title.md",
      "manuscript/front_matter/02_copyright.md",
      "manuscript/front_matter/03_dedication.md",
      "manuscript/front_matter/04_epigraph.md",
      "manuscript/front_matter/05_content_notes.md",
      "manuscript/back_matter/01_author_note.md",
      "manuscript/back_matter/02_also_by.md",
      "manuscript/back_matter/03_about_author.md",
      "manuscript/back_matter/04_coming_soon.md",
      "manuscript/back_matter/05_review_request.md",
      "kdp/README.md",
      "reviewer_complaints.md",
      ".claude/settings.local.json",
      ".gemini/settings.json",
      "context/FACTS_SHEET.md",
      "context/WRITER_VOICE.md",
      "context/WRITER_VOICE_CORE.md",
      "context/LESSONS_LEARNED.md",
      ".claude/skills/de-ai-audit/SKILL.md",
      ".claude/skills/draft/SKILL.md",
      ".claude/skills/holistic-audit/SKILL.md",
      ".claude/skills/holistic-pass/SKILL.md",
      ".claude/skills/prose-scan/SKILL.md",
      ".claude/skills/pre-publish/SKILL.md",
      ".claude/skills/review-chapter/SKILL.md",
      ".claude/skills/feedback-digest/SKILL.md",
      ".gemini/skills/continuity-audit/SKILL.md",
      ".gemini/skills/de-ai-audit/SKILL.md",
      ".gemini/skills/kdp-format/SKILL.md",
      ".gemini/skills/voice-lint/SKILL.md",
      ".gemini/skills/holistic-audit/SKILL.md",
      ".gemini/skills/holistic-pass/SKILL.md",
      ".gemini/skills/logic-check/SKILL.md",
      ".gemini/skills/research-brief/SKILL.md",
      "docs/HOLISTIC_PASSES.md",
      "docs/characters.md",
      ".claude/scripts/notebooklm-prep.sh"
    ],
    "sync_always": [
      "Makefile",
      "scripts/compile.sh",
      "scripts/compile.ps1",
      "build/print.latex",
      "build/epub.css",
      "reference/collaboration_workflow.md",
      "reference/CENTRAL_FRAMEWORK_SETUP.md",
      "reference/MODEL_SELECTION_GUIDE.md",
      "reference/art_brief.md",
      "reference/KDP_BOOK_FORMATTING_SKILL.md",
      ".claude/settings.json",
      ".claude/hooks/prose-checklist-reminder.sh",
      ".claude/hooks/save-critical-context.sh",
      ".claude/hooks/version-check.sh",
      ".claude/rules/manuscript-prose.md",
      ".claude/scripts/gemini-continuity-audit-spec.md",
      ".claude/scripts/prose-scan.sh",
      ".claude/scripts/prose_scan.py"
    ],
    "project_owned": [
      "CLAUDE.md",
      "GEMINI.md",
      "PROJECT_IDENTITY.md",
      "TODO.md",
      "README.md",
      "CHANGELOG.md",
      ".gitignore",
      "book.yaml",
      "progress.json",
      ".claude/settings.local.json",
      ".gemini/settings.json",
      "context/FACTS_SHEET.md",
      "context/WRITER_VOICE.md",
      "context/WRITER_VOICE_CORE.md",
      "manuscript/",
      "output/",
      "release/",
      "kdp/",
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
- Initialized from Starter Kit v1.6.0
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
echo "    .claude/hooks/     — 2 automatic hooks (checklist reminder, context preservation)"
echo "    .claude/rules/     — Auto-loaded prose rules for manuscript files"
echo "    .claude/skills/    — 4 slash commands (/draft, /de-ai-audit, /holistic-audit, /holistic-pass)"
echo "    .claude/scripts/   — NotebookLM prep + Gemini audit spec"
echo "    .gemini/skills/    — 8 Gemini skills (continuity-audit, holistic-audit, logic-check, research-brief, etc.)"
echo "    docs/              — Holistic passes template"
echo ""
echo "  Build pipeline:"
echo "    scripts/compile.sh | compile.ps1 — Pandoc build drivers"
echo "    build/             — Typography (print.latex, epub.css, metadata.yaml)"
echo "    Makefile           — make epub | make print | make docx | make all"
echo "    release/           — Compiled output (EPUB, PDF, DOCX) lands here"
echo "    kdp/               — KDP submission assets (covers, mockups). See kdp/README.md"
echo ""
echo "  Manuscript scaffold:"
echo "    manuscript/front_matter/ — 5 templates (title, copyright, dedication, epigraph, content notes)"
echo "    manuscript/back_matter/  — 5 templates (author note, also-by, about, coming soon, review)"
echo "    book.yaml          — title, author, rights, slug, KDP abstract (fill in placeholders)"
echo ""
echo "  Next steps:"
echo "    1. Fill out PROJECT_IDENTITY.md"
echo "    2. Customize CLAUDE.md (tone, POV, tense, active modules)"
echo "    3. Customize GEMINI.md (thesis, audience, strategic pillars)"
echo "    4. Fill out book.yaml (title, author, slug, KDP abstract)"
echo "    5. Customize or delete front/back matter templates in manuscript/"
echo "    6. git init && git add -A && git commit -m 'Initial project setup'"
echo ""
echo "  To build: make epub | make print | make all   (requires pandoc)"
echo "  To update from kit later: bash update_book.sh"
echo "============================================"
