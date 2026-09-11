#!/usr/bin/env bash
# Validate Mode Selector, Len Policy loading, and single-agent constraints
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

fail() { echo "FAIL: $*" >&2; exit 1; }
pass() { echo "  [PASS] $*"; }

echo "=== Len Mode Selector & Policy Integration Tests ==="

# 1. Mode selector skill exists and defines supported modes
MODE_SKILL="$REPO_ROOT/skills/mode/SKILL.md"
[ -f "$MODE_SKILL" ] || fail "mode skill missing at $MODE_SKILL"
grep -q "^name: mode" "$MODE_SKILL" || fail "mode skill missing name: mode"
for m in Plan Code Review Search Off; do
  grep -q "$m" "$MODE_SKILL" || fail "mode skill does not document mode $m"
done
pass "Mode selector exists and documents Plan, Code, Review, Search, Off"

# 2. Council skill exists
[ -f "$REPO_ROOT/skills/council/SKILL.md" ] || fail "council skill missing"
pass "Council skill present"

# 3. Ponytail suite exists
for p in ponytail ponytail-audit ponytail-debt ponytail-gain ponytail-help ponytail-review; do
  [ -f "$REPO_ROOT/skills/$p/SKILL.md" ] || fail "ponytail skill $p missing"
done
pass "Ponytail suite present (ponytail, audit, debt, gain, help, review)"

# 4. Canonical policy exact hash
ORIGINAL_POLICY="$REPO_ROOT/docs/len/AGENTS.original.md"
[ -f "$ORIGINAL_POLICY" ] || fail "canonical policy missing at $ORIGINAL_POLICY"
EXPECTED_HASH="86ee90450b7032f2cc0aed01de32f069d81e555f6bbaee08b286528861433463"
ACTUAL_HASH=$(sha256sum "$ORIGINAL_POLICY" | awk '{print tolower($1)}')
[ "$ACTUAL_HASH" = "$EXPECTED_HASH" ] || fail "policy hash mismatch: expected $EXPECTED_HASH, got $ACTUAL_HASH"
pass "Canonical AGENTS.original.md SHA-256 matches exact baseline"

# 5. Policy adapter exists and documents MIG-REQ-03 & MIG-REQ-02
ADAPTER="$REPO_ROOT/docs/len/AGENTS.adapter.md"
[ -f "$ADAPTER" ] || fail "policy adapter missing at $ADAPTER"
grep -q "MIG-REQ-03" "$ADAPTER" || fail "adapter missing MIG-REQ-03 reference"
grep -q "MIG-REQ-02" "$ADAPTER" || fail "adapter missing MIG-REQ-02 reference"
pass "Policy adapter documents MIG-REQ-03 interpretations and MIG-REQ-02 contract"

# 6. Policy loading in GEMINI.md
GEMINI_MD="$REPO_ROOT/GEMINI.md"
grep -q "@./docs/len/AGENTS.original.md" "$GEMINI_MD" || fail "GEMINI.md does not load AGENTS.original.md"
grep -q "@./docs/len/AGENTS.adapter.md" "$GEMINI_MD" || fail "GEMINI.md does not load AGENTS.adapter.md"
pass "GEMINI.md loads exact policy and adapter via extension context"

# 7. Policy injection in session-start hook
SESSION_START="$REPO_ROOT/hooks/session-start"
grep -q "docs/len/AGENTS.original.md" "$SESSION_START" || fail "hooks/session-start does not read AGENTS.original.md"
grep -q "docs/len/AGENTS.adapter.md" "$SESSION_START" || fail "hooks/session-start does not read AGENTS.adapter.md"
pass "hooks/session-start injects exact policy and adapter"

# 8. Single-agent constraint and mode gating in core process skills
USING_SP="$REPO_ROOT/skills/using-superpowers/SKILL.md"
grep -q "Single-Agent Execution" "$USING_SP" || fail "using-superpowers does not enforce single-agent execution"
grep -q "Workflow Modes" "$USING_SP" || fail "using-superpowers does not document workflow modes"

WRITING_PLANS="$REPO_ROOT/skills/writing-plans/SKILL.md"
grep -q "mode code" "$WRITING_PLANS" || fail "writing-plans does not gate execution on mode code switch"

EXECUTING_PLANS="$REPO_ROOT/skills/executing-plans/SKILL.md"
grep -q "single primary agent" "$EXECUTING_PLANS" || fail "executing-plans does not enforce single primary agent"
grep -q "hard stops" "$EXECUTING_PLANS" || fail "executing-plans does not enforce hard stops"

pass "Process skills enforce mode gates and single-agent constraints"

echo "=== All Mode Selector & Policy Tests Passed ==="
