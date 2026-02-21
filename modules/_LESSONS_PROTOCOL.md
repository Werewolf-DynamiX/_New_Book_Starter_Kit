# LESSONS PROTOCOL: Continuous Improvement Loop

**Purpose:** To prevent the repetition of mistakes across chapters, sessions, and projects by systematically capturing, logging, and reviewing "Learned Lessons."

---

## 1. THE RECURSION LOOP

This protocol follows a **Capture → Log → Review → Audit** loop.

### Phase 1: CAPTURE (End of Session)
At the end of every writing or revision session, the AI (Gemini) must identify:
- **Mistake Made:** Did we hit a CLI error? Did a logic flaw get past initial triage? Did we violate a module rule?
- **Lesson Learned:** What is the specific fix or change to the workflow that will prevent this?

### Phase 2: LOG (The Repository)
Append the findings to the appropriate location:
- **Project-Specific Mistakes:** `context/LESSONS_LEARNED.md` (Local file)
- **Workflow/Meta Mistakes:** `modules/_LESSONS_LEARNED_GENERAL.md` (Global kit-level)
- **Genre/Fiction Mistakes:** `modules/_LESSONS_LEARNED_FICTION.md` (Global kit-level)

### Phase 3: REVIEW (Start of Session)
At the start of every session, both Claude and Gemini must:
1.  Read the relevant "Lessons Learned" files.
2.  Explicitly state: "Reviewing Lessons: [Key Lesson]... Ready to proceed without repeating."

### Phase 4: AUDIT (QA Phase)
During the **Triage (Phase 2)** and **Verify (Phase 4)** stages of the `_REVISION_WORKFLOW.md`:
- Check for "Known Mistakes" identified in previous sessions.
- If a mistake is repeated, the fix is REJECTED and the "Lessons Learned" must be reinforced.

---

## 2. HOW TO LOG A LESSON

Use the standardized format from `modules/_LESSONS_LEARNED_GENERAL.md`:

### Lesson [ID]: [Title]
**The Mistake:** [Description]
**The Fix:** [Specific remediation]
**Verification:** [How to check]

---

## 3. TYPES OF LESSONS

| Type | Scope | Storage Location |
|------|-------|------------------|
| **Meta/Workflow** | CLI usage, prompt engineering, project structure | `modules/_LESSONS_LEARNED_GENERAL.md` |
| **Genre-Specific** | Pacing, character tropes, style rules | `modules/_LESSONS_LEARNED_FICTION.md` |
| **Project-Specific** | Lore errors, character voice, specific user feedback | `context/LESSONS_LEARNED.md` |

---

## 4. [STRICT] ENFORCEMENT

1. **No Session Ends Without a Check:** You MUST ask "What did we learn this session?" before signing off.
2. **No Review is Complete Without Audit:** The `_REVISION_WORKFLOW.md` is incomplete if it doesn't check against the Lessons Learned.
3. **Repeated Mistakes are Critical Failures:** If the same mistake is made twice after being logged, it is a priority CRITICAL fix.

---

*Module Version 1.0 — February 2026*
