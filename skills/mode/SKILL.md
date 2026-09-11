---
name: mode
description: "Explicitly select or switch the engineering workflow mode (Plan, Code, Review, Search, Off). Governs permitted activities, Council deliberation, Ponytail execution, verification gates, and single-agent constraints."
metadata:
  argument-hint: "[plan|code|review|search|off]"
license: MIT
---

# Workflow Mode Selector

Select or switch the explicit conversation-scoped workflow mode.
Modes govern authorized activities, Council deliberation, Ponytail execution, and single-agent execution.

## Supported Modes

| Mode | Allowed Activities | Workflow & Specialist Skills |
| --- | --- | --- |
| **None** | General discussion, Q&A, and read-only inspection. Request an explicit mode before starting specialized tasks. | No autonomous implementation or full Council. |
| **Plan** | Requirements discovery, system architecture, feature specifications, and phased implementation plans. | Superpowers brainstorming/writing-plans; Council deliberation for consequential trade-offs; no production implementation edits. |
| **Code** | Implementing authorized plans, writing tests, debugging, and verifying changes. | Superpowers test-driven-development, systematic-debugging, verification-before-completion, plus Ponytail anti-bloat ladder. |
| **Review** | Non-destructive code review, simplicity review, and test execution. | Superpowers code-review plus Ponytail-review; report findings without editing production sources. |
| **Search** | Codebase and documentation research, web search, and fact-checking. | Source quality and recency verification; no project file edits or speculative conclusions. |
| **Off** | Ends active specialized mode and returns to baseline interaction. | General safety and quality guidelines remain active. |

## Mode Rules

1. **Conversation Scoping:**
   Mode state is strictly scoped to the active conversation.
   Do not modify global configuration files or shared settings to track mode state.
   A new conversation begins with no mode selected.
   On resumed conversations, restore explicitly recorded mode state or ask for selection if ambiguous.

2. **Transition Rules:**
   Selecting a mode replaces the previous active mode in the conversation.
   Mode transitions preserve existing task progress, approvals, and phase hard stops.
   Upstream skills ending (e.g. writing a plan or completing a review) must NOT automatically switch modes.
   Switching to Code requires an existing approved plan; it does not grant missing approval.

3. **Single-Agent Execution:**
   All execution across all modes is performed by a single primary agent.
   Do not dispatch subagents, parallel agents, or delegate tasks unless Len explicitly directs it.

4. **Response Protocol on Mode Change:**
   When an explicit mode change occurs, output exactly one concise confirmation line:
   `Mode set to <Mode>. <Brief summary of permitted scope and pending approvals>.`
   Do not repeat boilerplate mode status messages on subsequent responses.
