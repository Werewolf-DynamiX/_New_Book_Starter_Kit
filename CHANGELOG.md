# Starter Kit Changelog

## [1.5.2] - 2026-04-14
### Changed — `update_book.sh` Restructure
- **Five named phases** (Structure, Infrastructure, Skills, Your Files, New Kit Files) with a clear header explaining the three file categories: auto-synced, prompted, and never-touched.
- **Migration guide system:** project-owned files that diverge from kit templates now produce `.sync/migration_guide.md` (a unified-diff report) instead of a noisy interactive diff walkthrough. User hands it to Claude/Gemini for guided merging, then deletes it.
- **Explicit directory seeding:** required dirs (including all Claude + Gemini skill dirs) are verified and created up front, so later sync steps never fail on a missing folder.
- **Auto-creates missing `modules/` and `.vale/` symlinks** instead of prompting, and reports without asking when they're correct.
- **Condensed output:** header shows `project: current -> kit`, per-phase summaries replace per-file chatter.

## [1.5.1] - 2026-04-02
### Changed — NotebookLM Prep Hardening
- **`notebooklm-prep.sh` is now structure-aware:** auto-discovers chapters in `manuscript/chapters/` or `manuscript/`, skips `FULL_MANUSCRIPT*` files, and picks up `docs/`, character files, and series bibles wherever they live.
- **Reclassified from `sync_always` to `template_copy`:** project-level customizations to the script now survive kit updates (fixes revert bug where local edits were overwritten).

### Added
- **`docs/characters.md` template:** standard location for character voice rules and physical descriptions.

## [1.5.0] - 2026-04-02
### Added — Holistic Manuscript-Level QA
- **`/holistic-audit` (Claude + Gemini):** Full-manuscript structural analysis identifying cross-chapter patterns (voice bleed, narrative device dependency, consequence gaps, pacing arcs). Generates `docs/HOLISTIC_PASSES.md` with prioritized revision passes.
- **`/holistic-pass N` (Claude + Gemini):** Executes a specific numbered pass across targeted chapters. Works 2–4 chapters per invocation and tracks progress. User checkpoint required before changes apply.
- **`docs/HOLISTIC_PASSES.md`:** Template/output file for holistic pass planning.
- **`.claude/hooks/version-check.sh`:** Notifies when a project has fallen behind the kit version.
- **Gemini skills:** `holistic-audit`, `holistic-pass`, `voice-lint` installed under `.gemini/skills/`.

### Fixed
- **Gemini skills deployment:** `.gemini/skills/` was never being copied to new projects via `init_book.sh`. Now deployed correctly.
- **`continuity-audit` skill:** trimmed the bundled `CONTINUITY_AUDIT_PROMPT.md` reference; skill now self-contained.

### Changed
- **CLAUDE.md:** Added manuscript-level workflow documentation (`/holistic-audit` → `/holistic-pass`) alongside the existing chapter-level workflow.
- **`init_book.sh` / `update_book.sh`:** Deploy new skills, hooks, and Gemini skills directory.
- **`.sync/manifest.json`:** Bumped to 1.5.0 with new file classifications.

## [1.4.1] - 2026-03-17
### Added — Gemini Continuity Audit Skill
- **Implemented Continuity Audit Skill:** Created `.gemini/skills/continuity-audit/SKILL.md` based on the installation spec. This provides systematic batch analysis across multiple chapters for consistency in characters, objects, locations, and timeline.

## [1.4.0] - 2026-03-17
### Added — Claude Code Automation
- **5 Claude Skills (slash commands):**
  - `/scene-brief`: Research Brief → Scene Brief pipeline with Gemini integration and user checkpoint
  - `/draft`: Pre-flight validated prose drafting with inline QC (Self-Editing + De-AI)
  - `/de-ai-audit`: Systematic AI-pattern scanner producing A-F graded reports
  - `/revision-guide`: 3-audit Gemini pipeline (Continuity, Logic, Voice/AI) → triaged Revision Guide
  - `/chapter-done`: Chapter Completion Checklist + Gemini Verification Certificate + user sign-off gate
- **3 Automatic Hooks:**
  - `deai-quick-scan.sh` (PostToolUse): Warns on AI vocabulary clusters in manuscript writes
  - `prose-checklist-reminder.sh` (Stop): Reminds to run QC if manuscript files were modified
  - `save-critical-context.sh` (PreCompact): Preserves banned vocab, burstiness rules, and persona across context compaction
- **Contextual Rule:** `manuscript-prose.md` auto-loads anti-AI rules when editing manuscript files
- **NotebookLM Integration:** `notebooklm-prep.sh` bundles manuscript + context for Google NotebookLM with 5 pre-written audit prompts (continuity, voice, timeline, character arc, plot thread)
- **Gemini Skill Spec:** `gemini-continuity-audit-spec.md` documents manual installation of a Gemini continuity-audit skill

### Changed — Infrastructure
- **init_book.sh** (v1.4.0): Creates `.claude/hooks/`, `.claude/rules/`, `.claude/scripts/`, `.claude/skills/` directories; copies and chmod's new files
- **update_book.sh**: Syncs hooks/rules/scripts as `sync_always`; syncs skills as `template_copy` with diff-check
- **.sync/manifest.json**: Updated to v1.4.0 with all new file classifications
- **CLAUDE.md**: Added "Automation & Skills" section documenting slash commands, hooks, and rules

## [1.3.1] - 2026-03-17
### Added — Custom Gemini Skills
- **kdp-format**: Automated KDP formatting workflow using `docx` and `pandoc`.
- **de-ai-audit**: Specialized audit skill for detecting AI patterns, vocabulary clusters, and structural tells.
- **adversarial-review**: High-stakes persona-based review engine with Anti-Agreeability Protocol and iteration gating.

### Changed — Module Consolidation
- **_STYLE_AUTHORITY.md**: Consolidated `_ANTI_AI_CORE.md` and `_WORD_VARIATION.md` into a single source of truth for diction, syntax, and AI-pattern avoidance.
- **_NARRATIVE_VOICE.md**: Renamed and expanded `_FICTION_POV.md` to cover all POV types (1st/3rd), tenses, and dialogue mechanics.
- **README.md**: Updated module references to reflect the consolidated architecture.

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
