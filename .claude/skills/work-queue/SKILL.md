---
name: work-queue
description: "Processes the playtest inbox, then builds, verifies, and closes queued bugs and stories one after another until the limit, an empty queue, or a decision only Matthew can make."
argument-hint: "[max-items, default 3]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Agent, Bash(git status*), Bash(git diff*), Bash(git branch*), Bash(git checkout -b *), Bash(git add -- *), Bash(git commit -m *), Bash(godot *), Bash(mkdir -p production/*)
---

# Work Queue

Matthew playtests and writes notes in `production/playtest/inbox.md`. This skill turns those
notes into work, does the work, checks it, and hands back what to play next. Read
`production/WORKFLOW.md` and the Collaboration Protocol in `CLAUDE.md` first: creative content
is Matthew's, and is never invented here.

**Argument:** an optional maximum number of items to work this run. Default 3.

**Writes follow `modes.automation`** (`.claude/docs/automation-modes.md`). In `collaborative` or
`guided` mode, ask "May I write this to [filepath]?" before each file write, and show a draft or
summary first. In `autonomous` mode (this project's setting) write directly and log decisions in
`production/session-logs/decision-log.md`. Pushing and merging to `main` are never covered by
this skill: they always need Matthew's go-ahead.

**Skills that cannot be started with the Skill tool.** `dev-story` and `story-done` are set
`disable-model-invocation`. To use either, Read its `SKILL.md` and follow it directly.
`bug-report`, `quick-design` and `create-stories` can be invoked normally.

## 1. Process the inbox

For each line under `## New` in `production/playtest/inbox.md`:

- `[bug]`: run `/bug-report` with the note.
- `[idea]`: run `/quick-design`, then turn the spec into a story under the matching epic
  (`/create-stories` if the epic has none). Content Matthew has not designed gets a
  placeholder (`PLACEHOLDER_...`, `placeholder_..._01`) and an entry in
  `design/open-questions.md` with the question he needs to answer.
- `[feel]`: if the note gives a value, make a `/quick-design` tuning change with that value.
  If it gives no value, change no numbers. Add the question and the current value to
  `design/open-questions.md`.
- A line with no tag, or an unknown tag, is not processed. Leave it under `## New` and list
  it in the hand-back.

Move each processed line under `## Processed`, with a link to the bug or story it became.
If `## New` is empty, say so in the hand-back: it is not an error.

## 2. Build the queue

Open bugs first (critical and high severity, then the rest), from `production/qa/bugs/`.
Then ready stories in sprint order. Skip anything already blocked.

## 3. Work the queue

One item at a time, up to the maximum:

a. **Build it.** A story: Read and follow `.claude/skills/dev-story/SKILL.md`. A bug: fix it.
b. **Run the game and check real state.** Follow "Godot 4 with godot-mcp" in
   `.claude/docs/run-and-observe.md`. The rules, in short:
   - Read the real game state (HP, stamina, player state, positions, whatever the criteria
     name) through `run_script` **before and after each input**, and pass or fail each
     criterion on those numbers, with the tolerance written down. A screenshot alone, or
     "no error was logged", is never a pass.
   - Drive input as Godot input actions (`action`) or keyboard events (`key`). **Never mouse
     motion**: it does not move `get_global_mouse_position()`. Arrange aim-dependent setups
     with `run_script`, or flag that the game needs a non-mouse aim input.
   - Still take screenshots for the visual criteria and keep them in
     `production/qa/evidence/<slug>/`. Check `get_debug_output`, `stop_project`, and confirm
     no bridge autoload was left in `project.godot`.
   - If godot-mcp is not connected, or `run_script` is not confirmed, use the Godot CLI
     capture instead. It gives pixels only, so every criterion about state is
     **NOT VERIFIED**, not a pass, and the hand-back says which run happened.
c. **Independent check.** Spawn the `qa-tester` subagent. Its objective: judge each
   acceptance criterion on its own, from the evidence alone. Give it only the acceptance
   criteria, the before and after values with their tolerances, the screenshot paths, the
   log output and the test results. Do not give it your reasoning or your own verdict. It
   reports PASS, FAIL or NOT VERIFIED per criterion, with the value or file it relied on.
d. **PASS:** a story is closed by reading and following
   `.claude/skills/story-done/SKILL.md`. A bug goes through `/bug-report verify [BUG-ID]`,
   then `/bug-report close [BUG-ID]`. Commit to the current feature branch with a
   Conventional Commit message and the story or bug ID in the body.
e. **FAIL:** fix it and run b and c again. If it fails a second time, mark it BLOCKED, note
   why in the item, and move to the next one. An item with any criterion NOT VERIFIED is not
   closed: leave it open and list the unverified criteria in the hand-back.

Log each non-trivial decision in `production/session-logs/decision-log.md`.

## 4. Stop

Stop when any of these happens, and say which one in the hand-back:

- the maximum is reached
- the queue is empty
- the next item needs a creative decision (see the list in `CLAUDE.md`)
- the next item falls in a `modes.automation_always_ask` category
- the run would push, merge to `main` or force-push

Never commit to `main`: if the current branch is `main`, create a feature branch first.

## 5. Hand back

Write `production/playtest/test-next.md` with:

- what changed, one line per item
- exactly what Matthew should play to test each one
- new entries added to `design/open-questions.md`
- blocked items and why
- inbox lines left unprocessed, and why the run stopped

Then show Matthew a short summary.

**Recommended next:** Matthew plays what `production/playtest/test-next.md` lists, writes his
notes under `## New` in `production/playtest/inbox.md`, and runs `/work-queue` again.
