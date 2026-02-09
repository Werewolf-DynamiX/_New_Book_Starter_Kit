# MODEL SELECTION GUIDE: Brain Power vs. Speed

**Purpose:** To prevent "AI-Smoothness" and logical drift by ensuring the right model class is used for the right task.

---

## 1. THE RISKS OF "FAST" MODELS (Flash/Haiku Class)
*   **Prose Decay:** Fast models prioritize efficiency, leading to repetitive sentence structures and cliches.
*   **Logic Blindness:** They are more likely to "agree" with the user rather than catch complex continuity errors.
*   **Shallow Texture:** They struggle with the "Prose Texture" requirements (tangents, self-corrections).

## 2. THE STRENGTHS OF "CAPABLE" MODELS (Opus/Ultra/Pro Class)
*   **Nuance:** They can handle conflicting character motivations and subtext.
*   **Rhythm:** They produce "burstier," more human-sounding prose.
*   **Adversarial Rigor:** They are better at executing the `_CRITIC_PROTOCOL`.

---

## 3. SELECTION MATRIX

| Task Category | Recommended Model Class | Why? |
|---------------|-------------------------|------|
| **Drafting Prose** | **Most Capable** | Requires "Human Signal" and texture. |
| **Developmental Review**| **Most Capable** | Requires deep structural reasoning. |
| **Deep Continuity Audit**| **Long-Context (1M+ Tokens)** | Must hold the entire book in memory. |
| **Research / Fact-Checking**| **Long-Context / Search-Enabled** | Needs to "Turn Every Page." |
| **File Management** | **Fastest** | Clerk work; speed is the priority. |
| **Initial Triage** | **Fastest** | Categorization and tagging. |

---

## 4. OPERATIONAL DIRECTIVE
If the user or Gemini CLI provides a choice, **default to the Most Capable model for any file that will be read by a human.** Use Fast models only for internal processing or initial classification.
