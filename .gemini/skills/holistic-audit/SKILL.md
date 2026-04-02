---
name: holistic-audit
description: Full-manuscript structural analysis to identify cross-chapter patterns and generate holistic revision passes. Use at act boundaries, after external reviews, or at manuscript completion.
---

# Holistic Manuscript Audit

## Overview
You are performing a **manuscript-level structural audit** — not a chapter-level review. Your job is to identify patterns that only become visible when reading across the full manuscript and structure them into actionable revision passes.

This is your highest-value QA function. Chapter-level tools (continuity-audit, voice-lint, de-ai-audit) catch local issues. This catches the problems that make readers say "something felt off about this book" without pointing to a specific paragraph.

## What You're Looking For

Patterns that span **3+ chapters**:

1. **Voice Consistency Across POVs:** Do different POV characters have distinguishable sentence architecture, metaphor sets, and cognitive patterns? Or do they blur together? Cover the POV tag — can you tell who's narrating from the prose alone?

2. **Narrative Device Dependencies:** Is any single device (magic system, bond, motif, structural gimmick) doing too much work? Does it replace communication, shortcut emotional development, or solve too many unrelated problems?

3. **Consequence Propagation:** When something traumatic or transformative happens, do consequences persist and degrade naturally? Or does the character recover suspiciously fast?

4. **Character Page Time:** Are important characters getting enough room for their arcs? Is any key relationship developing entirely offscreen or only during crisis moments?

5. **Pacing Across Acts:** Read as continuous narrative. Where does it drag? Where does it rush? Chapter-level pacing can be fine while act-level pacing fails.

6. **Prose Pattern Accumulation:** Tics, phrases, or structural habits that are fine in isolation but reach noticeable frequency across the manuscript. (e.g., "the way a [noun] [verbs]" appearing 30 times, or every chapter ending with a one-line paragraph)

7. **Romance/Relationship Texture:** (If applicable) Does the central relationship have ordinary, non-crisis moments? Or does every beat happen under duress?

8. **Thematic Coherence:** Does the thematic argument build consistently? Does it get muddled, abandoned, or resolved too early?

## What You're NOT Looking For

Do NOT flag:
- Single continuity errors (those belong in `continuity-audit`)
- Individual AI vocabulary hits (those belong in `de-ai-audit`)
- One weak scene or awkward transition (those belong in `/revision-guide`)
- Line-level prose issues (those belong in line editing)

## Execution Protocol

### Phase 1: Load Context
Read in order:
1. `PROJECT_IDENTITY.md`
2. `context/FACTS_SHEET.md`
3. `context/WRITER_VOICE.md`
4. `manuscript/00_master_outline.md`
5. `docs/HOLISTIC_PASSES.md` (if it exists — you're updating, not replacing)

### Phase 2: Full Manuscript Read
Read all chapter files in `manuscript/chapters/` in order. This is a structural read — you're tracking patterns across chapters, not evaluating individual scenes.

As you read, maintain running notes on:
- POV voice markers per character
- Narrative device usage frequency and purpose
- Emotional state trajectories per character
- Scene type distribution (crisis vs. quiet, action vs. dialogue vs. reflection)
- Recurring phrases or structures

### Phase 3: Pattern Identification
For each of the 8 categories above, assess whether a problem exists. For each problem found, document:

- **Pattern:** What you observed (be specific)
- **Evidence:** Specific chapters and passages where it manifests (quote briefly)
- **Scope:** How many chapters are affected
- **Impact:** Critical / High / Medium
- **Suggested approach:** How to fix it, including which chapters to target and what the method should be

### Phase 4: Structure as Passes
Convert each finding into a pass using this format:

```markdown
## Pass N: [Descriptive Title]

**Problem:** [The cross-manuscript pattern — specific, evidence-based]

**Goal:** [What "fixed" looks like — one clear sentence]

**Method:**
1. [Step-by-step execution approach]
2. [Include grep patterns, reading order, decision criteria]
3. [Specific enough to execute without additional context]

**Targeted chapters:** [Chapter numbers or ranges]

**Scope:** ~[N] chapters, [estimated edits per chapter]. Estimated [N] total changes.

**Already done:** [Nothing yet, or reference prior work]

**Risk:** [What could go wrong — e.g., adding length, breaking pacing, tone drift]
```

### Phase 5: Prioritize and Output
Rank passes by impact and output the complete `docs/HOLISTIC_PASSES.md` file with:
- Updated manuscript state summary
- All passes in the standard format
- Priority Order section with one-line justifications
- Updated Pass Generation Log

If merging with existing passes, preserve "Already done" progress and add new passes at appropriate priority positions.
