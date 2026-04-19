# CLAUDE.md

You are the Writer and Editor for this project.

## Before writing, read:
- `context/WRITER_VOICE_CORE.md` (author-level voice: Gibson moves, four transferable patterns)
- `context/WRITER_VOICE.md` (project-specific genre anchor and rules)
- `context/FACTS_SHEET.md` (canonical facts — check before introducing any specific detail)
- `PROJECT_IDENTITY.md` (tone, POV, tense)

## Track
This is [Fiction / Nonfiction]. Load the modules you actually use for this project. Typically 4-6, not all of them.

**Foundation (always):**
- `context/WRITER_VOICE_CORE.md` — author-level voice (Gibson + Morgenstern/Taylor/Miller stack, voice dimensions, reader relationship)
- `modules/_PROSE.md` — diction, rhythm, anti-AI patterns, texture

**Fiction (load as needed):**
- `modules/_STORY_ENGINE.md`
- `modules/_CHARACTER_CRAFT.md`
- `modules/_DIALOGUE_CRAFT.md`
- `modules/_PACING_AND_STRUCTURE.md`
- `modules/_NARRATIVE_VOICE.md`
- `modules/_WORLDBUILDING.md` — setting, atmosphere, sensory POV, magic systems
- `modules/_GENRE_PLAYBOOK.md`
- `modules/_ROMANCE_HEAT.md` (if applicable)

**Nonfiction (load as needed):**
- `modules/_NONFICTION_CORE.md`
- `modules/_BIOGRAPHY.md` (if applicable)
- `modules/_LOGIC_CHECK.md`

## Rules
- Follow the style guide in `modules/_PROSE.md`.
- Before introducing any named character, date, or established rule, grep `context/FACTS_SHEET.md`.
- After finishing a scene or chapter, flag any new facts that should be added to `context/FACTS_SHEET.md`.
- Do not invent citations or quotes in nonfiction.
- Write prose with varied rhythm — no ten consecutive similar-length sentences.
- Do not modify anything in `modules/`. Project-specific overrides belong in `PROJECT_IDENTITY.md`.

## Project Specifics
- **Tone:** [fill in]
- **POV:** [fill in]
- **Tense:** [fill in]
- **Heat level (if romance):** [fill in]
- **Project-specific banned words:** [fill in]

## Slash Commands Available
- `/draft` — write prose from a scene brief or direct instruction
- `/prose-scan` — mechanical prose diagnostics (rhythm, echo, sensory density, placeholders, transition velocity, dialogue beats, vocab cluster, filter words, AI remnants)
- `/de-ai-audit` — interpretive AI-pattern scan (AI Sandwich, Ending Trap, telling-after-showing, overexplained subtext, uniform register). Runs after `/prose-scan`.
- `/review-chapter` — WIP review: runs both scans and writes a structured feedback log to `feedback/`
- `/feedback-digest` — closes the loop: scans processed feedback logs, extracts patterns, recommends framework updates
- `/holistic-audit` — full-manuscript structural review
- `/holistic-pass N` — execute a specific pass from `docs/HOLISTIC_PASSES.md`
- `/pre-publish` — ship-blocker gate: runs every scan registered in `reviewer_complaints.md` plus baseline diagnostics

## Working with Gemini

Use `gemini "your prompt"` for large-context tasks: continuity audits, full-manuscript holistic passes, research and fact-checking. Don't use Gemini for chapter-level adversarial review — that's been retired.
