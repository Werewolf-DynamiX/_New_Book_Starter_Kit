# MASTER BOOK REVIEW PROMPT

## Multi-Model Collaborative Manuscript Analysis

**Version:** 3.0  
**Purpose:** Publication-grade editorial review using Claude CLI + Gemini CLI in coordinated passes

---

## WORKFLOW OVERVIEW

This prompt is designed for a **multi-pass, multi-model workflow**. Different models handle what they're best at:

| Pass | Focus | Recommended Model | Why |
|------|-------|-------------------|-----|
| **Pass 0** | Classification & Triage | Gemini Flash / Haiku | Fast, cheap, just needs to categorize |
| **Pass 1** | Structure & Market | Claude Opus or Sonnet | Nuanced judgment on pacing, voice, commercial instincts |
| **Pass 2** | Accuracy & Consistency | Gemini Pro | Strong at factual verification, large context for cross-referencing |
| **Pass 3** | Line-Level & Polish | Claude Opus or Sonnet | Best at prose quality, natural language, subtle issues |
| **Pass 4** | Adversarial & Authenticity | Split (see below) | Each model catches different things |
| **Pass 5** | Synthesis | Claude Opus | Reconcile findings, prioritize, create final action list |

**Execution:** Run each pass separately. Feed the manuscript + the relevant section of this prompt. Collect outputs. Synthesize at the end.

---

# PASS 0: CLASSIFICATION & TRIAGE

**Model:** Gemini Flash or Claude Haiku  
**Input:** Full manuscript (or first 3 chapters for very long works)

## Task

Classify the manuscript and output a structured assessment:

```yaml
classification:
  genre: [Genre/Category]
  subject_domain: [Subject area]
  target_audience: [Who this is for]
  tone: [Academic/Conversational/Journalistic/Satirical/Literary]
  word_count: [Actual count]
  length_class: [Short <30K / Standard 30-80K / Long 80K+]
  fiction_or_nonfiction: [Fiction / Nonfiction / Hybrid]
  
fact_check_mode:
  # For Nonfiction: STANDARD (verify external claims)
  # For Fiction: LORE_CONSISTENCY (verify internal rules)
  mode: [STANDARD / LORE_CONSISTENCY]
  
series_potential:
  is_part_of_series: [Yes/No/Unclear]
  hooks_next_book: [Yes/No/NA]
  
estimated_passes_needed:
  # Based on length and complexity
  recommended: [1-3 depending on length]
  
initial_concerns:
  # Top 3 things that jumped out on first read
  - [Concern 1]
  - [Concern 2]
  - [Concern 3]
```

This output feeds into all subsequent passes.

---

# PASS 1: STRUCTURE & MARKET ANALYSIS

**Model:** Claude Opus or Claude Sonnet  
**Input:** Full manuscript + Pass 0 classification

## Perspectives to Apply

### Developmental Editor

- Does the book deliver what the title/introduction promises?
- Is the structure logical? Should chapters be reordered or cut?
- Where does pacing drag or rush?
- Is there a clear throughline or thesis?
- Is the opening compelling enough to hook a browser?
- Does the ending satisfy? (For series: does it hook Book 2 without feeling cheap?)
- Does each chapter earn its place?

### Market Positioning Analyst

- Who is the target reader? Is that audience large enough?
- What are comparable titles? How does this stack up?
- What's the unique angle or hook?
- Can this be pitched in one sentence?
- Is there commercial potential?

### KDP/Self-Pub Specialist

- Is the title search-optimized for the category?
- Is word count appropriate for the genre and price point?
- Would the implied cover concept and description convert?
- **Series Potential:** Does the structure support read-through to future books? Is the ending satisfying but leaves readers wanting more?

### Target Reader Simulation

- Does this deliver what the cover and description promise?
- Is it accessible at the target knowledge level?
- Would I recommend this to peers?

## Output Format

List issues with:

- **Location:** Chapter/section
- **Problem:** Clear description
- **Evidence:** Quoted text
- **Fix:** Specific remediation
- **Complexity:** Low / Medium / High

---

# PASS 2: ACCURACY & CONSISTENCY

**Model:** Gemini Pro (large context helps for cross-referencing)  
**Input:** Full manuscript + Pass 0 classification

## Perspectives to Apply

### Subject Matter Expert (SME)
- Does the technical/historical detail hold up to scrutiny?
- Are the specific terms (jargon) used correctly for the domain?
- **Fiction:** Does the "science" or magic follow its own internal logic rigorously?
- **Nonfiction:** Would a professor or practitioner in this field spot errors?

## Mode Selection (from Pass 0)

### If NONFICTION (Fact-Check Mode: STANDARD)

For each significant factual claim:

| Claim | Location | Status | Note |
|-------|----------|--------|------|
| [Claim text] | Ch X, ¶Y | TRUE / FALSE / UNVERIFIABLE / NEEDS HEDGING | [Source or issue] |

Check specifically:

- Dates, names, titles, statistics
- Quotes (attributed? accurate?)
- Historical and technical claims
- Claims needing hedging ("reportedly," "according to")
- Technical specifications and procedures
- Safety-critical information

### If FICTION (Fact-Check Mode: LORE_CONSISTENCY)

Track and verify internal consistency:

**World Rules:**

- Magic system rules: Are they applied consistently?
- Technology rules: Do capabilities stay consistent?
- Physical/geographic rules: Do distances, travel times, layouts stay consistent?

**Character Consistency:**

- Physical descriptions: Do eye color, height, distinguishing features stay constant?
- Abilities: Do character skills/powers remain consistent?
- Knowledge: Do characters "know" things they shouldn't have learned yet?
- Voice: Does each character's speech pattern stay distinct?

**Timeline:**

- Do events occur in logical sequence?
- Are time references consistent (days of week, seasons, ages)?
- Do characters age appropriately across the narrative?

**Proper Nouns:**

- Are character names spelled consistently?
- Are place names consistent?
- Are invented terms used consistently?

### Both Modes: Cross-Reference Audit

- Do chapter titles match TOC?
- Do internal references ("as mentioned in Chapter 3") point correctly?
- Are abbreviations/acronyms defined before use?

## Output Format

List issues with Location, Problem, Evidence, Fix, Complexity (Low/Med/High)

---

# PASS 3: LINE-LEVEL & POLISH

**Model:** Claude Opus or Claude Sonnet  
**Input:** Full manuscript (or chapter-by-chapter for long works)

## Perspectives to Apply

### Line Editor

- Awkward constructions that need rewriting?
- Sentences that are unclear on first read?
- Paragraphs that bury the point?
- Weak verbs that could be stronger?
- Passive voice where active would be better?

### Copy Editor

- Grammar, punctuation, spelling errors?
- Sentence variety (length, structure, rhythm)?
- Repeated words or phrases within paragraphs?
- Consistent terminology throughout?
- Style guide consistency?

### Novice Reader

- What terms are used without definition?
- What background knowledge is assumed?
- Where would a newcomer get lost?

### Impatient Reader

- Where does attention flag?
- What sections feel like filler?
- Where is the author repeating themselves?
- What could be cut without loss?

## Output Format

List issues with Location, Problem, Evidence, Fix, Complexity (Low/Med/High)

---

# PASS 4: ADVERSARIAL & AUTHENTICITY

**Split between models for cross-validation**

## Part A: Skeptical Reader

**Model:** Gemini Pro  

- What's the weakest argument or section?
- What's missing that should be included?
- Where does the author overreach or overclaim?
- What would a hostile reviewer attack?
- What counterarguments are not addressed?

## Part B: Voice & Authenticity

**Model:** Claude Opus or Claude Sonnet  

### Voice Consistency

- Does this read like one person wrote it?
- Is there a consistent personality throughout?
- Read key passages aloud mentally: do they sound natural or stilted?
- Are there jarring tonal shifts?

### Originality Assessment

- What phrases are clichés that should be rewritten?
- Where is there generic filler instead of specific insight?
- What could appear in any book on this topic vs. what's unique here?
- Does the author have a distinctive point of view?

### Machine-Pattern Review

**Check for these patterns (flag only if pervasive, not occasional):**

*Vocabulary patterns (flag if clustered/excessive):*

- delve, tapestry, testament, myriad, multifaceted, nuanced
- notably, furthermore, moreover, it's worth noting
- landscape, realm, paradigm, cornerstone, pivotal
- seamlessly, leverage, harness, foster, cultivate
- invaluable, indispensable, paramount, intricate

*Structural patterns:*

- Uniform sentence/paragraph length throughout
- Overly smooth transitions (real writing has more texture)
- Every paragraph follows identical structure
- Formulaic [Setup → Quote → Explanation] pattern
- **Summary Conclusions:** Every chapter ends with "Ultimately," "In the end," or a paragraph restating what was just said
- **Sermonizing Dialogue:** Characters giving speeches that feel too balanced, diplomatic, or moralistic

*Literal AI Remnants (instant flags):*

- "As an AI language model"
- "I cannot" / "I'm unable to" (in narrative voice)
- Refusal language or safety hedging in inappropriate contexts
- "Here's" or "Here are" constructions to introduce lists (in prose)

**Important:** Many flagged words appear in legitimate human writing. Only flag when patterns are pervasive or unnatural. The goal is authenticity, not word-banning.

## Part C: Legal & Sensitivity

**Model:** Either (Gemini or Claude)

- Are living people portrayed fairly and accurately?
- Could any statement be defamatory?
- Are quotes used within fair use?
- Is potentially harmful content handled responsibly?
- Are marginalized groups represented without stereotype?
- What disclaimers might be needed?

## Output Format

List issues with Location, Problem, Evidence, Fix, Complexity (Low/Med/High)

---

# PASS 5: SYNTHESIS & PRIORITIZATION

**Model:** Claude Opus  
**Input:** Outputs from all previous passes

## Task

1. **Deduplicate:** Merge issues flagged by multiple passes
2. **Cross-Validate:** Note where models agreed (high confidence) vs. disagreed (needs human review)
3. **Prioritize:** Assign final priority to each issue:

| Priority | Meaning | Action |
|----------|---------|--------|
| **CRITICAL** | Blocks publication: factual errors, legal risk, broken formatting | Must fix |
| **HIGH** | Significant quality impact: structural problems, confusion | Should fix |
| **MEDIUM** | Polish issues: awkward phrasing, minor inconsistencies | Fix if time |
| **LOW** | Preferences: stylistic suggestions | Optional |

1. **Sequence:** Order fixes logically (structural changes before line edits)
2. **Estimate:** Total complexity load (how many High-complexity fixes?)

## Final Output Structure

```markdown
# MANUSCRIPT REVIEW: [Title]

## Classification Summary
[From Pass 0]

## Executive Summary
- Total Issues: X
- Critical: X | High: X | Medium: X | Low: X
- Estimated Remediation Effort: [Light / Moderate / Substantial]
- Publication Readiness: [Ready / Near-Ready / Needs Work / Major Revision]

## Critical Issues (Must Fix)
[Detailed issue list]

## High Priority Issues
[Detailed issue list]

## Medium Priority Issues
[Detailed issue list]

## Low Priority Issues
[Summary or detailed list]

## Model Agreement Notes
- Issues flagged by both Claude and Gemini: [list]
- Issues flagged by one model only: [list]
- Conflicting assessments requiring human judgment: [list]

## Recommended Fix Sequence
1. [First fix - usually structural]
2. [Second fix]
...

## Checklists

### Format Compliance
- [ ] No broken characters
- [ ] Proper typography
- [ ] TOC links functional
- [ ] Consistent heading hierarchy

### Front Matter
- [ ] Title page
- [ ] Copyright page
- [ ] Table of contents
- [ ] Introduction/Preface

### Back Matter
- [ ] Conclusion/Afterword
- [ ] Notes/Bibliography (if applicable)
- [ ] Author bio
- [ ] CTA (review request, mailing list)
- [ ] Other books by author

### Audiobook Readiness
- [ ] No visual-only content
- [ ] Footnotes handled for audio
- [ ] Acronyms pronounceable
- [ ] No "see above/below" references
```

---

# CLI EXECUTION GUIDE

## Prerequisites

- `claude` CLI installed and configured
- `gemini` CLI installed and configured (or use API)
- Manuscript in plain text or markdown format

## Example Workflow

```bash
# Pass 0: Classification (fast model)
gemini -m flash -f manuscript.md -p "$(cat pass0_prompt.md)" > pass0_output.md

# Pass 1: Structure & Market (Claude heavy)
claude -m opus -f manuscript.md -f pass0_output.md -p "$(cat pass1_prompt.md)" > pass1_output.md

# Pass 2: Accuracy (Gemini Pro for context length)
gemini -m pro -f manuscript.md -f pass0_output.md -p "$(cat pass2_prompt.md)" > pass2_output.md

# Pass 3: Line-Level (Claude for prose judgment)
claude -m sonnet -f manuscript.md -p "$(cat pass3_prompt.md)" > pass3_output.md

# Pass 4A: Skeptical (Gemini)
gemini -m pro -f manuscript.md -p "$(cat pass4a_prompt.md)" > pass4a_output.md

# Pass 4B: Voice & Authenticity (Claude)
claude -m opus -f manuscript.md -p "$(cat pass4b_prompt.md)" > pass4b_output.md

# Pass 5: Synthesis (Claude Opus)
claude -m opus -f pass1_output.md -f pass2_output.md -f pass3_output.md -f pass4a_output.md -f pass4b_output.md -p "$(cat pass5_prompt.md)" > FINAL_REVIEW.md
```

## Model Selection Rationale

| Model | Best For | Use When |
|-------|----------|----------|
| **Gemini Flash** | Classification, simple checks | Speed matters, task is straightforward |
| **Claude Haiku** | Quick categorization, format checks | Need Claude's style but task is simple |
| **Gemini Pro** | Fact-checking, cross-referencing, adversarial critique | Large context needed, factual verification |
| **Claude Sonnet** | Line editing, voice analysis | Good balance of quality and speed |
| **Claude Opus** | Developmental feedback, synthesis, nuanced judgment | Quality matters most, complex reasoning |

## Cost Optimization Tips

- Use Flash/Haiku for Pass 0 (classification is simple)
- Use Sonnet instead of Opus for Pass 3 if manuscript is clean
- Run Pass 4 parts in parallel
- For very long manuscripts: chunk into sections for line-level passes

---

# SINGLE-MODEL FALLBACK

If you only have access to one model, run passes sequentially with the same model. Use this prompt structure:

```markdown
You are reviewing a manuscript in multiple passes. This is Pass [N] of 5.

Previous pass outputs:
[Paste relevant previous outputs]

Focus for this pass:
[Paste relevant section from above]

Manuscript:
[Paste manuscript]
```

The multi-model approach catches more issues through different "perspectives," but single-model still works.

---

# QUICK REFERENCE: WHAT EACH MODEL HANDLES

```
GEMINI FLASH / HAIKU
├── Pass 0: Classification & triage
└── Quick format compliance checks

GEMINI PRO  
├── Pass 2: Fact-checking / Lore consistency
├── Pass 4A: Skeptical/adversarial read
└── Cross-reference verification

CLAUDE SONNET
├── Pass 3: Line-level editing (if manuscript is relatively clean)
└── Quick voice checks

CLAUDE OPUS
├── Pass 1: Structure & market analysis
├── Pass 3: Line-level editing (if manuscript needs heavy work)
├── Pass 4B: Voice & authenticity
└── Pass 5: Synthesis & final prioritization
```

---

[END OF PROMPT FRAMEWORK]
