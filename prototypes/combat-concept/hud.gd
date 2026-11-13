# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does one shared stamina bar make dodge, parry, light and heavy attacks feel weighty and readable without feeling punishing?
# Date: 2026-11-11
extends Control
## Draws the bars, the counters used to judge the hypothesis, a flash message and the controls.

var player = null  # set by main.gd
var dummy = null  # set by main.gd
var msg: String = ""
var msg_left: float = 0.0


func show_message(text: String) -> void:
	msg = text
	msg_left = 1.0


func _process(delta: float) -> void:
	msg_left = maxf(msg_left - delta, 0.0)
	queue_redraw()


func _draw() -> void:
	var font := ThemeDB.fallback_font

	_bar(Vector2(30, 24), Vector2(300, 20), player.hp / player.max_hp, Color(0.85, 0.2, 0.2))
	draw_string(font, Vector2(340, 40), "HP", HORIZONTAL_ALIGNMENT_LEFT, -1, 16)

	var stam_col := Color(0.3, 0.85, 0.35)
	if player.stamina <= 0.0:
		stam_col = Color(1.0, 0.3, 0.1)
	_bar(Vector2(30, 52), Vector2(300, 16), player.stamina / player.max_stamina, stam_col)
	draw_string(font, Vector2(340, 66), "STAMINA", HORIZONTAL_ALIGNMENT_LEFT, -1, 16)

	var stats := "Parries: %d    Streak: %d    Out-of-stamina: %d" % [player.parries, player.parry_streak, player.stamina_outs]
	draw_string(font, Vector2(30, 84), stats, HORIZONTAL_ALIGNMENT_LEFT, -1, 16)

	if msg_left > 0.0:
		draw_string(font, Vector2(0, 150), msg, HORIZONTAL_ALIGNMENT_CENTER, 1280, 40, Color(1, 1, 1, minf(msg_left * 2.0, 1.0)))

	draw_string(font, Vector2(30, 706), "WASD move | Mouse aim | LMB light | RMB heavy | Space dodge | Q parry | R reset", HORIZONTAL_ALIGNMENT_LEFT, -1, 16)


func _bar(pos: Vector2, size_px: Vector2, frac: float, col: Color) -> void:
	draw_rect(Rect2(pos, size_px), Color(0, 0, 0, 0.6))
	draw_rect(Rect2(pos, Vector2(size_px.x * clampf(frac, 0.0, 1.0), size_px.y)), col)
	draw_rect(Rect2(pos, size_px), Color(1, 1, 1, 0.5), false, 2.0)
