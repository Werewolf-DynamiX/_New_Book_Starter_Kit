# Task: Create Custom Gemini Skills from Project Modules

You need to create 3 custom Gemini Skills from existing module files in this project. Use `skill-creator` for each one.

---

## Skill 1: KDP Formatting

**Source:** `modules/KDP_BOOK_FORMATTING_SKILL.md`

**Skill Name:** `kdp-format`

**Trigger phrase:** "Format for KDP" or "KDP formatting"

**What it should do:**
- Make the KDP spec (trim sizes, margins, typography, section breaks) the primary operating directive
- Apply all formatting rules from the source module as hard constraints, not suggestions
- Include the Node.js/docx workflow and pandoc conversion steps
- Validate output against KDP's technical requirements before declaring done

---

## Skill 2: De-AI Audit

**Source:** Synthesize from these sections:
- `CLAUDE.md` → "Anti-AI Quality Control" (Section 7)
- `modules/_STYLE_AUTHORITY.md` → Banned vocabulary list
- `modules/_HUMAN_PATTERNS.md` → Burstiness and perplexity rules
- `MASTER_BOOK_REVIEW_PROMPT.md` → Pass 4B "Machine-Pattern Review"

**Skill Name:** `de-ai-audit`

**Trigger phrase:** "De-AI audit" or "AI detection check"

**What it should do:**
- Scan text for AI vocabulary patterns (delve, tapestry, testament, realm, etc.)
- Check sentence length variance (flag "AI Flatline" — uniform length throughout)
- Identify structural tells: AI Sandwiches (Topic → 3 points → Summary), sermonizing dialogue, summary endings
- Check for hedging language clusters (notably, furthermore, it's worth noting)
- Flag literal AI remnants ("As an AI", refusal language, "Here's/Here are" list intros)
- Output a scored report: vocabulary hits, structural hits, burstiness score
- Important: flag only when patterns are pervasive, not occasional. Single instances of "delve" in 80K words is fine.

---

## Skill 3: Adversarial Review

**Source:** `modules/_ADVERSARIAL_REVIEW_ENGINE.md`

**Skill Name:** `adversarial-review`

**Trigger phrase:** "Adversarial review" or "persona review"

**What it should do:**
- Activate the Anti-Agreeability Protocol: no praise, default-to-fail stance
- Load the full Persona Library from the source module
- Run each Primary Panel persona as a separate review pass
- Apply the rating system (Grade A / 4.5+ Stars threshold)
- Enforce the iteration loop: max 3 rounds, escalate to user after Round 3
- Output structured findings per persona with: Location, Problem, Evidence (quoted text), Fix, Severity
- Gate completion: ALL Primary Panel personas must pass. Advisory Panel informs but does not gate.

---

## How to Create These

For each skill above:

1. Run `skill-creator` in an interactive session
2. Point it at the source module(s)
3. Use the skill name and trigger phrases specified
4. Test the skill on a sample chapter or passage
5. Run `/skills reload` to pick up the new skill

## After Creation

Delete this file — it's a one-time task instruction, not a permanent reference.
