extends Control

@onready var victory_title: Label = $VBoxContainer/VictoryTitle
@onready var message_label: Label = $VBoxContainer/MessageLabel
@onready var stars_earned_label: Label = $VBoxContainer/StarsEarnedLabel
@onready var total_stars_label: Label = $VBoxContainer/TotalStarsLabel
@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var main_menu_button: Button = $VBoxContainer/MainMenuButton
@onready var close_button: Button = $VBoxContainer/CloseButton

func _ready():
	# Set up victory message
	victory_title.text = "🎉 Habit Hero! 🎉"
	victory_title.add_theme_font_size_override("font_size", 28)
	
	# Get the last completed habit info
	var last_habit = Global.habits_completed[-1] if Global.habits_completed.size() > 0 else "unknown"
	var habit_data = Global.HABITS.get(last_habit, {"name": "Good Habit", "stars": 0})
	var stars_earned = habit_data.stars
	
	# Update labels
	message_label.text = "Amazing work, " + Global.player_name + "!"
	stars_earned_label.text = "You earned " + str(stars_earned) + " stars for " + habit_data.name + "! ⭐"
	total_stars_label.text = "Total Stars: " + str(Global.total_stars) + " ⭐"
	
	# Connect buttons
	continue_button.pressed.connect(_on_continue_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	close_button.pressed.connect(_on_close_pressed)
	
	# Style buttons
	_style_button(continue_button, "Continue Playing", Color(0.2, 0.8, 0.2))
	_style_button(main_menu_button, "Main Menu", Color(0.5, 0.5, 0.8))
	_style_button(close_button, "Close Game", Color(0.8, 0.2, 0.2))
	
	# Celebration animation
	_celebration_animation()

func _style_button(button: Button, text: String, color: Color):
	button.text = text
	button.custom_minimum_size = Vector2(200, 50)
	button.add_theme_color_override("font_color", Color.WHITE)
	button.add_theme_color_override("font_hover_color", Color(1, 1, 0.8))
	
	var normal_style = StyleBoxFlat.new()
	normal_style.bg_color = color
	normal_style.corner_radius_top_left = 10
	normal_style.corner_radius_top_right = 10
	normal_style.corner_radius_bottom_left = 10
	normal_style.corner_radius_bottom_right = 10
	normal_style.content_margin_left = 15
	normal_style.content_margin_right = 15
	normal_style.content_margin_top = 10
	normal_style.content_margin_bottom = 10
	
	var hover_style = StyleBoxFlat.new()
	hover_style.bg_color = color.lightened(0.2)
	hover_style.corner_radius_top_left = 10
	hover_style.corner_radius_top_right = 10
	hover_style.corner_radius_bottom_left = 10
	hover_style.corner_radius_bottom_right = 10
	hover_style.content_margin_left = 15
	hover_style.content_margin_right = 15
	hover_style.content_margin_top = 10
	hover_style.content_margin_bottom = 10
	
	button.add_theme_stylebox_override("normal", normal_style)
	button.add_theme_stylebox_override("hover", hover_style)

func _celebration_animation():
	# Animate victory title
	var tween = create_tween()
	tween.tween_property(victory_title, "scale", Vector2(1.2, 1.2), 0.5)
	tween.tween_property(victory_title, "scale", Vector2(1.0, 1.0), 0.5)
	tween.set_loops()

func _on_continue_pressed():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")

func _on_close_pressed():
	get_tree().quit()