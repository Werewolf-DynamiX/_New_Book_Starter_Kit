# Reviewer Complaints — [Project Name]

Living log of specific things readers have flagged. Every entry becomes a pre-publish scan. Run `/pre-publish` to execute every scan against the current manuscript.

## Categories
- **Continuity** — contradictions, name-before-introduction, knowledge a character shouldn't have
- **Formatting** — brackets in dialogue, markdown artifacts, weird punctuation
- **Prose** — repetitive description, list-like scenes, filter words
- **Structure** — story jumps, pacing problems, trope stacking
- **Voice** — tonal shifts, character voice bleed

## How to Log a Complaint

Every entry must include a **Scan method**. If you can't write one, the complaint is too vague to fix — rewrite it until it's testable.

```
### [Date] — [Reviewer source]
- **Category:** [Continuity / Formatting / Prose / Structure / Voice]
- **Complaint:** "[quoted reader text]"
- **Specifics:** [book, chapter, scene references]
- **Scan method:** [exact thing to check — regex, grep, targeted prompt, or skill to run]
- **Status:** [Fixed in rev X / Not yet addressed / Acknowledged pattern / Monitoring]
```

## Scan method examples

| Complaint | Scan method |
|---|---|
| "Brackets in dialogue" | Regex `"[^"]*[\[\(\<][^"]*` — already in `/prose-scan` |
| "Name used before introduction" | Gemini `continuity-audit` CHECK 1 |
| "Dress color changed between scenes" | Gemini `continuity-audit` CHECK 5 (state attributes) |
| "Written almost in a list" | `/prose-scan` sentence-opener-variance + burstiness-collapse |
| "Story jumps" | `/prose-scan` transition-velocity |
| "Repetitive description" | `/prose-scan` echo detector |
| "Characters sound the same" | Gemini `voice-lint` against `docs/characters.md` |
| "Formulaic chapter endings" | Custom: read last paragraph of every chapter; grep for "testament to", moralizing summaries |
| "Over-explained subtext" | Custom: grep for "meaning", "as if to say", "which meant that" |

## Complaints Log

<!-- ============================================================ -->
<!-- Template for new entries — copy and fill in -->
<!-- ============================================================ -->

<!--
### [YYYY-MM-DD] — [Amazon / ARC / mailing list / beta]
- **Category:** [...]
- **Complaint:** "[...]"
- **Specifics:** [...]
- **Scan method:** [...]
- **Status:** [...]
-->

<!-- Add real entries below this line. Remove the placeholder once you have three or more. -->

### [example — delete once you have real entries]
- **Category:** Formatting
- **Complaint:** "Brackets left in dialogue like [character name]."
- **Specifics:** Multiple scenes across two books.
- **Scan method:** `/prose-scan` — dialogue-placeholder check is CRITICAL severity.
- **Status:** Acknowledged pattern. Pre-publish gate catches this.
