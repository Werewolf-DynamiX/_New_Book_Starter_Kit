# Collaboration Workflow: Claude & Gemini

## 1. The Core Loop

1. **Gemini** researches and plans (outputs to `research/` and `TODO.md`).
2. **Claude** writes prose based on Gemini's work (outputs to `manuscript/`).
3. **Gemini** reviews Claude's prose for technical accuracy (outputs to `reviews/`).
4. **Claude** revises based on review (updates `manuscript/`).
5. **Gemini** signs off (updates `TODO.md`).

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
"C:\Users\toast\.bun\bin\gemini.exe" -p "your prompt here"
```

**Example commands:**
```bash
# Request research
"C:\Users\toast\.bun\bin\gemini.exe" -p "Research the history of [topic] for Chapter 5"

# Request outline review
"C:\Users\toast\.bun\bin\gemini.exe" -p "Review the outline in manuscript/00_master_outline.md"

# Request QA
"C:\Users\toast\.bun\bin\gemini.exe" -p "Check Chapter 3 for factual accuracy"
```

### Gemini → Claude
Gemini can call Claude using:
```bash
claude -p "your prompt here"
```

**Example commands:**
```bash
# Request prose generation
claude -p "Write the opening scene for Chapter 2 based on research/chapter_2_brief.md"

# Request revision
claude -p "Revise this paragraph to remove filter words: [text]"
```

**Note:** Full paths may be required depending on system configuration.
