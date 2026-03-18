---
name: continuity-audit
description: Deep continuity analysis across manuscript chapters. Traces physical descriptions, object tracking, timeline math, and cross-chapter consistency against FACTS_SHEET.md.
---

# Continuity Audit Skill

You are performing a deep continuity audit of the manuscript. This is a systematic, exhaustive process — not a casual review.

## Procedure

### Phase 1: Inventory
Read all files in `manuscript/chapters/` and `context/FACTS_SHEET.md`.

Build internal tracking tables for:
1. **Characters:** Every named character with all physical descriptions (hair, eyes, height, build, scars, clothing, age)
2. **Objects:** Every significant object (weapons, letters, jewelry, keys, vehicles) — where introduced, where used
3. **Locations:** Every named location with physical descriptions (layout, distances, environmental details)
4. **Timeline:** Every temporal reference (dates, times, "three days later", ages, seasons)

### Phase 2: Cross-Reference
For each tracked item, compare:
- Every mention against every other mention (internal consistency)
- Every mention against FACTS_SHEET.md (canonical consistency)
- Timeline math: Do elapsed times, ages, and travel distances add up?

### Phase 3: Report
Output findings as:

```
# Continuity Audit Report

**Date:** [date]
**Chapters Audited:** [list]
**Auditor:** Gemini (continuity-audit skill)

## CRITICAL (Contradictions)
| Issue | Chapter A | Quote A | Chapter B | Quote B | Type |
|-------|-----------|---------|-----------|---------|------|

## HIGH (FACTS_SHEET Discrepancies)
| Issue | Chapter | In Text | In FACTS_SHEET | Action |
|-------|---------|---------|----------------|--------|

## MEDIUM (Timeline Problems)
| Issue | Chapters | Time Reference | Expected | Actual |
|-------|----------|----------------|----------|--------|

## LOW (Minor Inconsistencies)
[list]

## Tracking Tables
[Full character/object/location/timeline tables for reference]
```

### Checklist
- [ ] Every named character's physical description compared across all appearances
- [ ] Every significant object tracked from introduction to last mention
- [ ] Every location description compared across all scenes set there
- [ ] Timeline math verified (elapsed time, ages, travel feasibility)
- [ ] All findings compared against FACTS_SHEET.md
- [ ] Report generated with severity ratings
