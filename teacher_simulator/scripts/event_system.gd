extends Node

const STUDENT_NAMES: Array = [
	"Alex","Jordan","Taylor","Morgan","Riley","Casey","Drew","Avery","Jamie","Quinn",
	"Sam","Blake","Reese","Sage","Hayden","Devon","Rowan","Skylar","Peyton","Parker",
	"Logan","River","Emery","Finley","Harlow","Indigo","Juno","Kai","Luca","Milo",
	"Nova","Oakley","Piper","Quinn","Remy","Sable","Tatum","Uma","Vale","Wren"
]

# --- STUDENT EVENTS (lots of variety) ---
const STUDENT_EVENTS: Array = [
	# Troublemaker
	{"personality":"troublemaker","topic":"behavior","text":"{name} is making barnyard noises every time you turn your back."},
	{"personality":"troublemaker","topic":"behavior","text":"{name} has been flicking eraser bits at {name2} for the past ten minutes."},
	{"personality":"troublemaker","topic":"behavior","text":"{name} wrote something rude on the whiteboard while you were helping another student."},
	{"personality":"troublemaker","topic":"behavior","text":"{name} is playing music out loud from their pocket and pretending not to notice."},
	{"personality":"troublemaker","topic":"behavior","text":"{name} tipped their chair back and fell over loudly, disrupting everything."},
	{"personality":"troublemaker","topic":"behavior","text":"{name} is passing around a note and the whole back row is giggling."},
	{"personality":"troublemaker","topic":"behavior","text":"{name} stands up and announces they're 'done with school' and sits back down defiantly."},
	{"personality":"troublemaker","topic":"behavior","text":"{name} changed the name on their paper to 'Professor Cool' and dares you to grade it."},
	{"personality":"troublemaker","topic":"behavior","text":"{name} is mimicking your gestures behind your back. Half the class is laughing."},
	{"personality":"troublemaker","topic":"behavior","text":"{name} has built a fort out of textbooks and refuses to come out."},
	{"personality":"troublemaker","topic":"behavior","text":"{name} is making paper planes and launching them across the room mid-lesson."},
	{"personality":"troublemaker","topic":"behavior","text":"{name} loudly declares your explanation 'makes no sense' and crosses their arms."},
	# Lazy
	{"personality":"lazy","topic":"effort","text":"{name} submitted a test with just their name written and nothing else."},
	{"personality":"lazy","topic":"effort","text":"{name} has been staring at the ceiling for 15 minutes without touching their worksheet."},
	{"personality":"lazy","topic":"effort","text":"{name} asks if they can 'just watch' instead of participating today."},
	{"personality":"lazy","topic":"effort","text":"{name} is asleep sitting straight up. Their eyes are closed. They're still holding a pencil."},
	{"personality":"lazy","topic":"effort","text":"{name} has copied {name2}'s work word for word, including their name."},
	{"personality":"lazy","topic":"effort","text":"{name} whispers that they 'don't see the point' of this subject."},
	{"personality":"lazy","topic":"effort","text":"{name} finishes in 2 minutes and puts their head down. Their answers are all wrong."},
	{"personality":"lazy","topic":"effort","text":"{name} asks how many points they need to 'just barely pass'."},
	{"personality":"lazy","topic":"effort","text":"{name} is visibly doing homework from another class under the desk."},
	{"personality":"lazy","topic":"effort","text":"{name} has written the same sentence over and over to look busy."},
	# Anxious
	{"personality":"anxious","topic":"support","text":"{name} is crying quietly and says they studied all night but still don't understand."},
	{"personality":"anxious","topic":"support","text":"{name} hyperventilates and knocks their books off the desk. Everyone looks over."},
	{"personality":"anxious","topic":"support","text":"{name} asks if this will be on the test, then panics when you say yes."},
	{"personality":"anxious","topic":"support","text":"{name} erases so hard their paper tears. They look on the verge of giving up."},
	{"personality":"anxious","topic":"support","text":"{name} whispers they failed the last quiz and they're scared of getting held back."},
	{"personality":"anxious","topic":"support","text":"{name} freezes when you call on them and goes completely silent."},
	{"personality":"anxious","topic":"support","text":"{name} raises their hand then puts it down 6 times before asking a great question."},
	{"personality":"anxious","topic":"support","text":"{name} asks to go to the nurse. They seem genuinely overwhelmed."},
	# Focused
	{"personality":"focused","topic":"academic","text":"{name} finishes early and starts tutoring nearby students without being asked."},
	{"personality":"focused","topic":"academic","text":"{name} asks a question so advanced that you have to think before answering."},
	{"personality":"focused","topic":"academic","text":"{name} points out a mistake in the textbook and is 100% correct."},
	{"personality":"focused","topic":"academic","text":"{name} wants extra credit work. You have to think of something on the spot."},
	{"personality":"focused","topic":"academic","text":"{name} asks why this topic matters in real life. It's a genuinely great question."},
	{"personality":"focused","topic":"academic","text":"{name} finishes their assignment and then starts reading ahead in the next chapter."},
	{"personality":"focused","topic":"academic","text":"{name} respectfully disagrees with your explanation and provides sources."},
]

# --- CURVEBALL EVENTS (random surprise challenges) ---
const CURVEBALL_EVENTS: Array = [
	{
		"text": "The fire drill goes off mid-lesson. You have to line everyone up in under 2 minutes.",
		"choices": [
			{"key":"stay_calm","label":"Stay calm and direct firmly"},
			{"key":"panic","label":"Panic and forget who's missing"},
			{"key":"delegate","label":"Delegate to a reliable student"}
		]
	},
	{
		"text": "A bee flies in through the window. Half the class screams and abandons their seats.",
		"choices": [
			{"key":"stay_calm","label":"Calmly guide it out"},
			{"key":"panic","label":"React to the chaos"},
			{"key":"ignore","label":"Ignore it and keep teaching"}
		]
	},
	{
		"text": "The projector dies mid-presentation. Your entire lesson plan was on the slides.",
		"choices": [
			{"key":"adapt","label":"Improvise from memory"},
			{"key":"panic","label":"Stall while it reboots"},
			{"key":"delegate","label":"Turn it into a class discussion"}
		]
	},
	{
		"text": "A parent walks in unannounced claiming their child told them 'you never teach anything useful'.",
		"choices": [
			{"key":"stay_calm","label":"Professionally invite them to talk later"},
			{"key":"defend","label":"Defend yourself immediately"},
			{"key":"panic","label":"Freeze and let them talk"}
		]
	},
	{
		"text": "Another teacher pokes their head in and says your class is 'too loud'. Students are watching.",
		"choices": [
			{"key":"stay_calm","label":"Apologize and quiet the room"},
			{"key":"defend","label":"Defend your teaching style"},
			{"key":"ignore","label":"Ignore it and continue"}
		]
	},
	{
		"text": "Your coffee spills all over your lesson notes right before a key explanation.",
		"choices": [
			{"key":"adapt","label":"Laugh it off and improvise"},
			{"key":"panic","label":"Scramble to reconstruct your notes"},
			{"key":"delegate","label":"Ask a student to help recap"}
		]
	},
	{
		"text": "The intercom crackles and plays 5 minutes of static interrupting your class.",
		"choices": [
			{"key":"stay_calm","label":"Wait patiently and redirect"},
			{"key":"adapt","label":"Use the pause for a quick activity"},
			{"key":"panic","label":"Lose your train of thought entirely"}
		]
	},
	{
		"text": "A student from a different class wanders in and sits down as if they belong here.",
		"choices": [
			{"key":"stay_calm","label":"Politely redirect them"},
			{"key":"ignore","label":"Just let them stay"},
			{"key":"defend","label":"Make a scene about it"}
		]
	},
]

# --- CURVEBALL OUTCOMES ---
const CURVEBALL_OUTCOMES: Dictionary = {
	"stay_calm":  {"stress_delta":-8,  "score_delta":15, "message":"You handle it like a pro. The class respects you more for it."},
	"adapt":      {"stress_delta":-5,  "score_delta":12, "message":"Nicely improvised. A little chaos keeps things interesting."},
	"delegate":   {"stress_delta":-6,  "score_delta":10, "message":"Smart move. A reliable student steps up and handles it."},
	"panic":      {"stress_delta":14,  "score_delta":-15,"message":"That could have gone better. The class saw everything."},
	"ignore":     {"stress_delta":8,   "score_delta":-8, "message":"Ignoring it costs you. It escalates on its own."},
	"defend":     {"stress_delta":10,  "score_delta":-10,"message":"Getting defensive backfires. Now everyone's uncomfortable."},
}

# --- PRINCIPAL EVENTS ---
const PRINCIPAL_EVENTS: Array = [
	{
		"text": "Principal Chen walks in unannounced for a surprise observation. She's taking notes.",
		"choices": [
			{"key":"shine","label":"Launch into your best lesson"},
			{"key":"normal","label":"Continue normally"},
			{"key":"nervous","label":"Visibly panic and stumble"}
		]
	},
	{
		"text": "The principal stops you in the hall and asks why test scores dipped this week.",
		"choices": [
			{"key":"shine","label":"Present a clear plan to improve"},
			{"key":"normal","label":"Explain the circumstances honestly"},
			{"key":"nervous","label":"Make excuses that don't land"}
		]
	},
	{
		"text": "Principal Chen calls you to the office. A parent complained about your homework policy.",
		"choices": [
			{"key":"shine","label":"Back it up with educational research"},
			{"key":"normal","label":"Offer a compromise"},
			{"key":"nervous","label":"Cave immediately under pressure"}
		]
	},
	{
		"text": "The principal praises your class in the hallway in front of other teachers.",
		"choices": [
			{"key":"shine","label":"Thank her and stay humble"},
			{"key":"normal","label":"Accept graciously"},
			{"key":"nervous","label":"Deflect awkwardly"}
		]
	},
	{
		"text": "Principal Chen asks you to cover another teacher's class during your free period.",
		"choices": [
			{"key":"shine","label":"Agree and prep something engaging"},
			{"key":"normal","label":"Agree reluctantly"},
			{"key":"nervous","label":"Try to refuse and it goes badly"}
		]
	},
]

const PRINCIPAL_OUTCOMES: Dictionary = {
	"shine":   {"stress_delta":-12, "score_delta":25, "message":"Principal Chen smiles and writes 'EXEMPLARY' in her notebook."},
	"normal":  {"stress_delta":-2,  "score_delta":10, "message":"A solid performance. The principal nods and moves on."},
	"nervous": {"stress_delta":18,  "score_delta":-20,"message":"That was rough. She'll remember this visit for a while."},
}

# --- STUDENT CHOICES ---
const STUDENT_CHOICES: Dictionary = {
	"ignore":       {"label":"Ignore it",         "stress_delta":9,  "score_delta":-12,"message":"You look away. Two more students start doing the same thing."},
	"call_out":     {"label":"Call them out",     "stress_delta":-3, "score_delta":8,  "message":"You address it directly. They comply but the atmosphere tenses."},
	"encourage":    {"label":"Encourage them",   "stress_delta":-7, "score_delta":14, "message":"Your warmth breaks through. They visibly reset and engage."},
	"give_warning": {"label":"Issue a warning",  "stress_delta":2,  "score_delta":5,  "message":"A formal warning. They back off, but resentment lingers."},
	"send_out":     {"label":"Send to hall",      "stress_delta":6,  "score_delta":-18,"message":"They leave. Three students start whispering about fairness."},
	"offer_help":   {"label":"Offer help",        "stress_delta":-9, "score_delta":18, "message":"You sit with them. Real progress happens. The class notices."},
	"redirect":     {"label":"Redirect quietly",  "stress_delta":-4, "score_delta":10, "message":"A quiet word. Handled professionally without a scene."},
	"praise":       {"label":"Praise publicly",   "stress_delta":-5, "score_delta":12, "message":"Public praise lifts the whole room's energy."},
	"challenge":    {"label":"Give extra task",   "stress_delta":-3, "score_delta":10, "message":"You channel the energy productively. They rise to the challenge."},
	"contact_home": {"label":"Note for parents",  "stress_delta":3,  "score_delta":6,  "message":"You write it down. The student suddenly behaves better."},
}

const CHOICE_SETS: Dictionary = {
	"troublemaker": ["ignore","call_out","give_warning","send_out","contact_home","redirect"],
	"lazy":         ["ignore","redirect","encourage","give_warning","challenge","offer_help"],
	"anxious":      ["ignore","encourage","offer_help","redirect","praise","call_out"],
	"focused":      ["praise","challenge","encourage","offer_help","redirect","ignore"],
}

# --- GRADING QUESTIONS (lots of educational variety) ---
const GRADING_PROMPTS: Array = [
	# Math
	{"subject":"Math",    "question":"Student wrote: \"The square root of 144 is 14.\"",       "correct":false, "fact":"The square root of 144 is actually 12, since 12x12=144."},
	{"subject":"Math",    "question":"Student wrote: \"Pi is exactly 3.14.\"",                  "correct":false, "fact":"Pi is irrational and never ends. 3.14 is only an approximation."},
	{"subject":"Math",    "question":"Student wrote: \"A prime number has exactly two factors.\"","correct":true,  "fact":"Correct! Primes are divisible only by 1 and themselves."},
	{"subject":"Math",    "question":"Student wrote: \"0.999... equals exactly 1.\"",           "correct":true,  "fact":"This is a proven mathematical fact, not an approximation!"},
	{"subject":"Math",    "question":"Student wrote: \"The sum of angles in any triangle is 180 degrees.\"","correct":true,"fact":"True for flat (Euclidean) geometry. On curved surfaces it can differ."},
	{"subject":"Math",    "question":"Student wrote: \"Dividing by zero gives infinity.\"",     "correct":false, "fact":"Division by zero is undefined, not infinity."},
	{"subject":"Math",    "question":"Student wrote: \"A hexagon has 7 sides.\"",              "correct":false, "fact":"A hexagon has 6 sides. A heptagon has 7."},
	{"subject":"Math",    "question":"Student wrote: \"An integer can be negative.\"",          "correct":true,  "fact":"Integers include ...-3,-2,-1,0,1,2,3... both negative and positive."},
	# Science
	{"subject":"Science", "question":"Student wrote: \"DNA stands for Deoxyribonucleic Acid.\"","correct":true, "fact":"DNA carries genetic instructions for all living organisms."},
	{"subject":"Science", "question":"Student wrote: \"Photosynthesis produces carbon dioxide.\"","correct":false,"fact":"Plants absorb CO2 and produce oxygen during photosynthesis."},
	{"subject":"Science", "question":"Student wrote: \"Light travels at 300,000 km per second.\"","correct":true, "fact":"This speed is constant in a vacuum and the universe's speed limit."},
	{"subject":"Science", "question":"Student wrote: \"Sound travels faster than light.\"",     "correct":false, "fact":"Sound is about 340 m/s in air. Light is nearly a million times faster."},
	{"subject":"Science", "question":"Student wrote: \"The Earth's core is solid iron.\"",      "correct":false, "fact":"The inner core is solid iron, but the outer core is liquid iron-nickel."},
	{"subject":"Science", "question":"Student wrote: \"Humans share about 98% of DNA with chimpanzees.\"","correct":true,"fact":"We share even more DNA with other humans - about 99.9%."},
	{"subject":"Science", "question":"Student wrote: \"Water is the only substance that expands when it freezes.\"","correct":false,"fact":"Many substances expand when frozen. This just makes water unusual but not unique."},
	{"subject":"Science", "question":"Student wrote: \"Gravity on the Moon is about 1/6 of Earth's.\"","correct":true,"fact":"That's why astronauts can bounce so high on the Moon."},
	{"subject":"Science", "question":"Student wrote: \"Atoms are the smallest particles in existence.\"","correct":false,"fact":"Atoms are made of protons, neutrons, and electrons - and those have smaller parts too."},
	{"subject":"Science", "question":"Student wrote: \"Mitochondria generate energy for the cell.\"","correct":true, "fact":"Mitochondria convert glucose to ATP, the cell's energy currency."},
	# History
	{"subject":"History", "question":"Student wrote: \"World War II ended in 1945.\"",          "correct":true,  "fact":"Germany surrendered May 8 and Japan September 2, 1945."},
	{"subject":"History", "question":"Student wrote: \"Napoleon was born in France.\"",         "correct":false, "fact":"Napoleon was born in Corsica in 1769, the year France acquired the island."},
	{"subject":"History", "question":"Student wrote: \"The Berlin Wall fell in 1979.\"",        "correct":false, "fact":"The Berlin Wall fell on November 9, 1989."},
	{"subject":"History", "question":"Student wrote: \"The printing press was invented by Gutenberg around 1440.\"","correct":true,"fact":"Gutenberg's press revolutionized the spread of knowledge across Europe."},
	{"subject":"History", "question":"Student wrote: \"The French Revolution began in 1789.\"","correct":true,  "fact":"The storming of the Bastille on July 14, 1789 is its iconic starting point."},
	{"subject":"History", "question":"Student wrote: \"Cleopatra was Egyptian.\"",              "correct":false, "fact":"Cleopatra was Greek Macedonian, from the Ptolemaic dynasty. Egypt was her kingdom."},
	{"subject":"History", "question":"Student wrote: \"The first moon landing was in 1969.\"", "correct":true,  "fact":"Apollo 11 landed July 20, 1969. Neil Armstrong was the first human on the Moon."},
	{"subject":"History", "question":"Student wrote: \"The Roman Empire fell in 476 AD.\"",    "correct":true,  "fact":"476 AD is when the Western Roman Empire fell. The Eastern half lasted until 1453."},
	# Geography
	{"subject":"Geography","question":"Student wrote: \"The Amazon River is the longest river in the world.\"","correct":false,"fact":"The Nile (or possibly the Amazon by some measures) is longest. The Amazon carries more water."},
	{"subject":"Geography","question":"Student wrote: \"Australia is both a country and a continent.\"","correct":true,"fact":"Australia is unique as the only country that is also its own continent."},
	{"subject":"Geography","question":"Student wrote: \"The capital of Australia is Sydney.\"","correct":false, "fact":"Canberra is Australia's capital, chosen as a compromise between Sydney and Melbourne."},
	{"subject":"Geography","question":"Student wrote: \"Mount Everest is the tallest mountain from Earth's center.\"","correct":false,"fact":"Chimborazo in Ecuador is farthest from Earth's center due to the planet's bulge."},
	{"subject":"Geography","question":"Student wrote: \"Russia is the largest country by land area.\"","correct":true,"fact":"Russia spans 11 time zones and is nearly twice the size of the next largest country."},
	# Language Arts
	{"subject":"Language","question":"Student wrote: \"A simile uses 'like' or 'as' to compare.\"","correct":true,"fact":"'She runs like the wind' is a simile. 'She is the wind' is a metaphor."},
	{"subject":"Language","question":"Student wrote: \"Shakespeare wrote the play 'Don Quixote'.\"","correct":false,"fact":"Don Quixote was written by Miguel de Cervantes, published in 1605-1615."},
	{"subject":"Language","question":"Student wrote: \"An oxymoron is two contradictory words together.\"","correct":true,"fact":"Examples: jumbo shrimp, deafening silence, bittersweet."},
	{"subject":"Language","question":"Student wrote: \"A haiku has 5-7-5 syllables.\"",         "correct":true,  "fact":"Traditional Japanese haiku also reference nature and a seasonal word (kigo)."},
]

# --- SURPRISE CURVEBALL QUESTIONS (for the player) ---
const PLAYER_QUESTIONS: Array = [
	{
		"text": "A student asks: 'Why do we dream?'",
		"options": [
			{"label":"Brain processes memories and emotions","correct":true},
			{"label":"The brain rests completely during dreams","correct":false},
			{"label":"Dreams are random electrical noise only","correct":false},
		],
		"fact": "Dreams likely help consolidate memories and process emotions. REM sleep is crucial for learning."
	},
	{
		"text": "A student asks: 'What percentage of the ocean is explored?'",
		"options": [
			{"label":"About 20%","correct":true},
			{"label":"About 80%","correct":false},
			{"label":"About 50%","correct":false},
		],
		"fact": "Only about 20% of Earth's oceans have been mapped in detail. The deep sea is less known than the Moon's surface."
	},
	{
		"text": "A student asks: 'How many bones does an adult human have?'",
		"options": [
			{"label":"206","correct":true},
			{"label":"350","correct":false},
			{"label":"178","correct":false},
		],
		"fact": "Babies are born with around 270-300 bones. Many fuse together as we grow into the adult 206."
	},
	{
		"text": "A student asks: 'What is the most spoken language in the world?'",
		"options": [
			{"label":"Mandarin Chinese","correct":true},
			{"label":"English","correct":false},
			{"label":"Spanish","correct":false},
		],
		"fact": "Mandarin Chinese has about 1 billion native speakers. English has more total speakers when including second-language speakers."
	},
	{
		"text": "A student asks: 'How fast does hair grow?'",
		"options": [
			{"label":"About 6 inches per year","correct":true},
			{"label":"About 2 feet per year","correct":false},
			{"label":"About 1 inch per year","correct":false},
		],
		"fact": "Hair grows about half an inch (1.25 cm) per month on average, or about 6 inches per year."
	},
	{
		"text": "A student asks: 'Which planet has the most moons?'",
		"options": [
			{"label":"Saturn","correct":true},
			{"label":"Jupiter","correct":false},
			{"label":"Uranus","correct":false},
		],
		"fact": "Saturn has over 140 confirmed moons as of 2023, edging out Jupiter which has around 95."
	},
	{
		"text": "A student asks: 'What is the hardest natural substance?'",
		"options": [
			{"label":"Diamond","correct":true},
			{"label":"Titanium","correct":false},
			{"label":"Quartz","correct":false},
		],
		"fact": "Diamond scores 10 on the Mohs hardness scale. It's made of pure carbon atoms in a crystal lattice."
	},
	{
		"text": "A student asks: 'How many chambers does the human heart have?'",
		"options": [
			{"label":"4","correct":true},
			{"label":"2","correct":false},
			{"label":"6","correct":false},
		],
		"fact": "The heart has 4 chambers: right/left atria and right/left ventricles. Fish hearts only have 2 chambers."
	},
	{
		"text": "A student asks: 'What year did the first iPhone come out?'",
		"options": [
			{"label":"2007","correct":true},
			{"label":"2004","correct":false},
			{"label":"2010","correct":false},
		],
		"fact": "Steve Jobs announced the first iPhone on January 9, 2007. It had no App Store until 2008."
	},
	{
		"text": "A student asks: 'What causes rainbows?'",
		"options": [
			{"label":"Refraction and reflection of light in water droplets","correct":true},
			{"label":"The sky reacting with sunlight directly","correct":false},
			{"label":"Heat distortion in the upper atmosphere","correct":false},
		],
		"fact": "Light enters a water droplet, bends (refracts), reflects inside, and bends again coming out - splitting into colors."
	},
	{
		"text": "A student asks: 'Who wrote the theory of general relativity?'",
		"options": [
			{"label":"Albert Einstein","correct":true},
			{"label":"Isaac Newton","correct":false},
			{"label":"Niels Bohr","correct":false},
		],
		"fact": "Einstein published the theory of general relativity in 1915. It describes gravity as curvature of spacetime."
	},
	{
		"text": "A student asks: 'What is the chemical symbol for gold?'",
		"options": [
			{"label":"Au","correct":true},
			{"label":"Go","correct":false},
			{"label":"Gd","correct":false},
		],
		"fact": "Au comes from the Latin word 'aurum'. Gold has been valued for thousands of years for its rarity and beauty."
	},
]

func get_random_student_name() -> String:
	return STUDENT_NAMES[randi() % STUDENT_NAMES.size()]

func get_random_student_name_pair() -> Array:
	var n1 = get_random_student_name()
	var n2 = get_random_student_name()
	while n2 == n1:
		n2 = get_random_student_name()
	return [n1, n2]

func generate_classroom_students(count: int) -> Array:
	var used_names: Array = []
	var students: Array = []
	var personalities = ["troublemaker", "lazy", "anxious", "focused"]
	var col: int = 0
	var row: int = 0
	var grid_cols: int = 4
	for i in range(count):
		var sname = get_random_student_name()
		while used_names.has(sname):
			sname = get_random_student_name()
		used_names.append(sname)
		students.append({
			"name": sname,
			"personality": personalities[randi() % personalities.size()],
			"handled": false,
			"grid_col": col,
			"grid_row": row,
		})
		col += 1
		if col >= grid_cols:
			col = 0
			row += 1
	return students

func get_event_for_student(student: Dictionary) -> Dictionary:
	var pool: Array = []
	for ev in STUDENT_EVENTS:
		if ev["personality"] == student["personality"]:
			pool.append(ev)
	if pool.is_empty():
		pool = STUDENT_EVENTS
	var ev = pool[randi() % pool.size()].duplicate()
	ev["text"] = ev["text"].replace("{name}", student["name"])
	var pair = get_random_student_name_pair()
	ev["text"] = ev["text"].replace("{name2}", pair[1])
	return ev

func get_choices_for_personality(personality: String) -> Array:
	var keys: Array = CHOICE_SETS.get(personality, ["ignore","call_out","encourage"])
	var result: Array = []
	for k in keys:
		result.append({"key": k, "label": STUDENT_CHOICES[k]["label"]})
	return result

func get_student_outcome(choice_key: String) -> Dictionary:
	return STUDENT_CHOICES.get(choice_key, {})

func get_grading_prompt() -> Dictionary:
	return GRADING_PROMPTS[randi() % GRADING_PROMPTS.size()]

func get_random_curveball() -> Dictionary:
	return CURVEBALL_EVENTS[randi() % CURVEBALL_EVENTS.size()]

func get_curveball_outcome(key: String) -> Dictionary:
	return CURVEBALL_OUTCOMES.get(key, {})

func get_random_principal_event() -> Dictionary:
	return PRINCIPAL_EVENTS[randi() % PRINCIPAL_EVENTS.size()]

func get_principal_outcome(key: String) -> Dictionary:
	return PRINCIPAL_OUTCOMES.get(key, {})

func get_random_player_question() -> Dictionary:
	return PLAYER_QUESTIONS[randi() % PLAYER_QUESTIONS.size()]
