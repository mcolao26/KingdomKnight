# Domain docs: single context (this project's folders)

How the engineering skills should read this project's domain documentation.

## Before exploring, read these

- **`design/GLOSSARY.md`**: the project glossary. It does not exist yet.
- **`docs/architecture/`**: ADRs. Read the ones that touch the area you are about to work in.
- **`design/kingdom-knight-design.md`**: the design document. Read it by section.

If the glossary or an ADR does not exist, **proceed silently**. Do not flag its absence and
do not suggest creating it up front. `/domain-modeling` (reached through `/grill-with-docs`)
creates them lazily when a term or decision is actually settled.

## Layout (replaces the skills' default `GLOSSARY.md` at the root and `docs/adr/`)

```
/
├── design/
│   ├── kingdom-knight-design.md
│   ├── open-questions.md
│   └── GLOSSARY.md              <- created lazily
└── docs/architecture/           <- ADRs
```

Wherever a skill says `GLOSSARY.md` or `docs/adr/`, use `design/GLOSSARY.md` and
`docs/architecture/` instead. Do not create a root `GLOSSARY.md` or a `docs/adr/` folder.

## ADRs follow the studio's rules

ADRs use `.claude/docs/templates/architecture-decision-record.md` and the status lifecycle
in `docs/CLAUDE.md` (`Proposed` then `Accepted`, then `Superseded`). `/architecture-decision`
is the studio's way to create one.

## Creative content is Matthew's

Glossary terms and ADRs about story, characters, factions, items, skills or balance record
what Matthew has decided. Never invent them; ask him, or use a `PLACEHOLDER_` value and log
it in `design/open-questions.md`.

## Use the glossary's vocabulary

When output names a domain concept (an issue title, a test name, a refactor proposal), use
the term as the glossary defines it. If the term is missing, either you are inventing
language the project does not use, or there is a real gap to note for `/domain-modeling`.

## Flag ADR conflicts

If output contradicts an existing ADR, say so explicitly rather than silently overriding it.
