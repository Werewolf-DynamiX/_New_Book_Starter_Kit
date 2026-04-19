---
name: pre-publish
description: Run every scan registered in reviewer_complaints.md against the current manuscript. The ship-blocker gate — a book does not ship until this passes. Combines /prose-scan, /de-ai-audit, Gemini continuity/voice checks, and any custom scans the writer has registered based on past reader feedback.
user-invocable: true
---

# /pre-publish

You are running the Pre-Publish Gate. Every complaint a reader has ever logged in `reviewer_complaints.md` becomes a scan here. The book does not ship until this passes.

## Input
- `$ARGUMENTS`: Optional — scope. Default is the whole manuscript (`manuscript/chapters/*.md` sorted).

## Procedure

### Step 1: Load the complaint registry
Read `reviewer_complaints.md`. For every entry that has a **Scan method** field, extract:
- Category
- Short complaint summary
- The exact scan to run

If there are fewer than 3 real complaints logged, note it to the user but proceed — this skill also runs the baseline scans.

### Step 2: Enumerate chapter files
```bash
ls manuscript/chapters/*.md
```
If the list is empty, stop and ask the user where chapters live.

### Step 3: Run baseline scans on every chapter

For each chapter:

1. **`/prose-scan`** — dialogue placeholder (CRITICAL), sentence-opener variance, burstiness, echo, sensory ratio, transition velocity, dialogue beats.
   - Invoke: `bash .claude/scripts/prose-scan.sh manuscript/chapters/<file>`
   - Record: CRITICAL / HIGH / MEDIUM counts per chapter.

2. **`/de-ai-audit`** — structural AI tells and vocabulary clusters (Claude-side, per chapter).
   - Record grade and any hits.

### Step 4: Run manuscript-level scans (Gemini)

1. **`continuity-audit`** — state attributes, name introductions, knowledge graph.
2. **`voice-lint`** — character voice differentiation against `docs/characters.md`.
3. **`logic-check`** — plot logic and timeline.

Invoke these via `gemini` CLI with full manuscript bundled.

### Step 5: Run registered complaint scans

For each complaint with a Scan method from Step 1:
- Execute the scan (regex, grep, Gemini prompt, or skill invocation as registered).
- Record: hit count, chapter locations, severity assessment.
- If the complaint says "Fixed in rev X", still run it — confirming the fix stuck is the whole point.

### Step 6: Synthesize the Gate Report

Output this format:

```markdown
# Pre-Publish Gate Report

**Manuscript:** [slug from book.yaml]
**Scan date:** [today]
**Chapters scanned:** [N]
**Total words:** [N]

## Gate Status
[PASSED / FAILED]

- Baseline scans: [PASSED / FAILED — details]
- Continuity: [PASSED / FAILED]
- Voice: [PASSED / FAILED]
- Logic: [PASSED / FAILED]
- Registered complaints: [X/Y passed]

## Blockers (must fix before shipping)

### CRITICAL from /prose-scan
[chapter, line, finding]

### Continuity failures
[from continuity-audit]

### Logged-complaint regressions
[Any complaint from reviewer_complaints.md whose scan fired. These are things readers already caught once; shipping them again is worse than shipping a new bug.]

## High-priority (fix before publishing, not hard blockers)

[HIGH findings from /prose-scan, voice-lint drift, de-ai-audit C grades]

## Medium / Low (fix-if-you-have-time)

[Lower-severity findings, summarized]

## Numbers that changed since last publish

If previous run data is available in `build/pre_publish_log.json`, compare:
- CRITICAL count: [prev] → [now]
- Registered-complaint hits: [prev] → [now]
- Overall pass rate: [prev] → [now]
```

### Step 7: Decision Gate

If any **Blocker** (CRITICAL, continuity failure, or logged-complaint regression) is present:
> **"Pre-publish gate FAILED. [N] blockers listed above. Fix them or explicitly override before shipping."**

Otherwise:
> **"Pre-publish gate PASSED. [N] non-blocker items flagged. Manuscript is safe to ship after a final human read."**

### Step 8: Record the run

Append a one-line summary to `build/pre_publish_log.json` (create if missing):

```json
{"date": "YYYY-MM-DD", "chapters": N, "words": N, "critical": N, "high": N, "complaints_hit": N, "status": "PASSED|FAILED"}
```

This gives the writer a trend over time: are scans catching fewer things as the framework tightens?

## Rules

- Never claim the gate passed if any CRITICAL is present. That's what the gate is for.
- If a scan method in `reviewer_complaints.md` can't be executed (malformed, missing tool), flag that entry for the user rather than silently skipping.
- Do not attempt to fix findings. This skill reports; fixing is a separate step.
- The gate is only as strict as the complaints logged. Encourage the user to add new entries after every external review.
