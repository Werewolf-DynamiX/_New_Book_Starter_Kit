# PROJECT COMPENDIUM: Modular Book Starter Kit

This document provides a comprehensive overview of the project's architecture, functionality, and workflow. It is designed to give an AI or LLM a complete understanding of how the system operates.

---

## 1. CORE ARCHITECTURE: THE TWO-AGENT SYSTEM

The project operates on a collaborative, two-agent model where roles are strictly divided to ensure high-quality, human-like output and factual rigor.

*   **GEMINI (The Architect & Research Lead):**
    *   **Role:** Strategic planning, deep research, fact-checking, and quality assurance.
    *   **Key Responsibilities:** Maintaining the "Series Bible" (Facts Sheet), auditing prose for "AI-isms" (hedging, purple prose), and structural oversight.
    *   **Motto:** "Turn every page."
*   **CLAUDE (The Writer & Editor):**
    *   **Role:** Drafting prose, scene execution, and stylistic refinement.
    *   **Key Responsibilities:** Adhering to strict modular rules for voice and pacing, generating "messy" human-like drafts, and self-editing.
    *   **Motto:** "Prose with scars."

---

## 2. DIRECTORY STRUCTURE & SYSTEM LOGIC

The project is organized to separate "rules" (modules) from "data" (research/context) and "content" (manuscript).

### Root Files
*   **`GEMINI.md`**: The mission control for the Architect. Contains project identity, strategic pillars, and session logs.
*   **`CLAUDE.md`**: The primary instruction set for the Writer. Defines active modules and the operational protocol.
*   **`README.md`**: High-level onboarding for the human user.
*   **`TODO.md`**: Current task list and project roadmap.

### Folders
*   **`modules/` (The Engine)**: The "brain" of the system. Contains `.md` files that act as sets of instructions/constraints for Claude.
    *   *Universal Modules:* `_STYLE_AUTHORITY`, `_HUMAN_PATTERNS`, `_ANTI_AI_CORE`.
    *   *Genre Modules:* `_STORY_ENGINE`, `_CHARACTER_CRAFT`, `_NONFICTION_CORE`, etc.
*   **`manuscript/` (The Work)**:
    *   `00_master_outline.md`: The living skeleton of the book.
    *   `chapters/` & `drafts/`: Where the actual prose lives.
*   **`context/` (The Bible)**:
    *   `FACTS_SHEET.md`: The single source of truth for names, dates, rules, and continuity.
    *   `WRITER_VOICE.md`: Definitions of the specific "Author Persona."
*   **`research/` (The Foundation)**: Structured research briefs and source verification notes.
*   **`reference/`**: Documentation on tools and collaboration workflows.

---

## 3. OPERATIONAL PROTOCOLS

The system follows a rigid lifecycle for every writing session to prevent "AI drift."

### Step 1: Session Initialization
Claude checks `CLAUDE.md` and `GEMINI.md` to identify the current phase and active modules. It must identify the "Track" (Fiction, Nonfiction, or Narrative Nonfiction).

### Step 2: Track Selection & Configuration
*   **Fiction:** Loads modules for POV, Pacing, and Worldbuilding.
*   **Nonfiction:** Loads modules for Epistemic Rigor and Technical Scaffolding.

### Step 3: The Mandatory Brief (`_PLANNING_PROTOCOL.md`)
Claude **cannot** write prose without first generating a **Scene/Section Brief**.
*   **Fiction Briefs** include: Objective, Continuity Check, Conflict Architecture, and Sensory Palette.
*   **Nonfiction Briefs** include: Core Claim, Epistemic Foundation, and the "So What?" (Value proposition).
*   *Gemini must approve the brief before drafting begins.*

### Step 4: Drafting (The "Anti-Polish")
Claude writes prose while applying "Human Patterns" (burstiness, varied rhythm) and avoiding "AI-isms." The goal is a draft with "rough edges" that feels authentic.

### Step 5: Self-Editing & QA
Claude runs a self-editing checklist (`_WRITING_WORKFLOW.md`). Gemini then performs a "Persona-Based Review" or a "Continuity Audit" to ensure the prose aligns with the Project Identity and Facts Sheet.

---

## 4. THE MODULE SYSTEM: KEY CONSTRAINTS

The project relies on specific modules to override default LLM behaviors:
*   **`_STYLE_AUTHORITY`**: Banned words (e.g., "tapestry," "vibrant," "delve"), forbidden transitions, and diction rules.
*   **`_HUMAN_PATTERNS`**: Forces sentence length variation (burstiness) and prevents uniform paragraph rhythm.
*   **`_REVISION_TOOLKIT`**: Protocols for "Hatchet Mode" (ruthless cutting) and "Texture Injection."
*   **`_CRITIC_PROTOCOL`**: Defines how Gemini should provide adversarial feedback to Claude.

---

## 5. AGENT COLLABORATION WORKFLOW

Agents communicate via the CLI.
*   **Claude to Gemini:** "Research the historical accuracy of X," or "Review this scene for pacing."
*   **Gemini to Claude:** "Update the Facts Sheet with this new character," or "The dialogue in Chapter 2 violates the Author Persona rules."

This structured separation of powers ensures that the book remains cohesive, factually accurate, and stylistically distinct from generic AI writing.

---

## 6. KEY PROMPT TEMPLATES

Specific high-utility prompts are used to maintain project integrity:

*   **`CONTINUITY_AUDIT_PROMPT.md`**: Used at the end of acts or sections to "reverse-engineer" the series bible from the prose, identifying drift or contradictions.
*   **`MASTER_BOOK_REVIEW_PROMPT.md`**: A structured framework for Gemini to evaluate Claude's drafts based on the active modules and the specific "Strategic Pillars" of the book.
*   **`GEMINI_REVIEW.md`**: Specific criteria for "De-AI-ifying" text, focusing on rhythm, diction, and emotional honesty.

---

## 7. SUMMARY FOR EXTERNAL AI

If you are an AI being introduced to this project:
1.  **Context is King:** Always reference `context/FACTS_SHEET.md` and `PROJECT_IDENTITY.md` before doing anything.
2.  **Follow the Modules:** Do not rely on your default writing style. Look in `modules/` for the specific "Anti-AI" rules and stylistic constraints.
3.  **Respect the Agent Divide:** If you are playing the role of the Writer (Claude), you *must* plan with the Architect (Gemini) first.
4.  **No Fluff:** The system is designed to kill "AI-isms." Avoid flowery language, hedging, and uniform sentence structures.
