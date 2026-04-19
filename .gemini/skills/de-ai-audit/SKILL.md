---
name: de-ai-audit
description: Audit text for AI writing patterns, vocabulary, and structural tells. Trigger when the user asks for a "De-AI audit" or "AI detection check".
---

# De-AI Audit

This skill scans text for AI writing patterns, vocabulary, and structural tells to ensure human-quality prose.

## Operating Directives
- **Pervasiveness over Single Instances:** Flag patterns only when they are pervasive, not occasional. A single instance of "delve" in 80K words is fine.
- **Output Report:** The audit must produce a scored report detailing vocabulary hits, structural hits, and burstiness score.

## Audit Checklist
Reference the kit's `modules/_PROSE.md` for the full rule set. At minimum, scan for:

1. **Structural phrases** that reliably signal AI authorship:
   - *testament to, reminder that, dive in, let's explore, in today's digital age, let that sink in, only time will tell*
2. **Structural tells:**
   - The "AI Sandwich" (Topic → 3 points → Summary).
   - Sermonizing dialogue.
   - Summary/moralizing endings (e.g., "In conclusion," "Ultimately").
3. **Literal AI remnants** — flag instantly:
   - Refusal language, "As an AI", "Here's/Here are" list intros in prose, bracketed placeholders in dialogue.
4. **Burstiness** — sentence length variance:
   - Flag "AI Flatline" — uniform sentence length (all 12–18 words) for 10+ consecutive sentences.