# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does one shared stamina bar make dodge, parry, light and heavy attacks feel weighty and readable without feeling punishing?
# Date: 2026-11-11
extends CharacterBody2D
## Practice dummy: walks up, telegraphs slowly, strikes, recovers. A parry staggers it.

signal message(text: String)

enum State { CHASE, WINDUP, STRIKE, RECOVER, STAGGER }

const ARENA_MIN := Vector2(60, 110)
const ARENA_MAX := Vector2(1220, 660)

@export var max_hp: float = 100.0
@export var move_speed: float = 70.0
@export var approach_distance: float = 80.0
@export var idle_time: float = 1.4
@export var windup_time: float = 0.8
@export var strike_time: float = 0.15
@export var recover_time: float = 0.6
@export var stagger_time: float = 1.2
@export var strike_range: float = 100.0
@export var strike_damage: float = 20.0
@export var strike_cone_dot: float = 0.35  # how wide the strike is; lower = wider

var radius: float = 28.0
var state: State = State.CHASE
var state_time: float = 0.0
var hp: float = 0.0
var facing: Vector2 = Vector2.LEFT
var flash: float = 0.0
var strike_resolved: bool = false
var player = null  # set by main.gd


func _ready() -> void:
	hp = max_hp


func _physics_process(delta: float) -> void:
	state_time += delta
	flash = maxf(flash - delta, 0.0)
	var to_player: Vector2 = player.global_position - global_position
	var dist := to_player.length()

	match state:
		State.CHASE:
			facing = to_player.normalized()
			velocity = facing * move_speed if dist > approach_distance else Vector2.ZERO
			if state_time >= idle_time and dist <= strike_range - 10.0:
				_enter(State.WINDUP)
		State.WINDUP:
			velocity = Vector2.ZERO
			if state_time >= windup_time:
				_enter(State.STRIKE)
		State.STRIKE:
			velocity = Vector2.ZERO
			if not strike_resolved and dist <= strike_range and facing.dot(to_player.normalized()) >= strike_cone_dot:
				strike_resolved = true
				var result: StringName = player.try_hit(strike_damage, global_position)
				if result == &"parried":
					_enter(State.STAGGER)
			if state == State.STRIKE and state_time >= strike_time:
				_enter(State.RECOVER)
		State.RECOVER:
			velocity = Vector2.ZERO
			if state_time >= recover_time:
				_enter(State.CHASE)
		State.STAGGER:
			velocity = Vector2.ZERO
			if state_time >= stagger_time:
				_enter(State.CHASE)

	move_and_slide()
	global_position = global_position.clamp(ARENA_MIN, ARENA_MAX)
	queue_redraw()


## Double damage while staggered (after a parry).
func take_damage(amount: float) -> void:
	var dmg := amount * (2.0 if state == State.STAGGER else 1.0)
	hp -= dmg
	flash = 0.12
	if hp <= 0.0:
		hp = max_hp
		message.emit("Dummy down - reset")


func _enter(new_state: State) -> void:
	state = new_state
	state_time = 0.0
	strike_resolved = false


func _draw() -> void:
	var col := Color(0.55, 0.55, 0.65)
	match state:
		State.WINDUP:
			col = Color(1.0, 0.6, 0.1)
		State.STRIKE:
			col = Color(1.0, 0.15, 0.15)
		State.RECOVER:
			col = Color(0.45, 0.45, 0.5)
		State.STAGGER:
			col = Color(1.0, 0.95, 0.3)
	if flash > 0.0:
		col = Color.WHITE
	draw_rect(Rect2(-24, -24, 48, 48), col)
	draw_line(Vector2.ZERO, facing * 32.0, Color.BLACK, 3.0)

	# telegraph: the red outline is the reach, the inner arc grows until the strike lands
	if state == State.WINDUP or state == State.STRIKE:
		var angle := facing.angle()
		var half := acos(strike_cone_dot)
		draw_arc(Vector2.ZERO, strike_range, angle - half, angle + half, 20, Color(1.0, 0.2, 0.2, 0.8), 3.0)
		if state == State.WINDUP:
			var progress := clampf(state_time / windup_time, 0.0, 1.0)
			draw_arc(Vector2.ZERO, strike_range * progress, angle - half, angle + half, 20, Color(1.0, 0.6, 0.1, 0.9), 3.0)

	# health bar over its head
	draw_rect(Rect2(-24, -42, 48, 6), Color(0, 0, 0, 0.7))
	draw_rect(Rect2(-24, -42, 48.0 * clampf(hp / max_hp, 0.0, 1.0), 6), Color(0.85, 0.2, 0.2))
