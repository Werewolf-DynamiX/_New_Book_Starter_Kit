---
name: voice-lint
description: Mechanical check of character dialogue against character bible rules in docs/characters.md. Use when the user requests voice linting or when verifying dialogue constraints.
---

# Voice Lint

## Overview
Performs a mechanical audit of dialogue to ensure characters speak according to their specific constraints.

## Execution Protocol

Read `docs/characters.md` voice constraints table. Read the target chapter.
For each character with documented voice rules, check every line of their
dialogue for violations. Report: character, line, violation, suggested fix.
Do not evaluate prose quality. This is a mechanical audit only.
