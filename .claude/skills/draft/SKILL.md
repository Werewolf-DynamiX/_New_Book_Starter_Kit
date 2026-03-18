---
name: draft
description: Draft prose from an approved Scene Brief. Pre-flight checks persona and facts, applies anti-polish rules, runs Self-Editing Checklist and de-ai-audit inline.
user-invocable: true
---

# /draft

You are drafting prose from an approved Scene/Section Brief.

## Input
- `$ARGUMENTS`: Optional file path to write to. If empty, determine from the Scene Brief or ask.

## Pre-Flight Checks

Before writing a single word of prose, verify:

### 1. Scene Brief Exists
There must be an approved Scene Brief in the current conversation. If none exists:
**"No approved Scene Brief found. Run /scene-brief first, then /draft."**
Stop here.

### 2. Persona Check
Read `context/WRITER_VOICE.md`.
- If defined: "Writing as: [Persona Archetype]."
- If not defined: **"No persona defined. Run persona interview first."** Stop here.

### 3. Facts Sheet
Read `context/FACTS_SHEET.md`. Note all established facts relevant to this scene.

### 4. Scene Assertions
Output a Scene Assertions block — factual statements that must remain true throughout this draft:
```
SCENE ASSERTIONS:
- [Character] has [physical description] (FACTS_SHEET line X)
- [Location] is described as [details] (FACTS_SHEET line Y)
- [Timeline]: This scene takes place [when] (FACTS_SHEET line Z)
- [Open thread]: [thread from Scene Brief]
```

## Drafting Rules

### Voice & Anti-Polish
- Write in the persona voice from `WRITER_VOICE.md`
- Include purposeful imperfections: tangents, fragments, abrupt transitions
- Do not smooth every sentence. Real voices are messy.
- Vary sentence length aggressively (2-6 words, 8-15 words, 18-30 words)
- Vary paragraph length (some 1 sentence, some 4-5 sentences)
- Use the Sensory Palette from the Scene Brief — at least 3 non-visual details

### What NOT To Do
- No AI vocabulary clusters (delve, tapestry, testament, etc.)
- No filter words (saw, heard, felt, noticed, realized, watched, observed)
- No wan intensifiers (very, really, quite, rather, somewhat, just)
- No AI Sandwich structure (topic → 3 points → summary)
- No uniform paragraph lengths
- No moralizing endings or uplifting wrap-ups
- No telling after showing
- No overexplaining subtext
- No 3+ consecutive sentences starting the same way

### Structure
- Follow the Conflict Architecture from the Scene Brief (Goal → Obstacle → Turn)
- Ground characters in physical space
- Dialogue must have subtext — no on-the-nose speech
- Each scene needs Goal, Obstacle, Outcome

## Post-Draft QC

After completing the draft, run these checks BEFORE presenting to the user:

### Self-Editing Checklist
- [ ] Facts Sheet updated with any new names/dates/places
- [ ] Filter words removed (saw, heard, felt, noticed, realized, watched, observed)
- [ ] Wan intensifiers cut (very, really, quite, rather, somewhat, just)
- [ ] "To be" + -ing converted to active verbs where possible
- [ ] Sentence openings varied
- [ ] Tautologies cut
- [ ] Each scene has Goal, Obstacle, Outcome
- [ ] POV consistent throughout
- [ ] Characters grounded in physical space
- [ ] Dialogue has subtext

### Inline De-AI Scan
Run a quick scan of your own output:
- Count any banned vocabulary
- Check burstiness (sample 10 consecutive sentences — are lengths varied?)
- Check for structural tells
- Check endings (no moralizing wrap-up)

### Scene Assertions Verification
Re-check every Scene Assertion against what you actually wrote. Flag any violations.

## Output

Present the draft with:

1. **The prose itself** (in a code block or clearly delineated)
2. **QC Results:**
   - Self-Editing Checklist: [PASS/issues found]
   - De-AI Scan: [PASS/issues found]
   - Scene Assertions: [All verified / violations found]
3. **Facts Sheet Updates:** List any new facts to add
4. **Word count**

State: **"Draft ready for review. For a comprehensive scored De-AI audit, run /de-ai-audit. For full QA with Gemini audits, run /revision-guide. Or provide feedback directly."**
