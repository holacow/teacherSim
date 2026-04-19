# 🍎 Teacher Simulator — Godot 4

A UI-driven, choice-based RPG/visual-novel where you survive a 5-day week of teaching.  
No player movement. Pure decisions, consequences, and classroom chaos.

---

## 📁 Project Structure

```
teacher_simulator/
├── project.godot               ← Godot 4 project config (autoloads GameManager & EventSystem)
├── icon.svg
├── scenes/
│   ├── start_menu.tscn         ← Scene 1: Name + schedule setup
│   ├── gameplay.tscn           ← Scene 2: Main game loop
│   └── end_screen.tscn         ← Scene 3: Results
└── scripts/
	├── game_manager.gd         ← Autoload singleton: state, signals
	├── event_system.gd         ← Autoload singleton: events, choices, grading
	├── start_menu.gd
	├── gameplay.gd
	└── end_screen.gd
```

---

## 🚀 How to Run

1. **Install Godot 4.3+** from https://godotengine.org/download
2. Open Godot → **Import** → select the `teacher_simulator/` folder → open `project.godot`
3. Press **F5** (or the ▶ Play button) to run

> **Compatibility note:** The project uses the GL Compatibility renderer so it works on most hardware.

---

## 🎮 How to Play

### Start Menu
- Enter your teacher name
- Type class names one at a time and click **Add Class** (up to 5 classes)
- Press **Start Week** when your schedule is ready

### Gameplay Loop
Each day cycles through every class in your schedule.  
Each class generates **2–4 random student events**.

**Student Events:**  
A student with a personality (focused / lazy / troublemaker / anxious) is causing a situation.  
Pick a response from the buttons:

| Choice | Effect |
|--------|--------|
| Ignore | −5 score, +5 stress |
| Call Out | +10 score, −5 stress |
| Encourage | +15 score, −10 stress |
| Give Warning | +5 score, no stress change |
| Send to Hall | −10 score, −5 stress |
| Offer Help | +10 score, −5 stress |

*Available choices vary by student personality.*

**After each class — Grading:**  
Grade a student answer as Correct or Incorrect.  
- Right call → +20 points  
- Wrong call → −10 points, +5 stress

**Sleep Button:**  
Once per day you can take a break: −15 stress.

### Stress
- Ranges 0–100
- If it hits **100**, you burn out and the week ends early

### Day Summary
After all classes each day, a popup shows your points and stress changes.  
Day 5 ends the week and loads the results screen.

---

## 🏆 Endings

| Condition | Ending |
|-----------|--------|
| Stress ≥ 100 | 💀 Burnout Ending |
| Stress ≥ 70, Score < 100 | 😰 Barely Made It |
| Stress ≥ 40, Score ≥ 100 | 😊 Solid Week |
| Stress < 40, Score ≥ 150 | ⭐ Teacher of the Year! |
| Everything else | 📘 Week Complete |

---

## 🛠 Code Architecture

| File | Role |
|------|------|
| `game_manager.gd` | Autoloaded singleton. Holds all persistent state (score, stress, day, schedule). Emits `choice_selected`, `class_completed`, `day_completed` signals. |
| `event_system.gd` | Autoloaded singleton. Generates random student events, maps personality → choice set, holds all choice outcome data, supplies grading prompts. |
| `start_menu.gd` | Collects teacher name + class list, passes to GameManager, loads gameplay scene. |
| `gameplay.gd` | Drives the entire event→grading→summary loop. Manages UI, reads from both autoloads. |
| `end_screen.gd` | Reads final GameManager state, picks ending text, offers restart. |

---

## 🎨 Design Notes
- Dark blue-grey color palette — readable on all monitors
- Stress bar changes color: green → yellow → red
- RichTextLabel BBCode used for colored outcome messages
- No assets required — 100% Godot built-in UI nodes
