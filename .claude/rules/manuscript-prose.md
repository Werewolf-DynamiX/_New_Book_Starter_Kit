---
paths: ["manuscript/**/*.md"]
---

# Manuscript Prose Rules (Auto-Loaded)

These rules apply automatically when editing manuscript files. They are a condensed reference — full details in the modules.

## Persona & Continuity
- Check `context/WRITER_VOICE.md` for your active Author Persona. Write in that voice.
- Check `context/FACTS_SHEET.md` before writing. Update it after introducing new names, dates, places, or physical descriptions.
- Check `PROJECT_IDENTITY.md` for tone, POV, and tense requirements.

## Banned AI Vocabulary
Flag when 3+ cluster in a chapter. Replace or remove.

**Zero tolerance:** "A testament to...", "A reminder that...", "In conclusion,", "Ultimately,", "At the end of the day", "Let's dive in", "Let's explore", "In this chapter, we will...", "It's not just about X, it's about Y", "To understand X, you have to understand Y", "Let that sink in", "It is important to note that", "In today's digital age", "Whether it's X or Y...", "Only time will tell...", "Think of X as a Y..."

**AI-associated words:** delve, tapestry, testament, myriad, plethora, multifaceted, crucial, nuanced, realm, paradigm, notably, furthermore, moreover, additionally, seamlessly, leverage, harness, foster, cultivate, invaluable, indispensable, paramount, intricate, game-changer, cutting-edge, revolutionary, rich tapestry, vibrant landscape, dynamic, optimize, utilize, facilitate, deep dive

**Exception:** These words are fine when used literally (e.g., "a faded tapestry on the wall", "she delved into her pocket").

## Burstiness (Non-Negotiable)
- Mix short sentences (2-6 words), medium (8-15 words), and long (18-30 words)
- Never write 2+ sentences of similar length back-to-back
- If 10 consecutive sentences all fall within 12-18 words → "AI Flatline" → rewrite
- Vary paragraph length: some single sentences, some 4-5 sentences
- One-word sentences and fragments are legal. Use them.
- After a long sentence, go short. After several short ones, let one breathe.
- Don't let every paragraph be 3 sentences. That's a pattern. Break it.

## Filter Words (Remove Distancing Phrases)
**Cut these:** saw, heard, felt, noticed, realized, watched, observed, thought, wondered, seemed

These place a character between reader and action. Remove unless the act of perception itself matters.

| Before | After |
|--------|-------|
| She heard footsteps. | Footsteps echoed. |
| He noticed the door was open. | The door hung open. |
| She felt her heart racing. | Her heart raced. |

## Wan Intensifiers (Delete or Replace)
**Cut:** very, really, quite, rather, somewhat, just, actually, basically, literally (when not literal)

## Structural Tells to Avoid
- **AI Sandwich:** Topic → 3 points → Summary. Break this pattern.
- **Uniform paragraphs:** All 3-sentence blocks = AI tell. Vary length.
- **Parallel sentence starts:** 3+ consecutive "He went... He saw... He felt..." = AI pattern.
- **The Ending Trap:** Never end a scene with a moralizing summary, "A testament to...", or an uplifting thematic wrap-up. Strip these.
- **Telling after showing:** Don't describe emotion through action then name it anyway.
- **Overexplaining:** Trust the reader. Don't explain subtext.

## Prose Quality
- Convert "to be" + -ing to active verbs: "was running" → "sprinted"
- Convert "there was/were" openers: "There were three men" → "Three men stood"
- Em-dash discipline: max 1-2 per paragraph
- Vary sentence openings — no 3+ consecutive same-structure starts
- Cut tautologies

## Before Submitting Any Prose
1. Run `/de-ai-audit` on the file
2. Run `/prose-scan` for rhythm, echo, and sensory-density diagnostics
3. Update `context/FACTS_SHEET.md` if you introduced new names/dates/places
