# New Book Starter Kit (Modular Edition)

This is the standard starting point for all new book projects. It features a **modular writing system** that allows you to configure the AI writer (Claude) for specific genres (Fiction/Romantasy or Biography/Non-Fiction) while enforcing universal high-quality "human" writing standards.

## Prerequisites

Before using this kit, ensure you have the following installed:
- **[Bun](https://bun.sh/):** JavaScript runtime and package manager.
- **[Vale](https://vale.sh/):** A syntax-aware linter for prose.
- **Gemini CLI:** The interactive CLI agent. Ensure it is available globally as `gemini`.

## How to Use This Kit

1. **Run `init_book.sh`** from inside your new (empty) project directory:
   ```bash
   mkdir my_new_book && cd my_new_book
   bash /path/to/_New_Book_Starter_Kit/init_book.sh
   ```
   This creates the directory structure, symlinks shared modules, and copies template files.
2. **Configure `CLAUDE.md`**:
   - Open `CLAUDE.md`.
   - **Select Track:** The system dynamically loads Fiction or Nonfiction modules at session start. Delete the track you do not need to simplify the file.
   - Fill in the "Project Specifics" section at the bottom.
3. **Initialize `GEMINI.md`**:
   - Open `GEMINI.md`.
   - Fill in Project Identity, Thesis, and Scope.
4. **Start Planning**:
   - Use `manuscript/00_master_outline.md` to begin structuring your book.
5. **To update from the kit later:** Run `bash update_book.sh` from inside your project.

## The Module System

The writing rules are stored in `modules/`:

- **Universal:**
  - `_STYLE_AUTHORITY.md`: Banned words, forbidden transitions, structural rules, crutch word limits.
  - `_HUMAN_PATTERNS.md`: Sentence rhythm (burstiness), paragraph variation.

- **Genre-Specific:**
  - `_NARRATIVE_VOICE.md`: POV rules (1st/3rd), all tenses, dialogue mechanics.
  - `_ROMANCE_HEAT.md`: Heat levels, fantasy integration.
  - `_BIOGRAPHY.md`: New Journalism style, factual rigor, avoiding hagiography.

## Dual-AI Automation

This kit uses two AI agents with distinct roles:

| | **Claude** (Writer/Editor) | **Gemini** (Architect/QA) |
|---|---|---|
| **Role** | Writes and revises prose | Reviews, researches, verifies |
| **Skills** | `/scene-brief`, `/draft`, `/de-ai-audit`, `/revision-guide`, `/chapter-done` | `de-ai-audit`, `adversarial-review`, `kdp-format`, `continuity-audit` |
| **Automation** | 3 hooks (vocabulary scan, checklist reminder, context preservation) + 1 auto-loading rule | Plan Mode subagents, model routing |

### Typical Workflow
1. `/scene-brief` — Claude gets a Research Brief from Gemini, generates a Scene Brief, user approves
2. `/draft` — Claude writes prose with automatic QC checks
3. `/de-ai-audit` — Claude scans for AI patterns (also runs automatically via hook)
4. `/revision-guide` — Claude requests 3 Gemini audits, builds a prioritized fix list, user approves
5. `/chapter-done` — Claude runs completion checklist, Gemini issues verification, user signs off

### NotebookLM Integration
Run `bash .claude/scripts/notebooklm-prep.sh` to bundle your manuscript for Google NotebookLM with pre-written audit prompts for continuity, voice consistency, timeline, character arcs, and plot threads.

## Directory Structure

- `manuscript/`: Your actual book content.
- `research/`: Structured research notes (facts, not prose).
- `context/`: Project bible details (characters, timeline, voice).
- `modules/`: The brain of the writing system.
- `output/`: Compiled files (PDF, EPUB, DOCX).
- `.claude/`: Claude Code automation (hooks, rules, skills, scripts).