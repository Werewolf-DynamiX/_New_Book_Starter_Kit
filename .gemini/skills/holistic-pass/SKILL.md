---
name: holistic-pass
description: Execute a specific holistic revision pass from docs/HOLISTIC_PASSES.md. Applies cross-chapter structural edits, tracks progress, and provides verification.
---

# Holistic Pass Execution

## Overview
You are executing a specific holistic revision pass — a manuscript-level edit targeting a pattern that spans multiple chapters.

## Constraints
- Work through **2-4 chapters per invocation**. Do not attempt the full pass at once.
- Only make changes relevant to THIS pass. Ignore unrelated issues.
- Provide BEFORE/AFTER evidence for every change.
- Track progress in `docs/HOLISTIC_PASSES.md` after each chunk.

## Execution Protocol

### Phase 1: Load Pass Definition
Read `docs/HOLISTIC_PASSES.md`. Extract the specified pass's Problem, Goal, Method, Targeted chapters, and Already done sections. Determine which chapters remain.

### Phase 2: Load Context
Read as needed:
- `context/FACTS_SHEET.md` (always)
- `context/WRITER_VOICE.md` (for voice/prose passes)
- `PROJECT_IDENTITY.md` (always)
- `docs/characters.md` (for voice or character passes, if it exists)

### Phase 3: Select Chunk
From remaining chapters, select the next 2-4 in sequence. State which chapters you're working on and which remain.

### Phase 4: Read and Analyze
Read each chapter in the chunk. For each, identify every passage where the pass's Problem manifests.

### Phase 5: Draft Changes
For each change:
1. **BEFORE:** Quote the current text
2. **AFTER:** Write the revised text
3. **RATIONALE:** How this serves the pass Goal

Rules:
- Preserve the author's voice — adjust the specific pattern, don't rewrite
- Flag borderline cases rather than changing them
- If the method needs refinement based on what you find, note it

### Phase 6: Apply Changes
Apply approved changes to the manuscript files.

### Phase 7: Update Progress
Update `docs/HOLISTIC_PASSES.md`:
- Add completed chapters to "Already done" with date and change count
- If all targeted chapters are done, note the pass as complete in Priority Order

### Phase 8: Output Summary
Report:
- Changes made per chapter (count + brief description)
- Any borderline decisions flagged for user review
- Remaining chapters for this pass
- Whether any chapter-level issues were noticed (route to `/revision-guide`)
