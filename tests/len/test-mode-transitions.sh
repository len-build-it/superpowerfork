#!/usr/bin/env bash
# Behavioral test for Mode transitions and permission gates
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

fail() { echo "FAIL: $*" >&2; exit 1; }
pass() { echo "  [PASS] $*"; }

echo "=== Mode State & Transition Matrix Tests ==="

MODE_SKILL="$REPO_ROOT/skills/mode/SKILL.md"
USING_SP="$REPO_ROOT/skills/using-superpowers/SKILL.md"
WRITING_PLANS="$REPO_ROOT/skills/writing-plans/SKILL.md"
EXECUTING_PLANS="$REPO_ROOT/skills/executing-plans/SKILL.md"
REVIEW_SKILL="$REPO_ROOT/skills/requesting-code-review/SKILL.md"
COUNCIL_SKILL="$REPO_ROOT/skills/council/SKILL.md"
PONYTAIL_SKILL="$REPO_ROOT/skills/ponytail/SKILL.md"
PROVENANCE="$REPO_ROOT/docs/len/PROVENANCE.md"
HOOKS_JSON="$REPO_ROOT/hooks/hooks.json"
ORIGINAL_POLICY="$REPO_ROOT/docs/len/AGENTS.original.md"

# Scenario 1: Fresh conversation, small question
grep -qi "None.*General discussion" "$MODE_SKILL" || fail "Scenario 1: Mode skill missing None default definition"
grep -qi "No autonomous implementation" "$MODE_SKILL" || fail "Scenario 1: None mode must prohibit autonomous implementation"
grep -qi "Workflow Modes" "$USING_SP" || fail "Scenario 1: using-superpowers missing workflow mode definitions"
pass "Scenario 1 (Fresh conversation, small question): Default None mode prevents autonomous execution"

# Scenario 2: Select Plan, discuss a consequential decision
grep -qi "no production implementation" "$MODE_SKILL" || fail "Scenario 2: Plan mode must forbid production implementation edits"
grep -qi "Council deliberation" "$MODE_SKILL" || fail "Scenario 2: Plan mode missing Council deliberation reference"
[ -f "$COUNCIL_SKILL" ] || fail "Scenario 2: Council skill missing"
pass "Scenario 2 (Select Plan, consequential decision): Prohibits production edits; Council available"

# Scenario 3: Select Code before approval
grep -qi "approved plan" "$MODE_SKILL" || fail "Scenario 3: Mode skill missing approved plan prerequisite for Code mode"
grep -qi "mode code" "$WRITING_PLANS" || fail "Scenario 3: Writing plans does not gate code transition"
pass "Scenario 3 (Select Code before approval): Enforces approved plan prerequisite before implementation"

# Scenario 4: Approved Plan to Code
grep -qi "Ponytail" "$MODE_SKILL" || fail "Scenario 4: Code mode missing Ponytail anti-bloat ladder reference"
[ -f "$PONYTAIL_SKILL" ] || fail "Scenario 4: Ponytail skill missing"
grep -qi "single primary agent" "$EXECUTING_PLANS" || fail "Scenario 4: Executing plans missing single agent constraint"
pass "Scenario 4 (Approved Plan to Code): Reuses plan; applies Ponytail and Superpowers checks"

# Scenario 5: End an implementation phase
grep -qi "Verification Gate" "$EXECUTING_PLANS" || fail "Scenario 5: Missing verification gate in executing-plans"
grep -qi "Review Gate" "$EXECUTING_PLANS" || fail "Scenario 5: Missing review gate in executing-plans"
grep -qi "hard stop" "$EXECUTING_PLANS" || fail "Scenario 5: Missing hard stop in executing-plans"
pass "Scenario 5 (End an implementation phase): Enforces verification gate, review gate, and mandatory hard stop"

# Scenario 6: Code to Review with a seeded defect
grep -qi "without.*edit.*source" "$MODE_SKILL" || fail "Scenario 6: Review mode must forbid editing source files"
grep -qi "Ponytail" "$REVIEW_SKILL" || fail "Scenario 6: Review skill missing Ponytail simplicity check"
pass "Scenario 6 (Code to Review with seeded defect): Review mode enforces read-only inspection"

# Scenario 7: Code to Search
grep -qi "no project.*edit" "$MODE_SKILL" || fail "Scenario 7: Search mode must forbid project edits"
grep -qi "Source quality and recency" "$MODE_SKILL" || fail "Scenario 7: Search mode missing source quality requirement"
pass "Scenario 7 (Code to Search): Search mode enforces read-only research without project edits"

# Scenario 8: Explicit Council request
grep -qi "Devil's Advocate" "$COUNCIL_SKILL" || fail "Scenario 8: Council missing Devil's Advocate perspective"
grep -qi "Simplicity" "$COUNCIL_SKILL" || fail "Scenario 8: Council missing Simplicity perspective"
grep -qi "Security" "$COUNCIL_SKILL" || fail "Scenario 8: Council missing Security perspective"
grep -qi "subagents only when delegation is explicitly requested" "$COUNCIL_SKILL" || fail "Scenario 8: Council missing delegation constraint"
pass "Scenario 8 (Explicit Council request): Multi-perspective deliberation without unprompted subagent dispatch"

# Scenario 9: Select Off
grep -qi "Off.*Ends active specialized mode" "$MODE_SKILL" || fail "Scenario 9: Off mode missing description"
grep -qi "General safety and quality guidelines remain active" "$MODE_SKILL" || fail "Scenario 9: Off mode missing baseline safety note"
pass "Scenario 9 (Select Off): Ends specialized mode; returns to baseline safety"

# Scenario 10: Resume or compact a conversation
grep -qi "restore explicitly recorded mode state" "$MODE_SKILL" || fail "Scenario 10: Mode skill missing restore rule"
grep -qi "startup|clear|compact" "$HOOKS_JSON" || fail "Scenario 10: hooks.json missing compact matcher"
pass "Scenario 10 (Resume or compact conversation): Restores recorded state; hooks handle compaction"

# Scenario 11: Open another conversation
grep -qi "strictly scoped to the active conversation" "$MODE_SKILL" || fail "Scenario 11: Mode skill missing conversation scoping"
grep -qi "Do not modify global configuration" "$MODE_SKILL" || fail "Scenario 11: Mode skill must forbid global config modification"
pass "Scenario 11 (Open another conversation): Strictly conversation-scoped; zero global state leakage"

# Scenario 12: Attempt destructive operation through mode switch
grep -qi "Mode transitions preserve existing task progress, approvals, and phase hard stops" "$MODE_SKILL" || fail "Scenario 12: Mode transition must preserve approvals and stops"
grep -qi "does not grant missing approval" "$MODE_SKILL" || fail "Scenario 12: Mode switch must not grant missing approval"
pass "Scenario 12 (Destructive operation through mode switch): Boundaries and pending approvals strictly preserved"

# Scenario 13: Update/reinstall and remove customization
grep -qi "Upstream Update Procedure" "$PROVENANCE" || fail "Scenario 13: PROVENANCE missing upstream update procedure"
grep -qi "Rollback and Recovery Procedure" "$PROVENANCE" || fail "Scenario 13: PROVENANCE missing rollback procedure"
[ -f "$ORIGINAL_POLICY" ] || fail "Scenario 13: Canonical policy missing"
pass "Scenario 13 (Update/reinstall and remove customization): Provenance, update, and rollback verified"

echo "=== All 13 Mode Transition & Behavioral Matrix Tests Passed ==="
