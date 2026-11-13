---
paths:
  - "src/ui/**"
  - "Assets/**/{UI,Ui,ui}/**/*.cs"
  - "Source/**/{UI,Ui,ui}/**/*.{h,cpp}"
---

# UI Code Rules

- UI must NEVER own or directly modify game state — display only, use commands/events to request changes
- All UI text must go through the localization system — no hardcoded user-facing strings
- Support both keyboard/mouse AND gamepad input for all interactive elements
- All animations must be skippable and respect user motion/accessibility preferences
- UI sounds trigger through the audio event system, not directly
- UI must never block the game thread
- Scalable text and colorblind modes are mandatory, not optional
- Test all screens at minimum and maximum supported resolutions
- Godot: anchor every HUD and UI Control to the screen edges (Control anchors and Containers, for example a full-rect root). Never place UI with absolute pixel coordinates. The base viewport is 480×270 with whole-number scaling (see `src/core/pixel_viewport.gd`), so the visible area is slightly larger than 480×270 on windows that are not an exact multiple (512×288 at 1440p, 688×288 at 3440×1440); edge-anchored UI stays on the real edges
