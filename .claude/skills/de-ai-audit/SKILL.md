---
name: de-ai-audit
description: Scan manuscript prose for AI-generated patterns, vocabulary clusters, structural tells, and burstiness failures. Produces a scored report (A-F).
allowed-tools: Read, Grep, Glob
user-invocable: true
---

# /de-ai-audit

You are running a De-AI Audit — a systematic scan for AI-generated writing patterns.

## Input
- `$ARGUMENTS`: File path or directory to audit. Defaults to `manuscript/` if empty.
- If a directory, audit all `.md` files within it.

## Procedure

### 0. Persona Context
Read `context/WRITER_VOICE.md` if it exists. Note the target voice and tone — this informs whether vocabulary and structural patterns are intentional or AI artifacts.

### 1. Vocabulary Scan
Search for AI-associated vocabulary. Flag when 3+ cluster in a single file.

**Zero-tolerance phrases (instant flag):**
- "A testament to..." / "A reminder that..."
- "In conclusion," / "Ultimately," / "At the end of the day"
- "Let's dive in" / "Let's explore" / "In this chapter, we will..."
- "It's not just about X, it's about Y"
- "To understand X, you have to understand Y"
- "Let that sink in" / "It is important to note that"
- "In today's digital age" / "Whether it's X or Y..."
- "Only time will tell..." / "Think of X as a Y..."

**AI-associated words (flag clusters of 3+):**
delve, tapestry, testament, myriad, plethora, multifaceted, crucial, nuanced, realm, paradigm, notably, furthermore, moreover, additionally, seamlessly, leverage, harness, foster, cultivate, invaluable, indispensable, paramount, intricate, game-changer, cutting-edge, revolutionary, rich tapestry, vibrant landscape, dynamic, optimize, utilize, facilitate, deep dive

**Exception:** Words used literally are fine (e.g., "a faded tapestry on the wall"). Note the context.

### 2. Structural Tells
Scan for these AI writing patterns:
- **AI Sandwich:** Topic → 3 examples → Summary pattern
- **Uniform paragraphs:** All paragraphs ~3 sentences long
- **Parallel sentence starts:** 3+ consecutive sentences starting the same way
- **The Ending Trap:** Scene ending with moralizing summary, "testament to...", or uplifting wrap-up
- **Telling after showing:** Action/emotion shown, then named anyway
- **Overexplaining:** Subtext or jokes explained

### 3. Burstiness Check
For each file, sample 3 passages of 10 consecutive sentences each:
- Count word length of each sentence
- Flag "AI Flatline" if all 10 fall within 12-18 words
- Flag if 3+ consecutive sentences have similar length (within 3 words)
- Flag if 3+ consecutive paragraphs are uniform length
- Check for varied paragraph lengths (should include 1-sentence and 4-5 sentence paragraphs)

### 4. Filter Word Scan
Count occurrences of distancing filter words:
saw, heard, felt, noticed, realized, watched, observed, thought, wondered, seemed

Flag each with line number and context. Note exceptions where perception is the point.

### 5. Wan Intensifier Scan
Count: very, really, quite, rather, somewhat, just, actually, basically, literally (non-literal)

### 6. Literal AI Remnants
Search for:
- "As an AI" / "language model" / "I cannot" / "I'm unable to"
- Markdown artifacts in prose (##, **, ```)
- "Here's" / "Here are" introducing lists in narrative prose
- Any meta-commentary about the writing process

## Output Format

```markdown
# De-AI Audit Report

**File(s):** [files audited]
**Date:** [date]
**Overall Grade:** [A-F]

## Summary
[1-2 sentence overall assessment]

## Vocabulary ([X] issues)
| Word/Phrase | File | Line | Context | Literal Use? |
|-------------|------|------|---------|--------------|

## Structural Tells ([X] issues)
| Pattern | File | Line | Description |
|---------|------|------|-------------|

## Burstiness ([PASS/FAIL])
| File | Passage | Sentence Lengths | Verdict |
|------|---------|-------------------|---------|

## Filter Words ([X] found)
| Word | File | Line | Context | Keep? |
|------|------|------|---------|-------|

## Wan Intensifiers ([X] found)
| Word | File | Line | Context |
|------|------|------|---------|

## AI Remnants ([X] found)
| Issue | File | Line | Context |
|-------|------|------|---------|

## Grading Rubric
- **A:** 0 zero-tolerance phrases, <3 AI vocab, burstiness passes, <5 filter words
- **B:** 0 zero-tolerance, 3-5 AI vocab, burstiness mostly passes, 5-10 filters
- **C:** 1 zero-tolerance OR 6-10 AI vocab OR burstiness fails in 1 passage
- **D:** 2+ zero-tolerance OR 10+ AI vocab OR burstiness fails in 2+ passages
- **F:** Literal AI remnants found OR structural tells dominant
```
