extends Control

var teacher_name_input: LineEdit
var error_label: Label
var diff_desc_label: Label
var selected_diff: int = 1

const DIFF_NAMES: Array = ["Easy", "Normal", "Hard", "Nightmare"]
const DIFF_DESCS: Array = [
	"Easy: 10 students/class, +3 stress overnight - a gentle start",
	"Normal: 16 students/class, +8 stress overnight - standard challenge",
	"Hard: 22 students/class, +14 stress overnight - intense",
	"Nightmare: 30 students/class, +20 stress overnight - pure chaos"
]

const C_BG     = Color(0.575, 0.545, 0.529, 1.0)
const C_GOLD   = Color(0.60, 0.44, 0.01)
const C_GREEN  = Color(0.10, 0.50, 0.20)
const C_LIME   = Color(0.35, 0.62, 0.05)
const C_YELLOW = Color(0.62, 0.52, 0.00)
const C_DARK   = Color(0.10, 0.18, 0.10)

func _ready() -> void:
	var bg = ColorRect.new()
	bg.color = C_BG
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(520, 0)
	center.add_child(panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 16)
	panel.add_child(vbox)

	var title = Label.new()
	title.text = "TEACHER SIMULATOR"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 38)
	title.add_theme_color_override("font_color", C_GOLD)
	vbox.add_child(title)

	var sub = Label.new()
	sub.text = "Five days. Endless chaos. Can you survive?"
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub.add_theme_color_override("font_color", C_LIME)
	vbox.add_child(sub)

	vbox.add_child(HSeparator.new())

	var lbl = Label.new()
	lbl.text = "Your Name:"
	lbl.add_theme_color_override("font_color", C_DARK)
	lbl.add_theme_font_size_override("font_size", 16)
	vbox.add_child(lbl)

	teacher_name_input = LineEdit.new()
	teacher_name_input.placeholder_text = "e.g. Ms. Rivera"
	vbox.add_child(teacher_name_input)

	vbox.add_child(HSeparator.new())

	var diff_lbl = Label.new()
	diff_lbl.text = "Select Difficulty:"
	diff_lbl.add_theme_color_override("font_color", C_DARK)
	diff_lbl.add_theme_font_size_override("font_size", 16)
	vbox.add_child(diff_lbl)

	var diff_row = HBoxContainer.new()
	diff_row.add_theme_constant_override("separation", 10)
	vbox.add_child(diff_row)

	var diff_colors = [
		Color(0.10, 0.52, 0.22),
		Color(0.60, 0.48, 0.01),
		Color(0.75, 0.35, 0.02),
		Color(0.75, 0.08, 0.08)
	]
	for i in range(4):
		var btn = Button.new()
		btn.text = DIFF_NAMES[i]
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.add_theme_color_override("font_color", diff_colors[i])
		btn.add_theme_font_size_override("font_size", 15)
		btn.pressed.connect(_on_diff_selected.bind(i))
		diff_row.add_child(btn)

	diff_desc_label = Label.new()
	diff_desc_label.text = DIFF_DESCS[1]
	diff_desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	diff_desc_label.add_theme_color_override("font_color", C_GREEN)
	diff_desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(diff_desc_label)

	vbox.add_child(HSeparator.new())

	error_label = Label.new()
	error_label.text = ""
	error_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	error_label.add_theme_color_override("font_color", Color(0.78, 0.10, 0.10))
	vbox.add_child(error_label)

	var start_btn = Button.new()
	start_btn.text = "CREATE YOUR TEACHER"
	start_btn.add_theme_font_size_override("font_size", 20)
	start_btn.add_theme_color_override("font_color", C_GOLD)
	start_btn.pressed.connect(_on_start_pressed)
	vbox.add_child(start_btn)

func _on_diff_selected(idx: int) -> void:
	selected_diff = idx
	diff_desc_label.text = DIFF_DESCS[idx]

func _on_start_pressed() -> void:
	var t: String = teacher_name_input.text.strip_edges()
	if t.is_empty():
		error_label.text = "Please enter your name."
		return
	GameManager.teacher_name = t
	GameManager.difficulty = selected_diff
	GameManager.schedule = ["Period 1", "Period 2", "Period 3", "Period 4"]
	GameManager.reset()
	get_tree().change_scene_to_file("res://scenes/character_creator.tscn")
