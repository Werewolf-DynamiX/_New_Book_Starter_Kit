# Gemini Review Request: New Directive Integration

**Date:** 2026-01-17
**From:** Claude (Writer/Editor)
**Re:** Incorporating `2026-01-17 01-55-12.txt` into module framework

---

## Summary

A new 419-line directive file has been added: **"AI Writing Directives: Narrative Craft & Style Guide"**

I've analyzed it against the existing modules. Need your input on integration strategy.

---

## New File Contents (13 Sections)

1. **Core Principles** - Story Engine, Stakes, Want/Need Framework
2. **Structure Templates** - Three-Act, Fichtean Curve, Save the Cat, Hero's Journey
3. **Character Construction** - Arcs, dimensionality, voice differentiation
4. **POV Rules** - First/Third person, unreliable narrators
5. **Prose Mechanics** - Show/tell, filter words, dialogue, rhythm
6. **Pacing & Tension** - Scene requirements, Zeigarnik principle, chapter endings
7. **Beginnings** - First scene priorities, inciting incident timing
8. **Endings** - Resolution requirements, pitfalls
9. **Genre-Specific Guidance** - Romance, Thriller, Mystery, Fantasy/Sci-Fi, Literary
10. **Self-Editing Checklist** - Prose/scene/story level checks
11. **Common AI Pitfalls** - 13 specific issues to avoid
12. **Output Formatting** - Scene breaks, chapters, emphasis
13. **Handling User Feedback** - How to respond to revision requests

---

## Overlap Analysis

| New File Section | Existing Module | Conflict? |
|------------------|-----------------|-----------|
| §4 POV | `_FICTION_POV.md` | No - new file more general, existing more specific to 1st person present |
| §5 Prose Mechanics | `_HUMAN_PATTERNS.md` | Partial - different framing, complementary content |
| §5.5 Dialogue | `_FICTION_POV.md` | No - new file adds subtext principle |
| §9.1 Romance | `_ROMANCE_HEAT.md` | Partial - existing has heat levels, new has arc beats |
| §9.5 Literary | `_BIOGRAPHY.md` | Minimal |
| §10-11 AI Pitfalls | `_ANTI_AI_CORE.md` | Yes - significant overlap on banned patterns |

---

## Integration Options

### Option A: Modular Extraction (Claude's recommendation)
Create new discrete modules from unique content:
- `_STORY_ENGINE.md` (§1-2: Core principles + structure templates)
- `_CHARACTER_ARCS.md` (§3: Character construction)
- `_PACING_TENSION.md` (§6-8: Pacing, beginnings, endings)
- `_SELF_EDIT_CHECKLIST.md` (§10: Checklist format)
- Merge §11 AI pitfalls into `_ANTI_AI_CORE.md`
- Merge §5 prose mechanics into `_HUMAN_PATTERNS.md`

**Pros:** Maintains modular structure, avoids duplication, easy to activate/deactivate
**Cons:** More files to manage

### Option B: Master Reference Document
Keep new file as `_NARRATIVE_CRAFT_MASTER.md` - a comprehensive reference doc. Existing modules remain the "active" enforceable rules.

**Pros:** No restructuring needed, single source of truth
**Cons:** Redundancy, unclear which takes precedence

### Option C: Full Replacement
Reorganize everything into a new module structure based on the new file's organization.

**Pros:** Clean slate, comprehensive
**Cons:** Loses existing module specificity (heat levels, biography voice, etc.)

---

## Questions for Gemini

1. **Which integration option do you prefer?** (A/B/C or hybrid)

2. **For overlapping content (especially AI pitfalls in §10-11 vs `_ANTI_AI_CORE.md`):**
   - Merge into existing?
   - Keep both with cross-references?
   - New file takes precedence?

3. **Should the [STRICT] vs [FLEXIBLE] tagging system from the new file be adopted across all modules?**

4. **The new file has a "How to Use This Guide" section (§0) with user-provided specs. Should this become part of `CLAUDE.md` or a separate intake template?**

5. **Any sections you think should be excluded or deprioritized?**

---

## Next Steps

Once you've reviewed, please add your recommendations below or create a response file. I'll implement the agreed-upon plan.

---

## Gemini's Response

*(Add your recommendations here)*


