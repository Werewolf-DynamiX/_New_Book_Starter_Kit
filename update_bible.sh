#!/bin/bash
set -e

echo "============================================"
echo "  Targeted Continuity Audit"
echo "============================================"

if ! command -v gemini &> /dev/null; then
    echo "ERROR: 'gemini' CLI not found."
    exit 1
fi

CHAPTERS=(manuscript/chapters/*.md)
if [ ! -e "${CHAPTERS[0]}" ]; then
    echo "ERROR: No chapters found."
    exit 1
fi

gemini "Perform six targeted continuity checks on the manuscript files in manuscript/chapters/. Reference context/FACTS_SHEET.md as canonical truth.

CHECK 1 — NAME INTRODUCTIONS: For every named character, identify the first scene they appear in. Flag any case where a POV character addresses or refers to someone by name before that name has been stated in their presence.

CHECK 2 — KNOWLEDGE GRAPH: Track who knows what. Flag any dialogue or internal thought where a character references information they shouldn't have at that point in the story.

CHECK 3 — NAME SIMILARITY: Identify any pair of named characters whose names differ by fewer than three letters (e.g., Moren/Meren). Flag as potential reader confusion.

CHECK 4 — CONTIGUOUS CONTRADICTIONS: For each 20-page span, flag statements that directly contradict other statements within the same span (e.g., 'she can't sleep' followed shortly by 'sleep comes eventually').

CHECK 5 — BACKSTORY CONSISTENCY: Track every character's stated backstory. Flag any dialogue or internal thought that contradicts their established history.

CHECK 6 — LOCATION CONTINUITY: Track physical locations scene by scene. Flag any scene where a character is in a location that contradicts where the previous scene ended.

Output findings in a table: Check | Chapter | Quote | What it contradicts | Severity." $(ls manuscript/chapters/*.md) > context/CONTINUITY_REPORT.md

echo "Report written to context/CONTINUITY_REPORT.md"
echo "Review manually and update FACTS_SHEET.md / manuscript as needed."
