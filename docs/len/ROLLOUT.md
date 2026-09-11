# Rollout & Legacy Toolkit Retirement Guide

Created: 2026-09-11T12:05:00+08:00
Fork: `len-build-it/superpowers` (local checkout: `superpowers`)
Target Branch: `codex/superpowers-migration`

## 1. Overview & Migration Outcome

This repository is Len's customized, maintainable fork of Superpowers.
It succeeds the legacy `len-toolkit` as the primary engineering workflow system.
It preserves Len's exact general coding guidelines and Core Directives byte-for-byte while introducing explicit conversation-scoped workflow modes, Ponytail anti-bloat principles, Council deliberation, and single-agent execution constraints.

- Upstream Base: `obra/superpowers` release tag `v6.3.0` (commit `b36e0829c6d0140e93cfef2ca599b1b07d4a7797`).
- Fork Remote: `https://github.com/len-build-it/superpowerfork.git`.
- Canonical Policy: `docs/len/AGENTS.original.md` (exact SHA-256 `86EE90450B7032F2CC0AED01DE32F069D81E555F6BBAEE08B286528861433463`).
- Policy Adapter: `docs/len/AGENTS.adapter.md`.

## 2. Installation by Target Client

Install or reference Superpowers separately for each client environment you use.

### A. Antigravity / Gemini CLI

1. The repository includes `gemini-extension.json` with entry point `GEMINI.md`.
2. `GEMINI.md` automatically imports `@./docs/len/AGENTS.original.md` and `@./docs/len/AGENTS.adapter.md`.
3. In consuming workspaces, skills are discovered via `.agents/skills` or via the Antigravity plugin loader.
4. Tool invocations map to Antigravity native tools (`write_to_file`, `replace_file_content`, `run_command`).

### B. OpenAI Codex CLI & Desktop App

1. Manifest is located at `.codex-plugin/plugin.json`.
2. SessionStart hook in `hooks/session-start` injects the canonical policy and adapter into the session context on startup, clear, and compact events.
3. In consuming workspaces, point Codex to the fork's skills directory or link the plugin.

### C. Claude Code / Cursor / GitHub Copilot CLI

1. `hooks/session-start` detects the host environment (`CLAUDE_PLUGIN_ROOT`, `CURSOR_PLUGIN_ROOT`, `COPILOT_CLI`).
2. Emits appropriately shaped session context JSON (`hookSpecificOutput`, `additional_context`, or `additionalContext`).
3. Ensures Len's Core Directives and mode guidelines are enforced in every session.

## 3. Workflow Modes & Exact Invocation

To select or switch a workflow mode, invoke the mode selector skill:

```
mode [plan|code|review|search|off]
```

| Mode | Allowed Activities | Workflow Constraints |
| --- | --- | --- |
| **None** | General discussion, Q&A, and read-only inspection. | Default state for new conversations; autonomous implementation blocked. |
| **Plan** | Requirements discovery, system architecture, feature specifications, phased implementation plans. | Prohibits production edits; Council available for consequential trade-offs. |
| **Code** | Implementing authorized plans, writing tests, debugging, and verifying changes. | Requires an approved plan; enforces Ponytail ladder and Superpowers TDD. |
| **Review** | Non-destructive code review, simplicity review, and test execution. | Inspects and reports findings; production source edits strictly forbidden. |
| **Search** | Codebase and documentation research, web search, and fact-checking. | Validates source quality and recency; zero code edits permitted. |
| **Off** | Ends active specialized mode and returns to baseline interaction. | Preserves baseline safety and general coding guidelines. |

### Execution Rules

- **Single-Agent Execution:** All execution across all modes is carried out by a single primary agent; do not dispatch subagents without explicit instruction.
- **Conversation Scoping:** Mode state is strictly scoped to the current conversation; no global mutable state is modified.
- **Phase Hard Stops:** In Code mode, each phase requires running the Verification Gate, Review Gate (Ponytail check), Git Checkpoint, and stopping for human confirmation before the next phase.

## 4. Legacy Toolkit Retirement & `npx len-toolkit start`

### Understanding the Legacy CLI

The legacy command `npx len-toolkit start` was a one-shot file scaffolding utility.
It was never a background service, daemon, or persistent process.
There was no global disable switch in the legacy CLI because none was needed.

### Retiring the Legacy Workflow

1. Consuming projects no longer need to run `npx len-toolkit start`.
2. The legacy `templates/rules/AGENTS.md` contained a line directing agents to run `npx len-toolkit start`.
   In all new and updated projects, replace that template with references to this fork's policy (`docs/len/AGENTS.original.md` and `docs/len/AGENTS.adapter.md`).
3. Global npm link: If `len-toolkit` was linked globally via `npm link`, it can be safely unlinked by running `npm rm -g len-toolkit`.
   Do not uninstall unless authorized, as `npx` will still fetch from registry/cache if ever invoked explicitly.

## 5. Upstream Synchronization & Maintenance

To pull improvements from upstream Superpowers while protecting Len's policy:

1. Fetch upstream updates:
   ```bash
   git fetch upstream
   ```
2. Create an isolated sync branch:
   ```bash
   git checkout -b update/upstream-sync codex/superpowers-migration
   ```
3. Merge the desired upstream tag or commit:
   ```bash
   git merge <upstream-tag>
   ```
4. Verify canonical policy integrity:
   Ensure `docs/len/AGENTS.original.md` matches SHA-256 `86EE90450B7032F2CC0AED01DE32F069D81E555F6BBAEE08B286528861433463`.
5. Run test verification:
   ```bash
   tests/len/test-modes-and-policy.sh
   tests/len/test-mode-transitions.sh
   tests/hooks/test-session-start.sh
   tests/antigravity/run-tests.sh
   ```
6. Obtain human sign-off before fast-forwarding `codex/superpowers-migration`.

## 6. Rollback and Recovery Procedures

### A. Pristine Upstream Rollback

To revert to pristine upstream Superpowers:
```bash
git checkout v6.3.0
```
This restores upstream files without custom modes, hooks, or adapters.

### B. Legacy Toolkit Restoration

A verified full Git bundle is preserved at:
`C:\Users\User\Desktop\PersonalProjects\04-FUN-STUFF\backups\Len-s_Toolkit_backup_2026-09-11\Len-s_Toolkit.bundle`
To restore into an isolated directory:
```bash
git clone -c core.autocrlf=false "C:\Users\User\Desktop\PersonalProjects\04-FUN-STUFF\backups\Len-s_Toolkit_backup_2026-09-11\Len-s_Toolkit.bundle" <target-dir>
```
Verify that `npm test` passes all 46 legacy tests and `AGENTS.md` hash matches `86EE9045...`.

## 7. Known Limitations

- **Host Python Dependency:** Upstream packaging scripts (`test-marketplace-manifest.sh`, `test-package-codex-plugin.sh`) require `python3`, which is unavailable on this Windows host.
- **Separate Surfaces:** Regular ChatGPT Chat and ChatGPT Work are separate web/cloud surfaces and are not validated as supporting this plugin harness.
