---
name: holistic-audit
description: Identify manuscript-level structural issues and generate prioritized holistic revision passes. Run after external reviews, beta feedback, or at act/manuscript completion milestones.
user-invocable: true
---

# /holistic-audit

You are identifying **manuscript-level** patterns that span multiple chapters and generating a structured revision plan in `docs/HOLISTIC_PASSES.md`.

This is fundamentally different from chapter-level QA. You are NOT looking for line-level issues, continuity errors, or AI tells. You are looking for **structural and craft patterns** that only become visible when reading across the full manuscript:

- Voice bleed between POV characters
- Over-reliance on a single narrative device or shortcut
- Consequence threads that drop too early or resolve too quickly
- Character page time imbalances
- Relationship development that only happens during crisis moments
- Prose tic accumulation (patterns too sparse to flag per-chapter but visible at scale)
- Pacing arcs across acts (not within chapters)
- Thematic throughlines that weaken or get lost

## Input
- `$ARGUMENTS`: Optional path to external review feedback, or "self" for self-audit mode. If empty, ask the user whether they have external feedback to incorporate or want a self-audit.

## Procedure

### Step 1: Gather Context
Read these files:
- `PROJECT_IDENTITY.md` (tone, POV, tense, genre)
- `context/FACTS_SHEET.md` (canonical state)
- `context/WRITER_VOICE.md` (persona targets)
- `docs/HOLISTIC_PASSES.md` (existing passes, if any — this is an update, not a replacement)
- `manuscript/00_master_outline.md` (structural overview)

If external review feedback was provided, read that too.

### Step 2: Full-Manuscript Analysis via Gemini
Delegate the heavy analysis to Gemini. It has the larger context window and the QA role.

Use `mcp__gemini-cli__ask-gemini` (or `gemini "prompt"`) with this prompt:

```
You are performing a HOLISTIC MANUSCRIPT AUDIT. This is NOT a chapter-level review. You are looking for patterns that span the full manuscript.

Read all chapter files in manuscript/chapters/ in order.
Cross-reference with FACTS_SHEET.md and PROJECT_IDENTITY.md.

For each category below, identify problems that span 3+ chapters:

1. **Voice Consistency Across POVs:** Do different POV characters narrate with distinguishable sentence architecture, metaphor sets, and cognitive patterns? Or do they blur together?

2. **Narrative Device Dependencies:** Is any single device (a magic system, a bond, a recurring motif, a structural gimmick) doing too much narrative work? Does it replace character communication, shortcut emotional development, or solve too many problems?

3. **Consequence Propagation:** When something traumatic or transformative happens, do the consequences persist and degrade naturally across subsequent chapters? Or does the character recover too quickly?

4. **Character Page Time:** Are important characters getting enough room? Is any relationship's development happening entirely offscreen or compressed into crisis moments?

5. **Pacing Across Acts:** Are there sections where the manuscript drags or rushes when read as a continuous narrative (not chapter-by-chapter)?

6. **Prose Pattern Accumulation:** Are there tics, phrases, or structural habits that are fine in isolation but accumulate to a noticeable frequency across the full manuscript?

7. **Romance/Relationship Texture:** (If applicable) Does the central relationship have enough ordinary, non-crisis moments? Or does every significant beat happen under duress?

8. **Thematic Coherence:** Does the thematic argument build consistently, or does it get muddled or abandoned in the middle?

For each problem found, provide:
- **Pattern:** What you observed
- **Evidence:** Specific chapters/passages where it manifests
- **Scope:** How many chapters are affected
- **Impact:** How much it hurts the manuscript (Critical/High/Medium)
- **Suggested approach:** How to fix it

Do NOT flag chapter-level issues (single continuity errors, individual AI tells, one weak scene). Those belong in chapter-level audits (`/de-ai-audit`, `/prose-scan`), not here.
```

### Step 3: Incorporate External Feedback
If the user provided external review notes:
- Map each reviewer complaint to the categories above
- Identify which complaints are chapter-level (handle per-chapter) vs. manuscript-level (include here)
- Note when multiple reviewers independently flag the same pattern — that's high-signal

### Step 4: Synthesize into Passes
For each identified pattern, draft a pass using this format:

```markdown
## Pass N: [Descriptive Title]

**Problem:** [What's wrong — the cross-manuscript pattern]

**Goal:** [What "fixed" looks like — one clear target state]

**Method:**
1. [Step-by-step execution approach]
2. [Include grep patterns, reading order, decision criteria]
3. [Specific enough to execute without additional context]

**Targeted chapters:** [Chapter numbers or ranges]

**Scope:** ~[N] chapters, [estimated edits per chapter]. Estimated [N] total changes.

**Already done:** [Nothing yet, or reference prior work]

**Risk:** [What could go wrong]
```

### Step 5: Prioritize
Rank passes by:
1. How many reviewers flagged it (if external feedback exists)
2. How much it affects the reader's experience
3. How many chapters it touches
4. Whether it blocks other passes (dependencies)

### Step 6: Write or Update docs/HOLISTIC_PASSES.md
- If the file has existing passes, merge — don't replace. Update the "Already done" sections of existing passes if progress has been made.
- Update the manuscript state summary at the top.
- Update the Priority Order section.
- Log this audit in the Pass Generation Log table.

### Step 7: USER CHECKPOINT
Present the complete passes document. State clearly:

**"Holistic passes generated. Review the passes and priority order. When ready, run `/holistic-pass N` to execute a specific pass, or request changes to the plan."**

Do NOT begin executing any pass until the user explicitly approves and selects one.
