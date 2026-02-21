# Module Provenance & Sync Status

This file tracks the origin of each module to facilitate updates between active projects and the starter kit.

## Kit Version
- **Current:** 1.3.0 (2026-02-20)
- **Previous:** 1.2.0 (2026-02-20), 1.1.0 (2026-01-14)

## Module Origins

### _ANTI_AI_CORE.md (archived to backup/)
- **Source Project:** TatsuroYamashita
- **Source File:** CLAUDE.md (Anti-AI Writing Guidelines)
- **Last Sync:** 2026-01-14
- **Status:** Archived. Rules integrated into _STYLE_AUTHORITY.md and _HUMAN_PATTERNS.md.

### _WORD_VARIATION.md (archived to backup/)
- **Source Project:** TatsuroYamashita
- **Source File:** CLAUDE.md (Crutch words, Em-dash, Prepositions)
- **Last Sync:** 2026-01-14
- **Status:** Archived. Rules integrated into _STYLE_AUTHORITY.md.

### _FICTION_POV.md
- **Source Project:** tools\writing system.md
- **Last Sync:** 2026-01-14
- **Key Concepts:** First person present rules, internal monologue.

### _ROMANCE_HEAT.md
- **Source Project:** tools\writing system.md
- **Last Sync:** 2026-01-14
- **Key Concepts:** Heat levels 1-5, fantasy blending.

### _HUMAN_PATTERNS.md
- **Source Project:** tools\writing system.md
- **Last Sync:** 2026-01-14
- **Key Concepts:** Burstiness, paragraph variation, structural tells, perplexity techniques.

### _BIOGRAPHY.md
- **Source Project:** TatsuroYamashita
- **Source File:** context/CLAUDE_WRITER.md
- **Last Sync:** 2026-01-14
- **Key Concepts:** New Journalism style, avoiding hagiography.

## Sync Infrastructure (added v1.2.0)
- **manifest.json:** File classification and version tracking.
- **init_book.sh:** Project bootstrapper with symlinks.
- **update_book.sh:** Project updater with diff/merge.
