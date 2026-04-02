---
name: holistic-pass
description: Execute a specific numbered holistic revision pass from docs/HOLISTIC_PASSES.md across targeted chapters. Works through one chunk per invocation and tracks progress.
user-invocable: true
---

# /holistic-pass

You are executing a specific holistic revision pass — a manuscript-level edit that spans multiple chapters.

**Critical constraint:** A holistic pass may span 5-15+ chapters. Do NOT attempt to rewrite the entire pass in one invocation. Work through a **chunk** (2-4 chapters) per invocation, track progress, and let the user decide when to continue.

## Input
- `$ARGUMENTS`: Pass number (e.g., "1", "3"). If empty, read `docs/HOLISTIC_PASSES.md` and ask the user which pass to execute.

## Procedure

### Step 1: Load the Pass Definition
Read `docs/HOLISTIC_PASSES.md`. Extract the specified pass's:
- **Problem** (what you're fixing)
- **Goal** (what "fixed" looks like)
- **Method** (step-by-step approach)
- **Targeted chapters** (full list)
- **Already done** (what's been completed — skip those chapters)

If the pass doesn't exist or the number is invalid, say so and list available passes.

### Step 2: Load Supporting Context
Read as needed based on the pass type:
- `context/FACTS_SHEET.md` (always)
- `context/WRITER_VOICE.md` (for voice/prose passes)
- `PROJECT_IDENTITY.md` (always)
- `docs/characters.md` (for voice differentiation or character passes, if it exists)

### Step 3: Determine the Chunk
From the targeted chapters list, subtract "Already done" chapters. From the remaining:
- Select the next **2-4 chapters** in sequence
- If the user specified particular chapters in $ARGUMENTS (e.g., "3 ch14 ch16"), use those

State clearly: **"Working on Pass [N]: [Title]. This chunk: chapters [X, Y, Z]. Remaining after this: [list]."**

### Step 4: Read the Chapters
Read all chapters in the chunk completely.

### Step 5: Apply the Pass Method
For each chapter in the chunk, follow the pass's Method step by step. For every change:

1. **Quote the BEFORE text** (the passage as it currently reads)
2. **Write the AFTER text** (the revised passage)
3. **State the rationale** (how this change serves the pass's Goal)

**Rules:**
- Only make changes relevant to THIS pass. Do not fix unrelated issues you notice — those belong in other passes or `/revision-guide`.
- Preserve the author's voice. You are adjusting a specific pattern, not rewriting prose.
- If a passage is borderline (could go either way), flag it for the user rather than changing it.
- If applying the method reveals the pass definition needs refinement, note that for the user.

### Step 6: Consult Gemini for Verification
After drafting changes for the chunk, ask Gemini to verify:

```
I'm executing Holistic Pass [N]: [Title] on chapters [X, Y, Z].

Pass Goal: [goal]

Here are my proposed changes:
[list BEFORE/AFTER pairs with rationale]

Verify:
1. Do these changes serve the pass goal without introducing new problems?
2. Do any changes contradict FACTS_SHEET.md or create continuity issues?
3. Are there passages I missed in these chapters that should also be addressed by this pass?
```

### Step 7: Present Changes
Present all changes grouped by chapter:

```markdown
# Holistic Pass [N]: [Title]
## Chunk: Chapters [X, Y, Z]

### Chapter [X]: [title]

**Change 1:**
- BEFORE: "[quoted text]"
- AFTER: "[revised text]"
- RATIONALE: [why]

**Change 2:**
...

### Chapter [Y]: [title]
...

---

**Gemini verification:** [summary of Gemini's response]
**Flagged for user:** [any borderline decisions]
**Remaining chapters:** [list of chapters not yet addressed by this pass]
```

### Step 8: USER CHECKPOINT
State clearly:

**"Pass [N] chunk complete. [X] changes across [N] chapters. Apply these changes? After applying, run `/holistic-pass [N]` again to continue with the next chunk."**

Do NOT apply changes until the user approves.

### Step 9: Apply and Track Progress
After user approval:
1. Apply all approved changes using Edit tool
2. Update `docs/HOLISTIC_PASSES.md` — add completed chapters to the "Already done" section with today's date and a count of changes made
3. If all targeted chapters are now done, mark the pass as complete in the Priority Order section

### Step 10: Suggest Next Steps
- If more chapters remain for this pass: "Run `/holistic-pass [N]` to continue."
- If this pass is complete: "Pass [N] complete. Next priority pass is [M]: [Title]."
- If changes were substantial: "Consider running `/revision-guide` on the modified chapters to verify no chapter-level issues were introduced."
