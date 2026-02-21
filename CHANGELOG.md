# Starter Kit Changelog

## [1.3.0] - 2026-02-20
### Added — Manuscript Iteration Improvements
- **Iteration Cap:** Maximum 3 rounds of adversarial review per chapter, then escalate to user. No more infinite loops.
- **Audience Weighting:** Personas split into Primary Panel (gating, 3 personas) and Advisory Panel (informing, non-gating). Only Primary Panel must hit Grade A.
- **Research Stage:** Formal Research Brief step before Scene/Section Brief in `_PLANNING_PROTOCOL.md`. Research is now a named pipeline stage, not ad hoc.
- **User Checkpoints:** Four explicit approval gates: Panel Assignment, Revision Guide, Round 3 Escalation, Chapter Sign-Off.
- **Chapter Completion Checklist:** Holistic "forest" check in `_WRITING_WORKFLOW.md` — runs after all individual fixes to verify the chapter works as a unit.

### Changed — Manuscript Iteration
- **_ADVERSARIAL_REVIEW_ENGINE.md** (v2.0): Now the single source of truth for all personas, ratings, audience weighting, iteration loop, and user checkpoints.
- **_REVISION_WORKFLOW.md** (v2.0): Persona definitions removed (consolidated to engine). Added user checkpoint markers. Added iteration cap reference.
- **_PLANNING_PROTOCOL.md** (v2.0): Added Research Brief stage before Scene/Section Brief.
- **_WRITING_WORKFLOW.md**: Added Chapter Completion Checklist.
- **CLAUDE.md**: Updated operational protocol with research stage, user checkpoints, iteration cap, and chapter completion gate.

## [1.2.0] - 2026-02-20
### Added — Sync Infrastructure
- **init_book.sh**: Complete rewrite. Now creates symlinks, copies templates, generates manifest.
- **update_book.sh**: New script for syncing existing projects to latest kit version.
- **.sync/manifest.json**: File classification system (linked, sync_always, template_copy, project_owned).
- **reference/CENTRAL_FRAMEWORK_SETUP.md**: Rewritten to document the new automated tooling.

### Changed
- File classification is now explicit — every file is categorized as linked, infrastructure, or project-owned.
- Projects use symlinks for `modules/` and `.vale/` by default (no more manual copying).
- Removed manual symlink/submodule/absolute-path instructions in favor of automated scripts.

## [1.1.0] - 2026-01-14
### Added
- **Modular Writing System**: Broken down monolithic guides into mix-and-match modules.
- **_ANTI_AI_CORE.md**: Universal rules from TatsuroYamashita project.
- **_WORD_VARIATION.md**: Crutch word limits and discipline from TatsuroYamashita.
- **_FICTION_POV.md**: POV rules and dialogue patterns from tools\writing system.md.
- **_ROMANCE_HEAT.md**: Heat levels and romantasy guidelines from tools\writing system.md.
- **_HUMAN_PATTERNS.md**: Burstiness and perplexity guides from tools\writing system.md.
- **_BIOGRAPHY.md**: Non-fiction voice guidelines from TatsuroYamashita context.

### Changed
- **CLAUDE.md**: Refactored into a lean template that imports modules.
- **README.md**: Updated to explain the new modular system.

## [1.0.0] - Initial Version
- Basic structure for new book projects.
