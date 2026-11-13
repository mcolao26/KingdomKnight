# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does one shared stamina bar make dodge, parry, light and heavy attacks feel weighty and readable without feeling punishing?
# Date: 2026-11-11
extends Node2D
## Glue script: registers the keys, introduces the nodes to each other, draws the floor.

@onready var player = $Player
@onready var dummy = $Dummy
@onready var hud = $HUDLayer/HUD


func _ready() -> void:
	_setup_input()
	player.dummy = dummy
	dummy.player = player
	hud.player = player
	hud.dummy = dummy
	player.message.connect(hud.show_message)
	dummy.message.connect(hud.show_message)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"reset"):
		Engine.time_scale = 1.0
		get_tree().reload_current_scene()


func _draw() -> void:
	draw_rect(Rect2(0, 0, 1280, 720), Color(0.08, 0.08, 0.10))
	var arena := Rect2(40, 90, 1200, 590)
	draw_rect(arena, Color(0.16, 0.17, 0.20))
	draw_rect(arena, Color(0.4, 0.4, 0.45), false, 3.0)


func _setup_input() -> void:
	_add_key(&"move_left", KEY_A)
	_add_key(&"move_right", KEY_D)
	_add_key(&"move_up", KEY_W)
	_add_key(&"move_down", KEY_S)
	_add_key(&"dodge", KEY_SPACE)
	_add_key(&"parry", KEY_Q)
	_add_key(&"reset", KEY_R)
	_add_mouse(&"attack_light", MOUSE_BUTTON_LEFT)
	_add_mouse(&"attack_heavy", MOUSE_BUTTON_RIGHT)


func _add_key(action: StringName, keycode: Key) -> void:
	if InputMap.has_action(action):
		return
	InputMap.add_action(action)
	var ev := InputEventKey.new()
	ev.physical_keycode = keycode
	InputMap.action_add_event(action, ev)


func _add_mouse(action: StringName, button: MouseButton) -> void:
	if InputMap.has_action(action):
		return
	InputMap.add_action(action)
	var ev := InputEventMouseButton.new()
	ev.button_index = button
	InputMap.action_add_event(action, ev)
