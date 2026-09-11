---
name: using-superpowers
description: Use when starting any conversation - establishes how to find and use skills, requiring skill invocation before ANY response including clarifying questions
---

<SUBAGENT-STOP>
If you were dispatched as a subagent to execute a specific task, ignore this skill.
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a skill might apply to what you are doing, you ABSOLUTELY MUST invoke the skill.

IF A SKILL APPLIES TO YOUR TASK, YOU DO NOT HAVE A CHOICE. YOU MUST USE IT.

This is not negotiable. You cannot rationalize your way out of this.
</EXTREMELY-IMPORTANT>

## The Rule

**Invoke relevant or requested skills BEFORE any response or action** — including clarifying questions, exploring the codebase, or checking files. If it turns out wrong for the situation, you don't have to use it.

**Before entering plan mode:** if you haven't already brainstormed, invoke the brainstorming skill first.

Then announce "Using [skill] to [purpose]" and follow the skill exactly. If it has a checklist, create a todo per item.

## Skill Priority

When multiple skills apply, process skills come first — they set the approach, then implementation skills (frontend-design, etc.) carry it out. Brainstorming and systematic-debugging are Superpowers' most common process skills, but the rule holds for any of them.

- "Let's build X" → superpowers:brainstorming first, then implementation skills.
- "Fix this bug" → superpowers:systematic-debugging first, then domain skills.

## Red Flags

These thoughts mean STOP—you're rationalizing:

| Thought | Reality |
|---------|---------|
| "This is just a simple question" | Questions are tasks. Check for skills. |
| "I need more context first" | Skill check comes BEFORE clarifying questions. |
| "Let me explore the codebase first" | Skills tell you HOW to explore. Check first. |
| "I can check git/files quickly" | Files lack conversation context. Check for skills. |
| "Let me gather information first" | Skills tell you HOW to gather information. |
| "This doesn't need a formal skill" | If a skill exists, use it. |
| "I remember this skill" | Skills evolve. Read current version. |
| "This doesn't count as a task" | Action = task. Check for skills. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "I'll just do this one thing first" | Check BEFORE doing anything. |
| "This feels productive" | Undisciplined action wastes time. Skills prevent this. |
| "I know what that means" | Knowing the concept ≠ using the skill. Invoke it. |

## Platform Adaptation

If your harness appears here, read its reference file for special instructions:

- Codex: `references/codex-tools.md`
- Pi: `references/pi-tools.md`
- Antigravity: `references/antigravity-tools.md`
- Hermes Agent: `references/hermes-tools.md`

## User Instructions

User instructions (CLAUDE.md, AGENTS.md, GEMINI.md, etc, direct requests) take precedence over skills, which in turn override default behavior.
Only skip skill workflows or instructions when your human partner has explicitly told you to.

## Workflow Modes & Single-Agent Constraint

This workspace operates under explicit conversation-scoped workflow modes via the `mode` skill:
- **No mode selected:** General conversation, questions, and read-only inspection.
  Do not start implementation or full Council without an explicit mode selection.
- **Plan:** Creative design, requirements, and implementation plans (`brainstorming`, `writing-plans`).
  Surface meaningful trade-offs with `council`.
  Do not write production code.
- **Code:** Authorized implementation, tests, debugging, and verification (`executing-plans`, `test-driven-development`, `systematic-debugging`).
  Apply the Ponytail anti-bloat ladder to every line of code.
  Always require an approved plan before beginning implementation edits.
- **Review:** Non-destructive code review and simplicity inspection (`requesting-code-review`, `ponytail-review`).
  Report findings without editing production files.
- **Search:** Research, fact-checking, and documentation lookups.
  No source file edits.
- **Off:** Return to baseline conversation.

### Single-Agent Execution
Execute all tasks using a single primary agent.
Do not dispatch subagents or parallel worker agents unless your human partner explicitly directs it.
When a skill suggests subagent-driven development, use sequential single-agent execution with plan verification gates.
