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
1. **Vocabulary Scan:** Check for clusters of AI vocabulary patterns. Reference `references/_STYLE_AUTHORITY.md`.
   - Examples: *delve, tapestry, testament, realm, nuanced, multifaceted*.
2. **Structural Tells:** Identify common AI formatting patterns. Reference `references/MASTER_BOOK_REVIEW_PROMPT.md` and `references/_STYLE_AUTHORITY.md`.
   - The "AI Sandwich" (Topic → 3 points → Summary).
   - Sermonizing dialogue.
   - Summary/moralizing endings (e.g., "In conclusion," "Ultimately").
3. **Literal AI Remnants:** Flag literal traces of AI generation instantly.
   - Refusal language, "As an AI", "Here's/Here are" list intros in prose.
4. **Burstiness and Perplexity:** Check sentence length variance. Reference `references/_HUMAN_PATTERNS.md`.
   - Flag "AI Flatline" — uniform sentence length throughout the section.