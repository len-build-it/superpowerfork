# Fork Provenance & Upstream Maintenance Guide

Created: 2026-09-11T11:15:00+08:00
Fork: `len-build-it/superpowers` (local: `superpowers`)

## 1. Upstream Baseline

- Upstream Repository: `https://github.com/obra/superpowers.git`.
- Pinned Release Tag: `v6.3.0`.
- Pinned Commit Hash: `b36e0829c6d0140e93cfef2ca599b1b07d4a7797`.
- Upstream Author: Jesse Vincent (`obra`).
- Upstream License: MIT License (see `LICENSE` in repository root).
- Attribution: All upstream contributions, skill definitions, manifests, and documentation remain credited to their original authors.

## 2. Legacy Toolkit & Policy Origin

- Legacy Source Repository: `https://github.com/len-build-it/Len-s_Toolkit.git`.
- Pre-Migration Commit: `c85e261923ab56a00e8fac9395c6f767aff4b2c9`.
- Final Phase 1 Archive Commit: `9aa39495694e813c7bb9780a8a71779b8913969c`.
- Canonical Policy File: `docs/len/AGENTS.original.md`.
- Policy SHA-256 Checksum: `86EE90450B7032F2CC0AED01DE32F069D81E555F6BBAEE08B286528861433463`.
- Durable Backup Archive: `Len-s_Toolkit_backup_2026-09-11/Len-s_Toolkit.bundle` (SHA-256: `E3600C6C9E872B5447A45768339587B3D57750181AFCED4F5B34137E743D3F75`).

## 3. Upstream Update Procedure

To incorporate future upstream enhancements while protecting Len's policy:

1. Fetch upstream changes:
   ```bash
   git fetch upstream
   ```
2. Create an isolated update branch from current migration branch:
   ```bash
   git checkout -b update/upstream-sync codex/superpowers-migration
   ```
3. Merge or rebase against the new upstream release tag:
   ```bash
   git merge <upstream-tag>
   ```
4. Verify policy preservation:
   Ensure `docs/len/AGENTS.original.md` remains unaltered with SHA-256 `86EE90450B7032F2CC0AED01DE32F069D81E555F6BBAEE08B286528861433463`.
5. Run test verification:
   Verify mode selector and client bootstrap integrity.
6. Submit for explicit human review and sign-off before fast-forwarding `codex/superpowers-migration`.

## 4. Rollback and Recovery Procedure

If custom fork behavior must be rolled back or the legacy toolkit restored:

1. Rollback to pristine upstream Superpowers:
   Check out pristine upstream main or the pinned release tag:
   ```bash
   git checkout v6.3.0
   ```
   This restores upstream behavior without custom modes, hooks, or adapters.

2. Restore legacy toolkit from durable backup archive:
   The verified Git bundle is stored at `Len-s_Toolkit_backup_2026-09-11/Len-s_Toolkit.bundle`.
   Restore into an isolated recovery directory:
   ```bash
   git clone -c core.autocrlf=false "C:/Users/User/Desktop/PersonalProjects/04-FUN-STUFF/backups/Len-s_Toolkit_backup_2026-09-11/Len-s_Toolkit.bundle" <target-dir>
   ```
   Verify `AGENTS.md` SHA-256 matches `86EE90450B7032F2CC0AED01DE32F069D81E555F6BBAEE08B286528861433463`.
   Run legacy test suite `npm test` (46/46 passed) to confirm baseline functionality.

3. Recover custom fork branch:
   To re-establish the migration branch after an experimental update:
   ```bash
   git checkout codex/superpowers-migration
   git reset --hard origin/codex/superpowers-migration
   ```
   Run `tests/len/test-modes-and-policy.sh` and `tests/len/test-mode-transitions.sh` to confirm integrity.
