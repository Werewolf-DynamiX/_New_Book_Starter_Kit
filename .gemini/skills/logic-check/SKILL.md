---
name: logic-check
description: Audit a chapter or section for internal contradictions — comparison direction, cause/effect order, character knowledge, timeline, spatial blocking, emotional transitions. Mechanical check only; does not evaluate prose quality. Use in revision passes and final polish.
---

# Logic & Consistency Check

## Overview
You are performing a **literal-reading audit**. Read every sentence exactly as written — not as intended. Your job is to catch the contradictions the writer's ear glossed over.

This complements `continuity-audit` (which checks against FACTS_SHEET) and `voice-lint` (which checks dialogue rules). Logic check catches **internal** contradictions — sentence-against-sentence, scene-against-scene — not external ones.

## Operating Directives
- **The Golden Rule:** Does each sentence mean what it actually says? Not what the author intended. What the words literally assert.
- **Mechanical audit only.** Do not comment on prose quality, style, or voice. Only contradictions.
- **Evidence required.** Every finding must include a direct quote and a specific violation type from the checklist below.
- **No speculation.** If it's ambiguous, flag it as ambiguous. Do not assume the "generous reading" resolves the problem.

## Audit Checklist

Run each category as a separate pass through the text.

### 1. Comparison Logic
For any comparative construction (more/less, above/below, better/worse, barely/almost), verify the direction.

- **Ask:** What is being compared to what? Which direction is "good/high/extreme"? Does "less" or "more" move in the direction intended?
- **Red flag phrases:**
  - "barely [more/above/better]... [less/worse]"
  - "almost [X]... [more than X]"
  - "not quite... [exceeds]"
  - "[comparative]... [opposite comparative]"
- **Broken:** "We're barely a step above livestock. Less, maybe." (Contradicts direction.)
- **Fixed:** "We're no better than livestock. Worse, maybe."

### 2. Cause and Effect
For every result or reaction, verify the trigger.

- **Ask:** What caused this? Is the cause sufficient? Did the cause happen *before* the effect?
- **Check:** Reactions compressed into the same sentence as their trigger — does the grammar imply simultaneity when sequence is required?

### 3. Character Knowledge
Verify that the POV character has the information they act on.

- **Ask:** How do they know this? Were they present? Could they have learned it offscreen?
- **Check:** POV leakage — character knows something only the author knows. Guessing/assuming should be clearly signaled.

### 4. Timeline & Temporal Logic
Verify time flow within and between scenes.

- **Ask:** What happened before? After? Is there enough time for described action (travel, dressing, healing)?
- **Check:** Day/night, weather, seasonal markers matching the established timeline.

### 5. Physical & Spatial Logic
Visualize the scene blocking physically.

- **Ask:** Where is everyone standing? Can they see/reach what the text says they see/reach? Are body positions anatomically possible?
- **Check:** Blocking changes shown, not "teleported."

### 6. Emotional Logic
Verify emotional shifts are earned and transitioned.

- **Ask:** What triggered this emotion? Is intensity proportional to trigger?
- **Check:** Emotional whiplash — grief to humor without a transition beat or a character-specific reason.

## Output Format

Structure findings by category. For each:

```
### [Category Name]

**Location:** Chapter N, paragraph/section
**Quote:** "[exact text from the manuscript]"
**Violation:** [one-sentence description of what contradicts]
**Suggested fix:** [minimal change that resolves the contradiction]
```

If a category has no findings, write: `No violations found.`

End the report with a summary count by category and severity:
- **Critical:** Direct contradiction that breaks the scene
- **High:** Ambiguity a careful reader will catch
- **Low:** Technically consistent but reads oddly

## What This Skill Is Not

Do not flag:
- Word choice or style ("this sentence is clunky")
- Pacing or scene structure
- Character voice violations (that's `voice-lint`)
- FACTS_SHEET contradictions (that's `continuity-audit`)
- AI vocabulary (that's `de-ai-audit`)

If you find something outside scope, note it in a single-line "Out of scope (route elsewhere)" footer — do not expand on it.

Reference: `references/_LOGIC_CHECK.md` for the full protocol.
