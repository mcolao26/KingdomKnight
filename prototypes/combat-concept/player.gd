# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does one shared stamina bar make dodge, parry, light and heavy attacks feel weighty and readable without feeling punishing?
# Date: 2026-11-11
extends CharacterBody2D
## The knight: 8-direction movement, light/heavy attack, dodge roll, parry, one stamina bar.

signal message(text: String)

enum State { IDLE, LIGHT, HEAVY, DODGE, PARRY, HURT }

const ARENA_MIN := Vector2(60, 110)
const ARENA_MAX := Vector2(1220, 660)

@export var max_hp: float = 100.0
@export var move_speed: float = 220.0

@export var max_stamina: float = 100.0
@export var stamina_regen: float = 35.0  # per second
@export var regen_delay: float = 0.5  # pause after spending before it refills

@export var light_cost: float = 15.0
@export var light_windup: float = 0.08
@export var light_active: float = 0.10
@export var light_recovery: float = 0.20
@export var light_damage: float = 10.0
@export var light_reach: float = 55.0
@export var light_radius: float = 32.0

@export var heavy_cost: float = 32.0
@export var heavy_windup: float = 0.35
@export var heavy_active: float = 0.12
@export var heavy_recovery: float = 0.40
@export var heavy_damage: float = 30.0
@export var heavy_reach: float = 65.0
@export var heavy_radius: float = 40.0
@export var heavy_lunge_speed: float = 300.0

@export var dodge_cost: float = 25.0
@export var dodge_time: float = 0.30
@export var dodge_speed: float = 520.0
@export var dodge_iframes: float = 0.25

@export var parry_cost: float = 12.0  # refunded on a successful parry
@export var parry_window: float = 0.18
@export var parry_recovery: float = 0.30

@export var hurt_time: float = 0.25
@export var hurt_knockback: float = 260.0
@export var input_buffer: float = 0.15

var state: State = State.IDLE
var state_time: float = 0.0
var hp: float = 0.0
var stamina: float = 0.0
var regen_wait: float = 0.0
var aim: Vector2 = Vector2.RIGHT
var dodge_dir: Vector2 = Vector2.RIGHT
var hurt_dir: Vector2 = Vector2.LEFT
var flash: float = 0.0
var buffered: StringName = &""
var buffer_left: float = 0.0
var hit_landed: bool = false
var dummy = null  # set by main.gd

# the attack currently being swung (filled in by _start_attack)
var cur_windup: float = 0.0
var cur_active: float = 0.0
var cur_recovery: float = 0.0
var cur_damage: float = 0.0
var cur_reach: float = 0.0
var cur_radius: float = 0.0
var cur_lunge: float = 0.0

# counters shown on the HUD to judge the hypothesis
var parries: int = 0
var parry_streak: int = 0
var stamina_outs: int = 0


func _ready() -> void:
	hp = max_hp
	stamina = max_stamina


func _physics_process(delta: float) -> void:
	state_time += delta
	flash = maxf(flash - delta, 0.0)
	buffer_left = maxf(buffer_left - delta, 0.0)

	regen_wait = maxf(regen_wait - delta, 0.0)
	if regen_wait <= 0.0:
		stamina = minf(stamina + stamina_regen * delta, max_stamina)

	_read_input_buffer()

	match state:
		State.IDLE:
			_process_idle()
		State.LIGHT, State.HEAVY:
			_process_attack()
		State.DODGE:
			velocity = dodge_dir * dodge_speed
			if state_time >= dodge_time:
				_enter(State.IDLE)
		State.PARRY:
			velocity = Vector2.ZERO
			if state_time >= parry_window + parry_recovery:
				_enter(State.IDLE)
		State.HURT:
			velocity = hurt_dir * hurt_knockback * (1.0 - state_time / hurt_time)
			if state_time >= hurt_time:
				_enter(State.IDLE)

	move_and_slide()
	global_position = global_position.clamp(ARENA_MIN, ARENA_MAX)
	queue_redraw()


## Remember the last button press for a moment, so pressing slightly early still counts.
func _read_input_buffer() -> void:
	for action in [&"attack_light", &"attack_heavy", &"dodge", &"parry"]:
		if Input.is_action_just_pressed(action):
			buffered = action
			buffer_left = input_buffer
	if buffer_left <= 0.0:
		buffered = &""


func _process_idle() -> void:
	var move_dir := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	velocity = move_dir * move_speed
	aim = _mouse_aim()
	if buffered != &"":
		var action := buffered
		buffered = &""
		_try_action(action, move_dir)


func _try_action(action: StringName, move_dir: Vector2) -> void:
	if stamina <= 0.0:
		stamina_outs += 1
		message.emit("Out of stamina!")
		return
	aim = _mouse_aim()
	if action == &"attack_light":
		_spend(light_cost)
		_start_attack(State.LIGHT, light_windup, light_active, light_recovery, light_damage, light_reach, light_radius, 0.0)
	elif action == &"attack_heavy":
		_spend(heavy_cost)
		_start_attack(State.HEAVY, heavy_windup, heavy_active, heavy_recovery, heavy_damage, heavy_reach, heavy_radius, heavy_lunge_speed)
	elif action == &"dodge":
		_spend(dodge_cost)
		dodge_dir = move_dir.normalized() if move_dir != Vector2.ZERO else aim
		_enter(State.DODGE)
	elif action == &"parry":
		_spend(parry_cost)
		_enter(State.PARRY)


func _start_attack(kind: State, windup: float, active: float, recovery: float, damage: float, reach: float, radius: float, lunge: float) -> void:
	cur_windup = windup
	cur_active = active
	cur_recovery = recovery
	cur_damage = damage
	cur_reach = reach
	cur_radius = radius
	cur_lunge = lunge
	_enter(kind)


func _process_attack() -> void:
	velocity = Vector2.ZERO
	var t := state_time
	if t >= cur_windup and t < cur_windup + cur_active:
		if cur_lunge > 0.0:
			velocity = aim * cur_lunge
		if not hit_landed and dummy != null:
			var point := global_position + aim * cur_reach
			if point.distance_to(dummy.global_position) <= cur_radius + dummy.radius:
				hit_landed = true
				dummy.take_damage(cur_damage)
				hitstop(0.05)
	elif t >= cur_windup + cur_active + cur_recovery:
		_enter(State.IDLE)


## Called by the dummy when its strike lands. Returns &"hit", &"parried" or &"dodged".
func try_hit(damage: float, from_pos: Vector2) -> StringName:
	if state == State.DODGE and state_time < dodge_iframes:
		message.emit("Dodged")
		return &"dodged"
	if state == State.PARRY and state_time < parry_window:
		parries += 1
		parry_streak += 1
		stamina = minf(stamina + parry_cost, max_stamina)
		message.emit("PARRY!")
		hitstop(0.08)
		_enter(State.IDLE)
		return &"parried"
	hp = maxf(hp - damage, 0.0)
	parry_streak = 0
	flash = 0.2
	hurt_dir = (global_position - from_pos).normalized()
	_enter(State.HURT)
	hitstop(0.06)
	if hp <= 0.0:
		message.emit("You fell - back on your feet")
		hp = max_hp
		stamina = max_stamina
	return &"hit"


func hitstop(duration: float) -> void:
	Engine.time_scale = 0.05
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0


func _spend(cost: float) -> void:
	stamina = maxf(stamina - cost, 0.0)
	regen_wait = regen_delay


func _enter(new_state: State) -> void:
	state = new_state
	state_time = 0.0
	hit_landed = false


func _mouse_aim() -> Vector2:
	var to_mouse := get_global_mouse_position() - global_position
	if to_mouse.length() > 4.0:
		return to_mouse.normalized()
	return aim


func _draw() -> void:
	var col := Color(0.3, 0.6, 1.0)
	if flash > 0.0:
		col = Color.WHITE
	if state == State.DODGE:
		col.a = 0.45 if state_time < dodge_iframes else 0.8
	draw_rect(Rect2(-16, -16, 32, 32), col)
	draw_line(Vector2.ZERO, aim * 28.0, Color.WHITE, 3.0)

	if state == State.LIGHT or state == State.HEAVY:
		var centre := aim * cur_reach
		if state_time < cur_windup:
			draw_arc(centre, cur_radius, 0.0, TAU, 24, Color(1.0, 0.6, 0.2, 0.5), 2.0)
		elif state_time < cur_windup + cur_active:
			draw_circle(centre, cur_radius, Color(1.0, 1.0, 1.0, 0.5))
	elif state == State.PARRY:
		var ring := Color.CYAN if state_time < parry_window else Color(0.4, 0.4, 0.4)
		draw_arc(Vector2.ZERO, 30.0, 0.0, TAU, 32, ring, 3.0)
