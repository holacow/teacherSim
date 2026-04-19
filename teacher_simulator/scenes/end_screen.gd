extends Control

func _ready() -> void:
	var bg = ColorRect.new()
	bg.color = Color(0.94, 0.98, 0.90)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(580, 0)
	center.add_child(panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 18)
	panel.add_child(vbox)

	var title_label = Label.new()
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 38)
	vbox.add_child(title_label)

	var ending_label = Label.new()
	ending_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ending_label.add_theme_font_size_override("font_size", 19)
	ending_label.add_theme_color_override("font_color", Color(0.15, 0.30, 0.15))
	vbox.add_child(ending_label)

	vbox.add_child(HSeparator.new())

	var stats = HBoxContainer.new()
	stats.alignment = BoxContainer.ALIGNMENT_CENTER
	stats.add_theme_constant_override("separation", 40)
	vbox.add_child(stats)

	var sc_lbl = Label.new()
	sc_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sc_lbl.add_theme_font_size_override("font_size", 26)
	sc_lbl.add_theme_color_override("font_color", Color(0.10, 0.50, 0.22))
	sc_lbl.text = "SCORE\n" + str(GameManager.score)
	stats.add_child(sc_lbl)

	var st_lbl = Label.new()
	st_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	st_lbl.add_theme_font_size_override("font_size", 26)
	st_lbl.add_theme_color_override("font_color", Color(0.75, 0.10, 0.10))
	st_lbl.text = "STRESS\n" + str(GameManager.stress) + "/100"
	stats.add_child(st_lbl)

	var df_lbl = Label.new()
	df_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	df_lbl.add_theme_font_size_override("font_size", 26)
	df_lbl.add_theme_color_override("font_color", Color(0.60, 0.44, 0.01))
	df_lbl.text = "DIFFICULTY\n" + GameManager.DIFF_LABELS[GameManager.difficulty]
	stats.add_child(df_lbl)

	vbox.add_child(HSeparator.new())

	var flavor = RichTextLabel.new()
	flavor.custom_minimum_size = Vector2(0, 100)
	flavor.bbcode_enabled = true
	flavor.fit_content = true
	vbox.add_child(flavor)

	vbox.add_child(HSeparator.new())

	var restart_btn = Button.new()
	restart_btn.text = "PLAY AGAIN"
	restart_btn.add_theme_font_size_override("font_size", 17)
	restart_btn.add_theme_color_override("font_color", Color(0.10, 0.48, 0.20))
	restart_btn.pressed.connect(func():
		GameManager.reset()
		get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
	)
	vbox.add_child(restart_btn)

	var s = GameManager.stress
	var sc = GameManager.score

	if s >= 100:
		title_label.text = "BURNOUT ENDING"
		title_label.add_theme_color_override("font_color", Color(0.78, 0.10, 0.10))
		ending_label.text = "You collapsed before the week was over."
		flavor.text = "[center][color=#882222]The classroom is silent.\nThe substitute shows up on Tuesday.\nYou don't come back.[/color][/center]"
	elif s >= 80 and sc < 80:
		title_label.text = "SURVIVAL MODE"
		title_label.add_theme_color_override("font_color", Color(0.75, 0.38, 0.02))
		ending_label.text = "Technically you made it. But at what cost?"
		flavor.text = "[center][color=#885511]You stare at your parking spot for 20 minutes on Friday.\nYou forgot where you live.[/color][/center]"
	elif s < 30 and sc >= 200:
		title_label.text = "LEGEND OF EDUCATION"
		title_label.add_theme_color_override("font_color", Color(0.60, 0.44, 0.01))
		ending_label.text = "Students will tell their grandchildren about this week."
		flavor.text = "[center][color=#664400]A student names their dog after you.\nThe principal frames your lesson plan.\nYou are untouchable.[/color][/center]"
	elif s < 50 and sc >= 150:
		title_label.text = "TEACHER OF THE YEAR"
		title_label.add_theme_color_override("font_color", Color(0.10, 0.50, 0.22))
		ending_label.text = "An exceptional week from start to finish."
		flavor.text = "[center][color=#115522]Three students say you changed their life.\nFriday feels like a victory lap.[/color][/center]"
	elif s >= 60 and sc >= 100:
		title_label.text = "BATTLE-WORN TEACHER"
		title_label.add_theme_color_override("font_color", Color(0.38, 0.58, 0.10))
		ending_label.text = "Tough week, but you held it together."
		flavor.text = "[center][color=#445511]You got the job done.\nYour coffee intake was alarming.\nBut the kids learned something.[/color][/center]"
	elif sc >= 100:
		title_label.text = "SOLID WEEK"
		title_label.add_theme_color_override("font_color", Color(0.18, 0.55, 0.30))
		ending_label.text = "A tough but rewarding week."
		flavor.text = "[center][color=#225533]Not every lesson was perfect.\nBut you showed up for every student.[/color][/center]"
	else:
		title_label.text = "WEEK COMPLETE"
		title_label.add_theme_color_override("font_color", Color(0.40, 0.50, 0.38))
		ending_label.text = "Another week done."
		flavor.text = "[center][color=#445544]You survived.\nMaybe try again on a higher difficulty.[/color][/center]"
