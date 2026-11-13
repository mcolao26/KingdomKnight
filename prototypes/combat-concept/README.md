<!-- PROTOTYPE - NOT FOR PRODUCTION -->
<!-- Question: Does one shared stamina bar make dodge, parry, light and heavy attacks feel weighty and readable without feeling punishing? -->
<!-- Date: 2026-11-11 -->

# Combat concept (Godot 4.7.2)

## Hypothesis
If the player fights a slowly telegraphing dummy using dodge, parry and light/heavy attacks that
all draw on one stamina bar, combat will feel weighty and readable, not spammy.
True if, within 5 minutes of play: 3 parries in a row, a mix of dodge and parry (not one spammed),
and no more than 2 accidental out-of-stamina moments. The HUD shows parries, streak and
out-of-stamina counts.

## How to run
Open `prototypes/combat-concept/` in Godot 4.7.2 (Project Manager -> Import -> pick `project.godot`) and press F5.
Or from a terminal: `"C:/dev/Godot/Godot_v4.7.2-stable_win64.exe" --path prototypes/combat-concept`

Controls: WASD move, mouse aim, LMB light, RMB heavy, Space dodge, Q parry, R reset.
Tuning values are `@export` variables at the top of `player.gd` and `dummy.gd` (editable in the Inspector).

## Status
In-progress

## Findings
(filled in when the prototype concludes)
