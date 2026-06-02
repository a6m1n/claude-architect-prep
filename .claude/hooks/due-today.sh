#!/usr/bin/env bash
# SessionStart hook for the Claude Certified Architect study workspace.
# Prints a short "what's due" study digest to stdout; Claude Code injects
# stdout from a SessionStart hook into the session context.
# READ-ONLY (never writes progress.json — progress-tracker is the sole writer).
# Fast + graceful when uninitialized.
set -euo pipefail

# The hook receives event JSON on stdin; we don't need it. Drain it safely.
cat >/dev/null 2>&1 || true

PROGRESS="${CLAUDE_PROJECT_DIR:-.}/exam-notes/progress.json"

if [ ! -f "$PROGRESS" ]; then
  echo "📚 Study tracker not initialized. Run the progress-tracker skill ('init') to start spaced repetition, then use /tutor, /quiz, or /due."
  exit 0
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "📚 Study queue is in exam-notes/progress.json (install jq for an auto digest, or just ask 'what's due')."
  exit 0
fi

TODAY="$(date +%F)"
DUE=$(jq -r --arg t "$TODAY" '[.concepts[]? | select(.next_due != null and .next_due <= $t)] | length' "$PROGRESS" 2>/dev/null || echo 0)
RED=$(jq -r '[.concepts[]? | select(.tag == "red")] | length' "$PROGRESS" 2>/dev/null || echo 0)

if [ "${DUE:-0}" -gt 0 ]; then
  echo "📚 Study queue for ${TODAY}: ${DUE} concept(s) due for review (${RED} flagged 🔴). Start with /tutor or /quiz due; check /readiness vs the 720 bar."
else
  echo "📚 Nothing due today. Reinforce with /quiz weak, or run /mock to checkpoint readiness vs 720."
fi
exit 0
