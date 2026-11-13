# State-based godot-mcp check: combat prototype, one heavy attack

Date: 2026-11-13. Project: `prototypes/combat-concept/`. Procedure: `.claude/docs/run-and-observe.md`,
"Godot 4 with godot-mcp".

Run result: ran under godot-mcp (spawned, background), state read through `run_script` before and after,
input sent as the game's own input action. Screenshots: `05-state-proof-before.png`, `06-state-proof-after.png`.

## Setup (arrange only, not the result)
`run_script` set: player HP and stamina full, player idle, dummy HP full and idle, dummy `idle_time` raised so it does
not attack during the test, dummy placed 90 px from the player along the player's current aim (the mouse cannot be
steered, see below).

## Input
One `simulate_input` action: `{"type":"action","action":"attack_heavy"}`, then waits of 150, 250 and 700 ms.
No mouse events.

## Values read with `run_script`
| Value | Before | After | Expected | Result |
|---|---|---|---|---|
| Dummy HP | 100 | 70 | before - 30 (`heavy_damage`), tolerance 0.01 | PASS |
| Player state | 0 (IDLE) | 0 (IDLE) | back to IDLE once the 0.87 s attack is over | PASS |
| Player HP | 100 | 100 | unchanged (the dummy did not attack) | PASS |
| Player stamina | 100 | 100 | spent 32 then regenerated (see timeline) | PASS (see timeline) |
| Player position | (60.04, 360.00) | (83.63, 388.83) | moved along aim by the heavy lunge, 300 px/s x 0.12 s = 36 px | PASS (moved 37.3 px) |

## Timeline sampled with `watch` after each action
| t (ms) | Player state | Player stamina | Dummy HP |
|---|---|---|---|
| 11 | 2 (HEAVY) | 68 | 100 |
| 161 | 2 (HEAVY) | 68 | 100 |
| 411 | 2 (HEAVY) | 68 | 70 |
| 1111 | 0 (IDLE) | 87.8 | 70 |

The stamina cost (100 -> 68 = 32, `heavy_cost`) and the hit landing in the active window (0.35 to 0.47 s) both show
here. A single before/after pair would not have shown the stamina spend, because it regenerates by the time of the
"after" read.

## Finding: injected mouse motion does not steer the game's aim
In the first MCP run, `mouse_motion` to (760, 360) left `player.aim` unchanged, and the aim stayed on the real cursor's
direction. So in-game checks must not rely on the mouse: drive game input actions or keyboard events, and arrange
anything aim-dependent with `run_script`, or give the game a non-mouse aim input.
