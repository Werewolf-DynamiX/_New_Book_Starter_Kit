# Framework Trim — Minimum Viable Changes

**Goal:** Strip the existing framework down without a full rebuild. Every change below is reversible. You can do this in a couple of hours.

**Order doesn't matter much.** Do them in whatever order feels least annoying. If something breaks, you can restore from git.

**Before you start:** `git commit -am "pre-trim snapshot"` so you can roll back if anything goes sideways.

---

## 1. Delete these skills entirely

```bash
rm -rf .claude/skills/scene-brief/
rm -rf .claude/skills/revision-guide/
rm -rf .claude/skills/chapter-done/
rm -rf .gemini/skills/adversarial-review/
```

These are the highest-friction skills and they're solving problems you don't actually have. The adversarial review engine is simulated feedback from fictional readers — it's theater, not signal.

**Keep:** `/draft`, `/de-ai-audit`, `/holistic-audit`, `/holistic-pass`, continuity-audit, voice-lint, kdp-format. Those are doing real work.

---

## 2. Disable the noisy hook

Open `.claude/settings.json` and remove the `deai-quick-scan.sh` entry from `PostToolUse`. The file should end up looking like this:

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {"type": "command", "command": "bash .claude/hooks/prose-checklist-reminder.sh"},
          {"type": "command", "command": "bash .claude/hooks/version-check.sh"}
        ]
      }
    ],
    "PreCompact": [
      {
        "matcher": "",
        "hooks": [
          {"type": "command", "command": "bash .claude/hooks/save-critical-context.sh"}
        ]
      }
    ]
  }
}
```

The vocab scanner was producing noise. The other two hooks are low-friction and fine to keep.

---

## 3. Gut the banned-vocab list

Open `.claude/hooks/banned-vocab.sh`. Replace `BANNED_WORDS` with just structural tells:

```bash
BANNED_WORDS=(
  "testament to"
  "reminder that"
  "dive in"
  "let's explore"
  "in today's digital age"
  "let that sink in"
  "only time will tell"
)

BANNED_WORDS_CSV="testament to, reminder that, dive in, let's explore, in today's digital age, let that sink in, only time will tell"
```

Cut the 30+ lexical words (delve, tapestry, crucial, dynamic, etc.). They produce false positives and miss the real problems. The structural phrases above are what actually tell on AI.

Keep `ZERO_TOLERANCE_PHRASES` and `FILTER_WORDS` as-is; those are fine.

---

## 4. Rewrite `CLAUDE.md` down to ~100 lines

Replace the current file with something like:

```markdown
# CLAUDE.md

You are the Writer and Editor for this project.

## Before writing, read:
- `context/WRITER_VOICE.md` (active persona)
- `context/FACTS_SHEET.md` (canonical facts — check before introducing any specific detail)
- `PROJECT_IDENTITY.md` (tone, POV, tense)

## Track
This is [Fiction / Nonfiction]. Load these modules:

[List only the modules you actually use for this project. Probably 4-6 files, not 30.]

## Rules
- Follow the style guide in `_PROSE.md`
- Before introducing any named character, date, or established rule, grep `FACTS_SHEET.md`
- After finishing a scene or chapter, flag any new facts that should be added to `FACTS_SHEET.md`
- Do not invent citations or quotes in nonfiction
- Write prose with varied rhythm — no ten consecutive similar-length sentences

## Project Specifics
- Tone: [fill in]
- POV: [fill in]
- Tense: [fill in]
- Heat level (if romance): [fill in]
- Banned words for THIS project: [fill in any project-specific ones]

## Slash Commands Available
- `/draft` — write prose from a scene brief or direct instruction
- `/de-ai-audit` — scan for AI patterns
- `/holistic-audit` — full-manuscript structural review
- `/holistic-pass N` — execute a specific pass from HOLISTIC_PASSES.md
```

Cut: the 10-point operational protocol, the Adversarial Iteration Loop requirement, the "consult Gemini before every action" rule, the long CLI reference. None of that was earning its keep.

---

## 5. Rewrite `GEMINI.md` similarly

Gemini's job is one thing: large-context QA passes. Strip the file to something like:

```markdown
# GEMINI.md

You are the Architect and QA for this project.

## Your jobs (in priority order)
1. **Continuity audits** — read the full manuscript, cross-reference against `context/FACTS_SHEET.md`, flag contradictions
2. **Full-manuscript holistic passes** — patterns that span chapters (voice drift, pacing, trope stacking)
3. **Research and fact-checking** — especially for nonfiction citations

## Before auditing, read:
- `context/FACTS_SHEET.md`
- `PROJECT_IDENTITY.md`
- `reviewer_complaints.md` (specific failure modes to check for)

## Rules
- Never modify anything in `modules/`
- Report findings with quoted text and line numbers — no summaries without evidence
- If you cannot find evidence, say so — do not invent it

## Skills Available
- `continuity-audit` — systematic check against FACTS_SHEET
- `holistic-audit` — cross-chapter structural patterns
- `de-ai-audit` — scan for structural AI tells
- `voice-lint` — check dialogue against character bible
- `kdp-format` — format for Amazon KDP print
```

Cut: the persona library reference, the Verification Certificate ceremony, the multi-phase operational protocol, the session history requirement.

---

## 6. Consolidate modules

**Merge these:**
- `_STYLE_AUTHORITY.md` + `_HUMAN_PATTERNS.md` + `_PROSE_TEXTURE.md` → new file `_PROSE.md`
- `_ATMOSPHERE_ENGINE.md` + `_SENSORY_POV.md` → merge into `_WORLDBUILDING.md`

**Delete outright:**
- `_LESSONS_LEARNED_GENERAL.md` (generic CLI/prompt advice — outdated)
- `_LESSONS_LEARNED_FICTION.md` (generic craft advice — covered by your other files)
- All files under `.gemini/skills/de-ai-audit/references/` — these are stale snapshots of modules that live elsewhere. Delete and rely on the actual module files.

**Keep:**
- `_PROSE.md` (merged)
- `_WORLDBUILDING.md` (merged)
- `_STORY_ENGINE.md`
- `_CHARACTER_CRAFT.md`
- `_DIALOGUE_CRAFT.md`
- `_PACING_AND_STRUCTURE.md`
- `_NARRATIVE_VOICE.md`
- `_GENRE_PLAYBOOK.md`
- `_NONFICTION_CORE.md` (if you use it)
- `_BIOGRAPHY.md` (if you use it)

Should land you at ~10 modules instead of 30.

---

## 7. Create `reviewer_complaints.md` in each project

New file at project root:

```markdown
# Reviewer Complaints — [Project Name]

Living log of specific things readers have flagged. Check against manuscripts before publication.

## Categories
- **Continuity** — contradictions, name-before-introduction, knowledge-a-character-shouldn't-have
- **Formatting** — brackets in dialogue, markdown artifacts, weird punctuation
- **Prose** — repetitive description, list-like scenes, filter words
- **Structure** — story jumps, pacing problems, trope stacking
- **Voice** — tonal shifts, character voice bleed

## Complaints Log

### [Date] — [Reviewer source: Amazon / ARC / mailing list]
- **Category:** [Continuity / Formatting / etc.]
- **Complaint:** "[quoted text]"
- **Specifics:** [page numbers, scene references]
- **Status:** [Fixed in rev X / Not yet addressed / Acknowledged pattern]
```

Start by logging the four reviews already on record (the scathing one with Vane/Sylara/dress/love-you contradictions, the "formulaic, story jumps" one, the "brackets in dialogue" one, the "description was lacking and repetitive, written almost in a list" one).

This file becomes your pre-publication checklist over time. Every new book, before publishing: check against this list.

---

## 8. Rewrite `update_bible.sh` to do targeted continuity checks

Replace the current generic extraction with six specific checks. New version:

```bash
#!/bin/bash
set -e

echo "============================================"
echo "  Targeted Continuity Audit"
echo "============================================"

if ! command -v gemini &> /dev/null; then
    echo "ERROR: 'gemini' CLI not found."
    exit 1
fi

CHAPTERS=(manuscript/chapters/*.md)
if [ ! -e "${CHAPTERS[0]}" ]; then
    echo "ERROR: No chapters found."
    exit 1
fi

gemini "Perform six targeted continuity checks on the manuscript files in manuscript/chapters/. Reference context/FACTS_SHEET.md as canonical truth.

CHECK 1 — NAME INTRODUCTIONS: For every named character, identify the first scene they appear in. Flag any case where a POV character addresses or refers to someone by name before that name has been stated in their presence.

CHECK 2 — KNOWLEDGE GRAPH: Track who knows what. Flag any dialogue or internal thought where a character references information they shouldn't have at that point in the story.

CHECK 3 — NAME SIMILARITY: Identify any pair of named characters whose names differ by fewer than three letters (e.g., Moren/Meren). Flag as potential reader confusion.

CHECK 4 — CONTIGUOUS CONTRADICTIONS: For each 20-page span, flag statements that directly contradict other statements within the same span (e.g., 'she can't sleep' followed shortly by 'sleep comes eventually').

CHECK 5 — BACKSTORY CONSISTENCY: Track every character's stated backstory. Flag any dialogue or internal thought that contradicts their established history.

CHECK 6 — LOCATION CONTINUITY: Track physical locations scene by scene. Flag any scene where a character is in a location that contradicts where the previous scene ended.

Output findings in a table: Check | Chapter | Quote | What it contradicts | Severity." $(ls manuscript/chapters/*.md) > context/CONTINUITY_REPORT.md

echo "Report written to context/CONTINUITY_REPORT.md"
echo "Review manually and update FACTS_SHEET.md / manuscript as needed."
```

Run this once per book before publishing, not per chapter.

---

## 9. Stop using adversarial reviews

Don't delete the skill files if you're nervous (actually — I already said delete them in step 1, so this is just reinforcement). But the behavioral change is the key: **stop invoking persona panels to grade chapters**. They're generating plausible-sounding fake feedback, not real signal. Your actual signal comes from:

- Real reviews (log them in `reviewer_complaints.md`)
- Your own full read-through
- NotebookLM with a beta-reader prompt on the full manuscript

That's enough. You don't need simulated BookTok readers giving star ratings.

---

## 10. Update `.sync/manifest.json`

Remove references to the deleted skills so `update_book.sh` doesn't try to re-sync them. In the `template_copy` array, delete:
- `.claude/skills/scene-brief/SKILL.md`
- `.claude/skills/revision-guide/SKILL.md`
- `.claude/skills/chapter-done/SKILL.md`
- `.gemini/skills/adversarial-review/SKILL.md`
- `.gemini/skills/adversarial-review/references/_ADVERSARIAL_REVIEW_ENGINE.md`

And in `init_book.sh`, remove the same paths from `TEMPLATE_COPIES`.

---

## What your pipeline looks like after

**Per chapter:**
1. Write it (using voice guide and facts sheet)
2. Optionally `/de-ai-audit` for structural tells only
3. Update `FACTS_SHEET.md` with any new facts

**Per book, before publishing:**
1. Run `update_bible.sh` for the six targeted continuity checks
2. `/holistic-audit` for cross-chapter patterns
3. Full-manuscript pass through NotebookLM with a beta-reader prompt
4. Check against `reviewer_complaints.md`
5. One full cover-to-cover read by you

That's it. No persona panels, no verification certificates, no chapter completion rituals, no scene briefs, no workflow gates.

---

## What you're NOT changing

- `context/FACTS_SHEET.md` — keep maintaining this carefully, it's the most valuable file
- `context/WRITER_VOICE.md` — keep per-project
- `PROJECT_IDENTITY.md` — keep per-project
- The symlinked `modules/` setup — fine for now; consider per-genre separation later
- Your existing manuscripts — obviously
- The `notebooklm-prep.sh` script — genuinely useful, leave it alone

---

## Sanity check after trimming

Run this to see what you've got left:

```bash
find . -name "*.md" -not -path "*/node_modules/*" -not -path "./archive/*" | wc -l
find modules/ -name "*.md" | wc -l
ls .claude/skills/
ls .gemini/skills/
```

You should have roughly half the files you started with. If not, there's more to cut.

---

## What this doesn't solve

This trim addresses the framework bloat. It does **not** solve:

1. **Covers** — the actual binding commercial constraint. Work on this separately.
2. **Prose quality ceiling** — if you want to break past "passable," you need either your own developed taste (years) or paid editorial help ($2-4k per book).
3. **Discoverability** — ads, categories, keywords, positioning. Separate problem.

Don't let the framework work distract from the cover work. The framework was never the binding constraint.
