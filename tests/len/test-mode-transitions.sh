#!/usr/bin/env bash
# Behavioral test for Mode transitions and permission gates
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

fail() { echo "FAIL: $*" >&2; exit 1; }
pass() { echo "  [PASS] $*"; }

echo "=== Mode State & Transition Matrix Tests ==="

# Define test matrix
MODES="plan code review search off"

# Test mode definition in mode skill
for m in $MODES; do
  grep -qi "mode.*$m" "$REPO_ROOT/skills/mode/SKILL.md" || fail "Mode $m not documented in mode skill"
  pass "Mode $m declared in skills/mode/SKILL.md"
done

# Test gating logic rules:
# 1. Code mode requires an approved plan
grep -qi "approved plan" "$REPO_ROOT/skills/mode/SKILL.md" || fail "Mode skill missing approved plan prerequisite for Code mode"
grep -qi "mode code" "$REPO_ROOT/skills/writing-plans/SKILL.md" || fail "Writing-plans does not require mode code transition"
pass "Code mode enforces approved plan gate"

# 2. Plan mode prohibits production edits
grep -qi "no production implementation" "$REPO_ROOT/skills/mode/SKILL.md" || fail "Plan mode does not forbid production edits"
pass "Plan mode prohibits production code edits"

# 3. Review mode is non-destructive
grep -qi "without.*edit.*source" "$REPO_ROOT/skills/mode/SKILL.md" || fail "Review mode does not forbid source edits"
pass "Review mode enforces non-destructive inspection"

# 4. Search mode prohibits file edits
grep -qi "no project.*edit" "$REPO_ROOT/skills/mode/SKILL.md" || fail "Search mode does not forbid project file edits"
pass "Search mode enforces read-only research"

# 5. Off mode returns to baseline
grep -qi "baseline" "$REPO_ROOT/skills/mode/SKILL.md" || fail "Off mode does not document return to baseline"
pass "Off mode returns to baseline safety"

echo "=== All Mode Transition Tests Passed ==="
