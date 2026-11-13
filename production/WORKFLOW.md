# Workflow: how Matthew and Claude work on Kingdom Knight

**Roles.** Matthew makes creative decisions, tests, suggests and reports bugs. Claude plans,
builds, tests and fixes. Claude never invents creative content (see `CLAUDE.md`,
Collaboration Protocol).

## Step 1 (Matthew): creative decisions
Matthew fills out his creative decisions guide: story, characters, factions, weapons, armor,
buffs and so on. He pastes the answers into `design/kingdom-knight-design.md`. Claude does not
invent any of that content. Anything still open is built with obvious placeholder data and
listed in `design/open-questions.md`.

## Step 2 (Claude): autonomous mode
`project.yaml` sets `modes.automation: autonomous`. Claude decides and keeps going on code
structure, implementation, tests, bug fixes and refactors, and logs decisions in
`production/session-logs/decision-log.md`. It always stops and asks for the
`automation_always_ask` categories: `scope_changes`, `file_deletions`, `schema_changes` and
`external_calls`. Work is committed to feature branches. Claude never pushes or merges to
`main` without asking.

## Step 3 (Claude): playtest inbox, /work-queue, Pocock skills
- `production/playtest/inbox.md` is where Matthew writes playtest notes, one per line, tagged
  `[bug]`, `[idea]` or `[feel]`.
- `/work-queue [max]` (default 3) processes the inbox, then builds, verifies and closes
  queued bugs and stories until the limit, an empty queue, or a decision only Matthew can
  make. It writes `production/playtest/test-next.md` for him.
- Installed Pocock skills: `diagnosing-bugs`, `grill-with-docs` and `handoff`, plus
  `setup-matt-pocock-skills`, which configures them for local Markdown.

## Step 4 (Matthew, after setup): playtest
Matthew plays the build, writes notes in `production/playtest/inbox.md`, then runs
`/work-queue`. From then on his job is testing, suggesting and reporting bugs.
