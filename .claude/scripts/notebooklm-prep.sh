#!/bin/bash
# =============================================================================
# notebooklm-prep.sh — Bundle manuscript for Google NotebookLM upload
# =============================================================================
# Usage: bash .claude/scripts/notebooklm-prep.sh
#
# Auto-discovers manuscript chapters, context files, and project docs.
# Bundles them into output/notebooklm-bundle/ with pre-written audit prompts.
#
# Structure-aware: works with chapters in manuscript/chapters/ or manuscript/
# and picks up docs/, context/, and character files wherever they live.
# =============================================================================

set -e

PROJECT_DIR="$(pwd)"
BUNDLE_DIR="$PROJECT_DIR/output/notebooklm-bundle"

# --- Validate project structure ---
if [ ! -d "manuscript" ]; then
  echo "ERROR: No manuscript/ directory found. Run from your project root."
  exit 1
fi

# --- Clean and create bundle directory ---
rm -rf "$BUNDLE_DIR"
mkdir -p "$BUNDLE_DIR"

echo "============================================"
echo "  NotebookLM Prep"
echo "============================================"
echo ""

# --- Discover and copy manuscript chapters ---
# Priority: manuscript/chapters/*.md first, then manuscript/*.md as fallback
# Exclude: FULL_MANUSCRIPT*, compiled files, outlines, PDFs
CHAPTER_COUNT=0

echo "Manuscript files:"
if [ -d "manuscript/chapters" ] && ls manuscript/chapters/*.md >/dev/null 2>&1; then
  # Standard structure: chapters in subdirectory
  for f in manuscript/chapters/*.md; do
    [ -f "$f" ] || continue
    cp "$f" "$BUNDLE_DIR/"
    CHAPTER_COUNT=$((CHAPTER_COUNT + 1))
    echo "  + chapters/$(basename "$f")"
  done
else
  # Fallback: chapters directly in manuscript/
  for f in manuscript/*.md; do
    [ -f "$f" ] || continue
    fname=$(basename "$f")
    # Skip non-chapter files
    case "$fname" in
      FULL_MANUSCRIPT*|full_manuscript*|00_master_outline*) continue ;;
    esac
    cp "$f" "$BUNDLE_DIR/"
    CHAPTER_COUNT=$((CHAPTER_COUNT + 1))
    echo "  + $(basename "$f")"
  done
fi

# --- Copy context files ---
echo ""
echo "Context files:"
CONTEXT_FILES=(
  "context/FACTS_SHEET.md"
  "context/WRITER_VOICE.md"
  "context/LESSONS_LEARNED.md"
  "PROJECT_IDENTITY.md"
)

for f in "${CONTEXT_FILES[@]}"; do
  if [ -f "$f" ]; then
    cp "$f" "$BUNDLE_DIR/"
    echo "  + $(basename "$f")"
  fi
done

# --- Discover and copy character/docs files ---
echo ""
echo "Project docs:"
DOCS_FOUND=0

# Check standard location: docs/
if [ -d "docs" ]; then
  for f in docs/*.md; do
    [ -f "$f" ] || continue
    fname=$(basename "$f")
    # Skip holistic passes and revision internals — not useful for NotebookLM
    case "$fname" in
      HOLISTIC_PASSES*|REVISION_GUIDE*|revision_guide*|EDIT_PLAN*|BACKPORT*) continue ;;
    esac
    cp "$f" "$BUNDLE_DIR/docs_${fname}"
    echo "  + docs/$fname"
    DOCS_FOUND=$((DOCS_FOUND + 1))
  done
fi

# Check for character files in other common locations
for f in \
  "context/CHARACTER_VOICES.md" \
  "context/characters.md" \
  "series_bible.md" \
  "docs/series_bible.md" \
; do
  if [ -f "$f" ] && [ ! -f "$BUNDLE_DIR/docs_$(basename "$f")" ] && [ ! -f "$BUNDLE_DIR/$(basename "$f")" ]; then
    cp "$f" "$BUNDLE_DIR/$(basename "$f")"
    echo "  + $f"
    DOCS_FOUND=$((DOCS_FOUND + 1))
  fi
done

# Check for character sheet directories
for dir in "context/characters" "docs/characters"; do
  if [ -d "$dir" ]; then
    for f in "$dir"/*.md; do
      [ -f "$f" ] || continue
      cp "$f" "$BUNDLE_DIR/"
      echo "  + $f"
      DOCS_FOUND=$((DOCS_FOUND + 1))
    done
  fi
done

if [ $DOCS_FOUND -eq 0 ]; then
  echo "  (none found)"
fi

# --- Generate audit prompts ---
cat > "$BUNDLE_DIR/NOTEBOOKLM_PROMPTS.md" << 'PROMPTS'
# NotebookLM Audit Prompts

Use these prompts in NotebookLM after uploading all files from this bundle.
Copy-paste each prompt into the NotebookLM chat for the corresponding audit.

---

## 1. Continuity Audit (Physical Descriptions & Contradictions)

```
Audit all uploaded chapters for continuity errors. Specifically:

1. PHYSICAL DESCRIPTIONS: Find every physical description of each character
   (hair color, eye color, height, build, scars, clothing). List them by
   chapter with page/paragraph references. Flag any contradictions.

2. OBJECT TRACKING: Track significant objects (weapons, letters, jewelry,
   vehicles). Where do they appear? Are they ever in two places at once?
   Does a character use something they shouldn't have yet?

3. SETTING CONSISTENCY: Track descriptions of recurring locations. Do room
   layouts, distances between places, or environmental details change?

4. Compare all findings against FACTS_SHEET.md. Flag any discrepancies
   between the facts sheet and what's actually written in the chapters.

Output as a table: Issue | Chapter | Quote | Contradicts | Severity
```

## 2. Voice Consistency Audit

```
Analyze the narrative voice across all chapters for consistency. Check:

1. TONAL SHIFTS: Are there chapters or sections where the tone noticeably
   shifts? (e.g., suddenly more formal, more casual, more literary)

2. VOCABULARY LEVEL: Does the complexity of vocabulary stay consistent?
   Flag any sudden jumps in reading level.

3. SENTENCE PATTERNS: Are there chapters where sentence structure becomes
   noticeably more uniform or rhythmic compared to others?

4. POV DISCIPLINE: If the story uses limited POV, flag any moments where
   the narrator reveals information the POV character couldn't know.

5. DIALOGUE VOICE: Does each character maintain a distinct speech pattern?
   Flag any dialogue that could belong to any character interchangeably.

Compare against WRITER_VOICE.md for the intended persona and voice targets.
If character voice sheets are included, cross-reference dialogue against
each character's documented speech patterns, forbidden words, and vocal tics.

Output as: Chapter | Issue | Quote | Expected Voice | Severity
```

## 3. Timeline Audit

```
Build a complete timeline from the manuscript. For every chapter:

1. Extract all temporal references (dates, times, "three days later",
   "last Tuesday", seasons, weather, ages).

2. Calculate elapsed time between scenes and chapters.

3. Flag any temporal impossibilities:
   - Character ages that don't add up
   - Travel times that are physically impossible
   - Events that happen "yesterday" but contradict the established timeline
   - Seasonal/weather contradictions (snow in summer, etc.)

4. Check against FACTS_SHEET.md for established dates and ages.

Output as a chronological timeline, then a separate "ISSUES" table:
Issue | Chapters Involved | Time Discrepancy | Severity
```

## 4. Character Arc Tracing

```
For each named character in the manuscript:

1. Track their emotional state at each appearance. What do they want?
   What's blocking them? How do they feel?

2. Map their arc: Where do they start? Where do they end? What changes?

3. Flag any character who:
   - Appears and then vanishes without explanation
   - Changes personality without a triggering event
   - Has no clear want or need
   - Never faces opposition or conflict

4. Check for "flat supporting characters" — anyone who exists only to
   serve the protagonist without their own dimension.

Compare findings against any character sheets in the bundle.

Output as: Character | Arc Summary | Key Moments | Issues Found
```

## 5. Plot Thread Tracking

```
Identify and track every plot thread, subplot, and promise made to the
reader across all chapters:

1. SETUP: Where is each thread introduced? (foreshadowing, questions
   raised, mysteries posed, conflicts initiated)

2. DEVELOPMENT: Where is each thread advanced? How many chapters between
   touches?

3. RESOLUTION: Is each thread resolved? If not, is it intentionally
   left open or just forgotten?

4. Flag:
   - Threads introduced but never mentioned again
   - Threads that resolve too conveniently (deus ex machina)
   - Chekhov's Guns that never fire (significant objects/details
     introduced with emphasis but never used)
   - Promises made in early chapters that later chapters contradict

Output as: Thread | Introduced (Ch) | Touched (Chs) | Resolved? | Issues
```

PROMPTS

# --- Generate README ---
cat > "$BUNDLE_DIR/README.md" << 'README'
# NotebookLM Bundle

## How to Use

1. Go to [notebooklm.google.com](https://notebooklm.google.com)
2. Create a new notebook
3. Upload ALL `.md` files from this directory as sources
4. Open `NOTEBOOKLM_PROMPTS.md` (locally) and copy-paste each audit prompt
   into the NotebookLM chat

## What's Included

- All manuscript chapters (the text to audit)
- FACTS_SHEET.md (established facts — NotebookLM will cross-reference)
- WRITER_VOICE.md (voice targets — NotebookLM will check consistency)
- PROJECT_IDENTITY.md (project metadata)
- Character sheets and project docs (if found)
- NOTEBOOKLM_PROMPTS.md (5 pre-written audit prompts)

## Tips

- NotebookLM works best with 10-50 source documents
- If you have many chapters, consider bundling related chapters together
- Re-run audits after major revisions
- Use the Audio Overview feature to get a conversational summary of findings
README

echo ""
echo "============================================"
echo "  Bundle ready: $BUNDLE_DIR"
echo "  $CHAPTER_COUNT manuscript file(s) bundled"
echo "  $DOCS_FOUND project doc(s) included"
echo "============================================"
echo ""
echo "Next: Upload all .md files to notebooklm.google.com"
echo "Then use NOTEBOOKLM_PROMPTS.md for pre-written audit prompts."
