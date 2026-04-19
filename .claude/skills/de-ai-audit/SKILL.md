---
name: de-ai-audit
description: Interpretive scan for AI-pattern structures that require reading — AI Sandwich, Ending Trap, telling-after-showing, subtext overexplanation. Mechanical checks (vocabulary, burstiness, filter words, placeholders) live in /prose-scan — run that first.
allowed-tools: Read, Grep, Glob
user-invocable: true
---

# /de-ai-audit

You are running the **interpretive** pass of AI-pattern detection. The mechanical checks — vocabulary clusters, zero-tolerance phrases, burstiness collapse, filter-word density, dialogue placeholders — are all handled by `/prose-scan`. Your job here is the patterns that require reading and judgment.

## Preflight

If the user hasn't already run `/prose-scan` on this file, tell them to run it first and come back. The mechanical checks produce the numbers; this skill produces the interpretation.

**Recommended model:** Opus (interpretive judgment). Can run on Sonnet if speed matters more than depth.

## Input
- `$ARGUMENTS`: File path. If empty, ask which chapter.

## Procedure

### Step 1: Read the chapter
Load the full chapter. Also load `context/WRITER_VOICE_CORE.md` and `context/WRITER_VOICE.md` for voice context — some patterns are intentional for this voice.

### Step 2: Scan for the five interpretive AI tells

#### 1. AI Sandwich Structure
A passage (scene, paragraph, or section) that follows the pattern: **topic statement → three supporting examples/observations → restated summary.** Feels like an essay rather than a scene. Common in AI-drafted prose because it's the default LLM response shape.

Quote the passage. Mark whether it's a scene, paragraph, or whole section.

#### 2. The Ending Trap
Scene or chapter endings that do one of:
- Name the theme ("And that, she realized, was what friendship really meant.")
- Wrap up with moralizing summary ("A testament to the power of…")
- Punch an uplifting or redemptive note the rest of the scene hasn't earned
- Tell the reader how to feel about what just happened

Quote the last 2–3 sentences of each scene/chapter and evaluate.

#### 3. Telling-After-Showing
Emotion or action has been rendered through concrete detail, and then the narrator names the emotion anyway. Example: *"Her hands wouldn't stop shaking. She was afraid."* The second sentence is the tell.

Find instances where showing is complete and then undermined by a follow-up name.

#### 4. Overexplanation of Subtext
Subtext, jokes, or metaphors explained to the reader. Examples:
- Character says something pointed; narrator explains what they meant.
- Joke lands; narrator explains why it's funny.
- Metaphor used; narrator paraphrases the metaphor.

The rule: if the reader can get it without the explanation, the explanation is AI footprint.

#### 5. Uniform Emotional Register
Scene-level check: does the emotional temperature stay flat for long stretches? Human prose modulates — a moment of tension, a dry observation, a small laugh. AI prose tends to sustain one register. Flag stretches where the register doesn't shift.

### Step 3: Output Format

```markdown
# De-AI Audit (Interpretive)

**File:** [path]
**Date:** [today]
**Overall:** [verdict: clean / minor / patterned / pervasive]

## AI Sandwich
[quoted passages or "none found"]

## Ending Trap
[quoted scene/chapter endings, evaluation]

## Telling After Showing
[quoted instances]

## Overexplained Subtext
[quoted instances]

## Uniform Register Stretches
[passage ranges, summary of register]

## Recommendation
[1–3 sentence summary of what to fix vs. what to leave]
```

### Step 4: Grade

Use this rubric for the **Overall** verdict:

- **clean** — zero interpretive AI tells. Reading this chapter you would not suspect AI involvement.
- **minor** — 1–2 instances of any single tell. Easy to fix in a single revision pass.
- **patterned** — 3+ instances of one tell or 2+ instances of multiple. Chapter needs focused revision.
- **pervasive** — telling-after-showing or ending trap shows up more than once per scene, or AI Sandwich structures dominate. Chapter needs rewriting, not revising.

## Rules
- Always quote the offending text. Line numbers are a bonus, but the quote is the minimum.
- If a pattern fires but is clearly intentional for the voice (e.g., the narrator is deliberately essayistic), note it as "intentional — not a flag." Don't mechanically flag what the voice earns.
- Do not attempt fixes inside this skill. This is diagnosis, not treatment. Send the report to the user; fixing happens in `/draft` or `/holistic-pass`.
