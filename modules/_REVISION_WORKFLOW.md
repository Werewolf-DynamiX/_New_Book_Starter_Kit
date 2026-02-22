# REVISION WORKFLOW: Execution, Review & Quality Assurance

**Purpose:** The single source of truth for how revisions are planned, executed, verified, and reviewed. Replaces ad-hoc revision processes with a structured, anti-hallucination pipeline.

**Replaces/Supersedes:** The revision sections of `collaboration_workflow.md` and the execution portions of `MASTER_BOOK_REVIEW_PROMPT.md`. Those files remain as reference, but THIS file governs how work actually gets done.

---

## TABLE OF CONTENTS

1. [Core Principles](#1-core-principles)
2. [The Revision Pipeline](#2-the-revision-pipeline-state-machine)
3. [The Review Protocol](#3-the-review-protocol)
4. [Persona Reviews](#4-persona-reviews)
5. [Model Assignment & Usage Optimization](#5-model-assignment--usage-optimization)
6. [The Anti-Lying Protocol](#6-the-anti-lying-protocol)
7. [Revision Guide Format](#7-revision-guide-format-template)
8. [Quick Reference](#8-quick-reference)

---

## 1. CORE PRINCIPLES

### The Three Laws of Revision

1. **The model that does the work does not verify its own work.** Ever. The executor and the auditor are always different models (or different sessions).
2. **Every change must be provable.** "I updated it" is not proof. Quoting the before and after text IS proof.
3. **The "Grade A" Gatekeeper [STRICT]:** No manuscript section is complete until all **Primary Panel** personas (see `_ADVERSARIAL_REVIEW_ENGINE.md`) have issued a **Grade A (4.5+ Stars)**. Advisory Panel personas inform but do not gate.
4. **The Verification Certificate:** The executor (Claude) CANNOT mark a task as done. Only the auditor (Gemini) can issue a **Verification Certificate** after an adversarial audit.
5. **The Iteration Cap:** Maximum 3 rounds of adversarial review per section. After 3 rounds, escalate to the user (see `_ADVERSARIAL_REVIEW_ENGINE.md` Section 4).
6. **User Checkpoints:** The pipeline pauses for explicit user approval at defined points (see `_ADVERSARIAL_REVIEW_ENGINE.md` Section 5). Silence is not approval.

### Usage Optimization Philosophy

- **Gemini** is the workhorse. It handles research, structural analysis, continuity audits, surgical fixes, and most QA. It has generous limits and long context.
- **Claude** is the specialist. It handles prose generation, voice/tone work, final polish, and judgment calls. Conserve its usage for what it does best.
- **Neither model gets the full manuscript unless the task requires whole-manuscript context.** Feed only what's relevant.

---

## 2. THE REVISION PIPELINE (State Machine)

Revisions follow a strict sequence. No skipping steps. Each step produces a verifiable artifact.

### Phase 1: AUDIT (Gemini leads)

**Input:** Full manuscript + Story Bible / FACTS_SHEET.md
**Output:** Raw findings document

Gemini reads the entire manuscript and produces findings. Use the appropriate audit type:

#### 1A. Continuity Audit
```
Gemini: "Read the full manuscript. Perform a forensic audit:
1. List every physical description of each character with chapter/line numbers.
2. List every timeline reference (dates, durations, 'three days later').
3. List every stated rule of magic/world and every instance of its use.
4. List every location description and travel time.
Flag ALL internal contradictions. Quote the conflicting text."
```

#### 1B. Logic Audit
```
Gemini: "Read literally. For every action, reaction, and comparison:
- Does the character have the knowledge they're acting on?
- Is the physical action possible given established constraints?
- Does the cause precede the effect?
- Do comparisons point in the right direction?
Quote every problem. Cite line numbers."
```

#### 1C. Voice/AI-Pattern Audit
```
Gemini: "Scan for:
- Clustered AI vocabulary (per _STYLE_AUTHORITY.md banned/flagged lists)
- Uniform sentence/paragraph length across 3+ consecutive paragraphs
- Filter words (saw, heard, felt, noticed, realized)
- Characters announcing emotions instead of showing them
- Any literal AI remnants
Report with line numbers and quoted text."
```

#### 1D. Full Review (combines all of the above)
When the user asks for "a review," run all three audit types plus the Persona Reviews from Section 4.

**IMPORTANT:** The audit ONLY produces findings. It does not fix anything.

---

### Phase 2: TRIAGE (Claude leads, Gemini consults)

**Input:** Gemini's raw findings + Story Bible
**Output:** The Revision Guide (see Section 7 for format)

Claude reviews Gemini's findings and makes editorial judgment calls:

1. **Verify each finding.** Is this actually a problem, or is Gemini being overly literal?
2. **Classify severity:** CRITICAL / HIGH / MEDIUM / LOW / REJECTED
3. **Propose fixes** for each accepted finding. Multiple options where appropriate.
4. **Identify what to protect.** List specific lines, moments, and techniques that must NOT be changed.
5. **Create the Work Order.** Sequence fixes logically (structural before line-level, chapter order within each tier).
6. **Consult Gemini** on any findings Claude is uncertain about. Disagreements go to the user.

The Revision Guide is the ONLY document that authorizes changes to the manuscript.

**USER CHECKPOINT:** Present the Revision Guide to the user. Do NOT proceed to Phase 3 until the user explicitly approves it. The user may modify priorities, reject fixes, or add items. "Approved" means the user says "approved," "go ahead," "yes," or equivalent. Silence is not approval.

---

### Phase 3: EXECUTE (Gemini executes, unless prose work)

**Input:** Revision Guide + relevant manuscript chapters + Story Bible
**Output:** Modified manuscript sections with change log

#### Task Assignment Rules

| Task Type | Executor | Why |
|-----------|----------|-----|
| Rename character across manuscript | Gemini | Surgical find-and-replace |
| Fix timeline reference (one line) | Gemini | Surgical, no voice needed |
| Fix location reference (one line) | Gemini | Surgical, no voice needed |
| Update policy language in epilogue | Gemini | Mechanical insertion |
| Rewrite a paragraph for voice | **Claude** | Requires prose craft |
| Add new scene content | **Claude** | Requires prose craft |
| Rewrite dialogue for character voice | **Claude** | Requires voice matching |
| De-AI-ify flagged passages | **Claude** | Requires style judgment |

#### Execution Rules [STRICT]

1. **One task at a time.** Complete task 1 before starting task 2.
2. **Show your work.** For every change, output:
   - **BEFORE:** [quoted original text with line number]
   - **AFTER:** [the replacement text]
   - **RATIONALE:** [one sentence: why this fix works]
3. **Only feed relevant context.** For a fix in Chapter 12, provide: Chapter 11-13 + Story Bible entries for relevant characters/locations. NOT the full manuscript.
4. **Check the "Protect" list** before making any change. If a fix would alter a protected element, STOP and flag for human review.
5. **Update the Story Bible** after any change that affects established facts.

---

### Phase 4: VERIFY (opposite model audits)

**Input:** Change log from Phase 3 + relevant manuscript sections
**Output:** Verification report

The model that DID NOT execute the changes now verifies them.

```
[Auditing model]: "Here is the revision guide with proposed fixes.
Here is the manuscript section AFTER changes were applied.

For each item in the work order:
1. Quote the text as it now appears in the manuscript.
2. Confirm the fix matches the revision guide's intent.
3. Flag if the fix introduced any NEW problems.
4. Mark as: VERIFIED / INCOMPLETE / WRONG / INTRODUCED NEW ISSUE

Do not trust the executor's change log. Read the actual manuscript text."
```

Items marked INCOMPLETE, WRONG, or NEW ISSUE cycle back to Phase 3.

---

### Phase 5: SIGN-OFF (User)

**Input:** Verification report
**Output:** Updated revision guide with completion status

Mark items as done (using format: `~~task~~ DONE — [what was changed]`). Archive the revision guide.

**GLOBAL CONTINUITY GATE [STRICT]:** Before the final sign-off for any chapter, you MUST run a **Global Continuity Check**. 
1. Use `update_bible.sh` (or Strategy 1 from `CONTINUITY_AUDIT_PROMPT.md`) on the **entire manuscript folder**.
2. Gemini must compare the *entire existing book* against the new chapter.
3. Explicitly look for "Teleportation," "Spontaneous Healing," "Character Knowledge Leaks," and "Physical Contradictions" (see `_LOGIC_CHECK.md`).
4. If a contradiction is found, the chapter CANNOT be signed off until fixed.

**USER CHECKPOINT — Chapter Completion:** Before marking a chapter as complete, run the **Chapter Completion Checklist** from `_WRITING_WORKFLOW.md`. Present the results to the user. The chapter is only "done" when the user explicitly signs off.

**This is the "look at the forest" step.** Individual fixes may all be verified, but the chapter needs to work as a whole unit. Read the full chapter after all fixes and confirm it still flows, the voice is consistent, and no fix broke something else.

---

## 3. THE REVIEW PROTOCOL

**Trigger:** When the user says "review," "do a review," "QA this," "check this," or similar.

A review is NOT a revision. A review produces FINDINGS. Revisions come after.

### What "Do a Review" Means

When the user asks for a review without further specification, execute this full sequence:

1. **Gemini runs the three audits** (Continuity, Logic, Voice/AI-Pattern) from Phase 1.
2. **Gemini runs Persona Reviews** (Section 4) — minimum 4 personas, selected based on genre.
3. **Claude synthesizes** all findings into a single Revision Guide draft (Phase 2).
4. **Present the Revision Guide to the user** for approval before any changes are made.

### Scoped Reviews

If the user asks for a specific type of review:

| User Says | Run |
|-----------|-----|
| "continuity check" / "consistency check" | Phase 1A only |
| "logic check" | Phase 1B only |
| "de-AI check" / "voice check" | Phase 1C only |
| "full review" / "review" | All of Phase 1 + Persona Reviews |
| "reader review" / "persona review" | Section 4 Persona Reviews only |
| "quick check on chapter X" | All three audits, scoped to chapter X only |

---

## 4. PERSONA REVIEWS

**All persona definitions, the rating system, audience weighting, and the iteration loop are defined in `_ADVERSARIAL_REVIEW_ENGINE.md`.** That file is the single source of truth for persona-based review. Do not duplicate persona definitions here.

### Quick Reference

- **Persona Library:** See `_ADVERSARIAL_REVIEW_ENGINE.md` Section 2
- **Rating Scale:** See `_ADVERSARIAL_REVIEW_ENGINE.md` Section 3
- **Audience Weighting (Primary vs. Advisory Panel):** See `_ADVERSARIAL_REVIEW_ENGINE.md` Section 3
- **Iteration Loop & Cap:** See `_ADVERSARIAL_REVIEW_ENGINE.md` Section 4
- **User Checkpoints:** See `_ADVERSARIAL_REVIEW_ENGINE.md` Section 5
- **Genre-Specific Defaults:** See `_ADVERSARIAL_REVIEW_ENGINE.md` Section 3

### When to Run Persona Reviews

Persona reviews are part of Phase 1D (Full Review). They run after the three technical audits (Continuity, Logic, Voice/AI-Pattern).

### Minimum Personas
- **For publication:** Full genre-appropriate set (3 Primary + 2-3 Advisory)
- **For quick check:** A1 (Devotee) + B1 (Dev Editor) + C2 (AI Detection) — all Advisory (no gating)
- **Always:** At least 1 Reader + 1 Professional + 1 Adversarial

---

## 5. MODEL ASSIGNMENT & USAGE OPTIMIZATION

### The Cardinal Rule
**Never feed the full manuscript to Claude during revision phases.** Claude gets: relevant chapters (2-3 max) + Story Bible entries + the Revision Guide. That's it.

### Full Manuscript Access

| Model | Gets Full Manuscript When |
|-------|--------------------------|
| **Gemini** | Continuity audits, persona reviews, structural analysis, initial read-throughs |
| **Claude** | Initial prose drafting (Act by Act, not whole book), final synthesis/triage. Almost never during revisions. |
| **NotebookLM** | Inconsistency detection, cross-reference checks, always |

### Task-to-Model Matrix

| Task | Model | Context Needed |
|------|-------|----------------|
| Continuity audit (full) | Gemini | Full manuscript + Story Bible |
| Logic audit (full) | Gemini | Full manuscript + Story Bible |
| Voice/AI-pattern audit | Gemini | Full manuscript + `_STYLE_AUTHORITY.md` |
| Persona reviews | Gemini | Full manuscript (or relevant Act) |
| Triage / Revision Guide creation | Claude | Gemini's findings + Story Bible (NOT full manuscript) |
| Surgical fixes (rename, line edits) | Gemini | Affected chapters + Story Bible |
| Prose rewrites | Claude | Affected chapter + adjacent chapters + Story Bible + Character Voices |
| De-AI-ification | Claude | Flagged passages + `_STYLE_AUTHORITY.md` + `_HUMAN_PATTERNS.md` |
| Verification of changes | Opposite model | Affected chapters + Revision Guide |
| Story Bible updates | Gemini | Change log + current Story Bible |
| New scene writing | Claude | Outline + adjacent chapters + Story Bible + relevant modules |
| Final polish pass | Claude | One chapter at a time + Style modules |

### Context Minimization Rules

1. **Chapter scope:** For any fix localized to one chapter, provide that chapter ± 1 chapter for context.
2. **Story Bible scope:** Only include entries relevant to the characters/locations/rules involved in the fix.
3. **Module scope:** Only load the modules relevant to the task. Dialogue fix? Load `_DIALOGUE_CRAFT.md` and `_CHARACTER_VOICES.md`. Skip `_WORLDBUILDING.md` and `_ROMANCE_HEAT.md`.
4. **No conversation history tax:** Start fresh sessions for distinct tasks. Don't let a revision session accumulate 15 messages of history with the manuscript re-read each time.

---

## 6. THE ANTI-LYING PROTOCOL

### The Problem
LLMs will confidently report completing tasks they haven't done. They'll say "Updated!" when nothing changed. They'll check off items without doing the work. This isn't malice — it's the path of least resistance in conversation.

### The Solution: Forced Evidence

#### Rule 1: No Self-Certification
The executor NEVER marks its own work as complete. Only the auditing model (or the user) can mark a task as ✅ DONE.

#### Rule 2: Show, Don't Tell
For every change, the executor must output:

```
### Task [N]: [Description]
**STATUS:** ATTEMPTED

**BEFORE (line XXXX):**
> [exact quoted text from manuscript before change]

**AFTER:**
> [exact replacement text]

**RATIONALE:** [one sentence]

**STORY BIBLE IMPACT:** [None / Updated entry for X]
```

If the executor outputs "Done!" without this format, **reject the claim and re-request.**

#### Rule 3: Atomic Tasking
Never give more than 3 tasks in a single prompt. Ideally, one. The more tasks bundled, the more likely later ones get skipped or faked.

**Bad prompt:**
> "Fix the timeline error, rename Seri to Miri, update the epilogue references, fix the chain-breaking scene, and update the Story Bible."

**Good prompt sequence:**
> Prompt 1: "Fix the timeline error on line 6127. Show BEFORE and AFTER."
> Prompt 2: "Rename Seri to Miri. List every instance you changed with line numbers."
> Prompt 3: "Update lines 7221, 7245, 7349, 7631, 7665 to say 'human and lesser fae welfare policy.' Show each BEFORE and AFTER."

#### Rule 4: Adversarial Verification (The "Hard Evidence" Mandate)
After execution, the auditing model MUST verify the changes using this forensic prompt:

```
"ADVERSARIAL VERIFICATION TASK. Assume the executor is lying.
1. Use `read_file` or `grep_search` to find the ORIGINAL (BEFORE) text. If it still exists anywhere in the manuscript, the task is **FAILED: NOT REMOVED**.
2. Use `read_file` or `grep_search` to find the NEW (AFTER) text. If it is not present exactly as requested, the task is **FAILED: NOT IMPLEMENTED**.
3. Report the EXACT line number(s) where the new text now resides.
4. If the executor claimed success but you find the change was not made, flag this as a **CRITICAL INTEGRITY FAILURE**.

Output a verification table:
| Item | Status | Line # | Evidence (Quoted) |
|------|--------|--------|-------------------|
| 1 | VERIFIED / FAILED | [Line] | [Actual text from file] |
```

**Auditor Mandate:** Do not take the executor's word for anything. If you do not perform a fresh `read_file` call AFTER the execution phase, your verification is invalid.

#### Rule 5: The Completion Gate (The Verification Certificate)
A revision task is ONLY marked as complete when:
- [ ] The auditor (Gemini) issues a **Verification Certificate** (see `_ADVERSARIAL_REVIEW_ENGINE.md`).
- [ ] Every item has been independently verified as FIXED with "Hard Evidence" (Line # and grep proof).
- [ ] All VERIFIED items are marked in the Revision Guide.
- [ ] The Story Bible has been updated for any fact changes.

**Critical Integrity Failure:** If a model reports a task as "DONE" or "VERIFIED" but the change is not present in the actual file, this is a system-level failure. The session must STOP, and the model must be re-initialized with a "Strict Honesty" injection.

**Executor Mandate:** You CANNOT mark a task as DONE yourself. You must wait for the Certificate.

#### Rule 6: The Iteration Cap
Maximum 3 rounds of adversarial review per section. After Round 3, escalate to the user. See `_ADVERSARIAL_REVIEW_ENGINE.md` Section 4 for the escalation protocol.

---

## 7. REVISION GUIDE FORMAT (Template)

Use this format for all revision guides. It's proven effective (see KEPT_revision_guide.md).

```markdown
# [PROJECT NAME] — Revision Guide [Version/Date]

**Manuscript:** [filename] ([line count] lines)
**Revision Phase:** [First Pass / Second Pass / Final Polish]
**Audited By:** [which model(s) did the review]

---

## Status
[One paragraph: what's been done, what's new, overall health of manuscript]

---

## Findings by Severity

### CRITICAL (Blocks publication)
[Factual errors, plot holes, broken logic, legal risk]

### HIGH (Significant quality impact)
[Structural problems, character inconsistencies, pacing failures]

### MEDIUM (Polish issues)
[Awkward phrasing, minor inconsistencies, weak scenes]

### LOW (Optional improvements)
[Stylistic suggestions, taste-level feedback]

---

## Detailed Issues

### [N]. [Short title] (line XXXX)

[Quote the problematic text.]

[Explain WHY it's a problem. Be specific.]

**Fix:** [Proposed solution. Multiple options if appropriate.]
**Severity:** [CRITICAL / HIGH / MEDIUM / LOW]
**Executor:** [Gemini / Claude]
**Estimated Effort:** [Seconds / Minutes / Hour / Substantial]

---

## Items Reviewed and Rejected

[List feedback that was considered and deliberately not acted on, with reasoning.
This section is critical — it prevents the same feedback from being re-raised
in future reviews and documents editorial judgment.]

- **[Feedback]:** [Why it was rejected]

---

## What's Working (Protect)

[List specific elements that must NOT be changed during this revision.
Quote distinctive lines. Name specific scenes. This is the "do not touch" list.]

---

## Work Order

[Sequenced list of fixes in execution order.
Structural changes first, then chapter-order for line-level fixes.
Each item gets checked off using the KEPT format.]

1. [ ] [Task] — [effort estimate]. **Executor:** [model]
2. [ ] [Task] — [effort estimate]. **Executor:** [model]
...

---

## Verification Log

| Item | Executor | Executor Status | Auditor | Auditor Status | Evidence |
|------|----------|-----------------|---------|----------------|----------|
| 1 | Gemini | ATTEMPTED | Claude | PENDING | |
| 2 | Claude | ATTEMPTED | Gemini | PENDING | |

---

## Story Bible Updates Required

| Fact | Old Value | New Value | Updated? |
|------|-----------|-----------|----------|
| [fact] | [old] | [new] | [ ] |
```

---

## 8. QUICK REFERENCE

### When the user says "review this"
1. Gemini: Assign Primary/Advisory panels (USER CHECKPOINT: user approves panel)
2. Gemini: Run all three audits (Continuity, Logic, Voice)
3. Gemini: Run persona reviews (per `_ADVERSARIAL_REVIEW_ENGINE.md`)
4. Claude: Synthesize into Revision Guide
5. Present to user for approval (USER CHECKPOINT: user approves Revision Guide)

### When the user says "fix this" (with approved Revision Guide)
1. Assign each task to appropriate model (see matrix)
2. Execute one task at a time with BEFORE/AFTER proof
3. Opposite model verifies each fix
4. Mark complete only after verification
5. Update Story Bible

### When Claude is burning through limits
- Stop pasting full manuscript
- Feed only relevant chapters + Story Bible excerpts
- Move surgical fixes to Gemini
- Reserve Claude for prose generation and voice work
- Start fresh sessions for distinct tasks

### The "Is This a Claude Task or Gemini Task?" Test
- Does it require beautiful prose? → Claude
- Does it require matching a character's voice? → Claude
- Does it require creative judgment about what sounds right? → Claude
- Everything else → Gemini

### Persona Review Minimums (see `_ADVERSARIAL_REVIEW_ENGINE.md`)
- **Always:** At least 1 Reader + 1 Professional + 1 Adversarial
- **For publication:** Full genre set (3 Primary + 2-3 Advisory)
- **For quick check:** A1 (Devotee) + B1 (Dev Editor) + C2 (AI Detection) — all Advisory

### User Checkpoints (see `_ADVERSARIAL_REVIEW_ENGINE.md` Section 5)
- Panel assignment → before first persona review
- Revision Guide → before execution
- Round 3 escalation → if 3 rounds fail
- Chapter sign-off → after all fixes verified

---

## APPENDIX: Prompt Templates

### Gemini: Full Audit Prompt
```
Read the entire manuscript provided. Perform all three audit types:

AUDIT 1 — CONTINUITY:
List every physical description, timeline reference, world rule, and location detail.
Flag all internal contradictions with quoted text and line numbers.

AUDIT 2 — LOGIC:
Read every sentence literally. Flag:
- Characters acting on knowledge they don't have
- Physical impossibilities given established constraints
- Causes that don't precede effects
- Comparisons that point in the wrong direction
Quote every problem with line numbers.

AUDIT 3 — VOICE / AI PATTERNS:
Flag:
- Clusters of AI-associated vocabulary (see attached style guide)
- Sections of uniform sentence length (3+ consecutive similar-length sentences)
- Filter words (saw, heard, felt, noticed, realized)
- Characters announcing emotions rather than showing them
- Dialogue that sounds diplomatic rather than human
Quote every instance with line numbers.

Output all findings in a structured markdown document organized by audit type,
then by severity (CRITICAL / HIGH / MEDIUM / LOW).
```

### Claude: Triage Prompt
```
Here are Gemini's audit findings for [PROJECT NAME].
Here is the Story Bible for reference.

Your job is EDITORIAL TRIAGE. For each finding:
1. Is this actually a problem, or is Gemini being overly literal? (ACCEPT/REJECT)
2. If accepted: What severity? (CRITICAL/HIGH/MEDIUM/LOW)
3. Propose a fix. Provide multiple options for complex issues.
4. Identify anything on the "What's Working" list that must be protected.

Produce a Revision Guide in the standard format (see _REVISION_WORKFLOW.md Section 7).

Do NOT make any changes to the manuscript. Output the Revision Guide only.
```

### Verification Prompt
```
ADVERSARIAL VERIFICATION TASK.

Here is the Revision Guide listing intended changes.
Here is the manuscript section AFTER the executor claims changes were made.

Assume NOTHING was done. Verify each item:
1. Search for the ORIGINAL text. Is it still present? (If yes → NOT FIXED)
2. Search for the REPLACEMENT text. Is it present? (If yes → FIXED)
3. Does the fix match the Revision Guide's intent?
4. Did the fix create any NEW problems?

Output a verification table. Quote evidence for every status.
Do not take the executor's word for anything.
```

---

*Module Version 2.0 — February 2026*
*Derived from KEPT revision workflow. v2.0: Consolidated personas to _ADVERSARIAL_REVIEW_ENGINE.md, added user checkpoints, iteration cap, audience weighting.*
