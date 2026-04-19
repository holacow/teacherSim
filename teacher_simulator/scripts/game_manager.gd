extends Node

signal choice_selected(choice_key: String, outcome: Dictionary)
signal class_completed(class_name_str: String)
signal day_completed(day: int, points_gained: int, stress_change: int)

var teacher_name: String = "Teacher"
var schedule: Array = ["Period 1", "Period 2", "Period 3", "Period 4"]
var current_day: int = 1
var score: int = 0
var stress: int = 0
var difficulty: int = 1
var sleep_used_today: bool = false

# Character creator data
var avatar_hair: int = 0
var avatar_hair_color: int = 0
var avatar_skin: int = 0
var avatar_outfit: int = 0

const MAX_DAY: int = 5
const MAX_STRESS: int = 100
const SLEEP_STRESS_REDUCE: int = 12

# Difficulty settings
const DIFF_LABELS: Array = ["Easy", "Normal", "Hard", "Nightmare"]
const DIFF_STUDENT_COUNT: Array = [10, 16, 22, 30]
const DIFF_STRESS_START: Array = [0, 10, 20, 35]
const DIFF_OVERNIGHT_PENALTY: Array = [3, 8, 14, 20]

func reset() -> void:
	current_day = 1
	score = 0
	stress = DIFF_STRESS_START[difficulty]
	sleep_used_today = false

# Stress scaling: the more stress you have, the more extra stress you gain
func apply_stress(delta: int) -> void:
	if delta > 0:
		var scale_bonus = int(stress / 25)
		delta += scale_bonus
	stress = clamp(stress + delta, 0, MAX_STRESS)

func apply_score(delta: int) -> void:
	score += delta
	if score < 0:
		score = 0

func is_burnt_out() -> bool:
	return stress >= MAX_STRESS

func advance_day() -> void:
	current_day += 1
	sleep_used_today = false
	var penalty = DIFF_OVERNIGHT_PENALTY[difficulty]
	stress = clamp(stress + penalty, 0, MAX_STRESS)

func get_student_count() -> int:
	var base = DIFF_STUDENT_COUNT[difficulty]
	return base + (current_day - 1)

func get_diff_label() -> String:
	return DIFF_LABELS[difficulty]
