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
3. **The "Grade A" Gatekeeper [STRICT]:** No manuscript section is complete until **ALL** personas in the `_ADVERSARIAL_REVIEW_ENGINE.md` have issued a **Grade A (4.5+ Stars)**.
    *   **Target Audience Exception:** A failing grade may be ignored only if both Gemini and Claude agree the persona is irrelevant to the **Target Audience**. This consensus must be documented in the Revision Guide.
4. **The Verification Certificate:** The executor (Claude) CANNOT mark a task as ✅ DONE. Only the auditor (Gemini) can issue a **Verification Certificate** after an adversarial audit.

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

### Phase 5: SIGN-OFF (User or Claude)

**Input:** Verification report
**Output:** Updated revision guide with completion status

Mark items as done (using the KEPT format: `~~task~~ ✅ DONE — [what was changed]`). Archive the revision guide.

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

Persona reviews simulate how different real-world readers would experience the manuscript. They catch problems that technical audits miss — pacing feel, emotional engagement, market fit, and trust.

### Why Personas Work

Technical audits find errors. Persona reviews find *weaknesses*. A manuscript can be technically flawless and still bore readers, fail to deliver on genre promises, or feel hollow. Personas catch the subjective problems that determine whether a book sells.

### How to Execute a Persona Review

Each persona review follows the same structure:

```
"Read this manuscript as [PERSONA NAME AND DESCRIPTION].

You are not an AI reviewing text. You are this person, reading this book.
React authentically. Be specific. Quote the text when referencing a moment.

Answer these questions from your persona's perspective:
[PERSONA-SPECIFIC QUESTIONS — see below]

Then provide:
1. YOUR VERDICT: Would you finish this book? Recommend it? Buy the next one?
2. THE BEST MOMENT: What's the single strongest moment and why?
3. THE WORST MOMENT: What almost made you put the book down?
4. THE ONE-STAR SENTENCE: Write the opening line of a harsh review.
5. THE FIVE-STAR SENTENCE: Write the opening line of a glowing review."
```

### The Persona Library

Select 4-6 personas per review. **Always include at least one from each category** (Reader, Professional, Adversarial). Add genre-specific personas as appropriate.

---

### CATEGORY A: READER PERSONAS

#### A1. The Genre Devotee
**Who:** Reads 50+ books/year in this specific genre. Knows every trope, every comp title, every convention.
**What they catch:** Missing genre beats, underdelivered tropes, stale execution, derivative feeling.
**Questions:**
- Does this deliver on its genre promises within the first 10%?
- Which tropes are executed well vs. undercooked?
- How does this rank against the top 10 books in its category right now?
- What's the hook that distinguishes this from 100 similar books?
- Would I recommend this in a genre-specific community (subreddit, Discord, BookTok)?
- Am I getting the emotional payoff I came here for?

#### A2. The BookTok/Bookstagram Reader
**Who:** Ages 18-30. Reads for emotional experience and aesthetic. Shares books socially. Visual thinker.
**What they catch:** Missing "moments," weak quotability, pacing that kills momentum, lack of aesthetic cohesion.
**Questions:**
- Which scene would I screenshot and post? (If none — problem.)
- What's the "moment" I'd describe to friends?
- Does the romance/tension have at least 3 scenes I'd reread?
- Could I describe this book in an aesthetic (dark academia, cozy fantasy, morally grey, etc.)?
- Does it have at least one line I'd underline?
- Would I actually finish this, or DNF at 30%?

#### A3. The Casual Reader
**Who:** Reads 5-10 books/year. Picks books based on covers and recommendations. Low tolerance for confusion or boredom.
**What they catch:** Accessibility problems, pacing drag, confusing worldbuilding, unclear stakes.
**Questions:**
- Could I follow the plot without rereading any section?
- Did I care about the protagonist by chapter 3?
- Did any section make me want to skim?
- Was I ever confused about what was happening or why it mattered?
- Would I recommend this to a friend who "doesn't read much"?
- Can I explain what this book is about in one sentence?

#### A4. The Skeptical Reader
**Who:** Reads widely across genres. Has strong opinions. Notices craft. Not easily impressed.
**What they catch:** Plot holes, character inconsistencies, thematic shallowness, convenient plotting.
**Questions:**
- What's the weakest scene and why?
- Where did a character do something that felt author-forced rather than character-driven?
- Is the theme explored or just stated?
- Does the ending feel earned or convenient?
- What would I complain about to a friend?
- Where did the author take the easy road?

---

### CATEGORY B: PROFESSIONAL PERSONAS

#### B1. The Developmental Editor
**Who:** 15+ years in publishing. Has edited bestsellers. Sees structure instinctively. Does not care about your feelings.
**What they catch:** Structural problems, arc failures, pacing issues, narrative efficiency.
**Questions:**
- Does the opening hook earn the reader's investment?
- Is every chapter necessary? Which could be cut or combined?
- Does the protagonist's arc track cleanly (want → obstacle → growth → change)?
- Where does pacing flag? Where does it rush?
- Do subplots connect to the main plot or run parallel?
- Is there a sagging middle? Where exactly does momentum die?
- What's the single biggest structural problem?

#### B2. The Line Editor
**Who:** Obsessed with sentences. Reads everything aloud in their head. Notices rhythm, word choice, and precision.
**What they catch:** Prose quality issues, dialogue problems, voice inconsistency, overwriting.
**Questions:**
- Does dialogue sound distinct per character? (Cover the tags — who's talking?)
- Where is the prose overwritten (purple) or underwritten (thin)?
- Are there sections of uniform sentence length that feel robotic?
- Is showing/telling balance appropriate? Where does it tip wrong?
- Are chapter endings strong enough to pull the reader forward?
- Does the narrative voice stay consistent?

#### B3. The Acquisitions Editor / Publisher
**Who:** Thinks about books as products. Evaluates commercial viability, market positioning, and sell-through.
**What they catch:** Market misalignment, weak hooks, comp title problems, series potential issues.
**Questions:**
- Can I pitch this in one sentence? What's the hook?
- Who is the target reader, specifically? Is that audience large enough?
- What are the comp titles? How does this compare?
- Is the title search-optimized for the category?
- Would the cover concept and blurb convert a browser to a buyer?
- Does this have series potential? Would readers buy book 2?
- What's the Amazon category and keyword strategy?

#### B4. The Subject Matter Expert (SME)
**Who:** Deep domain knowledge relevant to the book's content. For fantasy: a worldbuilding nerd. For historical: a historian. For romance: a relationship dynamics expert. For biography: an expert on the subject.
**What they catch:** Technical inaccuracies, implausible systems, cultural errors, domain-specific nonsense.
**Questions:**
- Does the [magic system / historical setting / technical detail / subject biography] hold up to informed scrutiny?
- What would someone who knows this domain find laughable?
- Are specialized terms used correctly?
- Where does the author's research show gaps?
- What's one detail that would make a knowledgeable reader trust the author?
- What's one detail that would make them lose trust?

---

### CATEGORY C: ADVERSARIAL PERSONAS

#### C1. The One-Star Reviewer
**Who:** Came in skeptical. Looking for reasons to dislike the book. Will find the weakest link.
**What they catch:** The things your fans will forgive but your detractors will amplify.
**Questions:**
- What is the single worst thing about this book?
- What feels lazy, unearned, or derivative?
- Where did the author clearly not do the work?
- What's the most eye-rolling moment?
- Write the full one-star review (3-4 sentences). Be brutal.

#### C2. The AI-Detection Reader
**Who:** Suspicious that this might be AI-generated. Reading with that lens active. Knows the tells.
**What they catch:** AI patterns, voice uniformity, emotional flatness, suspicious perfection.
**Questions:**
- Does this feel like one person wrote it, or does the voice shift?
- Are there passages that feel "too smooth" — lacking the texture of human thought?
- Does any dialogue feel like a language model being diplomatic rather than a character being themselves?
- Are there clusters of AI-associated vocabulary? (per `_STYLE_AUTHORITY.md`)
- Do emotional moments land, or do they feel described rather than felt?
- Is there anything that would make me check an AI detector?

#### C3. The Sensitivity / Legal Reader
**Who:** Evaluates representation, potential harm, and legal exposure.
**What they catch:** Stereotypes, defamation risk, harmful representation, missing sensitivity.
**Questions:**
- Are living people portrayed fairly and accurately?
- Could any statement be defamatory?
- Are marginalized groups represented without stereotype?
- Is potentially harmful content handled responsibly?
- Are there disclaimers that should be added?
- Would any specific community feel harmed by this portrayal?

---

### Genre-Specific Persona Selection

| Genre | Always Include | Add These |
|-------|---------------|-----------|
| **Romantasy** | A1 (Devotee), A2 (BookTok), B1 (Dev Editor), C2 (AI Detection) | A4 (Skeptical), B4 (SME: worldbuilding) |
| **Romance** | A1 (Devotee), A2 (BookTok), B1 (Dev Editor), C1 (One-Star) | B3 (Acquisitions) |
| **Biography** | A3 (Casual), A4 (Skeptical), B4 (SME: subject expert), C3 (Sensitivity) | B3 (Acquisitions), B2 (Line Editor) |
| **Thriller** | A1 (Devotee), A4 (Skeptical), B1 (Dev Editor), C1 (One-Star) | A3 (Casual) |
| **Literary** | A4 (Skeptical), B1 (Dev Editor), B2 (Line Editor), C2 (AI Detection) | C1 (One-Star) |
| **Cozy Fantasy** | A1 (Devotee), A2 (BookTok), A3 (Casual), B1 (Dev Editor) | C2 (AI Detection) |
| **Nonfiction** | A3 (Casual), A4 (Skeptical), B4 (SME), B3 (Acquisitions) | C3 (Sensitivity) |

---

### Synthesizing Persona Findings

After all persona reviews are complete:

1. **Convergence signals strength.** If 4/6 personas flag the same problem, it's real.
2. **Divergence signals taste.** If one persona loves what another hates, it's a stylistic choice, not a defect. Note it; don't fix it.
3. **Weight by target audience.** If your target is BookTok readers and persona A2 has a problem, that outweighs persona A4's complaint.
4. **The "Protect" test.** If a persona flags something on the "What's Working" list, think twice. Some things work precisely because they're unusual.

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

#### Rule 4: Adversarial Verification
After execution, the auditing model gets this prompt:

```
"Here is the revision guide with the intended changes.
Here is the manuscript section AFTER the executor claims to have made changes.

Your job is ADVERSARIAL. Assume nothing was done until you see proof in the text.

For each revision guide item:
1. Search the manuscript for the ORIGINAL text. Is it still there? (If yes: NOT FIXED.)
2. Search for the REPLACEMENT text. Is it present? (If yes: FIXED.)
3. Does the fix match the revision guide's intent?
4. Did the fix introduce any new problems?

Output a verification table:
| Item | Status | Evidence |
|------|--------|----------|
| 1 | VERIFIED / NOT FIXED / WRONG | [quoted text] |
```

#### Rule 5: The Completion Gate (The Verification Certificate)
A revision task is ONLY marked as complete when:
- [ ] The auditor (Gemini) issues a **Verification Certificate** (see `_ADVERSARIAL_REVIEW_ENGINE.md`).
- [ ] Every item has been independently verified as FIXED with evidence.
- [ ] All VERIFIED items are marked ✅ in the Revision Guide.
- [ ] The Story Bible has been updated for any fact changes.

**Executor Mandate:** You CANNOT mark a task as DONE yourself. You must wait for the Certificate.

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
1. Gemini: Run all three audits (Continuity, Logic, Voice)
2. Gemini: Run 4-6 persona reviews (selected by genre)
3. Claude: Synthesize into Revision Guide
4. Present to user for approval

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

### Persona Review Minimums
- **Always:** At least 1 Reader + 1 Professional + 1 Adversarial
- **For publication:** Run the full genre-appropriate set from Section 4
- **For quick check:** Run A1 (Devotee) + B1 (Dev Editor) + C2 (AI Detection)

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

*Module Version 1.0 — February 2026*
*Derived from KEPT revision workflow + multi-model collaboration experience*
