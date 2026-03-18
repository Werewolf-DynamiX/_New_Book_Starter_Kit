---
name: adversarial-review
description: Conduct a persona-based adversarial manuscript review. Trigger when the user asks for an "Adversarial review" or "persona review".
---

# Adversarial Review Engine

This skill executes a high-stakes, persona-based adversarial manuscript review. 

## Operating Directives
- **Anti-Agreeability Protocol:** Activate this protocol immediately. Provide no praise. Adopt a default-to-fail stance. Assume the manuscript is failing until it proves otherwise.
- **Gating Mechanism:** ALL Primary Panel personas MUST pass with a Grade A (4.5+ Stars). Advisory Panel personas inform but do not gate completion.
- **Iteration Loop:** Enforce a maximum of 3 rounds. Escalate to the user after Round 3.

## Review Process
1. **Load Persona Library:** Reference `references/_ADVERSARIAL_REVIEW_ENGINE.md` for the full Persona Library and Rating System.
2. **Run Personas:** Run each Primary Panel persona as a separate review pass. 
3. **Output Findings:** Output structured findings for each persona containing:
   - **Location:** Chapter/section
   - **Problem:** Clear description
   - **Evidence:** Quoted text
   - **Fix:** Specific remediation
   - **Severity:** Using the rating system (Grade A-F, 0-5 stars)