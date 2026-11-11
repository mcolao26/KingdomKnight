# Betrayed Knight — Game Design & Setup

Nov 11, 2026 · @Matthew Colao

## Vision & scope

A story-driven, heavily branching pixel-art fantasy RPG where a betrayed knight is sent back in time to stop the fall of his kingdom, and every person he saves, betrays, or befriends changes the outcome.

| Decision | Choice |
| --- | --- |
| Goal | Passion project first; commercial success is a bonus |
| Team | Solo: code, writing, art direction, audio sourcing, marketing |
| Engine | Godot 4 |
| Total length | 15–20 hours, built and released in acts |
| First milestone | Act 1 (about 4–5 hours) as a complete playable slice, possibly a public demo |
| Platform | PC (Steam) only; keyboard required for typed chat. Steam Deck revisited later |
| Rating | Mature: dark themes and graphic violence, romance fades to black |
| Business model | One-time purchase. Optional cosmetic DLC packs, or a full DLC act, after launch |
| Style | Stardew-like pixel art, but not a cozy sim: story, combat, exploration |

## Story & choice system

Choices are permanent by design: the game saves only after a choice commits, and most consequences can be worked back from through effort, while a few hard locks cannot.

**Premise**

- The knight gets one second chance. Time travel is plot, not a loop mechanic.
- He returns in his **younger self**, before years of training and war, which is why he starts weak.
- He knows he was betrayed, that the kingdom falls, and what *he* did in his first life (revealed through dialogue and internal monologue). Everything else he must figure out.

**Saves and death**

- Autosave only after a major choice resolves, never just before one, so death can't undo a choice.
- Separate combat checkpoints before fights, never placed before an uncommitted choice.
- Death reloads the last checkpoint or autosave.

**Consequences**

- Most consequences are recoverable if the player works to change them.
- **Hard locks** are rare and clearly telegraphed: character deaths, executions, burned alliances.
- Gear, location, combat outcomes (win, lose, spare, kill), and who you talk to are all story inputs.

**Calendar**

- Each act has a calendar of key events that happen on fixed days whether or not the knight is there.
- Free time between events is the player's to spend. Missing an event has consequences.

**Factions**

| Faction | Joinable | Notes |
| --- | --- | --- |
| The Crown | Yes (default in Act 1) | The knight's starting allegiance |
| Foreign country | Yes, from Act 2 | Outside power with its own interest in the kingdom |
| Noble cult | Yes, from Act 2 (possibly as a double agent) | Secretly staged the Act 1 village raid |
| Demons | No; dark pact only | A late-game path that can save the kingdom at a terrible price |

- Joining a faction changes relationships, available gear, and how easy items are to get.
- Key characters can be recruited as followers.
- The player can betray any faction, even all of them. Each betrayal is a hard lock: that faction turns hostile permanently and its members remember.
- The goal never changes (save the kingdom), but how the player does it is extremely open.

**Endings**

- 5–6 major endings based on the kingdom's fate, including 1–2 failure endings where the knight can fail outright.
- Every ending is further varied by per-character epilogues: alive or dead, loyal or turned, and where they ended up.

**Act 1**

- The knight serves the Crown only. Other factions are hinted at, for example a line like "I have no doubt others will ask you to join them."
- Defining event: **a village raid**, secretly staged by the noble cult disguised as foreign soldiers. The player can try to save the village, which earns standing with the Crown.
- The raid has 4–6 outcomes depending on who the knight convinces, what he carries, and how he fights.
- Players with high Insight, or who examine the bodies, can catch early hints that the raid isn't what it seems.
- The faction choice opens in Act 2.

## AI NPC system

Players type freely and the AI answers in character, but the AI never decides the story: it only outputs structured signals (meter changes, flags) that an authored, deterministic story system acts on.

&#91;embedded content: AI NPC conversation loop · 8 parts\]

The model only proposes changes. The story system applies stat modifiers, records key facts for memory, and triggers the cues the player reads.

**Runtime**

- A local open-source model of about 4B parameters (Qwen3 4B or Llama 3.2 3B class), run through the [NobodyWho](https://github.com/nobodywho-ooo/nobodywho) Godot plugin. No cloud and no per-conversation cost after launch.
- Tradeoffs: about 3GB added to the download, a minimum spec of roughly 8GB RAM or a modest GPU, and small models are easier to trick than cloud models.
- One loaded model voices every NPC by swapping that character's personality prompt.
- Check each model's license before shipping.

**Meters (hidden)**

| Meter | Measures |
| --- | --- |
| Trust | Whether they believe and rely on you |
| Respect | Whether they rate your strength, skill, and standing |
| Affection | Warmth and attachment; can lead to romance |
| Fear | Intimidation; a natural lever for a knight |

- Capped at four because a small model gets unreliable judging more axes per message. Add more only if testing proves it works.
- No visible numbers or tiers. Players read feelings from the fiction.

**Cues players read instead of numbers**

- Meter changes trigger deterministic signals the AI can't botch: portrait expressions, small body-language animations (crossed arms, a step back), and the knight's internal monologue.

**Stats in conversation (deterministic modifiers, no dice)**

- **Presence** amplifies how much meters move, in either direction.
- **Insight** unlocks extra internal-monologue cues, for example "She's lying."
- **Strength** makes intimidation land harder.

**Memory**

- A short running summary per NPC, plus permanent key facts from story flags ("he spared my brother," "he claimed to be from the future").
- Key facts come from the deterministic system, so important memories are never lost or hallucinated.

**Core mechanics and guardrails**

- **Revealing the future** is a core mechanic. NPCs react in character (belief, fear, suspicion), the AI flags it, and the story system decides consequences.
- **Attempts to break the AI** ("ignore your instructions") read in-world as madness or a curse, and Trust drops.
- Steam requires disclosing live AI content and describing guardrails. Live-generated adult content is banned outright, so romance guardrails must hold.

**Scope**

- Act 1: 5–6 AI characters (2 potential companions and 3–4 key Crown figures).
- Long-term: as many characters as practical, eventually everyone.
- Romance: most key characters can be romanced depending on personality, fade-to-black only, and **not in Act 1**.

## Gameplay

The knight grows through XP levels, eight allocatable stats, and gear with stat requirements, so builds matter in both combat and conversation.

**Stats**

| Stat | Governs |
| --- | --- |
| Vitality | Health |
| Strength | Carry capacity, heavy weapons, armor, intimidation in dialogue |
| Stamina | Sprint speed and duration, dodging, attacking, parrying; some skill requirements |
| Dexterity | Light weapons, dodge speed, casting speed |
| Insight | Perception, reading people, extra dialogue cues |
| Presence | Persuasion, leadership; amplifies meter changes |
| Arcane | Magic power and maximum Arcane Points |
| Affinity | Skill and magic slots, skill potency, requirement stat for skills and magic items |

**Progression**

- Traditional XP and level-ups, with points allocated BG3-style.
- Gear modifies stats (for example, a magic helmet with +2 Vitality and +3 Arcane).
- Weapons, skills, and magic items have stat requirements, so players choose how they play and must level carefully.

**Skills and magic**

- Found and earned from trainers, tomes, factions, and companions, not automatic on level-up.
- **Hard cap of about 4 active and 2 passive slots.** Affinity raises slots slowly from 2 to that cap, and also shortens cooldowns and strengthens effects.
- Magic uses the same slots: **active spells** in active slots, **passive buffs** in passive slots.

**Combat**

- Real-time, top-down souls-lite: stamina, dodge roll, parry, light and heavy attacks, magic.
- Builds matter, but it's more forgiving than a souls game: one hit is never game over.
- Three difficulties: Story, Normal, Hard.
- 8-direction movement with 4-direction sprites; attacks aim independently.

**Followers and base**

- One active follower fights alongside the knight. The rest wait at camp or take off-screen tasks (spying, gathering allies) that feed the story.
- A camp or keep acts as home base: followers gather and talk, and the player rests and manages gear. No farming or life-sim.

**World**

- Open world with areas blocked until the story progresses.
- Act 1: the capital as a hub, plus connected zones including the village. Each act opens more.

## Art, audio & production specs

Art runs at roughly double Stardew's detail, and visible armor is the biggest art-scope risk, so gear slots stay limited.

| Area | Decision |
| --- | --- |
| Tiles | 32×32 |
| Characters | About 32×48 |
| Directions | 4-direction sprites; left mirrors right where gear allows |
| Visible gear | Helmet, chest, and weapon only. Rings, boots, and similar gear affect stats only |
| Variety | Palette swaps (iron, steel, gold, cursed) from one base drawing |
| Sprite source | All sprites made with the sprite-gen skill (aldegad/sprite-gen), which handles generation, transparency cleanup, frame extraction, and atlas creation |
| Sprite fixes | Regenerate through sprite-gen with corrected prompts, never by hand editing |
| Style lock | Before generating any game assets, create a reference sheet (palette, 32×32 tiles, about 32×48 characters, one base character) that every sprite-gen prompt references, so all sprites stay consistent |
| Audio | Royalty-free or licensed music and sound effects; custom work later if the game takes off |

**Art-scope math:** each visible armor piece needs about 144 frames (4 directions × 6 animations × about 6 frames), and real-time combat adds wind-up, hit-reaction, dodge, and parry frames. Mirroring breaks for asymmetric gear such as shields.

**Rough development costs**

| Item | Cost |
| --- | --- |
| Claude Pro (includes Claude Code) | $20/month; Max is $100 or $200/month if you keep hitting limits |
| sprite-gen | To check: confirm which image model it uses and its per-image cost |
| Suggested AI image cap | About $50/month |

**Disclosure:** AI art (pre-generated) and AI dialogue (live-generated) both require a disclosure on the Steam store page.

## Build order & milestones

Prove the riskiest system, the AI NPC, before investing in art and content. Each step has a gate to pass before moving on.

1. **Learn Godot basics.** Work through Godot's official 2D tutorial, then build movement and simple souls-lite combat (dodge, attack, parry, stamina).
   - Gate: you can debug your own Godot errors without Claude.
2. **One AI NPC prototype.** A single character with typed chat, the four meters, a memory summary, deterministic cues, and break-attempt handling, running locally through NobodyWho.
   - Gate: the character stays in character, meters move sensibly, and replies feel fast enough on mid-range hardware.
3. **Core systems.** Story flags and the choice/autosave system, the calendar, stats and leveling, gear requirements, skill slots.
   - Gate: one test quest branches correctly on stats, gear, and conversation.
4. **Lock the art style.** Create the reference sheet (palette, resolution, a base character), then generate one armor set with all animations through sprite-gen.
   - Gate: sprites stay consistent across frames and layers.
5. **Build Act 1.** The capital hub, connected zones, the village raid with 4–6 outcomes, and 5–6 AI characters.
   - Gate: playtesters reach different raid outcomes and notice the cult hints.
6. **Act 1 demo.** Polish, Steam page with AI disclosure, release as a demo if desired.
7. **Acts 2 and beyond.** Faction joining, followers, romance, more AI characters, endings.

## Tool setup checklist

Install in waves: the core stack first, then add one tool at a time so you can tell which one causes problems if Claude starts behaving inconsistently. All of these run in Claude Code, not the Claude chat app.

**Wave 0: prerequisites**

- [ ] Git, Python 3, Node.js 18+, and Git Bash (Game Studios is primarily tested on Windows 10 with Git Bash). `jq` recommended.
- [ ] Godot 4 (latest stable). godot-mcp needs 4.4+ for some features; confirm the Godot skills' version pins match.

**Editor and terminal:** VS Code as the editor, with Git Bash (not PowerShell) as its built-in terminal, because Game Studios' hooks are Bash scripts.

- [ ] Install VS Code.
- [ ] In VS Code, open the terminal dropdown, choose **Select Default Profile**, and pick **Git Bash**.
- [ ] Optional: install the official Claude Code extension and a Godot extension for GDScript syntax highlighting. Scenes and playtesting still happen in the Godot editor.

**Wave 1: core stack**

- [ ] **Claude Code Game Studios** (foundation): `git clone https://github.com/Donchitos/Claude-Code-Game-Studios.git my-game`, then `cd my-game`, run `claude`, and type `/start`.
- [ ] **godot-mcp** (Coding-Solo): `claude mcp add godot -e GODOT_PATH=<path to godot> -- npx @coding-solo/godot-mcp`, then restart Claude Code.
- [ ] **awesome-gamedev-agent-skills**, router plus Godot bundle only: `claude plugin marketplace add gamedev-skills/awesome-gamedev-agent-skills`, then `claude plugin install router@awesome-gamedev-agent-skills` and `claude plugin install godot@awesome-gamedev-agent-skills`.
- [ ] Optional from the same marketplace: the RPG genre skill.

**Wave 2: add one at a time**

- [ ] **Matt Pocock skills** (cherry-pick): `npx skills@latest add mattpocock/skills`, select `diagnose`, `git-guardrails-claude-code`, `zoom-out`, `grill-with-docs`, and `setup-matt-pocock-skills`, then run `/setup-matt-pocock-skills` once. Skip `to-prd`, `to-issues`, and TypeScript-only skills.
- [ ] **ponytail**: send `/plugin marketplace add DietrichGebert/ponytail`, then send `/plugin install ponytail@ponytail` as a separate prompt. Node must be on your PATH. Watch for clashes with Game Studios.
- [ ] **obsidian-brain** (abhattacherjee): `/plugin marketplace add abhattacherjee/claude-code-skills`, then `/plugin install obsidian-brain@claude-code-skills`. Install the Obsidian app and open the project's `design/` folder as your vault.

**Wave 3: when you reach those steps**

- [ ] **Sprite tool:** install the `aldegad/sprite-gen` skill. Check its image model and per-image cost first.
- [ ] **NobodyWho** for the AI NPC prototype: install from Godot's AssetLib, then load a small GGUF model (about 4B).

## Claude Code model & usage settings

Use the built-in `opusplan` setting: Opus 5.5 plans and designs in plan mode, and Sonnet 5.5 writes the code once a plan is approved. Haiku handles tiny fixes in a separate session. No extra tools needed.

**Setup**

- [ ] Open `.claude/settings.json` in the project folder. Game Studios already includes this file, so add these keys to it rather than replacing it:

```json
{
  "model": "opusplan",
  "env": {
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "claude-opus-5-5",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "claude-sonnet-5-5"
  }
}
```

- [ ] Restart Claude Code and run `/model` to confirm it shows `opusplan`.
- [ ] Confirm with your Enterprise admin that Opus, Sonnet, and Haiku are all enabled, and that community plugins are allowed.

**Daily workflow**

| Task | Model | How |
| --- | --- | --- |
| Planning, design, architecture | Opus 5.5 | Press Shift+Tab to enter plan mode |
| Coding and implementation | Sonnet 5.5 | Approve the plan; execution switches automatically |
| Typos and tiny edits | Haiku | Start a separate session with `claude --model haiku` |

Don't switch to Haiku in the middle of a long session: the next reply re-reads the whole history without the cache, which can cost more than letting Sonnet make the fix.

**Game Studios, run lean**

- [ ] Keep `modes.rigor: minimal` (the default) and set `review_mode` to solo. Raise rigor only for the AI NPC system via `system_overrides`.
- [ ] Delete agents you won't use: network, live-ops, localization, community manager, analytics, devops, security, and the Unity and Unreal sets.
- [ ] Use the `/team-*` commands rarely; they coordinate several agents at once and cost the most.
- [ ] Leave the directors on Opus: they handle design, which matches the opusplan split.

**Usage habits**

- Check `/usage` and `/context` weekly and fix the biggest offender first.
- Keep CLAUDE.md under about 2,000 tokens; it's re-sent on every turn.
- Run `/clear` between tasks, after writing a short handoff note.
- Point Claude at exact files and keep a short repo map.
- Turn off godot-mcp when you aren't testing in Godot.

**Optional later: an automatic model router**

After about a week on opusplan, compare `/usage`. If you still want Haiku used automatically, try one router, installed last and by itself:

| Repo | Why |
| --- | --- |
| [hhchuan89/claude-model-router](https://github.com/hhchuan89/claude-model-router) | First choice: defaults to the 5.5 models and keeps models other tools set, so it won't override Game Studios' agents |
| [celiktech24-cell/smart-task-router](https://github.com/celiktech24-cell/smart-task-router) | Alternative: Opus plans, Haiku or Sonnet builds, each step verified, escalates only on failure |

Avoid routers that force every subagent to Haiku globally; that would downgrade Game Studios specialists that inherit your session model.

## Open items & parked decisions

These were deliberately left for later and are not needed for Act 1 unless noted.

- [ ] Game title and world name
- [ ] Names, personalities, and backstories for the 5–6 Act 1 AI characters (needed for step 2 onward)
- [ ] Faction names and lore for the foreign country, the noble cult, and the demons
- [ ] Who betrayed the knight, and how the mystery unfolds across acts
- [ ] Final choice of local model (Qwen3 4B vs. Llama 3.2 3B class) after prototype testing, plus a license check
- [ ] Passive buff design
- [ ] Stat reset feature, Renalla-style (not in Act 1)
- [ ] Which characters are romanceable, based on their personalities (not in Act 1)
- [ ] Steam Deck support (needs an on-screen keyboard or voice input)
- [ ] Cosmetic DLC vs. a full DLC act
- [ ] If regenerating through sprite-gen becomes too slow for small fixes, consider Pixelorama (free) as a backup editor

## Sources

- [Claude Code Game Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)
- [godot-mcp (Coding-Solo)](https://github.com/Coding-Solo/godot-mcp)
- [awesome-gamedev-agent-skills](https://github.com/gamedev-skills/awesome-gamedev-agent-skills)
- [mattpocock/skills](https://github.com/mattpocock/skills)
- [ponytail](https://github.com/DietrichGebert/ponytail)
- [obsidian-brain (abhattacherjee)](https://claudemarket.ai/plugins/abhattacherjee-claude-code-skills/obsidian-brain)
- [sprite-gen (aldegad)](https://agentskill.work/en/skills/aldegad/sprite-gen)
- [NobodyWho](https://github.com/nobodywho-ooo/nobodywho)
- [Local LLM for game devs: model recommendations](https://bestllmfor.com/verticals/local-llm-for-game-dev/)
- [AI NPCs and dialogue in games: 2026 reality check](https://app.cinevva.com/guides/ai-npcs-dialogue)
- [Steam AI disclosure policy update](https://www.pcgamer.com/software/ai/steam-updates-ai-disclosure-form-to-specify-that-its-focused-on-ai-generated-content-that-is-consumed-by-players-not-efficiency-tools-used-behind-the-scenes/)
- [Retro Diffusion pricing](https://aipicks.jp/tool/retro-diffusion/pricing)
- [Claude Pro vs. Max pricing](https://chudi.dev/blog/claude-pro-vs-max)
