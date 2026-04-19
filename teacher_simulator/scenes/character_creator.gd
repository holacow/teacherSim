extends Control

const HAIR_STYLE_NAMES: Array = ["Short", "Long", "Curly", "Spiky", "Bun"]
const HAIR_COLOR_NAMES: Array = ["Black", "Brown", "Blonde", "Red", "Blue", "White"]
const HAIR_COLORS: Array = [
	Color(0.1,0.08,0.05), Color(0.45,0.25,0.1), Color(0.95,0.85,0.3),
	Color(0.8,0.2,0.1), Color(0.2,0.4,0.9), Color(0.95,0.95,0.95)
]
const SKIN_COLOR_NAMES: Array = ["Light", "Medium", "Tan", "Brown", "Dark"]
const SKIN_COLORS: Array = [
	Color(1.0,0.88,0.76), Color(0.95,0.76,0.57), Color(0.87,0.65,0.43),
	Color(0.65,0.42,0.24), Color(0.35,0.22,0.12)
]
const OUTFIT_COLOR_NAMES: Array = ["Blue", "Red", "Green", "Purple", "Orange", "Pink"]
const OUTFIT_COLORS: Array = [
	Color(0.2,0.4,0.9), Color(0.9,0.2,0.2), Color(0.2,0.75,0.35),
	Color(0.6,0.2,0.9), Color(0.95,0.55,0.1), Color(0.9,0.35,0.65)
]

const C_BG   = Color(0.10, 0.08, 0.18)
const C_GOLD = Color(1.00, 0.85, 0.20)
const C_GREEN= Color(0.30, 1.00, 0.50)
const C_LIME = Color(0.70, 1.00, 0.20)
const C_DARK = Color(0.90, 0.95, 1.00)
const C_YELL = Color(1.00, 0.95, 0.30)

var hair_idx: int = 0
var hair_color_idx: int = 0
var skin_idx: int = 0
var outfit_idx: int = 0
var avatar_display: Control

func _ready() -> void:
	var bg = ColorRect.new()
	bg.color = C_BG
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var outer = HBoxContainer.new()
	outer.add_theme_constant_override("separation", 40)
	center.add_child(outer)

	var left_panel = PanelContainer.new()
	left_panel.custom_minimum_size = Vector2(260, 420)
	outer.add_child(left_panel)

	var left_vbox = VBoxContainer.new()
	left_vbox.add_theme_constant_override("separation", 12)
	left_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	left_panel.add_child(left_vbox)

	var preview_lbl = _outlined_label("YOUR AVATAR", C_GOLD, 18)
	preview_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	left_vbox.add_child(preview_lbl)

	avatar_display = Control.new()
	avatar_display.custom_minimum_size = Vector2(160, 230)
	avatar_display.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_vbox.add_child(avatar_display)
	avatar_display.draw.connect(_draw_avatar)

	var diff_lbl = _outlined_label("Difficulty: " + GameManager.DIFF_LABELS[GameManager.difficulty], C_LIME, 14)
	diff_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	left_vbox.add_child(diff_lbl)

	var name_lbl = _outlined_label(GameManager.teacher_name, C_GREEN, 16)
	name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	left_vbox.add_child(name_lbl)

	var right_panel = PanelContainer.new()
	right_panel.custom_minimum_size = Vector2(400, 0)
	outer.add_child(right_panel)

	var right_vbox = VBoxContainer.new()
	right_vbox.add_theme_constant_override("separation", 14)
	right_panel.add_child(right_vbox)

	var title = _outlined_label("CUSTOMIZE YOUR TEACHER", C_GOLD, 20)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	right_vbox.add_child(title)

	right_vbox.add_child(HSeparator.new())

	right_vbox.add_child(_sec("HAIR STYLE"))
	right_vbox.add_child(_picker(HAIR_STYLE_NAMES, func(i): hair_idx = i; avatar_display.queue_redraw()))
	right_vbox.add_child(_sec("HAIR COLOR"))
	right_vbox.add_child(_picker(HAIR_COLOR_NAMES, func(i): hair_color_idx = i; avatar_display.queue_redraw()))
	right_vbox.add_child(_sec("SKIN TONE"))
	right_vbox.add_child(_picker(SKIN_COLOR_NAMES, func(i): skin_idx = i; avatar_display.queue_redraw()))
	right_vbox.add_child(_sec("OUTFIT COLOR"))
	right_vbox.add_child(_picker(OUTFIT_COLOR_NAMES, func(i): outfit_idx = i; avatar_display.queue_redraw()))

	right_vbox.add_child(HSeparator.new())

	var confirm_btn = Button.new()
	confirm_btn.text = "START TEACHING!"
	confirm_btn.add_theme_font_size_override("font_size", 20)
	confirm_btn.add_theme_color_override("font_color", C_GOLD)
	confirm_btn.add_theme_color_override("font_color", Color(1.0, 0.85, 0.20))
	confirm_btn.pressed.connect(_on_confirm)
	right_vbox.add_child(confirm_btn)

func _outlined_label(text: String, color: Color, size: int) -> Label:
	var l = Label.new()
	l.text = text
	var ls = LabelSettings.new()
	ls.font_color = color
	ls.font_size = size
	ls.outline_color = Color(0, 0, 0, 1)
	ls.outline_size = 4
	ls.shadow_color = Color(0, 0, 0, 0.7)
	ls.shadow_size = 2
	ls.shadow_offset = Vector2(2, 2)
	l.label_settings = ls
	return l

func _sec(text: String) -> Label:
	return _outlined_label(text, C_DARK, 13)

func _picker(names: Array, cb: Callable) -> HBoxContainer:
	var row = HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	for i in range(names.size()):
		var btn = Button.new()
		btn.text = names[i]
		btn.add_theme_font_size_override("font_size", 12)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.add_theme_color_override("font_color", Color(0.30, 1.00, 0.50))
		btn.pressed.connect(func(): cb.call(i))
		row.add_child(btn)
	return row

func _draw_avatar() -> void:
	var c: CanvasItem = avatar_display
	var cx = 80
	var skin = SKIN_COLORS[skin_idx]
	var hair = HAIR_COLORS[hair_color_idx]
	var outfit = OUTFIT_COLORS[outfit_idx]
	var dark = outfit.darkened(0.3)
	var px = 8

	var P = func(x, y, w, h, col):
		c.draw_rect(Rect2(cx + x * px, y * px, w * px, h * px), col)

	P.call(-2,14,4,4,outfit); P.call(-3,18,2,5,dark); P.call(1,18,2,5,dark)
	P.call(-4,14,2,3,outfit); P.call(2,14,2,3,outfit)
	P.call(-4,17,2,2,skin);   P.call(2,17,2,2,skin)
	P.call(-1,10,2,3,skin);   P.call(-3,5,6,6,skin)
	P.call(-2,7,1,1,Color(0.1,0.1,0.15)); P.call(1,7,1,1,Color(0.1,0.1,0.15))
	P.call(-1,9,2,1,Color(0.7,0.3,0.3))
	match hair_idx:
		0: P.call(-3,4,6,2,hair); P.call(-3,3,1,2,hair); P.call(2,3,1,2,hair)
		1: P.call(-3,3,6,3,hair); P.call(-3,5,1,7,hair); P.call(2,5,1,7,hair)
		2: P.call(-3,3,6,3,hair); P.call(-4,4,2,2,hair); P.call(2,4,2,2,hair); P.call(-2,2,1,2,hair); P.call(1,2,1,2,hair)
		3: P.call(-3,4,6,2,hair); P.call(-2,2,1,3,hair); P.call(0,1,1,4,hair); P.call(2,2,1,3,hair)
		4: P.call(-3,4,6,2,hair); P.call(-1,2,2,3,hair); P.call(-2,1,4,2,hair)
	P.call(-1,13,2,1,Color(1,1,1,0.4))
	P.call(-3,23,2,1,Color(0.2,0.2,0.2)); P.call(1,23,2,1,Color(0.2,0.2,0.2))

func _on_confirm() -> void:
	GameManager.avatar_hair = hair_idx
	GameManager.avatar_hair_color = hair_color_idx
	GameManager.avatar_skin = skin_idx
	GameManager.avatar_outfit = outfit_idx
	get_tree().change_scene_to_file("res://scenes/gameplay.tscn")
