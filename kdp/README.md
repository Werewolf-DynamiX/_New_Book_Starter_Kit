# KDP Submission Guide

This directory holds artifacts for Amazon KDP (Kindle Direct Publishing)
submission. The starter kit gives you structure; Amazon's own
[KDP help pages](https://kdp.amazon.com/help) are always the source of
truth for current specs.

## Directory conventions

- `kdp/covers/` — finished cover art (print PDF + ebook JPG/PNG)
- `kdp/submitted/` — copies of exactly what you uploaded, dated, for your
  records (this is the version Amazon actually has)
- `kdp/mockups/` — design iterations, drafts, alternates
- `kdp/README.md` — this file

The `release/` directory at the project root is where compiled manuscript
artifacts land (EPUB, PDF, DOCX). Those go *into* KDP; this directory
catches what comes out of KDP and what you built for it.

## Interior file specs

### Print interior (PDF)

- **Trim sizes** (common):
  - 5 x 8 — mass-market feel, short fiction/novellas
  - 5.5 x 8.5 — trade paperback standard, fiction
  - **6 x 9 — standard for nonfiction and longer novels (kit default)**
  - 8.5 x 11 — textbook/workbook
- **Margins:** 0.75" inner (gutter), 0.5" outer, 0.75" top/bottom minimum
  for the 6x9 default. KDP rejects files with margins too close to the
  trim line.
- **Bleed:** 0.125" on each outer edge only if your interior has
  full-bleed images (most books don't — leave bleed off).
- **Fonts:** Must be fully embedded. Pandoc + LuaLaTeX (our build
  pipeline) embeds automatically.
- **Page count:** Even number required. Insert blank pages if needed.

### Ebook interior (EPUB)

- Standard EPUB 3 from pandoc works for KDP.
- No DRM — Amazon handles that on ingestion.
- Keep cover image out of the EPUB interior; upload it separately.

## Cover specs

### Print cover (PDF, single file for front + spine + back)

- **Resolution:** 300 DPI minimum
- **Color space:** CMYK recommended (Amazon accepts RGB but converts)
- **Bleed:** 0.125" on all outer edges (required)
- **Spine width:** depends on page count and paper type:
  - White paper: page count × 0.002252"
  - Cream paper: page count × 0.0025"
  - E.g. 300-page cream book = 0.75" spine
- **Total cover dimensions for 6x9, 300 pages cream paper:**
  - Width: 6 + 6 + 0.75 + 0.125 + 0.125 = 13"
  - Height: 9 + 0.125 + 0.125 = 9.25"
- KDP's [cover calculator](https://kdp.amazon.com/cover-calculator) is
  authoritative — use it after page count is final.

### Ebook cover (JPG or PNG)

- **Aspect ratio:** 1.6:1 (height:width)
- **Recommended size:** 2560 x 1600 pixels
- **Minimum:** 1000 x 1600 pixels
- **Max file size:** 50 MB
- **Format:** JPG or TIFF; PNG works but JPG is safer

## Metadata required at upload

- Title (must match book exactly, including subtitle)
- Subtitle (optional but affects search)
- Series name and book number (if applicable)
- Author name and contributors
- Description — up to 4000 characters; your `book.yaml` `abstract:` field
  is a good starting point
- Keywords — 7 slots, each up to 50 chars. These matter for
  discoverability. Research competitor books before choosing.
- Categories — 3 at upload; you can email KDP to request up to 10 total.
- ISBN — Amazon provides a free one for the ebook; print ISBN can be
  Amazon's (free) or your own (costs money, transfers between platforms)
- Age range and grade range (if children's/YA)
- Adult content flag (if 18+)

## Pre-submission checklist

- [ ] Interior PDF has even page count
- [ ] All fonts embedded
- [ ] No hyperlinks in print interior (or they're styled to print well)
- [ ] Front matter ends before first chapter with correct page breaks
- [ ] Back matter includes review request
- [ ] Cover bleed and spine width match final page count
- [ ] Metadata description has no broken markup or placeholder text
- [ ] Keywords researched against top-10 competitors
- [ ] Categories verified (some require email to activate)
- [ ] Pricing set (check KDP royalty thresholds: $2.99-$9.99 for 70% ebook)
- [ ] Preview on KDP's online previewer before clicking Publish
