# New Book Starter Kit (Modular Edition)

This is the standard starting point for all new book projects. It features a **modular writing system** that allows you to configure the AI writer (Claude) for specific genres (Fiction/Romantasy or Biography/Non-Fiction) while enforcing universal high-quality "human" writing standards.

## Prerequisites

Before using this kit, ensure you have the following installed:
- **[Bun](https://bun.sh/):** JavaScript runtime and package manager.
- **[Vale](https://vale.sh/):** A syntax-aware linter for prose.
- **Gemini CLI:** The interactive CLI agent. Ensure it is available globally as `gemini`.

## How to Use This Kit

1. **Copy** this entire folder to your new project location and rename it.
2. **Configure `CLAUDE.md`**:
   - Open `CLAUDE.md`.
   - **Toggle Modules:** Delete the track modules you do not need (Fiction or Nonfiction) or use Markdown HTML comments (`<!-- comment -->`) to disable them.
   - Fill in the "Project Specifics" section at the bottom.
3. **Initialize `GEMINI.md`**:
   - Open `GEMINI.md`.
   - Fill in Project Identity, Thesis, and Scope.
4. **Start Planning**:
   - Use `manuscript/00_master_outline.md` to begin structuring your book.

## The Module System

The writing rules are stored in `modules/`:

- **Universal:**
  - `_ANTI_AI_CORE.md`: Banned words, forbidden transitions, structural rules.
  - `_HUMAN_PATTERNS.md`: Sentence rhythm (burstiness), paragraph variation.
  - `_WORD_VARIATION.md`: Crutch word limits, synonym cheat sheets.

- **Genre-Specific:**
  - `_FICTION_POV.md`: First-person present rules, dialogue, internal monologue.
  - `_ROMANCE_HEAT.md`: Heat levels, fantasy integration.
  - `_BIOGRAPHY.md`: New Journalism style, factual rigor, avoiding hagiography.

## Directory Structure

- `manuscript/`: Your actual book content.
- `research/`: Structured research notes (facts, not prose).
- `context/`: Project bible details (characters, timeline, voice).
- `modules/`: The brain of the writing system.
- `output/`: Compiled files (PDF, EPUB, DOCX).