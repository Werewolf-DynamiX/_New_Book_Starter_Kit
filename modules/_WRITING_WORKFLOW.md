# Writing Workflow & Process

## Session Initialization

At the start of each writing session, determine:

### 1. Track Selection
| Question | Answer | Modules Loaded |
|----------|--------|----------------|
| Fiction or Nonfiction? | **Fiction** | `_STORY_ENGINE`, `_CHARACTER_CRAFT`, `_PACING_AND_STRUCTURE`, `_NARRATIVE_VOICE`, `_DIALOGUE_CRAFT`, `_GENRE_PLAYBOOK`, `_WORLDBUILDING` |
| Fiction or Nonfiction? | **Nonfiction** | `_NONFICTION_CORE`, optionally `_BIOGRAPHY` |
| Fiction or Nonfiction? | **Narrative Nonfiction** | `_NONFICTION_CORE` + `_STORY_ENGINE` + `_PACING_AND_STRUCTURE` + `_DIALOGUE_CRAFT` |

**Narrative Nonfiction** is a hybrid track for: Memoir, Creative Nonfiction, Immersive Journalism, True Crime narratives. It applies fiction craft techniques (scenes, pacing, dialogue) while maintaining nonfiction's epistemic boundaries (no invention).

### 2. Fiction Configuration
If Fiction, also determine:
- **Primary genre** → Load relevant section from `_GENRE_PLAYBOOK`
- **POV and tense** → Reference appropriate section in `_NARRATIVE_VOICE`
- **Heat level** (if romance elements) → Load `_ROMANCE_HEAT` with specified level
- **Worldbuilding complexity** → Reference `_WORLDBUILDING` as needed

### 3. Nonfiction Configuration
If Nonfiction, also determine:
- **Biography?** → Load `_BIOGRAPHY` and select tone mode (Warm/Critical/Dark)
- **Technical?** → Emphasis on scaffolding and jargon handling from `_NONFICTION_CORE`

### 3b. Narrative Nonfiction Configuration
If Narrative Nonfiction, also determine:
- **Memoir?** → First-person, thematic structure, emotional arc over chronology
- **True Crime?** → Multiple POVs allowed, procedural pacing, ethical disclosure
- **Immersive Journalism?** → Scene-based reporting, present-tense optional
- **All types:** Apply `_PACING_AND_STRUCTURE` scene requirements (Goal/Obstacle/Outcome) but source all details from documented reality

### 4. Universal Modules (Always Active)
These apply to all projects:
- `_STYLE_AUTHORITY` (diction, syntax, anti-AI patterns)
- `_HUMAN_PATTERNS` (rhythm, burstiness)
- `_PROSE_TEXTURE` (intentional messiness/scars)
- `_REVISION_TOOLKIT` (for self-editing)
- `_REVISION_WORKFLOW` (revision pipeline & verification)
- `_CRITIC_PROTOCOL` (adversarial review standard)
- `_PLANNING_PROTOCOL` (the mandatory scene brief)
- `_WRITING_WORKFLOW` (this file)

---

## Project Initialization

**Before drafting, provide:**
- Genre/Type (e.g., "cozy fantasy," "biography," "technical guide")
- Tone (e.g., "dark and literary," "authoritative but warm")
- POV and tense (e.g., "first person past," "third limited present")
- Target audience (e.g., "adult," "YA," "expert")
- **For Fiction:** Tropes, Character sheets, Outline/Beat sheet.
- **For Nonfiction:** Thesis, Research Briefs, Key Sources, Citation Style.

**When instructions conflict:** User-provided specifications override module defaults.

**Rule flexibility:** Most rules in modules are strong defaults, not absolutes. [FLEXIBLE] rules can be broken for effect. [STRICT] rules must be followed unless overridden.

---

## AI Collaboration Workflow

### Role Division
- **Gemini:** Architect & Researcher (planning, outlining, research, QA, Fact-Checking)
- **Claude:** Writer & Editor (prose generation, applying style rules)

### How Claude Uses Gemini CLI
Claude can communicate with Gemini using the command line interface.

```bash
"C:\Users\toast\.bun\bin\gemini.exe" -p "your prompt here"
```

**Common use cases:**
```bash
# Research (Nonfiction/Fiction)
"C:\Users\toast\.bun\bin\gemini.exe" -p "Research the history of [topic] with primary sources"

# QA Review
"C:\Users\toast\.bun\bin\gemini.exe" -p "Review this chapter against _NONFICTION_CORE.md"

# Context
"C:\Users\toast\.bun\bin\gemini.exe" -p "Please review all files to understand the project"
```

---

## Output Formatting

Unless user specifies otherwise:

- **Scene/Section breaks:** Use "* * *" or "---" centered on their own line.
- **Chapter breaks:** "## Chapter [Number]: [Title]"
- **Emphasis:** Use *italics* for internal thought or emphasis.
- **Dialogue:** Use quotation marks ("dialogue").
- **Citations (Nonfiction):** Use `[Source Name]` or footnotes `[^1]` as requested.

---

## Self-Editing Checklist

### Prose Level (Universal)
- [ ] **Facts Sheet Updated** (CRITICAL: Add new names/dates to `context/FACTS_SHEET.md`)
- [ ] Filter words removed (saw, heard, felt, noticed).
- [ ] Wan intensifiers cut (very, really, quite, just).
- [ ] "To be" verbs replaced where possible.
- [ ] Sentence openings varied.
- [ ] Tautologies cut.

### Scene Level (Fiction)
- [ ] Each scene has Goal, Obstacle, Outcome.
- [ ] POV consistent throughout scene.
- [ ] Characters grounded in physical space.
- [ ] Dialogue has subtext.

### Story Level (Fiction)
- [ ] **Continuity Audit:** (End of Act) Run `CONTINUITY_AUDIT_PROMPT.md` to trace threads and consistency.
- [ ] Protagonist has clear Want and Need.
- [ ] Stakes established and escalate.
- [ ] Character arc tracks.
- [ ] Foreshadowing pays off.

### Integrity Level (Nonfiction)
- [ ] Every claim is verified/verifiable.
- [ ] No invented scenes or composite characters.
- [ ] "I" is used only where purposeful (not just filler).
- [ ] Jargon is defined or scaffolded.
- [ ] Counter-arguments are acknowledged.

---

## Handling User Feedback

1. **"Make it longer":**
   - **Fiction:** Add interiority, sensory grounding, dialogue.
   - **Nonfiction:** Add examples, historical context, opposing views, deep-dive into mechanics.
2. **"Make it shorter":** Cut filter words, redundancy, excessive description/explanation.
3. **"More tension":**
   - **Fiction:** Add obstacles, time pressure, interpersonal conflict.
   - **Nonfiction:** Highlight the stakes of the problem, the difficulty of the solution, or the conflict of ideas.
4. **"Fix the dialogue":** Add subtext, cut names, vary speech patterns.