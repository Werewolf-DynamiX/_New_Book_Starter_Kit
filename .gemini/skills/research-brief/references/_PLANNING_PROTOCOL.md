# PLANNING PROTOCOL: Research, Scene/Section Brief

**Active Module: PLANNING**
**Purpose:** To prevent structural drift, continuity errors, and AI-fluff by requiring research and a rigorous "Brief" before any drafting.

---

## 1. TRACK SELECTION
Before starting, specify if you are in **FICTION** or **NONFICTION** track.

---

## 2. RESEARCH STAGE (Before the Brief)

Research is a named pipeline step, not something that happens ad hoc. Complete the Research Brief before writing the Scene/Section Brief.

### 2A. Fiction Research Brief

**Executor:** Gemini (research specialist)
**Output:** Research Brief document

For each scene/chapter, Gemini answers:

1. **Continuity State:** What is the current state of all relevant characters, locations, and timeline? (Pull from `FACTS_SHEET.md` and Story Bible.)
2. **Open Threads:** What unresolved plot threads from previous chapters must be acknowledged or advanced?
3. **World Rules Check:** Are any magic system rules, physical constraints, or established world facts relevant to this scene? List them explicitly.
4. **Genre/Trope Context:** What genre conventions apply to this scene type? (e.g., "the first kiss scene," "the betrayal reveal," "the training montage")
5. **Comp Research:** (Optional, for key scenes) How do comparable books handle this moment? What works, what's cliché?

### 2B. Nonfiction Research Brief

**Executor:** Gemini (research specialist)
**Output:** Research Brief document

For each section/chapter, Gemini answers:

1. **Source Inventory:** What primary and secondary sources are available for this section? List with credibility assessment.
2. **Fact Verification:** Pre-verify the key claims that will anchor the section. Flag anything that needs hedging language.
3. **Counter-Arguments:** What are the strongest objections to the section's core claim? How will they be addressed?
4. **Domain Context:** What specialized terminology or background knowledge does the reader need? What must be scaffolded?
5. **Gap Analysis:** What information is missing that would strengthen the section? Can it be found, or must we work around it?

### Research Brief Format

```markdown
# Research Brief: [Chapter/Scene Title]

**Date:** [date]
**Researcher:** Gemini
**Track:** [Fiction / Nonfiction]

## Continuity State / Source Inventory
[findings]

## Open Threads / Fact Verification
[findings]

## World Rules / Counter-Arguments
[findings]

## Genre Context / Domain Context
[findings]

## Gaps & Risks
[anything missing or uncertain]
```

**The Research Brief feeds directly into the Scene/Section Brief.** Claude uses it as input for planning.

---

## 3. TRACK A: FICTION (The Scene Brief)

**Executor:** Claude (with Research Brief as input)

1.  **Objective:** What is the specific narrative purpose of this scene?
2.  **Continuity Check (Reference Research Brief + `FACTS_SHEET.md`):** Who, Where, When, and Open Loops.
3.  **Conflict Architecture:** Goal, Obstacle, and "The Turn" (how the scene ends differently).
4.  **Sensory Palette:** List 3 specific non-visual details to ground the scene.

---

## 4. TRACK B: NONFICTION (The Section Brief)

**Executor:** Claude (with Research Brief as input)

1.  **The Core Claim:** What is the primary point or piece of information this section must convey?
2.  **Epistemic Foundation:**
    *   What are the primary sources for this section? (From Research Brief)
    *   Are there any "grey areas" where we must use conditional language (e.g., "likely," "reportedly")?
3.  **Structural Hook:**
    *   **The Lead:** How are we hooking the reader into this specific sub-topic?
    *   **The Scaffolding:** What complex concepts need to be defined before we can proceed?
4.  **Voice & Intellectual Texture:**
    *   **The Stance:** What is the author's opinion or "take" on this data?
    *   **The Counter-Argument:** How will we acknowledge the opposing view or the complexity of the data?
5.  **The "So What?":** Why does this information matter to the reader's life or the book's thesis?

---

## 5. Operational Command

**Pipeline order:**
1. Gemini produces the **Research Brief**.
2. Claude produces the **Scene/Section Brief** using the Research Brief as input.
3. Gemini validates the Brief.
4. **USER CHECKPOINT:** Brief is presented to the user for approval.
5. Only after user approval does drafting begin.

**Do not write prose until the Brief is approved.**
Output the Brief to the log/file before the draft to create a "paper trail" for the Auditor (Gemini).

---

*Module Version 2.0 — February 2026*
*Added Research Stage as formal pipeline step before Scene/Section Brief.*
