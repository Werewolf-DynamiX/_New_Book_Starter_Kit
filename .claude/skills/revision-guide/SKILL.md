---
name: revision-guide
description: Generate a Revision Guide by requesting 3 Gemini audits (Continuity, Logic, Voice/AI-Pattern), triaging findings by severity, and presenting for user approval.
user-invocable: true
---

# /revision-guide

You are generating a Revision Guide following the revision workflow in `modules/_REVISION_WORKFLOW.md`.

## Input
- `$ARGUMENTS`: File path(s) to revise, or chapter number. If empty, ask the user which chapter to revise.

## Procedure

### Step 1: Read the Manuscript
Read the target file(s) completely. Note the line count and current state.

### Step 2: Read Supporting Context
- `context/FACTS_SHEET.md` (canonical facts)
- `context/WRITER_VOICE.md` (persona and voice targets)
- `PROJECT_IDENTITY.md` (tone, POV, tense)

### Step 3: Request 3 Gemini Audits
Use `mcp__gemini-cli__ask-gemini` (or bash: `gemini "prompt"`) for each audit. These can be sent as a combined prompt or sequentially.

**Review stance:** Per `modules/_CRITIC_PROTOCOL.md`, request "hatchet-mode" feedback — no praise, no softening, default-to-fail. Gemini should identify the "Fatal Flaw" and be aggressively skeptical.

**Audit 1 — Continuity:**
```
Perform a continuity audit on [file]. Cross-reference against FACTS_SHEET.md.
Check: character descriptions, object tracking, location consistency, timeline math.
For each issue, provide: the problematic quote, what it contradicts, and severity (CRITICAL/HIGH/MEDIUM/LOW).
```

**Audit 2 — Logic & Structure:**
```
Perform a logic and structure audit on [file].
Check: plot logic, motivation consistency, pacing, scene structure (goal/obstacle/outcome), cause-and-effect chains.
For each issue, provide: the problematic section, why it's a problem, and severity.
```

**Audit 3 — Voice & AI-Pattern:**
```
Perform a voice and AI-pattern audit on [file].
Check: tonal consistency, POV discipline, AI vocabulary clusters, structural tells (AI sandwich, uniform paragraphs, parallel starts), burstiness, filter words, ending traps.
Compare against WRITER_VOICE.md for persona consistency.
For each issue, provide: the problematic quote with line reference, the pattern detected, and severity.
```

### Step 4: Run Internal De-AI Scan
While waiting for Gemini, run your own scan for:
- Banned vocabulary clusters
- Filter words
- Structural tells
- Burstiness failures

### Step 5: Triage and Build Revision Guide
Combine all findings. Triage each by severity:
- **CRITICAL:** Factual errors, plot holes, broken logic, legal risk — blocks publication
- **HIGH:** Structural problems, character inconsistencies, pacing failures
- **MEDIUM:** Awkward phrasing, minor inconsistencies, weak scenes
- **LOW:** Stylistic suggestions, taste-level feedback
- **REJECTED:** Feedback considered and deliberately not acted on (with reasoning)

Build the Revision Guide using this format:

```markdown
# [PROJECT NAME] — Revision Guide

**Manuscript:** [filename] ([line count] lines)
**Revision Phase:** [First Pass / Second Pass / Final Polish]
**Audited By:** Gemini (Continuity, Logic, Voice/AI) + Claude (De-AI scan)

---

## Status
[Overall health assessment — 1 paragraph]

---

## Findings by Severity

### CRITICAL
[numbered list with quotes and line references]

### HIGH
[numbered list]

### MEDIUM
[numbered list]

### LOW
[numbered list]

---

## Items Reviewed and Rejected
[Feedback that was considered and deliberately not acted on, with reasoning]

---

## What's Working (Protect)
[Specific elements that must NOT be changed — quote distinctive lines, name scenes]

---

## Work Order
[Sequenced fix list — structural changes first, then chapter-order line fixes]
1. [ ] [Task] — [effort]. **Executor:** [Claude/Gemini]
2. [ ] [Task] — [effort]. **Executor:** [Claude/Gemini]

---

## Verification Log
| Item | Executor | Status | Auditor | Audit Status | Evidence |
|------|----------|--------|---------|--------------|----------|

---

## Story Bible Updates Required
| Fact | Old Value | New Value | Updated? |
|------|-----------|-----------|----------|
```

### Step 6: USER CHECKPOINT
Present the complete Revision Guide to the user. State clearly:

**"Revision Guide ready for review. Please approve the Work Order before I begin executing fixes, or request changes."**

Do NOT begin executing fixes until the user explicitly approves.
