---
name: prose-scan
description: Run seven mechanical prose diagnostics on a chapter — placeholder regex, sentence-opener variance, burstiness, echo detection, sensory vs. abstract ratio, transition velocity, dialogue beat ratio. Produces a line-numbered report with severity. Use after /draft to catch rhythm, monotony, and reader-complaint patterns before /de-ai-audit.
user-invocable: true
---

# /prose-scan

You are running mechanical prose diagnostics on a chapter. Unlike `/de-ai-audit` (which judges patterns subjectively), this skill produces **numbers and line references** — what the writer can actually fix. Each check exists to catch a specific reader complaint.

## Input
- `$ARGUMENTS`: Chapter file path. If empty, ask which chapter.

## Procedure

Run `bash .claude/scripts/prose-scan.sh <file>` and parse its output. The script emits sectioned, line-numbered findings. Format them into the report below.

If the script doesn't exist yet, you may run the diagnostics inline by reading the file and applying the logic in "Check Definitions" below.

## Check Definitions

Each check maps to a specific reader failure mode. Report only the top offenders per category (don't drown the writer in noise).

### 1. Dialogue Placeholder (CRITICAL)
**Catches:** "brackets in dialogue" — literal `[Name]`, `<TODO>`, or `(insert X)` left inside quotes.
**How:** Regex `"[^"]*[\[\(\<][^"]*[\]\)\>][^"]*"` anywhere in prose.
**Severity:** Any hit = CRITICAL. Ship-blocker.

### 2. Sentence Opener Variance (SOV)
**Catches:** "written almost in a list" — monotone SVO rhythm.
**How:** For each sentence, classify its opener: `Pronoun`, `Name`, `The+Noun`, `Preposition`, `Dependent-Clause`, `Fragment`. Flag runs of 4+ consecutive sentences sharing the same class.
**Severity:** 4–5 consecutive = LOW, 6–8 = MEDIUM, 9+ = HIGH.

### 3. Burstiness Collapse
**Catches:** AI Flatline — all sentences in the 12–18 word band.
**How:** Slide a 10-sentence window. If standard deviation of sentence length falls below 4.0 for 10+ consecutive sentences, flag.
**Severity:** MEDIUM per occurrence. A chapter with 3+ flatline zones = HIGH.

### 4. Echo Detector
**Catches:** "repetitive description" — same uncommon word reused in close proximity.
**How:** For every content word (nouns/verbs/adjectives, excluding the top-200 stopwords and character names), flag when it appears 3+ times within 200 words, or 2+ times within 40 words.
**Severity:** LOW per echo, MEDIUM if a paragraph has 3+ echoes.

### 5. Sensory vs. Abstract Ratio
**Catches:** "description was lacking" — telling emotion instead of rendering sensory reality.
**How:** Per paragraph, count concrete sensory tokens (from a curated lexicon: texture, taste, sound, smell, light, temperature words) vs. filter/abstract verbs (felt, saw, heard, noticed, realized, knew, thought, wondered, seemed). Flag paragraphs with ratio ≤ 0.3 (i.e., 3+ filter verbs per 1 sensory word) AND that are describing emotional content.
**Severity:** LOW per paragraph, MEDIUM if 5+ in a chapter.

### 6. Transition Velocity
**Catches:** "story jumps" — scenes skipped via lazy transition markers.
**How:** Count "low-effort transitions": *Suddenly, Then, Moments later, Meanwhile, Later, After a while, Soon, Eventually*. Flag when density exceeds 1 per 300 words.
**Severity:** LOW unless density > 1 per 150 words (MEDIUM) or chapter contains multiple scene boundaries with only a transition marker separating them (HIGH).

### 7. Dialogue Beat Ratio
**Catches:** "ping-pong dialogue" that lacks staging.
**How:** For every line of dialogue, check what precedes/follows. Categories: (a) just a tag (`"...", she said.`), (b) an action beat (`She wiped the counter. "..."`), (c) nothing. Flag when category (a)+(c) exceeds 75% of a dialogue scene of 10+ lines.
**Severity:** MEDIUM per scene.

## Output Format

```markdown
# Prose Scan: [chapter title]

**File:** [path]
**Word count:** [N]
**Scan date:** [today]

## Summary
- CRITICAL: [count] — ship-blockers
- HIGH: [count]
- MEDIUM: [count]
- LOW: [count]

## Findings

### CRITICAL
[Line N: Dialogue placeholder found: "..."]

### HIGH
[Line N–M: Sentence-opener run (9 pronouns) — paragraph reads as monotone.]

### MEDIUM
[Line N–M: Burstiness collapse (stddev 3.2 over 12 sentences).]
[Line N: Echo — "shimmer" appears 4× in 180 words.]

### LOW
[Line N: Filter-heavy paragraph (ratio 0.2).]

## Suggested Fix Order
1. [Critical hits first — must fix before shipping]
2. [Largest rhythm issues — they drag the whole chapter]
3. [Local echoes and filter paragraphs — line edits]
```

## Rules

- Report with line numbers. Never say "somewhere in the chapter" — the writer can't act on that.
- Quote the offending text. Let the writer see the problem.
- Don't grade overall (no A–F). That belongs in `/de-ai-audit`. This skill shows *what* to fix, not whether the chapter is good.
- Don't suggest rewrites unless asked. The writer is the voice; you're the instrument.
- If a finding would produce more than 10 instances in one category, collapse to "10+ instances; top 5 shown" and show the worst offenders.
- Be blunt about false positives. If a run of identical openers is clearly intentional (staccato action sequence, stylistic choice), note that the detector fired but the writer may override.
