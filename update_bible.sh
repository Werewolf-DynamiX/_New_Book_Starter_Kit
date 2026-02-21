#!/bin/bash
set -e

# ============================================================
# update_bible.sh — Automated Continuity Extraction
# ============================================================
# This script uses Gemini to extract characters, locations, 
# and timeline events from your manuscript and updates 
# your context/FACTS_SHEET.md.
# ============================================================

echo "============================================"
echo "  Continuity Extraction (The Entity Extractor)"
echo "============================================"

# Check for gemini CLI
if ! command -v gemini &> /dev/null; then
    echo "ERROR: 'gemini' CLI not found. Please install it first."
    exit 1
fi

# Check for chapters
CHAPTERS=(manuscript/chapters/*.md)
if [ ! -e "${CHAPTERS[0]}" ]; then
    echo "ERROR: No chapters found in manuscript/chapters/"
    exit 1
fi

echo "Reading manuscript/chapters/..."

# Read Strategy 1 from CONTINUITY_AUDIT_PROMPT.md
STRATEGY_FILE="CONTINUITY_AUDIT_PROMPT.md"
if [ ! -f "$STRATEGY_FILE" ]; then
    echo "ERROR: $STRATEGY_FILE not found."
    exit 1
fi

# Extract the Strategy 1 prompt (lines after Strategy 1 until next strategy)
# This is a bit brittle but better than hardcoding.
# For simplicity in this script, we'll just refer to the strategy file in the prompt.

echo "Running forensic extraction with Gemini..."

# We pass all chapter files to Gemini.
# Note: On some systems with huge manuscripts, this might hit shell argument limits.
# But for typical book sizes, it should be fine.

gemini "Read Strategy 1 in $STRATEGY_FILE and perform the forensic extraction on the following chapter files. Compare the findings with context/FACTS_SHEET.md and provide an updated, unified facts table. Flag any contradictions. $(ls manuscript/chapters/*.md)" > context/FACTS_SHEET_NEW.md

echo "Extraction complete."
echo "New facts written to context/FACTS_SHEET_NEW.md"
echo "Please review context/FACTS_SHEET_NEW.md and merge into context/FACTS_SHEET.md if satisfied."
echo "============================================"
