extends Control

var day_label: Label
var class_label: Label
var stress_bar: ProgressBar
var stress_val_label: Label
var score_label: Label
var diff_label: Label
var classroom_scroll: ScrollContainer
var classroom_area: Control
var info_title: Label
var info_body: RichTextLabel
var choice_container: VBoxContainer
var sleep_btn: Button
var action_log: RichTextLabel
var popup_panel: PanelContainer
var popup_title: Label
var popup_body: RichTextLabel
var popup_ok: Button

var students: Array = []
var current_class_idx: int = 0
var selected_student_idx: int = -1
var day_start_score: int = 0
var day_start_stress: int = 0
var waiting: bool = false
var events_handled: int = 0
var events_target: int = 0
var principal_appeared: bool = false
var teacher_pos: Vector2 = Vector2(60, 30)

const GRID_COLS: int = 4
const DESK_W: float = 140.0
const DESK_H: float = 110.0
const GAP_X: float = 40.0
const GAP_Y: float = 44.0
const ORIGIN_X: float = 40.0
const ORIGIN_Y: float = 100.0
const TEACHER_START: Vector2 = Vector2(70, 38)

# Light color palette
const C_BG        = Color(0.0, 0.0, 0.0, 1.0)
const C_HUD_BG    = Color(0.933, 0.928, 0.916, 1.0)
const C_PANEL_BG  = Color(0.956, 0.957, 0.954, 1.0)
const C_BOARD     = Color(0.22, 0.52, 0.28)
const C_CHALK     = Color(0.96, 1.00, 0.90)
const C_DESK_BG   = Color(0.98, 1.00, 0.94)
const C_TEXT_DARK = Color(0.10, 0.20, 0.10)
const C_GOLD      = Color(0.70, 0.55, 0.02)
const C_GREEN_D   = Color(0.10, 0.55, 0.22)
const C_GREEN_L   = Color(0.25, 0.78, 0.40)
const C_LIME      = Color(0.45, 0.72, 0.05)
const C_YELLOW    = Color(0.75, 0.65, 0.00)
const C_RED       = Color(0.78, 0.10, 0.10)
const C_ORANGE    = Color(0.80, 0.42, 0.02)
const C_HANDLED   = Color(0.716, 0.425, 0.0, 1.0)

const PERSONALITY_COLORS: Dictionary = {
	"troublemaker": Color(0.85, 0.18, 0.18),
	"lazy":         Color(0.25, 0.35, 0.82),
	"anxious":      Color(0.72, 0.58, 0.02),
	"focused":      Color(0.12, 0.62, 0.28),
}
const PERSONALITY_ICONS: Dictionary = {
	"troublemaker": "!",
	"lazy":         "z",
	"anxious":      "?",
	"focused":      "*",
}

func _ready() -> void:
	_build_ui()
	_start_day()

func _build_ui() -> void:
	var bg = ColorRect.new()
	bg.color = C_BG
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var canvas = CanvasLayer.new()
	add_child(canvas)

	var root_vbox = VBoxContainer.new()
	root_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	root_vbox.offset_left = 8
	root_vbox.offset_top = 8
	root_vbox.offset_right = -8
	root_vbox.offset_bottom = -8
	root_vbox.add_theme_constant_override("separation", 6)
	canvas.add_child(root_vbox)

	# HUD bar
	var hud = PanelContainer.new()
	root_vbox.add_child(hud)

	var hud_hbox = HBoxContainer.new()
	hud_hbox.add_theme_constant_override("separation", 14)
	hud.add_child(hud_hbox)

	day_label = _lbl("Day 1/5", C_GOLD, 17)
	hud_hbox.add_child(day_label)

	class_label = _lbl("Period 1", C_GREEN_D, 17)
	hud_hbox.add_child(class_label)

	diff_label = _lbl("Normal", C_ORANGE, 14)
	hud_hbox.add_child(diff_label)

	var sp = Control.new()
	sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hud_hbox.add_child(sp)

	hud_hbox.add_child(_lbl("STRESS:", C_RED, 14))

	stress_bar = ProgressBar.new()
	stress_bar.custom_minimum_size = Vector2(140, 20)
	stress_bar.max_value = 100
	stress_bar.value = 0
	stress_bar.show_percentage = false
	hud_hbox.add_child(stress_bar)

	stress_val_label = _lbl("0/100", C_RED, 13)
	hud_hbox.add_child(stress_val_label)

	score_label = _lbl("Score: 0", C_GREEN_D, 16)
	hud_hbox.add_child(score_label)

	# Main row: classroom + right panel
	var main_hbox = HBoxContainer.new()
	main_hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_hbox.add_theme_constant_override("separation", 8)
	root_vbox.add_child(main_hbox)

	# Classroom scroll area
	classroom_scroll = ScrollContainer.new()
	classroom_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	classroom_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_hbox.add_child(classroom_scroll)

	classroom_area = Control.new()
	classroom_area.mouse_filter = Control.MOUSE_FILTER_STOP
	classroom_area.draw.connect(_draw_classroom)
	classroom_area.gui_input.connect(_on_classroom_input)
	classroom_scroll.add_child(classroom_area)

	# Right panel
	var right_vbox = VBoxContainer.new()
	right_vbox.custom_minimum_size = Vector2(300, 0)
	right_vbox.add_theme_constant_override("separation", 8)
	main_hbox.add_child(right_vbox)

	var info_panel = PanelContainer.new()
	info_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_vbox.add_child(info_panel)

	var info_inner = VBoxContainer.new()
	info_inner.add_theme_constant_override("separation", 8)
	info_panel.add_child(info_inner)

	info_title = _lbl("CLASSROOM", C_GOLD, 16)
	info_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info_inner.add_child(info_title)

	info_body = RichTextLabel.new()
	info_body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	info_body.bbcode_enabled = true
	info_body.text = (
		"[color=#1a5522]Click a student desk to walk over and handle the situation.\n\n"
		+ "[b]LEGEND:[/b]\n"
		+ "[color=#cc2222]RED[/color] = Troublemaker\n"
		+ "[color=#3344cc]BLUE[/color] = Lazy\n"
		+ "[color=#aa8800]YELLOW[/color] = Anxious\n"
		+ "[color=#118833]GREEN[/color] = Focused\n"
		+ "[color=#aabbaa]GREY[/color] = Handled[/color]"
	)
	info_inner.add_child(info_body)

	info_inner.add_child(HSeparator.new())

	choice_container = VBoxContainer.new()
	choice_container.add_theme_constant_override("separation", 6)
	info_inner.add_child(choice_container)

	sleep_btn = Button.new()
	sleep_btn.text = "Take a Break (-" + str(GameManager.SLEEP_STRESS_REDUCE) + " stress, once/day)"
	sleep_btn.add_theme_color_override("font_color", C_GREEN_D)
	sleep_btn.pressed.connect(_on_sleep_pressed)
	right_vbox.add_child(sleep_btn)

	# Action log
	action_log = RichTextLabel.new()
	action_log.custom_minimum_size = Vector2(0, 65)
	action_log.bbcode_enabled = true
	action_log.text = "[color=#225533]Welcome! Click a colored desk to interact with that student.[/color]"
	root_vbox.add_child(action_log)

	# Popup
	popup_panel = PanelContainer.new()
	popup_panel.set_anchors_preset(Control.PRESET_CENTER)
	popup_panel.custom_minimum_size = Vector2(580, 0)
	popup_panel.visible = false
	canvas.add_child(popup_panel)

	var pvbox = VBoxContainer.new()
	pvbox.add_theme_constant_override("separation", 14)
	popup_panel.add_child(pvbox)

	popup_title = _lbl("", C_GOLD, 24)
	popup_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pvbox.add_child(popup_title)

	popup_body = RichTextLabel.new()
	popup_body.custom_minimum_size = Vector2(0, 150)
	popup_body.bbcode_enabled = true
	popup_body.fit_content = true
	pvbox.add_child(popup_body)

	popup_ok = Button.new()
	popup_ok.add_theme_font_size_override("font_size", 17)
	popup_ok.add_theme_color_override("font_color", C_GOLD)
	popup_ok.pressed.connect(_on_popup_ok)
	pvbox.add_child(popup_ok)

func _lbl(text: String, color: Color, size: int) -> Label:
	var l = Label.new()
	l.text = text
	l.add_theme_color_override("font_color", color)
	l.add_theme_font_size_override("font_size", size)
	return l

func _get_desk_rect(s: Dictionary) -> Rect2:
	var x = ORIGIN_X + s["grid_col"] * (DESK_W + GAP_X)
	var y = ORIGIN_Y + s["grid_row"] * (DESK_H + GAP_Y)
	return Rect2(x, y, DESK_W, DESK_H)

func _classroom_size() -> Vector2:
	var rows = 0
	var cols = 0
	for s in students:
		if s["grid_col"] > cols: cols = s["grid_col"]
		if s["grid_row"] > rows: rows = s["grid_row"]
	var w = ORIGIN_X + (cols + 1) * (DESK_W + GAP_X) + 30
	var h = ORIGIN_Y + (rows + 1) * (DESK_H + GAP_Y) + 30
	return Vector2(max(w, 600), max(h, 400))

func _start_day() -> void:
	day_start_score = GameManager.score
	day_start_stress = GameManager.stress
	current_class_idx = 0
	principal_appeared = false
	_start_class()

func _start_class() -> void:
	if current_class_idx >= GameManager.schedule.size():
		_show_day_summary()
		return
	var count = GameManager.get_student_count()
	students = EventSystem.generate_classroom_students(count)
	events_handled = 0
	events_target = count
	selected_student_idx = -1
	teacher_pos = TEACHER_START
	_clear_choices()
	_update_hud()
	_resize_classroom()
	_refresh()
	_set_info(
		GameManager.schedule[current_class_idx].to_upper(),
		"[color=#1a5522][b]" + str(count) + " students[/b] today.\n\nClick any colored desk to walk over and handle the situation.\n\n[color=#886600]Difficulty: " + GameManager.DIFF_LABELS[GameManager.difficulty] + "[/color][/color]"
	)
	_log("[color=#227733]-- " + GameManager.schedule[current_class_idx] + " begins | " + str(count) + " students --[/color]")

	if not principal_appeared and randf() < 0.25:
		principal_appeared = true
		await get_tree().create_timer(1.2).timeout
		_trigger_principal()

func _resize_classroom() -> void:
	var sz = _classroom_size()
	classroom_area.custom_minimum_size = sz
	classroom_area.size = sz

func _on_classroom_input(event: InputEvent) -> void:
	if waiting or popup_panel.visible:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		for i in range(students.size()):
			if students[i]["handled"]:
				continue
			if _get_desk_rect(students[i]).has_point(event.position):
				_walk_to_student(i)
				return

func _walk_to_student(idx: int) -> void:
	selected_student_idx = idx
	var r = _get_desk_rect(students[idx])
	teacher_pos = Vector2(r.position.x + DESK_W * 0.5 - 14, r.position.y - 28)
	_refresh()
	var s = students[idx]
	var ev = EventSystem.get_event_for_student(s)
	_set_info(
		"STUDENT: " + s["name"].to_upper(),
		"[color=#553300][b]Type: [/b][color=" + _pcol(s["personality"]) + "]" + s["personality"].capitalize() + "[/color][/color]\n\n[color=#111111]" + ev["text"] + "[/color]"
	)
	_build_student_choices(s["personality"])
	_log("[color=" + _pcol(s["personality"]) + "]" + s["name"] + " needs attention.[/color]")

func _pcol(p: String) -> String:
	match p:
		"troublemaker": return "#cc1111"
		"lazy": return "#3344bb"
		"anxious": return "#aa8800"
		"focused": return "#117733"
	return "#333333"

func _build_student_choices(personality: String) -> void:
	_clear_choices()
	var choices = EventSystem.get_choices_for_personality(personality)
	for choice in choices:
		var btn = Button.new()
		btn.text = choice["label"]
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.add_theme_color_override("font_color", C_GREEN_D)
		btn.pressed.connect(_on_student_choice.bind(choice["key"]))
		choice_container.add_child(btn)
	sleep_btn.visible = not GameManager.sleep_used_today

func _on_student_choice(key: String) -> void:
	if waiting or selected_student_idx < 0:
		return
	waiting = true
	_clear_choices()
	sleep_btn.visible = false

	var outcome = EventSystem.get_student_outcome(key)
	GameManager.apply_stress(outcome["stress_delta"])
	GameManager.apply_score(outcome["score_delta"])

	var hint = ""
	if outcome["stress_delta"] > 0:
		hint = " [color=#cc3300](+%d stress)[/color]" % outcome["stress_delta"]
	elif outcome["stress_delta"] < 0:
		hint = " [color=#228833](%d stress)[/color]" % outcome["stress_delta"]

	_log("[color=#225533]-> " + outcome["message"] + "[/color]" + hint)
	_update_hud()

	students[selected_student_idx]["handled"] = true
	events_handled += 1
	selected_student_idx = -1
	teacher_pos = TEACHER_START
	_refresh()

	if GameManager.is_burnt_out():
		waiting = false
		_trigger_burnout()
		return

	var roll = randi() % 5
	if roll == 0 and events_handled < events_target:
		await get_tree().create_timer(0.5).timeout
		waiting = false
		_trigger_curveball()
		return
	elif roll == 1 and events_handled < events_target:
		await get_tree().create_timer(0.5).timeout
		waiting = false
		_trigger_player_question()
		return

	await get_tree().create_timer(0.4).timeout
	waiting = false

	if events_handled >= events_target:
		_set_info("ALL HANDLED!", "[color=#117733][b]Great work![/b] Time to grade papers.[/color]")
		await get_tree().create_timer(0.7).timeout
		_show_grading()
	else:
		_set_info("KEEP GOING", "[color=#225533]" + str(events_target - events_handled) + " student(s) still need attention.[/color]")

func _on_sleep_pressed() -> void:
	GameManager.sleep_used_today = true
	sleep_btn.visible = false
	GameManager.apply_stress(-GameManager.SLEEP_STRESS_REDUCE)
	_log("[color=#338844]You step out briefly. Stress -" + str(GameManager.SLEEP_STRESS_REDUCE) + ".[/color]")
	_update_hud()

func _trigger_curveball() -> void:
	var cb = EventSystem.get_random_curveball()
	_set_info("SURPRISE EVENT!", "[color=#885500][b]Unexpected interruption![/b][/color]\n\n[color=#111111]" + cb["text"] + "[/color]")
	_clear_choices()
	for ch in cb["choices"]:
		var btn = Button.new()
		btn.text = ch["label"]
		btn.add_theme_color_override("font_color", C_YELLOW)
		btn.pressed.connect(_on_curveball_choice.bind(ch["key"]))
		choice_container.add_child(btn)
	_log("[color=#886600]A surprise event interrupts class![/color]")

func _on_curveball_choice(key: String) -> void:
	if waiting: return
	waiting = true
	_clear_choices()
	var out = EventSystem.get_curveball_outcome(key)
	GameManager.apply_stress(out["stress_delta"])
	GameManager.apply_score(out["score_delta"])
	_log("[color=#554400]-> " + out["message"] + "[/color]")
	_update_hud()
	if GameManager.is_burnt_out():
		waiting = false
		_trigger_burnout()
		return
	await get_tree().create_timer(0.7).timeout
	waiting = false
	if events_handled >= events_target:
		_show_grading()
	else:
		_set_info("BACK TO CLASS", "[color=#225533]" + str(events_target - events_handled) + " student(s) still need attention.[/color]")

func _trigger_player_question() -> void:
	var q = EventSystem.get_random_player_question()
	_set_info("STUDENT QUESTION!", "[color=#886600][b]A student puts you on the spot![/b][/color]\n\n[color=#111111]" + q["text"] + "[/color]\n\n[color=#225577]Answer correctly for bonus points![/color]")
	_clear_choices()
	for opt in q["options"]:
		var btn = Button.new()
		btn.text = opt["label"]
		btn.add_theme_color_override("font_color", C_GREEN_D)
		btn.pressed.connect(_on_player_question.bind(opt["correct"], q["fact"]))
		choice_container.add_child(btn)
	_log("[color=#886600]A student asks a tough question![/color]")

func _on_player_question(is_correct: bool, fact: String) -> void:
	if waiting: return
	waiting = true
	_clear_choices()
	if is_correct:
		GameManager.apply_score(25)
		GameManager.apply_stress(-5)
		_log("[color=#117733]Correct! The class is impressed. +25 pts.[/color]")
		_set_info("CORRECT!", "[color=#117733][b]Well done![/b][/color]\n\n[color=#224422]" + fact + "[/color]")
	else:
		GameManager.apply_stress(8)
		GameManager.apply_score(-10)
		_log("[color=#cc3300]Wrong answer... a few students snicker. +8 stress.[/color]")
		_set_info("INCORRECT!", "[color=#cc3300][b]Oh no...[/b][/color]\n\n[color=#224422]" + fact + "[/color]")
	_update_hud()
	await get_tree().create_timer(1.5).timeout
	waiting = false
	if events_handled >= events_target:
		_show_grading()
	else:
		_set_info("BACK TO CLASS", "[color=#225533]" + str(events_target - events_handled) + " still need attention.[/color]")

func _trigger_principal() -> void:
	var pe = EventSystem.get_random_principal_event()
	_set_info("PRINCIPAL VISIT!", "[color=#664400][b]Principal Chen has arrived![/b][/color]\n\n[color=#111111]" + pe["text"] + "[/color]")
	_clear_choices()
	for ch in pe["choices"]:
		var btn = Button.new()
		btn.text = ch["label"]
		btn.add_theme_color_override("font_color", C_GOLD)
		btn.pressed.connect(_on_principal_choice.bind(ch["key"]))
		choice_container.add_child(btn)
	_log("[color=#886600]Principal Chen steps into the room![/color]")

func _on_principal_choice(key: String) -> void:
	if waiting: return
	waiting = true
	_clear_choices()
	var out = EventSystem.get_principal_outcome(key)
	GameManager.apply_stress(out["stress_delta"])
	GameManager.apply_score(out["score_delta"])
	_log("[color=#554400]-> " + out["message"] + "[/color]")
	_update_hud()
	if GameManager.is_burnt_out():
		waiting = false
		_trigger_burnout()
		return
	await get_tree().create_timer(0.7).timeout
	waiting = false
	_set_info("BACK TO CLASS", "[color=#225533]" + str(events_target - events_handled) + " student(s) still need attention.[/color]")

func _show_grading() -> void:
	var prompt = EventSystem.get_grading_prompt()
	_set_info(
		"GRADING: " + prompt["subject"].to_upper(),
		"[color=#664400][b]Mark this answer:[/b][/color]\n\n[color=#111111]" + prompt["question"] + "[/color]\n\n[color=#225544][i]Did you know? " + prompt["fact"] + "[/i][/color]"
	)
	_clear_choices()
	var cb = Button.new()
	cb.text = "Mark CORRECT"
	cb.add_theme_color_override("font_color", C_GREEN_D)
	cb.pressed.connect(_on_grade.bind(true, prompt["correct"], prompt["fact"]))
	choice_container.add_child(cb)

	var wb = Button.new()
	wb.text = "Mark INCORRECT"
	wb.add_theme_color_override("font_color", C_RED)
	wb.pressed.connect(_on_grade.bind(false, prompt["correct"], prompt["fact"]))
	choice_container.add_child(wb)
	_log("[color=#886600]Time to grade papers![/color]")

func _on_grade(says_correct: bool, actually_correct: bool, fact: String) -> void:
	if waiting: return
	waiting = true
	_clear_choices()
	if says_correct == actually_correct:
		GameManager.apply_score(20)
		_log("[color=#117733]Correct grading! +20 pts.[/color]")
		_set_info("GOOD CALL", "[color=#117733]Correct marking![/color]\n\n[color=#224433]" + fact + "[/color]")
	else:
		GameManager.apply_score(-20)
		GameManager.apply_stress(10)
		_log("[color=#cc2200]Wrong call! -20 pts, +10 stress.[/color]")
		_set_info("WRONG CALL", "[color=#cc2200]Incorrect marking.[/color]\n\n[color=#224433]" + fact + "[/color]")
	_update_hud()
	if GameManager.is_burnt_out():
		waiting = false
		_trigger_burnout()
		return
	await get_tree().create_timer(1.5).timeout
	waiting = false
	GameManager.class_completed.emit(GameManager.schedule[current_class_idx])
	current_class_idx += 1
	_start_class()

func _show_day_summary() -> void:
	var pts = GameManager.score - day_start_score
	var sc = GameManager.stress - day_start_stress
	var pts_txt = "+%d" % pts if pts >= 0 else "%d" % pts
	var sc_txt = "+%d" % sc if sc >= 0 else "%d" % sc
	var pen = GameManager.DIFF_OVERNIGHT_PENALTY[GameManager.difficulty]
	var warn = ""
	if GameManager.stress >= 80:
		warn = "\n\n[color=#cc1100][b]WARNING: Close to burnout![/b][/color]"
	elif GameManager.stress >= 60:
		warn = "\n\n[color=#aa5500]Stress climbing. Be careful tomorrow.[/color]"
	popup_title.text = "END OF DAY " + str(GameManager.current_day)
	popup_body.text = (
		"[center][color=#224422]All classes complete!\n\n"
		+ "[color=#665500]Points today: " + pts_txt + "[/color]\n"
		+ "[color=#882222]Stress change: " + sc_txt + "[/color]\n"
		+ "[color=#774400]Overnight penalty: +" + str(pen) + " stress[/color]\n\n"
		+ "[b][color=#116633]Score: " + str(GameManager.score) + "[/color]  |  "
		+ "[color=#882233]Stress: " + str(GameManager.stress) + "/100[/color][/b]"
		+ warn + "[/color][/center]"
	)
	popup_ok.text = "Next Day" if GameManager.current_day < GameManager.MAX_DAY else "See Results"
	GameManager.day_completed.emit(GameManager.current_day, pts, sc)
	_clear_choices()
	popup_panel.visible = true

func _on_popup_ok() -> void:
	popup_panel.visible = false
	if GameManager.current_day >= GameManager.MAX_DAY:
		get_tree().change_scene_to_file("res://scenes/end_screen.tscn")
	else:
		GameManager.advance_day()
		_start_day()

func _trigger_burnout() -> void:
	popup_title.text = "BURNOUT!"
	popup_body.text = "[center][color=#cc1100][b]STRESS REACHED 100![/b][/color]\n\nYou put your head down and cannot continue.\n\n[b]Final Score: " + str(GameManager.score) + "[/b][/center]"
	popup_ok.text = "See Results"
	_clear_choices()
	popup_panel.visible = true

func _update_hud() -> void:
	day_label.text = "Day " + str(GameManager.current_day) + "/" + str(GameManager.MAX_DAY)
	var cls = GameManager.schedule[current_class_idx] if current_class_idx < GameManager.schedule.size() else "-"
	class_label.text = cls
	diff_label.text = GameManager.DIFF_LABELS[GameManager.difficulty]
	stress_bar.value = GameManager.stress
	stress_val_label.text = str(GameManager.stress) + "/100"
	score_label.text = "Score: " + str(GameManager.score)
	if GameManager.stress >= 75:
		stress_bar.modulate = Color(0.85, 0.15, 0.15)
		stress_val_label.add_theme_color_override("font_color", C_RED)
	elif GameManager.stress >= 50:
		stress_bar.modulate = Color(0.85, 0.50, 0.05)
		stress_val_label.add_theme_color_override("font_color", C_ORANGE)
	else:
		stress_bar.modulate = Color(0.20, 0.70, 0.30)
		stress_val_label.add_theme_color_override("font_color", C_GREEN_D)
	sleep_btn.visible = not GameManager.sleep_used_today

func _set_info(title: String, body: String) -> void:
	info_title.text = title
	info_body.text = body

func _log(msg: String) -> void:
	action_log.text += "\n" + msg

func _clear_choices() -> void:
	for c in choice_container.get_children():
		c.queue_free()

func _refresh() -> void:
	classroom_area.queue_redraw()

func _draw_classroom() -> void:
	var c: CanvasItem = classroom_area

	# Classroom floor
	c.draw_rect(Rect2(0, 0, classroom_area.size.x, classroom_area.size.y), Color(0.95, 0.97, 0.91))

	# Chalkboard at top
	c.draw_rect(Rect2(10, 6, classroom_area.size.x - 20, 56), C_BOARD)
	c.draw_rect(Rect2(10, 6, classroom_area.size.x - 20, 56), C_BOARD.darkened(0.3), false, 2.0)
	var cls_txt = GameManager.schedule[current_class_idx] if current_class_idx < GameManager.schedule.size() else "-"
	c.draw_string(ThemeDB.fallback_font, Vector2(24, 44), cls_txt + "  |  Teacher: " + GameManager.teacher_name, HORIZONTAL_ALIGNMENT_LEFT, -1, 24, C_CHALK)

	# Teacher desk top-right area
	var td_x = classroom_area.size.x - 130
	c.draw_rect(Rect2(td_x, 10, 110, 50), Color(0.88, 0.78, 0.55))
	c.draw_rect(Rect2(td_x, 10, 110, 50), Color(0.65, 0.50, 0.25), false, 2.0)
	c.draw_string(ThemeDB.fallback_font, Vector2(td_x + 12, 42), "TEACHER DESK", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color(0.3, 0.2, 0.05))

	# Teacher sprite
	_draw_teacher(c, teacher_pos)

	# Student desks
	for i in range(students.size()):
		var s = students[i]
		var r = _get_desk_rect(s)
		var col = PERSONALITY_COLORS.get(s["personality"], Color(0.4, 0.4, 0.4))

		# Brown wood base for all desks
		var desk_brown = Color(0.62, 0.38, 0.14) if not s["handled"] else Color(0.55, 0.45, 0.32)
		var desk_brown_dark = Color(0.42, 0.24, 0.06)
		c.draw_rect(r, desk_brown)
		# Wood grain lines
		c.draw_line(Vector2(r.position.x + 8, r.position.y + 4), Vector2(r.position.x + 8, r.position.y + r.size.y - 4), Color(0.52, 0.30, 0.10, 0.4), 1.5)
		c.draw_line(Vector2(r.position.x + r.size.x - 8, r.position.y + 4), Vector2(r.position.x + r.size.x - 8, r.position.y + r.size.y - 4), Color(0.52, 0.30, 0.10, 0.4), 1.5)

		if s["handled"]:
			# Faded handled state, thinner grey border
			c.draw_rect(r, Color(0.30, 0.20, 0.08, 0.55))
			c.draw_rect(r, Color(0.40, 0.32, 0.20), false, 2.0)
			c.draw_string(ThemeDB.fallback_font, Vector2(r.position.x + r.size.x * 0.5 - 8, r.position.y + r.size.y * 0.5 + 8), "v", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color(0.90, 0.95, 0.85))
		else:
			# Colored personality border
			var bw = 4.5 if i == selected_student_idx else 3.0
			c.draw_rect(r, col, false, bw)
			# Personality icon (white outline trick: draw slightly offset in black first)
			var icon = PERSONALITY_ICONS.get(s["personality"], "?")
			var icon_x = r.position.x + r.size.x * 0.5 - 8
			var icon_y = r.position.y + r.size.y * 0.5 + 10
			for ox in [-1, 0, 1]:
				for oy in [-1, 0, 1]:
					if ox != 0 or oy != 0:
						c.draw_string(ThemeDB.fallback_font, Vector2(icon_x + ox, icon_y + oy), icon, HORIZONTAL_ALIGNMENT_LEFT, -1, 26, Color(0, 0, 0, 0.6))
			c.draw_string(ThemeDB.fallback_font, Vector2(icon_x, icon_y), icon, HORIZONTAL_ALIGNMENT_LEFT, -1, 26, col)

		# Student name - always black with shadow for readability on brown
		var nm = s["name"]
		if nm.length() > 8:
			nm = nm.substr(0, 7) + "."
		var name_x = r.position.x + 6
		var name_y = r.position.y + 18
		# Shadow
		c.draw_string(ThemeDB.fallback_font, Vector2(name_x + 1, name_y + 1), nm, HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color(0, 0, 0, 0.5))
		# Black name
		c.draw_string(ThemeDB.fallback_font, Vector2(name_x, name_y), nm, HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color(0.0, 0.0, 0.0))

func _draw_teacher(c: CanvasItem, pos: Vector2) -> void:
	var skin  = [Color(1.0,0.88,0.76),Color(0.95,0.76,0.57),Color(0.87,0.65,0.43),Color(0.65,0.42,0.24),Color(0.35,0.22,0.12)][GameManager.avatar_skin]
	var hair  = [Color(0.1,0.08,0.05),Color(0.45,0.25,0.1),Color(0.95,0.85,0.3),Color(0.8,0.2,0.1),Color(0.2,0.4,0.9),Color(0.95,0.95,0.95)][GameManager.avatar_hair_color]
	var outfit= [Color(0.2,0.4,0.9),Color(0.9,0.2,0.2),Color(0.2,0.75,0.35),Color(0.6,0.2,0.9),Color(0.95,0.55,0.1),Color(0.9,0.35,0.65)][GameManager.avatar_outfit]
	var px = 5
	c.draw_rect(Rect2(pos.x - px*2, pos.y + px*2, px*4, px*4), outfit)
	c.draw_rect(Rect2(pos.x - px*2, pos.y - px*3, px*4, px*4), skin)
	c.draw_rect(Rect2(pos.x - px*2, pos.y - px*4, px*4, px*2), hair)
	c.draw_rect(Rect2(pos.x - px,   pos.y - px*2, px,   px),   Color(0.15,0.10,0.05))
	c.draw_rect(Rect2(pos.x + 2,    pos.y - px*2, px,   px),   Color(0.15,0.10,0.05))
