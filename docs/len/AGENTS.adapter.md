# Len Guidelines Policy Adapter

Created: 2026-09-11T11:15:00+08:00
Target: Superpowers fork (`len-build-it/superpowers`)
Canonical Policy Source: `docs/len/AGENTS.original.md` (SHA-256: `86EE90450B7032F2CC0AED01DE32F069D81E555F6BBAEE08B286528861433463`)

## Purpose

This adapter document bridges Len's exact guidelines with the Superpowers workflow.
The original guidelines in `docs/len/AGENTS.original.md` remain authoritative and unaltered.
This document defines approved interpretations under MIG-REQ-03 and the mode contract under MIG-REQ-02.

## Approved Policy Interpretations (MIG-REQ-03)

1. **Ponytail (Anti-Bloat Directive)**
   Ponytail engineering principles apply to all code changes across all modes.
   Always prefer YAGNI, standard library first, native platform capabilities, and zero unneeded dependencies.
   The full Ponytail workflow is active during Code mode or when explicitly invoked.

2. **Council (Debate Before Building)**
   Full multi-perspective Council deliberation is optional for routine or low-consequence decisions.
   Plan mode must always surface meaningful trade-offs, failure modes, and security considerations before implementation begins.
   Explicit invocation of Council remains available whenever deep architectural debate is requested.

3. **Phased Execution Lifecycle**
   The structured plan, verification gates, reviews, and hard-stop commits apply to substantial implementation.
   Every phase must stop for explicit human confirmation before the next phase begins.
   No automatic advancement between phases is permitted.

4. **Preserve Integrity & Test Preservation**
   Preserving existing tests means maintaining passing completion gates and valid coverage.
   Writing a new failing test during Test-Driven Development (TDD) as a reproduction or regression check is fully permitted and encouraged.
   No working feature or test suite may be overwritten or broken without explicit consent.

5. **Incidental Quality Excellence**
   Incidental quality standards (lint, UI alignment, test flakiness) must be held high.
   Fixes for observed defects must remain tightly scoped and must not expand authorized feature requirements.

6. **Single-Agent Constraint**
   All work within this workflow is performed by a single primary agent.
   Do not spawn or delegate execution or review to subagents unless Len explicitly grants permission.

7. **Deferred Specialist Skills**
   No new standalone UI/UX, cybersecurity, or external search specialist skills are implemented during this migration.
   Standard verification, security diligence, and accessibility checks remain standard engineering practice.

## Mode Contract (MIG-REQ-02)

- **None Selected:** Read-only inspection and general conversation; no autonomous code modifications.
- **Plan:** Requirements, design, and architecture; Council for consequential trade-offs; no production implementation.
- **Code:** Authorized implementation, TDD, debugging, verification, and Ponytail checks.
- **Review:** Non-destructive code review, inspection, and verification; reports findings without modifying sources.
- **Search:** Research, fact-checking, and citation; no source edits or speculative claims.
- **Off:** Returns to baseline interaction; general safety, quality, and coding guidelines remain in effect.
