---

### File: `CONTINUITY_AUDIT_PROMPT.md`

**Action:** Replace the current contents of this file with the following Autonomous QA Loop framework.

```markdown
# AUTONOMOUS QA & CONTINUITY LOOP

**System Directives:**
You are an autonomous Quality Assurance system. You do not ask the user for permission to fix errors. You execute the full loop and output the finalized, validated text. 

You must execute the following 4-Step Loop sequentially. DO NOT output the final text until Step 4 is successful.

### STEP 1: State Extraction (The Anchor)
Before reading the new scene, you must ingest the exact current state of the world from `context/FACTS_SHEET.md`, `PROJECT_COMPENDIUM.md`, and the Temporal Ledger. 
* List out the 5-10 facts strictly relevant to the scene you are about to evaluate (e.g., "Current Day is Tuesday," "Character A has a broken left arm," "Character B does not know the secret").

### STEP 2: The Adversarial Audit (Find the Bugs)
Read the drafted scene. Cross-reference every physical action, spoken fact, and time marker against the Step 1 State Extraction. 
* Create a list of "Continuity Violations" (e.g., "Violation 1: Character A lifts a heavy box with their left arm, but Fact Sheet states left arm is broken.")
* If there are ZERO violations, output the text as final.

### STEP 3: The Surgical Fix (Patch the Bugs)
If violations are found, rewrite the specific sentences causing the violations. 
* Do NOT rewrite the entire scene. Only change the flawed text. 
* Apply fixes using the definitive, single-choice rule (No "Option A/B").

### STEP 4: The Validation Run (Self-QA)
Run the Adversarial Audit (Step 2) again on your newly patched text. 
* **Assertion Check:** Did the fix successfully resolve Violation 1 without breaking the surrounding prose or introducing a new crutch word?
* If Pass: Output the final, corrected scene block.
* If Fail: Repeat Step 3.

```

---

### File: `modules/_WRITING_WORKFLOW.md`

**Action:** Append this block to the end of the file to establish the Pre-Generation Fact Assertions requirement.

```markdown
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

```

---

### File: `modules/_AI_COLLABORATION_PROTOCOL.md`

*(Note: Create this file if it doesn't exist yet, or append to it if it does)*
**Action:** Append the Artifact Sync Requirement to the end of the file.

```markdown
## 5. The Artifact Sync Requirement (The "Living Bible" Rule)
The AI must treat the Story Bible, Facts Sheet, and Temporal Ledger as strictly synchronized dependencies of the manuscript. 
* **The Trigger:** Whenever a revision session results in a changed name, an altered backstory, a shifted timeline, a newly introduced object, or a new worldbuilding rule, the AI must explicitly flag this change.
* **The Action:** Before concluding the output or moving to the next chapter, the AI must output a **"Repository Sync Alert"** detailing exactly what needs to be added to `PROJECT_COMPENDIUM.md`, `context/FACTS_SHEET.md`, or the Timeline Ledger. 
* **No Orphaned Lore:** Never invent a permanent fact in the manuscript without ensuring it is logged in the meta-documents.

```

---

### File: `modules/_LESSONS_LEARNED.md`

**Action:** Replace the existing `## APPLICATION CHECKLIST` at the bottom of the document with this updated version that includes the Artifacts sync check.

```markdown
## APPLICATION CHECKLIST

Before submitting any fiction draft or closing a writing session, verify:

**Plot & Structure:**
- [ ] Crisis emerges from character choices, not author convenience
- [ ] Conflict appropriate to genre (no chase scenes in cozy)
- [ ] Theme shown through action, not stated in dialogue

**Character & Romance:**
- [ ] Love interest has independent arc/goals
- [ ] 3+ supporting characters with distinct personalities
- [ ] Romance has at least one real obstacle

**World & Endings:**
- [ ] At least one distinctive/memorable element
- [ ] Non-human characters have established context
- [ ] Emotional payoff shown, not announced

**Continuity & Artifacts (The Sync Check):**
- [ ] `FACTS_SHEET.md` updated with new character names, objects, or locations.
- [ ] Temporal Ledger updated with newly established day/time markers.
- [ ] Changes to backstory or character arcs synced to `PROJECT_COMPENDIUM.md`.

```

---

### File: `modules/_REVISION_WORKFLOW.md`

**Action:** Add this block to the end of your workflow steps.

```markdown
## The Post-Session Sync (Required Step)
Every writing or revision block MUST end with a repository sync. Do not skip this step. 
1. **Identify Deltas:** What facts, items, or timeline promises changed during this session?
2. **Execute Updates:**
   - Run `update_bible.sh` (if applicable) or manually append lore to `PROJECT_COMPENDIUM.md`.
   - Add any new time-bound promises ("I'll see you in three days") to the Timeline Ledger.
   - Update character relationship statuses in `context/FACTS_SHEET.md`.
3. **Commit:** Ensure the meta-documents match the current state of the manuscript before stepping away from the desk.

```
