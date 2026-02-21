# Meta-Lessons Learned: Workflow & CLI Best Practices

These lessons are derived from project-wide observations of CLI performance, model behavior, and structural failures. Apply to all projects.

---

## CLI & COMMAND USAGE

### Lesson G1: Position over Flags (Deprecated `-p`)

**The Mistake:**
Using the `-p` flag in `gemini` or `claude` CLI commands (e.g., `gemini -p "do this"`). This is deprecated and can cause issues in newer versions.

**The Fix:**
Use positional arguments for prompts (e.g., `gemini "do this"`).

**Red Flags:**
- Seeing `-p` in any example documentation.
- Commands failing with "unknown flag" errors.

---

### Lesson G2: No Hardcoded Bin Paths

**The Mistake:**
Including hardcoded, user-specific paths in script examples (e.g., `C:\Users	oast\.bun\bin\gemini.exe`).

**The Fix:**
Assume the CLI is in the global PATH and use the base command (e.g., `gemini`).

---

### Lesson G3: Parallelism vs. Sequence

**The Mistake:**
Running multiple independent search tools in sequence when they could be run in parallel, or attempting to run interdependent tools in parallel (causing race conditions/context loss).

**The Fix:**
- Use the CLI's parallel execution capabilities for independent searches (e.g., `grep_search` on two different directories).
- Wait for the result of a write/replace before reading the file again for verification.

---

## MODEL BEHAVIOR & INTEGRITY

### Lesson G4: The "Anti-Lying" Protocol (Atomic Tasking)

**The Mistake:**
Giving a model more than 3 distinct tasks in a single prompt. LLMs will often "fake" completion of the later tasks or simply forget them.

**The Fix:**
- Break tasks into atomic, one-at-a-time operations.
- Demand BEFORE/AFTER evidence for every change.
- Never let a model self-certify its own work.

---

### Lesson G5: Module Integrity (Symlink Protection)

**The Mistake:**
Letting the AI modify files in the `modules/` directory, which are symlinked from the starter kit. This inadvertently changes the rules for EVERY project using the kit.

**The Fix:**
- Explicitly forbid modification of `modules/` in `CLAUDE.md` and `GEMINI.md`.
- Force all project-specific overrides into `PROJECT_IDENTITY.md`.

---

## PROJECT STRUCTURE

### Lesson G6: Manual "No Seams" Verification

**The Mistake:**
Relying on the AI to "know" if a fix integrated well. "Can you tell where fixes were applied?" is a weak prompt.

**The Fix:**
Instruct the auditing model to specifically analyze **sentence transitions** and **tonal shifts** between the new and old text at the granular level.

---

## LOGGING A NEW LESSON

When a mistake is identified, log it here using this template:

### Lesson G[N]: [Title]

**The Mistake:**
[Describe what went wrong and why it was a mistake.]

**The Fix:**
[The specific remediation or workflow change to prevent it.]

**Verification:**
[How to check if this mistake is happening again.]
