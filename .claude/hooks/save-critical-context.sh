#!/bin/bash
# =============================================================================
# save-critical-context.sh — PreCompact hook
# Extracts critical writing rules that must survive context compaction.
# Outputs as text that Claude will retain in compressed context.
# =============================================================================

# Read hook input from stdin
INPUT=$(cat)

echo ""
echo "=== CRITICAL CONTEXT (preserved across compaction) ==="
echo ""

# --- Source shared vocabulary lists ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/banned-vocab.sh"

# --- Banned AI Vocabulary ---
echo "## BANNED AI VOCABULARY (flag when 3+ cluster in a chapter)"
echo "$BANNED_WORDS_CSV"
echo ""

# --- Zero-Tolerance Phrases ---
echo "## ZERO-TOLERANCE PHRASES (never use)"
for phrase in "${ZERO_TOLERANCE_PHRASES[@]}"; do
  echo "- '$phrase'"
done
echo ""

# --- Filter Words ---
echo "## FILTER WORDS (remove distancing phrases)"
echo "Cut: $FILTER_WORDS"
echo ""

# --- Burstiness Rules ---
echo "## BURSTINESS (non-negotiable)"
echo "- Mix short (2-6 words), medium (8-15), and long (18-30) sentences"
echo "- Never 2+ similar-length sentences back-to-back"
echo "- If 10 consecutive sentences are all 12-18 words = AI Flatline = REJECT"
echo "- Vary paragraph length: some 1-sentence, some 4-5 sentences"
echo "- One-word sentences and fragments are legal"
echo ""

# --- Current Persona ---
if [ -f "context/WRITER_VOICE.md" ]; then
  PERSONA=$(cat "context/WRITER_VOICE.md" 2>/dev/null)
  if [ -n "$PERSONA" ]; then
    echo "## ACTIVE PERSONA"
    echo "$PERSONA"
    echo ""
  fi
else
  echo "## ACTIVE PERSONA"
  echo "WARNING: context/WRITER_VOICE.md not found. Define persona before writing."
  echo ""
fi

# --- Active Project Identity ---
if [ -f "PROJECT_IDENTITY.md" ]; then
  IDENTITY=$(cat "PROJECT_IDENTITY.md" 2>/dev/null)
  if [ -n "$IDENTITY" ]; then
    echo "## PROJECT IDENTITY"
    echo "$IDENTITY"
    echo ""
  fi
else
  echo "## PROJECT IDENTITY"
  echo "WARNING: PROJECT_IDENTITY.md not found. Define project identity before writing."
  echo ""
fi

echo "=== END CRITICAL CONTEXT ==="
echo ""

exit 0
