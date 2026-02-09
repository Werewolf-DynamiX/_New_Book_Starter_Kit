# DEEP CONTINUITY AUDIT: The Long-Context Extraction Protocol

**Purpose:** To solve the "Needle in a Haystack" problem by using the most current Long-Context capabilities to extract, trace, and assert facts across the entire manuscript.

**Trigger:** Run this at the end of each Act (roughly every 25% of the book) or when the `FACTS_SHEET.md` feels outdated.

---

## EXECUTION GUIDE

**If using CLI:**
```bash
gemini -p "Run Strategy 1 from CONTINUITY_AUDIT_PROMPT.md on all files in manuscript/chapters/"
```

**If using Web Interface:**
Upload the entire PDF/Document and paste the relevant Strategy Prompt below. Use the most capable long-context model available.

---

## STRATEGY 1: THE ENTITY EXTRACTOR (Series Bible Generation)
**Goal:** Reverse-engineer the `FACTS_SHEET.md` from the actual text to find drift.

**Prompt:**
> "I am providing the full manuscript. Read the text in its entirety. Then, perform a **Forensic Extraction**:
> 
> 1.  **Character Roster:** List every character named. For each, extract:
>     *   Eye Color / Hair Color / Distinctive Features (Cite Chapter #)
>     *   Age / Birthday (Cite Chapter #)
>     *   Job / Role (Cite Chapter #)
> 2.  **Location Register:** List every major location. Extract:
>     *   Specific layout details or distances mentioned (e.g., 'The kitchen is east of the hall').
>     *   Travel times mentioned between locations.
> 3.  **Timeline Reconstruction:**
>     *   List every specific date, day of the week, or time marker mentioned.
> 
> **Output format:** A structured Markdown table.
> **Comparison:** After generating, flag any internal contradictions (e.g., Character has blue eyes in Ch 1 but brown in Ch 10)."

---

## STRATEGY 2: THE CHRONOLOGY TRACE (Thread Tracking)
**Goal:** Track a specific item, wound, or subplot to ensure linear logic.

**Prompt:**
> "Trace the timeline of **[INSERT SUBJECT: e.g., The Magic Ring / The Protagonist's Leg Wound / The Antagonist's Plan]**.
> 
> Create a chronological log of every mention of this subject:
> 1.  **Event:** What happened?
> 2.  **Time/Chapter:** When?
> 3.  **State:** What is the condition? (e.g., Is the wound bleeding? Healing? Forgotten?)
> 4.  **Location:** Where is it?
> 
> **Analysis:** Flag any instance where the object teleports, the wound heals too fast, or the timeline is impossible (e.g., traveling 500 miles in 2 hours)."

---

## STRATEGY 3: THE ASSERTION CHECK (Rule Enforcement)
**Goal:** Aggressively hunt for violations of established world rules.

**Prompt:**
> "Review the text for the following **Inviolable Rules**:
> 
> 1.  [Rule A: e.g., Magic requires a wand]
> 2.  [Rule B: e.g., Vampires cannot enter without invitation]
> 3.  [Rule C: e.g., Travel from A to B takes 3 days]
> 
> **Task:** List every scene where these subjects appear. Explicitly verify if the rule was followed.
> **Flag:** ANY instance where the rule is broken, ignored, or bent without explanation."

---

## STRATEGY 4: THE ROLLING SUMMARY (For Lower Context Models)
*Use this only if you cannot fit the whole book in context.*

1.  **Chunk 1 (Ch 1-5):** "Extract all established facts." -> Save as `facts_v1.md`.
2.  **Chunk 2 (Ch 6-10):** "Read this text. Cross-reference with `facts_v1.md`. Flag contradictions. Then update the list with new facts." -> Save as `facts_v2.md`.
3.  **Repeat.**
