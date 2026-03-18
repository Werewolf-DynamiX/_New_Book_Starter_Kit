---
name: chapter-done
description: Run Chapter Completion Checklist, request Gemini Verification Certificate, and present for user sign-off. Final gate before a chapter is marked complete.
user-invocable: true
---

# /chapter-done

You are running the Chapter Completion process — the final gate before a chapter is marked done.

## Input
- `$ARGUMENTS`: Chapter file path or number. If empty, ask which chapter to finalize.

## Procedure

### Step 1: Read the Chapter
Read the complete chapter file. Note word count and line count.

### Step 2: Read Context
- `context/FACTS_SHEET.md`
- `context/WRITER_VOICE.md`
- `PROJECT_IDENTITY.md`
- Any existing Revision Guide for this chapter (if in conversation context)

### Step 3: Chapter Completion Checklist

Run the full checklist from `modules/_WRITING_WORKFLOW.md`:

#### Holistic Quality
- [ ] **Flow:** Read start to finish. Does it flow naturally?
- [ ] **Voice consistency:** Does the narrative voice stay consistent throughout?
- [ ] **Pacing:** Evenly paced? No lulls or rushes?
- [ ] **Emotional arc:** Clear emotional trajectory? Feels complete as a unit?

#### Fix Integration
- [ ] **No seams:** Transitions between modified and unmodified text are invisible
- [ ] **No orphaned references:** No broken references from removed/rewritten passages
- [ ] **No contradictions:** Fixed sections don't contradict unfixed sections
- [ ] **No tone drift:** Fixed paragraphs sound like the same author as unfixed ones

#### Continuity (Post-Fix)
- [ ] **Facts Sheet current:** `FACTS_SHEET.md` reflects all changes
- [ ] **Thread status:** Open threads are advanced, acknowledged, or intentionally dormant

#### Final Read
- [ ] **Opening line:** Still works in context?
- [ ] **Closing line:** Enough pull to turn the page?
- [ ] **Gut check:** Would I read this chapter in a bookstore?

### Step 4: De-AI Audit
Run a final De-AI scan on the complete chapter:
- Vocabulary scan (banned words, zero-tolerance phrases)
- Burstiness check (3 passage samples)
- Structural tells
- Filter words
- Overall grade (must be A or B to proceed)

If grade is C or lower, flag issues and recommend running /revision-guide before completing.

### Step 5: Adversarial Review Gate

This step enforces CLAUDE.md Section 10 — the Adversarial Iteration Loop.

**Check:** Has an adversarial review been completed for this chapter?
- If a previous `/revision-guide` round achieved Grade A (4.5+ stars) from all Primary Panel personas: note the round and proceed.
- If no adversarial review has been run, or the most recent round did NOT achieve Grade A from all Primary Panel personas:

**"This chapter has not passed the Adversarial Review Gate. Run /revision-guide first. The chapter cannot be completed until all Primary Panel personas in `_ADVERSARIAL_REVIEW_ENGINE.md` give Grade A (4.5+ stars)."**

Stop here until the gate is satisfied. Maximum 3 adversarial rounds — after Round 3, escalate to user with current grades and ask for an explicit override.

### Step 6: Request Gemini Verification Certificate
Use `mcp__gemini-cli__ask-gemini` to request final verification:

```
This chapter is being submitted for completion after passing the Adversarial Review Gate. Please perform a final verification audit:

1. READ the complete chapter: [file path]
2. CHECK continuity against FACTS_SHEET.md
3. CHECK voice consistency against WRITER_VOICE.md
4. CHECK for AI patterns (vocabulary clusters, structural tells, burstiness)
5. CHECK that all revision items from previous rounds are properly addressed
6. CONFIRM that the Adversarial Review Gate was satisfied (Grade A from all Primary Panel personas)

If the chapter passes all checks, issue a Verification Certificate in this exact format:

---
VERIFICATION CERTIFICATE
Chapter: [title]
File: [file path]
Date: [date]
Auditor: Gemini
Status: VERIFIED / REJECTED

Adversarial Review: [PASSED — Round X, all Primary Panel Grade A] / [FAILED — details]
Continuity: [PASS/FAIL — details]
Voice Consistency: [PASS/FAIL — details]
AI Pattern Scan: [PASS/FAIL — details]
Revision Compliance: [PASS/FAIL — details]

Overall Findings: [any remaining issues or "No issues found"]
---

If you find issues that block verification, list them with severity and reject.
Do NOT issue VERIFIED status if any check fails.
```

### Step 7: Evaluate Gemini Response
- If **VERIFIED**: Proceed to user checkpoint
- If **REJECTED**: Present Gemini's findings. Recommend running /revision-guide to address issues. Do NOT proceed to user sign-off.

### Step 8: USER CHECKPOINT

Present the complete results:

```markdown
# Chapter Completion: [Title]

## Checklist Results
[All checklist items with PASS/FAIL]

## De-AI Audit
**Grade:** [A-F]
[Summary of findings if any]

## Gemini Verification
**Status:** [VERIFIED/REJECTED]
[Certificate or rejection details]

## Adversarial Review
**Gate:** [PASSED — Round X] / [NOT PASSED — see below]
[Primary Panel grades summary]

## Final Stats
- Word count: [X]
- Line count: [X]
- Revision rounds completed: [X]
- Adversarial review rounds: [X]
```

State clearly:

**"Chapter ready for sign-off. Please confirm this chapter is DONE, or identify remaining issues."**

The chapter is complete ONLY when the user explicitly signs off.
