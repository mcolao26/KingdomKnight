extends Node
## Keeps every pixel the same whole-number size and fills the window with no black borders.
##
## Godot's own `expand` + `integer` stretch settings letterbox: the viewport grows to the window's
## aspect ratio, but the scale is then rounded down, so part of the window stays black (for
## example 2560x1440 draws 5x over 2400x1350). This autoload instead picks the whole-number
## scale first (the largest that still fits the base size), then sets the logical viewport to
## window size / scale. At 1920x1080 that is 4x over 480x270, at 2560x1440 it is 5x over 512x288,
## at 3840x2160 it is 8x over 480x270. A window that is not an exact multiple shows slightly more
## of the world, and any leftover is under one whole-number scale step (at most a hairline).
##
## The base size is read from the project settings (display/window/size/viewport_*), so it is
## changed in one place. Anchor HUD and UI to screen edges (see .claude/rules/ui-code.md).

var _base_size: Vector2i = Vector2i(480, 270)
var _last_window_size: Vector2i = Vector2i.ZERO


func _ready() -> void:
	_base_size = Vector2i(
		int(ProjectSettings.get_setting("display/window/size/viewport_width")),
		int(ProjectSettings.get_setting("display/window/size/viewport_height"))
	)
	get_window().min_size = _base_size  # below this the world would be cropped, not scaled
	_refit()


# Polled every frame on purpose: Window.size_changed only fires when the logical viewport size
# changes, so a resize that leaves it unchanged (1280x720 -> 1600x900 under a 640x360 viewport)
# would never be refitted. Comparing two Vector2i does not allocate.
func _process(_delta: float) -> void:
	if get_window().size != _last_window_size:
		_refit()


## The whole-number scale used for a window of `window_size`: the largest that fits the base size.
func scale_for(window_size: Vector2i) -> int:
	var fit: Vector2 = Vector2(window_size) / Vector2(_base_size)
	return maxi(1, int(floorf(minf(fit.x, fit.y))))


## The logical (in-game) size shown in a window of `window_size`.
func logical_size_for(window_size: Vector2i) -> Vector2i:
	var s: int = scale_for(window_size)
	return Vector2i(floori(window_size.x / float(s)), floori(window_size.y / float(s)))


func _refit() -> void:
	var window: Window = get_window()
	_last_window_size = window.size
	var target: Vector2i = logical_size_for(window.size)
	if window.content_scale_size != target:
		window.content_scale_size = target
