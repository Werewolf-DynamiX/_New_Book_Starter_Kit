---
name: kdp-format
description: Format book manuscripts for Amazon KDP print publication. Trigger when the user asks to "Format for KDP" or "KDP formatting".
---

# KDP Formatting

This skill provides the workflow and constraints for formatting book manuscripts for Amazon KDP print publication.

## Operating Directives
- **Primary Directive:** The KDP specification is the primary operating directive. Apply all formatting rules as hard constraints, not suggestions.
- **Validation:** Output MUST be validated against KDP's technical requirements before declaring the task done.

## Workflow
1. **Convert Source:** Always start by converting the source document to Markdown. This preserves structure better. Use Pandoc:
   ```bash
   pandoc input.docx -o content.md --wrap=none
   ```
2. **Process and Format:** Apply the Node.js/docx workflow. Refer to `references/KDP_BOOK_FORMATTING_SKILL.md` for specific implementation rules, including:
   - Trim Size (6" × 9") and Margins
   - Typography (Georgia, size 22 for body, etc.)
   - Document Structure (Front Matter, Main Content, Back Matter)
   - Critical Formatting Rules (Widow/Orphan control, Keeping headings with content, Indentation rules)
   - Content Parsing (Paragraph handling, Bold/Italic processing, etc.)
3. **Assemble and Validate:** Generate the final `.docx` using the `docx` library and review against the Pre-Flight Checklist in the reference.