#!/bin/bash
# =============================================================================
# banned-vocab.sh — Single source of truth for AI vocabulary lists
# Sourced by deai-quick-scan.sh and save-critical-context.sh
# =============================================================================

# AI-associated words that cluster
BANNED_WORDS=(
  "delve" "tapestry" "testament" "myriad" "plethora"
  "multifaceted" "crucial" "nuanced" "realm" "paradigm"
  "notably" "furthermore" "moreover" "additionally" "seamlessly"
  "leverage" "harness" "foster" "cultivate" "invaluable"
  "indispensable" "paramount" "intricate" "game-changer"
  "cutting-edge" "revolutionary" "rich tapestry" "vibrant landscape"
  "dynamic" "optimize" "utilize" "facilitate" "deep dive"
)

# Comma-separated for display
BANNED_WORDS_CSV="delve, tapestry, testament, myriad, plethora, multifaceted, crucial, nuanced, realm, paradigm, notably, furthermore, moreover, additionally, seamlessly, leverage, harness, foster, cultivate, invaluable, indispensable, paramount, intricate, game-changer, cutting-edge, revolutionary, rich tapestry, vibrant landscape, dynamic, optimize, utilize, facilitate, deep dive"

# Zero-tolerance phrases
ZERO_TOLERANCE_PHRASES=(
  "A testament to"
  "A reminder that"
  "In conclusion,"
  "Ultimately,"
  "At the end of the day"
  "Let's dive in"
  "Let's explore"
  "In this chapter, we will"
  "It's not just about"
  "To understand .*, you have to understand"
  "Let that sink in"
  "It is important to note that"
  "In today's digital age"
  "Whether it's .* or"
  "Only time will tell"
  "Think of .* as a"
)

# Filter words
FILTER_WORDS="saw, heard, felt, noticed, realized, watched, observed, thought, wondered, seemed"
