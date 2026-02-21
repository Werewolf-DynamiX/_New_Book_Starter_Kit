# _New_Book_Starter_Kit Architecture & Review: Action Plan

This document outlines the bugs, internal contradictions, and architectural improvements needed for the `_New_Book_Starter_Kit` repository, along with actionable suggestions for fixing them.

## 1. Bugs & Internal Contradictions

### 1.1. CLI Command Inconsistencies
* **Issue:** `_WRITING_WORKFLOW.md` instructs Claude to use a hardcoded, user-specific Windows path and a `-p` flag (`"C:\Users\toast\.bun\bin\gemini.exe" -p "your prompt here"`). However, `GEMINI.md` explicitly warns that the `-p` flag is deprecated and instructs the use of a simple `gemini "your prompt here"` command.
* **Action:** Update `modules/_WRITING_WORKFLOW.md` to remove the hardcoded `.bun/bin` path and the `-p` flag. Standardize all examples to use the global `gemini "prompt"` syntax.

### 1.2. Module Activation Instructions
* **Issue:** The `README.md` tells the user to "Uncomment the modules relevant to your project" inside `CLAUDE.md`. However, `CLAUDE.md` does not use comment syntax; it relies on the AI to dynamically determine which track (Fiction or Nonfiction) to load at the start of a session.
* **Action:** Update `README.md`. Change the instruction from "Uncomment the modules" to "Delete the track modules you do not need," or implement standard Markdown HTML comments (``) inside `CLAUDE.md` for users to toggle.

---

## 2. Architecture & Tooling Improvements

### 2.1. Symlink Vulnerabilities
* **Issue:** `init_book.sh` uses `ln -s` to link the `modules/` directory to the master kit. If an LLM is instructed to tweak a writing rule for *one* specific book, it will modify the symlinked file and inadvertently overwrite the master rule for *all* books.
* **Action:** Add a strict directive in `CLAUDE.md` and `GEMINI.md` explicitly forbidding the models from modifying any file inside the `modules/` directory. State clearly that all project-specific rule overrides must be strictly confined to `PROJECT_IDENTITY.md`.

### 2.2. Missing Dependency Documentation
* **Issue:** The initialization script copies a `.vale/` directory and references a `gemini` CLI wrapper running via `bun`. Currently, there is no documentation explaining these dependencies to a new user.
* **Action:** Add a "Prerequisites" section to the `README.md`. Detail that users need to install Vale (a prose linter) and Bun, and provide a link or instruction on where to obtain the Gemini CLI wrapper.

### 2.3. Cross-Platform Scripting (Windows Support)
* **Issue:** The script relies on bash and symlinks. On Windows systems (which the `C:\Users\` path implies are being used), the `ln -s` command will fail unless the user is running Git Bash as an Administrator or has Developer Mode enabled.
* **Action:** Add an OS check in `init_book.sh` to warn Windows users to enable Developer Mode for symlinks. Alternatively, implement a fallback mechanism that copies the directory instead of symlinking if `ln -s` fails.

---

## 3. Prompt Engineering Enhancements

### 3.1. Automated Continuity Extraction
* **Issue:** Currently, Gemini is instructed to manually scan outputs at the end of a session to update `FACTS_SHEET.md`. LLMs can suffer from attention degradation during long contexts, leading to missed facts.
* **Action:** Create an automated script (e.g., `update_bible.sh`). This script should utilize the existing `CONTINUITY_AUDIT_PROMPT.md` to systematically feed the latest drafted chapter into Gemini with a strict JSON-schema prompt. This ensures character states, timeline events, and locations are reliably extracted and appended to `FACTS_SHEET.md`.

### 3.2. "No Seams" Verification Rigor
* **Issue:** In the Chapter Completion Checklist, the AI is asked: "Can you tell where fixes were applied?". This is too vague for an LLM to reliably execute against.
* **Action:** Update the checklist in `_WRITING_WORKFLOW.md` to be highly specific. Instruct the auditing model to explicitly analyze the *sentence transitions* between the newly modified paragraphs and the surrounding unedited text to ensure the tone and pacing match flawlessly.