---
name: scene-brief
description: Generate a Scene/Section Brief with Gemini Research Brief input. Determines track (Fiction/Nonfiction), checks persona, consults Gemini, then presents Brief for user approval.
user-invocable: true
---

# /scene-brief

You are generating a Scene Brief (Fiction) or Section Brief (Nonfiction) following the planning protocol.

## Input
- `$ARGUMENTS`: Chapter/scene description or number. If empty, ask the user what they want to write next.

## Procedure

### Step 1: Determine Track
Read `PROJECT_IDENTITY.md` to determine if this is a Fiction or Nonfiction project.

### Step 2: Check Persona
Read `context/WRITER_VOICE.md`.
- If persona is defined: "Activating persona: [Archetype]."
- If not defined: Suggest a persona based on genre and ask user to confirm or define one using `modules/_AUTHOR_VOICE_BUILDER.md`.

### Step 3: Gather Context
Read these files to understand current project state:
- `context/FACTS_SHEET.md` (established facts)
- `manuscript/00_master_outline.md` (overall structure)
- Recent chapter files (for continuity)

### Step 4: Request Research Brief from Gemini
Use `mcp__gemini-cli__ask-gemini` (or bash: `gemini "prompt"`) to request a Research Brief. Construct a prompt like:

**For Fiction:**
```
I need a Research Brief for [chapter/scene]. Please analyze:
1. CONTINUITY STATE: Review manuscript chapters and FACTS_SHEET.md. What are the current character states, locations, and timeline position?
2. OPEN THREADS: What plot threads, promises, and unresolved conflicts carry into this scene?
3. WORLD RULES: What established world rules (magic systems, social structures, physical laws) constrain this scene?
4. GENRE CONTEXT: What genre conventions or reader expectations apply?
5. GAPS & RISKS: What could go wrong? What's missing?

Format as a Research Brief with sections for each area.
```

**For Nonfiction:**
```
I need a Research Brief for [section/chapter]. Please analyze:
1. SOURCE INVENTORY: What sources have been cited so far? What's available for this section?
2. FACT VERIFICATION: Are there claims that need verification?
3. COUNTER-ARGUMENTS: What opposing viewpoints should be addressed?
4. DOMAIN CONTEXT: What background knowledge does the reader need?
5. GAPS & RISKS: What could go wrong? What's missing?

Format as a Research Brief with sections for each area.
```

### Step 5: Generate Scene/Section Brief
Using Gemini's Research Brief as input, generate the Brief.

**Fiction Scene Brief format:**
```markdown
# Scene Brief: [Title]

**Chapter:** [number/title]
**POV:** [character]
**Setting:** [location, time]

## Objective
What is the specific narrative purpose of this scene?

## Continuity Check (from Research Brief)
- **Who:** Characters present, their current states
- **Where:** Location details, established descriptions
- **When:** Timeline position, elapsed time since last scene
- **Open Loops:** Threads that must be addressed or acknowledged

## Conflict Architecture
- **Goal:** What does the POV character want in this scene?
- **Obstacle:** What prevents them from getting it?
- **The Turn:** How does the scene end differently than it began?

## Sensory Palette
List 3 specific non-visual sensory details to ground the scene:
1. [sound/smell/texture/taste/temperature]
2. [sound/smell/texture/taste/temperature]
3. [sound/smell/texture/taste/temperature]

## Scene Assertions
Factual statements that must remain true throughout this scene — cross-referenced from FACTS_SHEET.md:
- [Character] has [physical description] (FACTS_SHEET line X)
- [Location] is described as [details] (FACTS_SHEET line Y)
- [Timeline]: This scene takes place [when] (FACTS_SHEET line Z)
- [Open thread]: [thread status and source]

## Notes
[Any warnings from the Research Brief, genre considerations, or constraints]
```

**Nonfiction Section Brief format:**
```markdown
# Section Brief: [Title]

**Chapter:** [number/title]
**Argument:** [core claim of this section]

## Objective
What does the reader understand after this section that they didn't before?

## Source Foundation (from Research Brief)
- Primary sources to draw from
- Facts verified / needing verification

## Argument Architecture
- **Claim:** The central point
- **Evidence:** Supporting material
- **Counter-argument:** What the skeptic says
- **Resolution:** How to address the counter

## Structural Approach
[How to open, develop, and close — avoiding AI Sandwich]

## Notes
[Warnings, gaps, constraints from Research Brief]
```

### Step 6: Validate with Gemini
Use `mcp__gemini-cli__ask-gemini` (or bash: `gemini "prompt"`) to send the completed Brief for review:
```
Review this Scene Brief for completeness and consistency. Check against FACTS_SHEET.md and the Research Brief you provided. Flag any issues.
```

### Step 7: USER CHECKPOINT
Present the Brief to the user. State clearly:

**"Scene Brief ready for review. Please approve before I begin drafting, or request changes."**

Do NOT proceed to drafting until the user explicitly approves.
