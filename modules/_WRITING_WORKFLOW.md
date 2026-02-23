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
gemini "your prompt here"
```

**Common use cases:**
```bash
# Research (Nonfiction/Fiction)
gemini "Research the history of [topic] with primary sources"

# QA Review
gemini "Review this chapter against _NONFICTION_CORE.md"

# Context
gemini "Please review all files to understand the project"
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

## Chapter Completion Checklist (The "Forest" Check)

**When to run:** After all individual revision fixes have been verified (Phase 5 of `_REVISION_WORKFLOW.md`), before the user signs off on the chapter.

**Purpose:** Individual fixes may all be correct, but the chapter needs to work as a whole. This checklist catches problems that only appear when you step back from the trees.

**Executor:** The auditing model reads the full chapter after all fixes and runs this checklist.

### Holistic Quality
- [ ] **Flow:** Read the chapter start to finish. Does it flow naturally, or do the fixes create jarring transitions?
- [ ] **Voice consistency:** Does the narrative voice stay consistent throughout? Did any fix introduce a tonal shift?
- [ ] **Pacing:** Does the chapter feel evenly paced? Did inserting/removing content create a lull or a rush?
- [ ] **Emotional arc:** Does the chapter have a clear emotional trajectory? Does it feel complete as a unit?

### Fix Integration
- [ ] **No seams:** Perform a granular audit of **sentence transitions** between newly modified paragraphs and surrounding unedited text. Does the rhythm, pacing, and tone match flawlessly? If the boundary is visible, smooth the seams.
- [ ] **No orphaned references:** Did removing or rewriting a passage break a reference earlier or later in the chapter?
- [ ] **No contradictions:** Do the fixed sections contradict unfixed sections within the same chapter?
- [ ] **No tone drift:** Do fixed paragraphs sound like the same author as unfixed paragraphs?

### Continuity (Post-Fix)
- [ ] **Facts Sheet current:** Does `FACTS_SHEET.md` reflect all changes made in this chapter?
- [ ] **Story Bible current:** Are character states, locations, and timeline accurate after this chapter?
- [ ] **Thread status:** Are all open threads from this chapter either advanced, acknowledged, or intentionally left dormant?

### Final Read
- [ ] **Opening line:** Does the chapter's first line still work? (Fixes elsewhere may have changed context.)
- [ ] **Closing line:** Does the chapter end with enough pull to make the reader turn the page?
- [ ] **Would I read this chapter in a bookstore?** Honest gut check. Not "is it technically correct" — does it *work*?

**USER CHECKPOINT:** Present checklist results to the user. The chapter is "done" only when the user explicitly signs off.

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

## Pre-Generation Fact Assertions
Before generating any new prose, the AI must output a hidden markdown block (or a block comment) at the top of the generation that declares the physical and temporal constraints of the scene.

**Example Block:**
> [SCENE ASSERTIONS]
> Day: 4 (Thursday)
> Weather: Raining (started in previous chapter)
> Protagonist Inventory: Dagger (left boot), Stolen ledger (coat pocket)
> Protagonist Physical State: Limping (right ankle injured in Ch 3)
> [END ASSERTIONS]

The generation engine MUST consult this block every 500 words to ensure the constraints have not been dropped or violated.