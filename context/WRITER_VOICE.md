# Writer Voice Guide — [Project Name]

This file defines the voice Claude should produce for **this project specifically**. It inherits from `context/WRITER_VOICE_CORE.md` (the author-level core) and layers genre-specific anchors on top.

Before filling this in, read `context/WRITER_VOICE_CORE.md` — the four transferable moves (Trust, Present-Tense Surface, Register Collision, Restraint on Interiority) already apply. This file is for what *this book* needs that the core doesn't give you.

Fill in every section. If a section is blank, the draft will drift toward generic AI-neutral prose.

---

## 1. Target Voice (one sentence)

A single sentence naming the voice. Avoid adjective stacks ("lyrical, restrained, observational").
Example: *"A quiet first-person that notices physical detail before emotion."*

**This project:** [fill in]

---

## 2. Genre Anchors (1–2 required)

The core file already anchors Gibson (Trust, Present-Tense Surface, Register Collision, Restraint on Interiority). Here you add 1–2 genre-specific anchors whose **emotional temperature** fits this book.

See `WRITER_VOICE_CORE.md` Section 3 for per-genre recommendations:
- **Biography / narrative nonfiction:** Didion, Talese, Tom Wolfe
- **Commercial nonfiction:** Lewis, McPhee, Orlean
- **Dark romantasy:** Miller, Clarke, Polk, Novik
- **Cozy romantasy:** Baldree, Klune, Chambers, Hazelwood

Paste 1–2 short passages (100–250 words each) of prose you want *this book* to sound like. For each, fill in the annotation fields below.

### Passage 1 — Source: [Author / your book / title]

```
[Paste passage here. Keep it short — 100–250 words — so the signal is dense.]
```

**Sentence-length pattern:** [e.g., "3 short, 1 long, 2 medium, 1 fragment"]
**Diction register:** [e.g., "Saxon/concrete, avoids Latinate abstractions"]
**Point-of-view distance:** [e.g., "tight third; no filter verbs"]
**What the passage does that Claude must emulate:** [one sentence]
**What it avoids that Claude must also avoid:** [one sentence]

### Passage 2 — Source: [...]

```
[Paste]
```

**Sentence-length pattern:**
**Diction register:**
**Point-of-view distance:**
**What it does:**
**What it avoids:**

### Passage 3 — Source: [...]

```
[Paste]
```

**Sentence-length pattern:**
**Diction register:**
**Point-of-view distance:**
**What it does:**
**What it avoids:**

(One strong genre anchor is usually enough. Two if the book mixes registers — e.g., a dark romantasy with cozy interludes.)

---

## 3. Project-Specific Rules (additions to the core)

`WRITER_VOICE_CORE.md` already defines the author-level rules. Here you list rules **unique to this book**, extracted from the genre anchors above. Leave empty if the core rules are sufficient.

**This project:**
1. [fill — e.g., "Sensory descriptions in intimate scenes must include at least one non-visual channel (taste, texture, temperature)."]
2. [fill]
3. [fill]

---

## 4. Project-Specific Hard Negatives (additions to core)

The core file already rules out Sanderson expository, McCarthy biblical, YA-chatty, epic-fantasy omniscient, and MFA interiority. Add any **project-specific** negatives here.

Example: *"For this dark romantasy: not Maas-style explicit heat (we aim for implication). Not Bardugo-style quippy banter."*

**This project:** [fill]

---

## 5. Active Checkpoints (Claude applies these before submitting any scene)

- [ ] The four core moves from `WRITER_VOICE_CORE.md` apply (Trust, Present-Tense Surface, Register Collision, Restraint on Interiority).
- [ ] Does the scene match the emotional temperature of the genre anchor(s)?
- [ ] No rule from Section 3 (project-specific) is violated.
- [ ] The scene does not drift into any Hard Negative (core or project-specific).
- [ ] If a passage "sounds AI," read aloud against the genre anchor. Where does the rhythm diverge?

---

## Notes on Use

- Claude reads **both** `WRITER_VOICE_CORE.md` and this file before every `/draft`. The core defines the author; this file defines the book.
- Update this file after every time you catch yourself rewriting Claude toward a specific pattern — if the pattern is book-specific, it belongs here in Section 3. If it's author-constant, propagate to the core.
- If a project-specific rule contradicts a core rule, write out why the genre demands the exception. Often the contradiction reveals something useful about the genre itself.
