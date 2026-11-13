---
name: work-queue
description: "Processes the playtest inbox, then builds, verifies, and closes queued bugs and stories one after another until the limit, an empty queue, or a decision only Matthew can make."
argument-hint: "[max-items, default 3]"
user-invocable: true
---

# Work Queue

Matthew playtests and writes notes in `production/playtest/inbox.md`. This skill turns those
notes into work, does the work, checks it, and hands back what to play next. Read
`production/WORKFLOW.md` and the Collaboration Protocol in `CLAUDE.md` first: creative content
is Matthew's, and is never invented here.

**Argument:** an optional maximum number of items to work this run. Default 3.

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
b. **Run the game and look.** Use godot-mcp when it is connected: check the debug output and
   take screenshots. If it is not connected, use the Godot CLI capture in
   `.claude/docs/run-and-observe.md` and keep the PNGs in `production/qa/evidence/`. State
   which one ran. A parse check alone is not a run.
c. **Independent check.** Spawn the `qa-tester` subagent. Give it only the acceptance
   criteria, the screenshot paths, the log output and the test results. Do not give it your
   reasoning or your own verdict. It reports pass or fail per criterion.
d. **Pass:** a story is closed by reading and following
   `.claude/skills/story-done/SKILL.md`. A bug goes through `/bug-report verify [BUG-ID]`,
   then `/bug-report close [BUG-ID]`. Commit to the current feature branch with a
   Conventional Commit message and the story or bug ID in the body.
e. **Fail:** fix it and run b and c again. If it fails a second time, mark it blocked, note
   why in the item, and move to the next one.

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
