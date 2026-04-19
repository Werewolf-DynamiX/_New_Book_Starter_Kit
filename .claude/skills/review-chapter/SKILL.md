---
name: review-chapter
description: Complete WIP review workflow. Runs /prose-scan + /de-ai-audit on a chapter, synthesizes findings into a structured feedback log at feedback/<chapter>_<date>.md with disposition fields (pending/fixed/dismissed/escalate) so the writer can act on each item and the loop stays closed. Run on any work-in-progress chapter.
user-invocable: true
---

# /review-chapter

You are producing a **WIP review** for a single chapter. The goal is a structured, editable feedback log the writer can work through — and later, a feedback corpus that teaches the framework where it's noisy vs. where it's catching real craft issues.

**Recommended model:** Opus (interpretive synthesis).

## Input
- `$ARGUMENTS`: chapter file path. If empty, ask which chapter.

## Procedure

### Step 1: Run the mechanical scan
```bash
bash .claude/scripts/prose-scan.sh <chapter>
```
Capture the full output. Every finding becomes a line in the review log.

### Step 2: Run the interpretive scan
Invoke `/de-ai-audit` on the same chapter in your working context (or execute its logic inline, reading the chapter yourself). Capture AI Sandwich, Ending Trap, telling-after-showing, overexplained subtext, and uniform-register stretches.

### Step 3: Read the voice files
Load `context/WRITER_VOICE_CORE.md` and `context/WRITER_VOICE.md`. For each interpretive finding, check whether the voice anchors intentionally permit this pattern. If so, note it.

### Step 4: Write the review log

Create `feedback/<chapter-slug>_<YYYY-MM-DD>.md` (e.g., `feedback/ch01_2026-04-19.md`).

If the feedback directory doesn't exist, create it.

Format:

```markdown
---
chapter: <filename>
date: <YYYY-MM-DD>
word_count: <N>
reviewer: claude-opus-4-7
status: pending
---

# Review: <chapter title or filename>

## Summary
- CRITICAL: <N>
- HIGH: <N>
- MEDIUM: <N>
- LOW: <N>
- Interpretive tells: <N>

## Findings

### F1 — [prose-scan: literal-ai-remnant] CRITICAL
- **Line(s):** <N>
- **Evidence:** <quoted text>
- **Disposition:** pending
- **Notes:**

### F2 — [prose-scan: sentence-opener-variance] MEDIUM
- **Line(s):** <N>–<M>
- **Evidence:** 6 consecutive sentences starting with [pronoun]
- **Disposition:** pending
- **Notes:**

### F3 — [de-ai-audit: ending-trap] HIGH
- **Line(s):** <N>
- **Evidence:** "And that, she realized, was what it meant to be free."
- **Disposition:** pending
- **Notes:**

[... one block per finding ...]

## Writer's Pass (fill in after acting on findings)

**What worked in this chapter:**
- [bullet list]

**What needed work:**
- [bullet list]

**Patterns noticed across findings:**
- [bullet list]

**Rules to consider adding to WRITER_VOICE.md:**
- [bullet list — the raw material for the feedback-digest loop]
```

### Step 5: Tell the user what to do next

Output:

> **"Review written to `feedback/<file>`. Open it and for each finding, change `Disposition: pending` to one of:**
> - `fixed` — you rewrote the passage
> - `fixed-later` — you'll address in a later revision pass
> - `dismissed: <reason>` — intentional for this voice; won't change
> - `escalate` — this pattern should become a permanent scan in `reviewer_complaints.md`
>
> **When you've processed 3+ reviews, run `/feedback-digest` — it scans dispositions across all reviews and suggests tuning, new rules, or promotion to the reviewer-complaints gate."**

## Rules

- Every finding gets a unique ID (F1, F2, ...). This lets feedback-digest reference specific items across reviews.
- `Disposition` field starts as `pending`. The writer edits it. Never pre-fill.
- `Notes` field starts empty. The writer can write why they dismissed, what the fix was, etc.
- The "Writer's Pass" section at the bottom is the human summary — freeform, post-processing.
- Keep quoted evidence short (one line, max two). Long quotes clutter the log.
- If prose-scan or de-ai-audit finds nothing of a given severity, still list that severity with "(no findings)" so the log structure is consistent.
- Do not modify the chapter itself during review. Diagnosis only.
