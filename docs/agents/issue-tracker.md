# Issue tracker: local Markdown (this project's folders)

This project does not use GitHub Issues, GitLab Issues or `.scratch/`. Work is tracked as
Markdown files in the folders the studio skills already use.

## Where things live

- **Bugs:** `production/qa/bugs/BUG-NNNN.md` (four-digit, zero-padded). Created with
  `/bug-report`. A `Status:` line records the state (for example `Verified Fixed`) and
  `/bug-report verify` and `close` update it.
- **Stories:** `production/epics/<epic-slug>/story-NNN-<slug>.md`, listed in the epic's
  `EPIC.md` and in `production/epics/index.md`. Created with `/create-stories`.
- **Small specs and tuning changes:** `design/quick-specs/`, created with `/quick-design`.
- **Playtest notes:** `production/playtest/inbox.md`, processed by `/work-queue`.
- **Open questions for Matthew:** `design/open-questions.md`.

## When a skill says "publish to the issue tracker"

Write the file in the matching folder above. Do not create `.scratch/`. A bug uses the next
free `BUG-NNNN` number (take the highest existing number and add 1).

## When a skill says "fetch the relevant ticket"

Read the file at the path given, or glob `production/qa/bugs/BUG-*.md` and match the number.

## Triage labels

The `triage` skill is not installed, so there is no label vocabulary. Severity and status
live in each bug file, as `/bug-report` writes them.

## Rules that still apply

Creative content is Matthew's. A skill must not invent story, characters, items or numbers
to fill a ticket: use a `PLACEHOLDER_` value and add it to `design/open-questions.md`
(see the Collaboration Protocol in `CLAUDE.md`).
