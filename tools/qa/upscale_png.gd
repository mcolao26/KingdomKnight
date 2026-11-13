extends SceneTree
## Makes a nearest-neighbor enlarged copy of a PNG, for a person to review pixel art.
##
## Usage (from the project root):
##   godot --headless --path . -s tools/qa/upscale_png.gd -- <in.png> <out.png> [scale=3]
##
## Nearest-neighbor keeps every source pixel a sharp block, with no smoothing and no new colors.
## The native-size file stays the one to check yourself; the enlarged copy is only for looking at.
## Exit code 0 on success, 1 if the image cannot be read or written, 2 on bad arguments.


func _initialize() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	if args.size() < 2:
		printerr("usage: upscale_png.gd -- <in.png> <out.png> [scale=3]")
		quit(2)
		return
	var factor: int = int(args[2]) if args.size() > 2 else 3
	if factor < 1:
		printerr("upscale_png: scale must be a whole number of 1 or more")
		quit(2)
		return
	var img: Image = Image.load_from_file(args[0])
	if img == null or img.is_empty():
		printerr("upscale_png: cannot read %s" % args[0])
		quit(1)
		return
	var w: int = img.get_width()
	var h: int = img.get_height()
	img.resize(w * factor, h * factor, Image.INTERPOLATE_NEAREST)
	if img.save_png(args[1]) != OK:
		printerr("upscale_png: cannot write %s" % args[1])
		quit(1)
		return
	print("upscale_png: %s %dx%d -> %s %dx%d (nearest, %dx)" % [args[0], w, h, args[1], w * factor, h * factor, factor])
	quit(0)
