# Collaboration Workflow: Claude & Gemini

## 1. The Core Loop

1. **Gemini** researches and plans (outputs to `research/` and `TODO.md`).
2. **Claude** writes prose based on Gemini's work (outputs to `manuscript/`).
3. **Gemini** reviews Claude's prose for technical accuracy (outputs to `reviews/`).
4. **Triage & Revision:** Claude and Gemini follow the `_REVISION_WORKFLOW.md` to process findings and execute fixes.
5. **Verification & Sign-off:** The opposite model verifies fixes before Gemini updates `TODO.md`.

---

## 2. Handoff Protocol

Use `TODO.md` to signal handoffs. Never leave a task "in the air."

**Gemini -> Claude:**
```markdown
- [ ] `[HANDOFF to CLAUDE]` Write Chapter 3
      - Input: `research/chapter_3_brief.md`
      - Constraints: Focus on [Theme]
```

**Claude -> Gemini:**
```markdown
- [ ] `[HANDOFF to GEMINI]` Review Chapter 3
      - File: `manuscript/chapters/03_chapter.md`
      - Note: Please check the date of [Event]
```

---

## 3. File Ownership

To prevent conflicts, respect these ownership rules:

| File Type | Primary Owner | Contributor |
|-----------|---------------|-------------|
| `GEMINI.md` | Gemini | (Read Only) |
| `CLAUDE.md` | Claude | (Read Only) |
| `TODO.md` | Both | Both |
| `manuscript/` | Claude | Gemini (Reviews) |
| `research/` | Gemini | Claude (Read Only) |
| `visuals/` | User | Both |

---

## 4. Conflict Resolution

If specific facts or instructions conflict:
1. **Gemini** is the authority on **FACTS** and **STRUCTURE**.
2. **Claude** is the authority on **PROSE**, **VOICE**, and **FLOW**.

If Gemini says a date is wrong, Claude changes it.
If Gemini says a sentence is "too flowery" but Claude thinks it fits the voice, Claude decides (unless it violates the De-AI-ify ban list).

---

## 5. Direct AI Communication (CLI)

Both AIs can communicate with each other via command line interfaces.

### Claude → Gemini
Claude can call Gemini using:
```bash
gemini "your prompt here"
```

**Example commands:**
```bash
# Request research
gemini "Research the history of [topic] for Chapter 5"

# Request outline review
gemini "Review the outline in manuscript/00_master_outline.md"

# Request QA
gemini "Run a full review of Chapter 3 per _REVISION_WORKFLOW.md"
```

**Plan Mode (for structured research/planning):**
```bash
# Start interactive session, then enter Plan Mode
gemini -i "Let's plan the research brief for Chapter 5"
/plan
```
Plan Mode uses built-in subagents for deep cross-file analysis (`codebase_investigator`) and batch operations (`generalist`). Preferred for Research Briefs, Scene Brief validation, and multi-chapter continuity checks.

**Custom Skills (for repeatable workflows):**
Gemini Skills turn module guides into activatable procedures. Use `skill-creator` to package workflows like KDP formatting or adversarial review into on-demand skills.

### Gemini → Claude
Gemini can call Claude using:
```bash
claude "your prompt here"
```

**Example commands:**
```bash
# Request prose generation
claude "Write the opening scene for Chapter 2 based on research/chapter_2_brief.md"

# Request triage
claude "Review these audit findings and create a Revision Guide per _REVISION_WORKFLOW.md"
```

### CLI Flag Reference
| Feature | Gemini | Claude |
|---------|--------|--------|
| Model selection | `--model-id [model]` | `--model [model]` |
| File input | `-f file.md` | (use @ syntax or paste) |
| Interactive mode | `-i "prompt"` | (interactive by default) |
| Resume session | `--resume latest` | `--resume` |

**Deprecated (Gemini):** `-p`, `-m`/`--model`, `--max-output-tokens`, `-t`. See CLAUDE.md for full deprecation table.
