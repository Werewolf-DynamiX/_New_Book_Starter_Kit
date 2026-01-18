# Writing Workflow & Process

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