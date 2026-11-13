# Claude Code Game Studios -- Game Studio Agent Architecture

Indie game development managed through 49 coordinated Claude Code subagents.
Each agent owns a specific domain, enforcing separation of concerns and quality.

## Technology Stack

- **Engine**: Godot 4.7.2
- **Language**: GDScript
- **Version Control**: Git with trunk-based development
- **Build System**: SCons (engine), Godot Export Templates
- **Asset Pipeline**: Godot Import System + custom resource pipeline

> **Note**: Engine-specialist agents exist for Godot, Unity, and Unreal with
> dedicated sub-specialists. Use the set matching your engine.

## Project Structure

@.claude/docs/directory-structure.md

## Engine Version Reference

<!-- ENGINE-REFERENCE-IMPORT: the line under this comment is engine-specific,
     and there is none until an engine is set. /setup-engine, the grow's record
     step and /project-settings (engine.name) write
     @docs/engine-reference/<engine>/VERSION.md here for the chosen engine. Skills
     that need the pinned version read that file on demand either way. -->
@docs/engine-reference/godot/VERSION.md


## Technical Preferences

`project.yaml` at the repo root is the primary config store — engine, specialists,
naming, platform, performance, modes. Skills resolve it via `resolve_config`
(see `.claude/docs/config-resolution.md`).

`.claude/docs/technical-preferences.md` is the **legacy fallback**, read on demand
when a key is absent from `project.yaml`. It is not imported here: before
`/setup-engine` runs it is almost entirely `[TO BE CONFIGURED]` placeholders, and
after it runs `project.yaml` holds the real values.

## Coordination Rules

@.claude/docs/coordination-rules.md

## Collaboration Protocol

**Autonomous build mode. Creative decisions belong to Matthew.**

Follow `modes.automation` in `project.yaml`. Where it conflicts with
`docs/COLLABORATIVE-DESIGN-PRINCIPLE.md`, `project.yaml` wins. The overall
workflow is in `production/WORKFLOW.md`.

**Never invent creative content. Always stop and ask Matthew for:**
- Story, plot, lore, factions, and the betrayal mystery
- Characters: names, personalities, backstories, dialogue, AI NPC personality
  prompts, and romance options
- Gameplay content: skills, magic, buffs and passives, weapon types, armor
  types, items, enemies, quests, stat values, and balance numbers
- Art direction and the style reference sheet

To keep building while those are open, make systems data-driven and use
obviously fake placeholder data (for example `PLACEHOLDER_SWORD` or
`placeholder_npc_01`). List every placeholder in `design/open-questions.md`
with the question Matthew needs to answer. Never present placeholder content
as a design decision.

A note Matthew writes in `production/playtest/inbox.md` counts as his decision
for whatever it states. Build it. For any part it leaves open, use the
placeholder rule above.

**Everything else: decide and keep going.** This covers code structure,
implementation, tests, bug fixes, refactors, and which backlog item is next.
Don't ask "should I continue?" or "what's next?". Log decisions in
`production/session-logs/decision-log.md`.

**Verify your own work.** Run the game through godot-mcp, check the debug
output and screenshots, and fix errors before handing back.

**Git:** commit each finished item to a feature branch with a Conventional
Commit message. Never push, merge to `main`, or force-push without asking.

**Stop and ask** for anything in the creative list above, anything in
`modes.automation_always_ask`, and anything `design/kingdom-knight-design.md`
does not cover.

## Coding Standards

@.claude/docs/coding-standards.md

## Context Management

Read `.claude/docs/context-management.md` on demand — it is a reference, not
session context. Two of its conventions are load-bearing and cited by name
elsewhere in the repo, so they are restated here rather than lost:

- **`production/session-state/active.md` is the session checkpoint.** The file is
  the memory, not the conversation. Read it first after any compaction, crash, or
  `/clear`.
- **Helpers in `.claude/scripts/` emit observations, never verdicts.** A script
  that scores or judges will eventually contradict a mode or override it cannot
  see. (Cited by `artifact-check.sh` and `adr-dep-graph.sh`.)

## Agent skills

### Issue tracker

Local markdown: bugs in `production/qa/bugs/`, stories under `production/epics/`. See `docs/agents/issue-tracker.md`.

### Domain docs

Single-context: glossary in `design/GLOSSARY.md`, ADRs in `docs/architecture/`. See `docs/agents/domain.md`.
