# Phase 4 Design Notes — Chapter-Level Diagnostics

**Status:** Design only. Not implemented.

These diagnostics operate at the **chapter** level — they measure things that pure regex can't catch (tension, stakes, emotional movement) but that still have measurable proxies. Deferring implementation because each requires more design than Phase 1–3.

## 1. Tension Arc

**What it catches:** Chapters that plateau. Scenes where the stakes never rise, or rise once and flatline.

**Measurable proxy (candidate approaches):**

a. **Sentence-length as a proxy for intensity.** In action/high-stakes scenes, mean sentence length typically drops (shorter = more urgent). Plot the rolling mean per 100-word window across the chapter. A healthy chapter has at least one visible dip. A flat plot = plateau.

b. **Paragraph-length entropy.** Rising tension correlates with shorter paragraphs (faster visual rhythm). Plot paragraph-length variance across the chapter.

c. **Stakes phrases.** A curated lexicon of stakes-escalation words (*had to, couldn't, nothing left, last chance, no way out, already too late, seconds, heartbeat, breath*). Rising density toward chapter end = rising tension. Flat density = flat chapter.

d. **Verb tense/mood proxy.** First-person present-tense action verbs concentrate in high-tension passages; past-tense reflective verbs in low-tension. Ratio plotted across chapter.

**Output:** A simple line chart (ASCII or emitted markdown table) showing where tension rises, plateaus, drops. User sees the shape.

**False-positive risk:** High. Genre matters enormously — a cozy scene should plateau; a thriller scene shouldn't.

**Recommendation:** Build (a) + (c). Present as "tension profile" showing the shape of the chapter, not a pass/fail judgment. Let the writer interpret.

## 2. Opening Hook Detector

**What it catches:** Chapters that open with weather, setting description, or character-reflecting-on-past instead of character-in-motion.

**Measurable proxy:**

a. **First-paragraph subject.** Is the grammatical subject of the first sentence a character, or is it weather/setting/time? A simple NER or pattern check.

b. **First-paragraph verb type.** Action verb vs. stative verb (was, had been, remembered). Stative opens are weaker.

c. **First-paragraph question count.** Rhetorical questions in paragraph one signal a weak hook.

**Output:** Per-chapter hook grade (Strong / Weak / Generic) with the first paragraph quoted for the user to judge.

**False-positive risk:** Low. Genre conventions do vary (literary fiction has earned the right to open slowly) but a Strong/Weak label with quoted text lets the writer decide.

**Recommendation:** Build. Short Python script, maybe 80 lines. Useful.

## 3. Closing Hook Detector

**What it catches:** Chapters that end with a fade/summary instead of forward-pressure.

**Measurable proxy:**

a. **Last-sentence structure.** Fragment, question, or action clause = strong. Summary sentence ("And that was when everything changed") or reflective sentence ("She would remember this moment for years") = weak.

b. **Last-paragraph length.** Very long closing paragraphs often fade. Strong closings are usually 1–3 sentences.

c. **Unresolved thread check.** Does the last 200 words name an open question, an unanswered line of dialogue, an object-with-mystery? Binary yes/no.

**Output:** Per-chapter closing grade + quoted last paragraph. Note whether the chapter "hooks the turn" (creates forward pull into the next chapter).

**Recommendation:** Build. Pairs well with opening hook detector.

## 4. Scene-Boundary Diagnostic

**What it catches:** "Story jumps" — scenes that end mid-beat, or chapters with too many scene transitions crammed together.

**Measurable proxy:**

a. Count scene breaks per chapter (`***` or `---` or blank-line-after-dialogue patterns).
b. For each scene, measure word count.
c. Flag chapters with: >4 scenes, any scene under 300 words (except deliberate intercuts), or scene-break density > 1 per 800 words.

**Output:** Scene map per chapter — a visual of scene boundaries and lengths.

**Recommendation:** Build. Simple. Feeds into the "story jumps" reviewer complaint we've logged.

## 5. Emotional-Channel Diversity

**What it catches:** Scenes that render only one emotion per beat instead of layered feeling.

**Measurable proxy:** A small lexicon of emotion words grouped by type (fear, anger, sadness, joy, shame, longing, confusion). Per paragraph, count how many distinct emotion types appear. Paragraphs with only one type = flat emotional rendering.

**Risk:** High false-positive. Some paragraphs should be single-emotion.

**Recommendation:** Defer. Probably not worth the noise.

---

## Implementation priority if we come back to this

1. **Opening hook detector** — cheap, high value, low false-positive.
2. **Closing hook detector** — paired with #1.
3. **Scene-boundary diagnostic** — addresses a logged reader complaint ("story jumps").
4. **Tension arc (profile only)** — useful as a visualization, not a gate.
5. **Emotional-channel diversity** — skip unless a specific reader complaint justifies it.

Each would extend `.claude/scripts/prose_scan.py` with a new check function and a new section in the report. No new skill needed.

## What this doesn't solve

None of these measure **whether the scene is any good**. They measure whether it has the mechanical shapes of a working scene. A technically-well-opened, well-closed, tension-profiled chapter can still be boring. Craft ceiling work remains human.
