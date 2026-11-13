## 2026-11-13 — chore/project-cleanup (pixel-art rendering settings)

**Decision point:** Which pixel-art rendering and stretch settings to put in the root `project.godot`.
**Options considered:** (a) texture filter Nearest vs Linear; (b) stretch `canvas_items` vs `viewport` vs `disabled`; (c) scale mode `integer` vs `fractional`; (d) aspect `keep` vs `expand`; (e) pixel snapping on or off; (f) base viewport size 1152x648 (engine default) vs 1280x720.
**Chosen:** `textures/canvas_textures/default_texture_filter=0` (Nearest); stretch mode `canvas_items`; scale mode `integer`; aspect `keep`; `2d/snap/snap_2d_transforms_to_pixel=true` and `snap_2d_vertices_to_pixel=true`; base viewport 1280x720; `renderer/rendering_method="forward_plus"` written back explicitly (the editor had dropped it because it is the default).
**Reason:** Nearest keeps 32x48 sprites crisp. `canvas_items` plus integer scale keeps every sprite pixel a whole number of screen pixels at any window size, and `keep` letterboxes rather than showing extra world on wide windows. Snapping stops sub-pixel shimmer. 1280x720 matches the combat prototype and `.claude/docs/run-and-observe.md`. `canvas_items` also matches the 4.7 new-project default in `docs/engine-reference/godot/breaking-changes.md`; the other names, hints and defaults were read from the installed 4.7.2 engine (ProjectSettings), because the engine reference does not cover them. NOTE: the base resolution decides how many tiles the player sees and ties to art direction, which is Matthew's call. 1280x720 is a placeholder until he decides.
**Category:** minor

## 2026-11-13 — feat/pixel-scale-and-mcp-verification (art scale change)

**Decision point:** Art scale and base resolution.
**Decided by:** MATTHEW (explicit instruction, 2026-11-13), not by Claude.
**Chosen (Matthew):** 16x16 tiles, about 16x32 characters, base viewport 480x270, nearest-neighbor filtering, canvas_items stretch, integer scaling, pixel snapping, aspect `expand` so the window is filled with no letterboxing; style traits (warm saturated palette, colored outlines a shade darker than the object and almost no pure black, 3/4 top-down with soft shadows, textures from scattered pixels not gradients); rule: never use another game's sprites, tilesets or screenshots as sprite-gen input or tracing references. This supersedes the earlier 1280x720 placeholder entry above.
**Category:** minor (creative decision recorded as the user's)

## 2026-11-13 — feat/pixel-scale-and-mcp-verification (implementation choices, Claude)

**Decision point:** Godot's `expand` + `integer` stretch does not fill the window.
**Options considered:** (a) leave the settings as asked and report the gap; (b) a small autoload that picks the whole-number scale first and sets the logical viewport to window/scale; (c) switch to fractional scaling.
**Chosen:** (b) `src/core/pixel_viewport.gd`, registered as the `PixelViewport` autoload, while keeping Matthew's static settings (480x270, canvas_items, expand, integer). Measured on 4.7.2: with the settings alone 2560x1440 draws 5x over 480x270 and leaves 160x90 px black; with the autoload it is 5x over 512x288 with 0 px border.
**Reason:** Matthew's goal is no black borders and evenly sized pixels; (c) would break even pixels. Window.size_changed only fires when the logical viewport changes, so the autoload polls the window size each frame (a cheap Vector2i compare) instead. A window that does not divide evenly by the scale keeps a sliver of at most scale-1 px (1600x900 at 3x leaves 1 px).
**Category:** minor

**Decision point:** The MCP writes `prototypes/combat-concept/.gitignore` (ignores `.mcp/`) on every run.
**Chosen:** track it, with the two MCP screenshots, rather than gitignore it.
**Reason:** tracked and unchanged it never shows as untracked again; ignoring it would make it reappear after each run.
**Category:** minor

**Decision point:** `commands.run` in project.yaml still launches at 1280x720.
**Chosen:** left alone and flagged to Matthew.
**Reason:** project.yaml edits are `schema_changes` (always ask). 1280x720 is not a multiple of 480x270 (2x, shows 640x360); 1920x1080 would be an exact 4x.
**Category:** schema_changes (not changed)

## 2026-11-13 — chore/finish-setup (wrap-up of setup)

**Decision point:** godot-mcp `run_script` confirmation, which timed out and blocked unattended `/work-queue` runs.
**Decided by:** MATTHEW (explicit instruction, 2026-11-13).
**Chosen:** `GODOT_MCP_DISABLE_ELICITATION=true` in the godot server's env, local scope, for this project only (the `C:/dev/Projects/KingdomKnight` entry in `~/.claude.json`, which runs godot-mcp-runtime). The older `C:/Dev/Projects/KingdomKnight` entry (capital D, @coding-solo/godot-mcp) was left untouched. Outside the repo, so not in git.
**Reason:** an unanswered prompt makes `run_script` fail, which makes every state check NOT VERIFIED. NOTE: with the prompt off, `run_script` runs GDScript inside the running game with no confirmation. It only takes effect once the server restarts (`/mcp` reconnect, or restart Claude Code).
**Category:** external_calls (user-approved)

**Decision point:** Dev launch window size.
**Decided by:** MATTHEW (schema change approved).
**Chosen:** `commands.run` in project.yaml launches at `--resolution 1440x810`.
**Reason:** exact 3x of the 480x270 base, so no letterbox and no extra world while developing.
**Category:** schema_changes (user-approved)

**Decision point:** Track this decision log in git.
**Decided by:** MATTHEW (explicit instruction); mechanism chosen by Claude.
**Chosen:** `.gitignore` now ignores `production/session-logs/*` (not the directory) plus `!production/session-logs/decision-log.md`; the rest of the folder stays ignored. `.claude/docs/directory-structure.md` comment updated to match.
**Reason:** ignoring the directory itself would make the negation inert, so the rule had to change from `production/session-logs/` to `production/session-logs/*`.
**Category:** schema_changes (user-approved)

