---
name: draft
description: Draft prose from a scene brief or direct instruction. Pre-flight checks persona and facts, applies anti-polish rules, runs Self-Editing Checklist and de-ai-audit inline.
user-invocable: true
---

# /draft

You are drafting prose. Work from whatever scene context the user has given you — a brief in conversation, a beat sheet, or direct instruction. If the intent is ambiguous, ask a clarifying question before writing.

## Input
- `$ARGUMENTS`: Optional file path to write to. If empty, determine from context or ask.

## Pre-Flight Checks

Before writing a single word of prose, verify:

### 1. Scene Intent is Clear
You need at minimum: what happens, whose POV, what the character wants, what stands in the way, what shifts by the end. If any of those are missing, ask the user.

### 2. Persona Check
Read **both** voice files:
1. `context/WRITER_VOICE_CORE.md` — author-level core (Gibson moves, four transferable patterns, general negatives). Required.
2. `context/WRITER_VOICE.md` — project-specific genre anchors.

Evaluate:
- If WRITER_VOICE_CORE.md is missing or empty: **"No author-level voice core defined. Create `context/WRITER_VOICE_CORE.md` from the kit template before drafting."** Stop here.
- If WRITER_VOICE.md Section 2 (Genre Anchors) has no filled passage: **"No project-specific genre anchor. Drafts will draw only from the core, which may be wrong for this book's emotional temperature. Paste a genre anchor (Section 2) before continuing, or type `override` to draft using the core alone."** Wait.
- If both are filled in: "Writing with core voice (Gibson moves) + genre anchor [N]: [summary]."

**During drafting:** keep the Four Transferable Moves from the core and the genre anchor passage in your working context. Every few paragraphs, compare your rhythm against the anchor. If divergence is obvious (emotional temperature, sentence rhythm, register), correct course before continuing.

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
- Apply the Four Transferable Moves from `WRITER_VOICE_CORE.md`: Trust, Present-Tense Surface, Register Collision, Restraint on Interiority.
- Match the emotional temperature of the project's genre anchor in `WRITER_VOICE.md`.
- Apply every rule in Section 3 of `WRITER_VOICE.md` (project-specific additions to the core).
- Include purposeful imperfections: tangents, fragments, abrupt transitions — if the model passages show them.
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

State: **"Draft ready for review. For a comprehensive scored De-AI audit, run /de-ai-audit. For prose diagnostics (rhythm, echo, sensory density), run /prose-scan. Or provide feedback directly."**
