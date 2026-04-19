---
name: feedback-digest
description: Scan all processed review logs in feedback/ and extract patterns across dispositions. Recommends detector tuning when a check is consistently dismissed, new WRITER_VOICE rules when a pattern is repeatedly fixed, and promotions to reviewer_complaints.md for items marked escalate. The closed-loop learning piece of the framework.
user-invocable: true
---

# /feedback-digest

You are running the **learning loop**. Individual chapter reviews are data points; this skill is what turns that data into framework improvements.

**Recommended model:** Sonnet (fast pattern extraction from structured text; no deep interpretation required).

## Input
- `$ARGUMENTS`: optional — glob pattern for feedback files. Default: `feedback/*.md`.

## Preflight

Count the feedback files. If there are fewer than 3, tell the user:

> **"Only <N> review(s) processed so far. Digest works best with 3+ reviews. Run `/review-chapter` on more chapters first, then retry."**

Still proceed if the user explicitly asks — small samples give noisy patterns but occasional tuning insights.

## Procedure

### Step 1: Parse every review log

For each `feedback/*.md`:
1. Parse the YAML frontmatter (chapter, date, word count).
2. Extract each Finding (F1, F2, ...) with: check name, severity, disposition, notes.
3. Skip findings where disposition is still `pending` — the writer hasn't judged yet.

Build a table of {check_name → [list of dispositions across all reviews]}.

### Step 2: Pattern extraction

For each check, compute:
- **Total processed:** count of non-pending dispositions.
- **Dismissed rate:** fraction marked `dismissed:*`.
- **Fixed rate:** fraction marked `fixed` or `fixed-later`.
- **Escalate count:** number of `escalate` entries.

Apply these rules:

**A. Noisy detector** — dismissed rate ≥ 60% over 5+ instances.
→ *"Detector `<name>` fires often but writer dismisses most. Consider loosening threshold or adding more stopwords."*

**B. Craft weakness** — fixed rate ≥ 70% over 5+ instances, AND the dismissed reasons don't indicate a detector problem.
→ *"Detector `<name>` is catching a real recurring pattern the writer fixes. Consider adding a preventive rule to `context/WRITER_VOICE.md` Section 3 (project-specific rules). Recommended rule draft: ..."*

**C. Escalate** — any finding marked `escalate`.
→ *"Finding F<N> from `<chapter>` marked for escalation. Draft an entry for `reviewer_complaints.md` with a scan method."* Produce the draft entry.

**D. Fixed-later backlog** — fixed-later count ≥ 3 for same check.
→ *"The writer has deferred fixing `<check>` 3+ times. Recommend scheduling a dedicated `/holistic-pass` on that pattern."*

### Step 3: Read voice files for context

Before recommending a rule addition, read `context/WRITER_VOICE_CORE.md` and `context/WRITER_VOICE.md`. Check whether the pattern is already covered by an existing rule (don't duplicate).

### Step 4: Output Format

```markdown
# Feedback Digest

**Generated:** <YYYY-MM-DD>
**Reviews analyzed:** <N>
**Findings processed:** <N> (pending: <N>)

## Scanner Health

| Check | Fires | Fixed | Dismissed | Verdict |
|-------|-------|-------|-----------|---------|
| prose-scan:sentence-opener-variance | 14 | 12 (86%) | 1 (7%) | **Catching real issue**. Consider preventive rule. |
| prose-scan:echo-tight | 20 | 6 (30%) | 13 (65%) | **Noisy**. Consider threshold tuning. |
| de-ai-audit:ending-trap | 3 | 3 (100%) | 0 | **Clean signal**. Keep. |
| [...] | | | | |

## Recommended Framework Changes

### Tuning (detector noise)
- [For each noisy detector, specific tuning recommendation.]

### New WRITER_VOICE.md rules (craft weaknesses)
- [For each craft-weakness pattern, a proposed rule the writer can paste.]

### reviewer_complaints.md promotions (escalated items)
- [For each escalate, a full draft entry.]

### Backlog items
- [Fixed-later items worth a dedicated pass.]

## Raw Data (for your records)
<table of all check × disposition counts>
```

### Step 5: Offer next actions

At the end:

> **"Apply recommendations? Options:**
> - `apply tuning` — I'll update detector thresholds in `prose_scan.py`
> - `apply rules` — I'll append proposed rules to `context/WRITER_VOICE.md` Section 3
> - `apply complaints` — I'll append promoted entries to `reviewer_complaints.md`
> - `apply all` — all three
> - `skip` — just produced the report; I'll act later"**

Wait for user instruction before modifying any files.

## Rules

- **Never silently modify files.** Even with `apply all`, show the diffs first and get confirmation.
- **Never drop data.** Every review's dispositions feed into the analysis; don't exclude reviews even if they're old.
- **Be honest about sample size.** A detector with 60% dismiss rate over 3 instances is inconclusive. Flag it as "watch," not "noisy."
- **Don't invent patterns.** If the data doesn't support a recommendation, say so. "No clear patterns yet — keep reviewing and retry."
- **Preserve the feedback corpus.** Don't delete processed review files. They're the training data for every future digest.
