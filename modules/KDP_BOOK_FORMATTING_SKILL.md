# KDP Book Formatting Skill

A guide for formatting book manuscripts for Amazon KDP print publication using Node.js and the `docx` package.

---

## Quick Start

```bash
npm install docx
```

Convert source document to markdown first (preserves structure better):
```bash
pandoc input.docx -o content.md --wrap=none
```

---

## KDP Specifications

### Trim Size (6" × 9" - most common)

```javascript
const PAGE_WIDTH = 6 * 1440;   // 8640 DXA
const PAGE_HEIGHT = 9 * 1440;  // 12960 DXA
```

### Margins

```javascript
const MARGIN_TOP = 1080;      // 0.75"
const MARGIN_BOTTOM = 1080;   // 0.75"
const MARGIN_INSIDE = 1080;   // 0.75" (gutter - for binding)
const MARGIN_OUTSIDE = 720;   // 0.5"
```

### Typography

```javascript
const BODY_SIZE = 22;         // 11pt (half-points)
const H1_SIZE = 36;           // 18pt - chapter titles
const H2_SIZE = 26;           // 13pt - subheadings
const SMALL_SIZE = 20;        // 10pt - liner notes, footnotes
const LINE_SPACING = 276;     // 1.15 line spacing
```

---

## Document Structure

### Front Matter (no headers/footers, no page numbers)

1. **Half-title page** - book title only, centered, 1/3 down
2. **Blank verso** - back of half-title
3. **Full title page** - title, subtitle, author
4. **Copyright page** - © year, rights, disclaimers, edition
5. **Dedication** - italicized, centered
6. **Epigraph** - quote + attribution (optional)
7. **Table of Contents** - manual list (avoid auto-generated TOC, causes corruption)

### Main Content (with headers/footers)

- Running header: book title in small caps, centered
- Page numbers: centered footer, Arabic numerals starting at 1
- Chapter breaks: page break before each chapter (except first)

### Back Matter

- Appendices
- Glossary
- Notes on Sources
- About the Author
- Call to action (review request)

---

## Critical Formatting Rules

### 1. Widow/Orphan Control

Add to ALL paragraph types:
```javascript
widowControl: true
```

### 2. Keep Headings With Content

Add to chapter titles, subheadings, section breaks, and any header element:
```javascript
keepNext: true
```

### 3. First Paragraph After Heading

**Do NOT indent** the first paragraph after any heading or section break. This is standard book typography.

```javascript
let afterHeading = false;

// When you hit a heading:
afterHeading = true;

// When you create a paragraph:
children.push(bodyPara(text, !afterHeading));  // indent = false if after heading
afterHeading = false;
```

### 4. Glossary/Definition Entries

Paragraphs starting with a bold term + colon should NOT be indented:
```javascript
const isGlossaryEntry = text.match(/^\*\*[^*]+\*\*[\s]*[:(\(]/);
children.push(bodyPara(text, !afterHeading && !isGlossaryEntry));
```

### 5. Block Quotes and Special Sections

Always explicitly set `firstLine: 0` to prevent inherited indentation:
```javascript
indent: { left: 576, right: 576, firstLine: 0 }
```

---

## Content Parsing

### Paragraph Handling

**Critical:** Split by double newlines, then join single newlines within each block:

```javascript
const blocks = content.split(/\n\n+/);

for (let block of blocks) {
  // Join lines within block (single newlines become spaces)
  const text = block.replace(/\n/g, ' ').replace(/\s+/g, ' ').trim();
  // ... process
}
```

### Text Processing

```javascript
function processText(text) {
  return text
    .replace(/\\\*/g, '★ASTERISK★')  // Protect escaped asterisks
    .replace(/\\'/g, "'")
    .replace(/\\"/g, '"')
    .replace(/---/g, "—")            // Em dash
    .replace(/--/g, "–")             // En dash
    .replace(/★ASTERISK★/g, '*');    // Restore for italic processing
}
```

### Italic/Bold Handling

```javascript
function createTextRuns(text, baseSize = BODY_SIZE) {
  const runs = [];
  text = processText(text);
  
  // Bold first
  const parts = text.split(/(\*\*[^*]+\*\*)/g);
  for (const part of parts) {
    if (part.startsWith('**') && part.endsWith('**')) {
      runs.push(new TextRun({ 
        text: part.slice(2, -2), 
        font: "Georgia", 
        size: baseSize, 
        bold: true 
      }));
    } else {
      // Then italics
      const italicParts = part.split(/(\*[^*]+\*)/g);
      for (const ip of italicParts) {
        if (ip.startsWith('*') && ip.endsWith('*')) {
          runs.push(new TextRun({ 
            text: ip.slice(1, -1), 
            font: "Georgia", 
            size: baseSize, 
            italics: true 
          }));
        } else if (ip) {
          runs.push(new TextRun({ 
            text: ip, 
            font: "Georgia", 
            size: baseSize 
          }));
        }
      }
    }
  }
  return runs;
}
```

### Chapter Detection

```javascript
const mainChapters = [
  "Introduction:",
  "Chapter 1:",
  "Conclusion:",
  "Appendix:",
  "Glossary",
  // ... add your chapter patterns
];

function isMainChapter(title) {
  const clean = title.replace(/\*/g, '').toLowerCase();
  return mainChapters.some(ch => clean.startsWith(ch.toLowerCase()));
}
```

### Block Quote Cleaning

When blockquotes span multiple lines, strip `>` from ALL lines before joining:

```javascript
function cleanBlockquoteText(block) {
  const lines = block.split('\n');
  const cleanedLines = lines.map(line => line.replace(/^\s*>\s*/, ''));
  return cleanedLines.join(' ').replace(/\s+/g, ' ').trim();
}
```

### Multi-line Bullet Points

Accumulate continuation lines into each bullet:

```javascript
if (block.includes('> •')) {
  const lines = block.split('\n');
  let currentBullet = '';
  
  for (const line of lines) {
    const cleanLine = line.replace(/^>\s*/, '').trim();
    
    if (cleanLine.startsWith('•')) {
      if (currentBullet) {
        children.push(bulletPoint(currentBullet));
      }
      currentBullet = cleanLine.replace(/^•\s*/, '');
    } else if (cleanLine && currentBullet) {
      currentBullet += ' ' + cleanLine;
    }
  }
  if (currentBullet) {
    children.push(bulletPoint(currentBullet));
  }
}
```

### Discography/Table Entries

Pandoc tables become messy. Parse them into structured entries:

```javascript
function discographyEntry(year, title, notes) {
  const runs = [
    new TextRun({ text: year + "  ", font: "Georgia", size: BODY_SIZE, bold: true }),
    new TextRun({ text: title, font: "Georgia", size: BODY_SIZE, italics: true }),
  ];
  
  if (notes) {
    runs.push(new TextRun({ text: " — " + notes, font: "Georgia", size: BODY_SIZE }));
  }
  
  return new Paragraph({
    children: runs,
    spacing: { after: 160, line: LINE_SPACING },
    indent: { left: 288, firstLine: 0 },
    widowControl: true
  });
}
```

### Italic Subheadings (***text***)

```javascript
if (text.startsWith('***') && text.endsWith('***')) {
  const title = text.slice(3, -3);
  children.push(new Paragraph({
    children: [new TextRun({ 
      text: title, 
      font: "Georgia", 
      size: H2_SIZE, 
      bold: true, 
      italics: true 
    })],
    alignment: AlignmentType.LEFT,
    spacing: { before: 360, after: 180 },
    keepNext: true
  }));
  afterHeading = true;
  continue;
}
```

---

## Common Pitfalls

### 1. Auto-generated Table of Contents
**Problem:** `TableOfContents` component in docx-js can corrupt the document.
**Solution:** Use a manual list of chapter titles.

### 2. Line-by-line Parsing
**Problem:** Each line becomes a separate paragraph with weird wrapping.
**Solution:** Split by `\n\n+` (double newlines), join single newlines with spaces.

### 3. Blockquote Markers Bleeding Through
**Problem:** `>` characters appear in rendered text.
**Solution:** Strip `>` from every line before joining, not just the first line.

### 4. Headings Orphaned at Page Bottom
**Problem:** Chapter title or subheading appears alone at bottom of page.
**Solution:** Add `keepNext: true` to all heading paragraphs.

### 5. Inconsistent Indentation
**Problem:** Some paragraphs indented, some not (looks unprofessional).
**Solution:** 
- First paragraph after heading: no indent
- Glossary entries: no indent
- Block quotes/liner notes: explicit `firstLine: 0`
- All other body paragraphs: consistent indent

### 6. Escaped Characters Showing
**Problem:** `\*`, `\'`, `\"` appear literally in output.
**Solution:** Process text to convert escapes before creating TextRuns.

### 7. Page Break Before First Chapter
**Problem:** Introduction starts on page 2.
**Solution:** Track `isFirstChapter` flag, skip page break for first chapter only.

### 8. Dashes Not Converting
**Problem:** Chapter titles show `1953--1972` instead of `1953–1972`.
**Solution:** Run `processText()` on chapter titles, not just body text.

---

## Document Assembly

```javascript
const doc = new Document({
  styles: {
    default: { 
      document: { 
        run: { font: "Georgia", size: BODY_SIZE } 
      } 
    }
  },
  sections: [
    // Front matter - no headers/footers
    {
      properties: {
        page: {
          size: { width: PAGE_WIDTH, height: PAGE_HEIGHT },
          margin: { top: MARGIN_TOP, bottom: MARGIN_BOTTOM, 
                    left: MARGIN_INSIDE, right: MARGIN_OUTSIDE }
        }
      },
      children: createFrontMatter()
    },
    // Main content - with headers/footers
    {
      properties: {
        page: {
          size: { width: PAGE_WIDTH, height: PAGE_HEIGHT },
          margin: { top: MARGIN_TOP, bottom: MARGIN_BOTTOM, 
                    left: MARGIN_INSIDE, right: MARGIN_OUTSIDE },
          pageNumbers: { start: 1, formatType: NumberFormat.DECIMAL }
        }
      },
      headers: {
        default: new Header({
          children: [
            new Paragraph({
              children: [new TextRun({ 
                text: "BOOK TITLE", 
                font: "Georgia", 
                size: 16, 
                smallCaps: true 
              })],
              alignment: AlignmentType.CENTER
            })
          ]
        })
      },
      footers: {
        default: new Footer({
          children: [
            new Paragraph({
              children: [new TextRun({ 
                children: [PageNumber.CURRENT], 
                font: "Georgia", 
                size: 20 
              })],
              alignment: AlignmentType.CENTER
            })
          ]
        })
      },
      children: contentChildren
    }
  ]
});

// Generate file
Packer.toBuffer(doc).then(buffer => {
  fs.writeFileSync('output.docx', buffer);
});
```

---

## Pre-Flight Checklist

Before generating final document:

- [ ] No duplicate content (search for repeated phrases)
- [ ] All liner notes/special sections properly formatted (header + body together)
- [ ] Chapter sequence correct
- [ ] Front matter complete (half-title, title, copyright, dedication)
- [ ] Back matter complete (appendix, glossary, about author)
- [ ] No malformed blockquotes (header on separate line from body)
- [ ] Tables converted to readable entries
- [ ] Bullet points accumulate multi-line content

---

## Editorial Notes

### Punchy Lines

One-sentence paragraphs for dramatic effect work in moderation. Over a full book, they can feel exhausting. Flag lines like:

- "The music delivered."
- "The internet exploded."
- "Literally."

Either delete or fold into adjacent sentences:
- "He's human. That's the whole point." → "He's human, and that's the whole point."

### What to Keep

Short punchy lines that ARE doing work:
- Thesis statements
- Transition sentences that set up a new section
- Conclusions that land after buildup

---

## Output

Final file goes to `/mnt/user-data/outputs/` for user access.

```javascript
fs.writeFileSync('/mnt/user-data/outputs/Book_Title_KDP.docx', buffer);
```
