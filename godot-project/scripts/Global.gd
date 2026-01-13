extends Node

# Game data
var player_name: String = ""
var total_stars: int = 0
var current_habit: String = ""
var habits_completed: Array = []
var game_progress: Dictionary = {}

# Habit definitions
const HABITS = {
	"brush_teeth": {"name": "Brush Teeth", "stars": 3, "icon": "🦷"},
	"clean_toys": {"name": "Clean Toys", "stars": 5, "icon": "🧸"},
	"help_parents": {"name": "Help Parents", "stars": 7, "icon": "🤝"}
}

# localStorage integration for web export
func _ready():
	# Initialize with default values first
	player_name = ""
	total_stars = 0
	habits_completed = []
	game_progress = {
		"brush_teeth": 0,
		"clean_toys": 0,
		"help_parents": 0,
		"total_sessions": 0
	}
	
	# Load saved data from localStorage
	load_game_data()

func save_game_data():
	# Save to localStorage using Applaa Game Storage API
	var data = {
		"playerName": player_name,
		"score": total_stars,
		"habitsCompleted": habits_completed,
		"gameProgress": game_progress
	}
	
	# Use JavaScriptBridge for web export
	if OS.get_name() == "Web":
		JavaScriptBridge.eval("""
			if (window.parent && window.parent.postMessage) {
				window.parent.postMessage({
					type: 'applaa-game-save-data',
					gameId: 'good-habits-hero',
					data: """ + JSON.stringify(data) + """
				}, '*');
			}
		""")

func load_game_data():
	# Request data from localStorage
	if OS.get_name() == "Web":
		JavaScriptBridge.eval("""
			if (window.parent && window.parent.postMessage) {
				window.parent.postMessage({
					type: 'applaa-game-load-data',
					gameId: 'good-habits-hero'
				}, '*');
			}
		""")
		
		# Set up listener for data response
		await get_tree().create_timer(0.1).timeout
		_setup_message_listener()

func _setup_message_listener():
	# Listen for localStorage data response
	JavaScriptBridge.eval("""
		window.addEventListener('message', function(event) {
			if (event.data.type === 'applaa-game-data-loaded' && event.data.data) {
				window.godotGameData = event.data.data;
			}
		});
	""")
	
	# Check if data was loaded
	await get_tree().create_timer(0.5).timeout
	var loaded_data = JavaScriptBridge.eval("window.godotGameData || null")
	
	if loaded_data and typeof(loaded_data) == TYPE_STRING:
		var parsed_data = JSON.parse(loaded_data)
		if parsed_data:
			_apply_loaded_data(parsed_data)

func _apply_loaded_data(data: Dictionary):
	if data.has("playerName") and data.playerName:
		player_name = data.playerName
	if data.has("score"):
		total_stars = data.score
	if data.has("habitsCompleted"):
		habits_completed = data.habitsCompleted
	if data.has("gameProgress"):
		game_progress = data.gameProgress

func complete_habit(habit_id: String):
	if not habit_id in HABITS:
		return
	
	var habit_data = HABITS[habit_id]
	var stars_earned = habit_data.stars
	
	# Add stars
	total_stars += stars_earned
	
	# Track completion
	habits_completed.append(habit_id)
	game_progress[habit_id] = game_progress.get(habit_id, 0) + 1
	game_progress["total_sessions"] = game_progress.get("total_sessions", 0) + 1
	
	# Save progress
	save_game_data()
	
	# Emit signal for UI update
	emit_signal("habit_completed", habit_id, stars_earned)

func reset_progress():
	player_name = ""
	total_stars = 0
	habits_completed = []
	game_progress = {
		"brush_teeth": 0,
		"clean_toys": 0,
		"help_parents": 0,
		"total_sessions": 0
	}
	save_game_data()

func get_high_score() -> int:
	# Return total stars as high score
	return total_stars

signal habit_completed(habit_id: String, stars: int)