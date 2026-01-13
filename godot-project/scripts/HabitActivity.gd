extends Control

@onready var habit_title: Label = $VBoxContainer/HabitTitle
@onready var habit_icon: Label = $VBoxContainer/HabitIcon
@onready var instructions: Label = $VBoxContainer/Instructions
@onready var progress_bar: ProgressBar = $VBoxContainer/ProgressBar
@onready var complete_button: Button = $VBoxContainer/CompleteButton
@onready var back_button: Button = $VBoxContainer/BackButton
@onready var close_button: Button = $VBoxContainer/CloseButton

var current_progress: float = 0.0
var target_progress: float = 100.0
var is_active: bool = false

func _ready():
	_setup_habit_ui()
	_connect_buttons()
	
	# Start activity after brief delay
	await get_tree().create_timer(0.5).timeout
	start_activity()

func _setup_habit_ui():
	var habit_data = Global.HABITS[Global.current_habit]
	
	habit_title.text = habit_data.name
	habit_icon.text = habit_data.icon
	habit_icon.add_theme_font_size_override("font_size", 64)
	
	# Set instructions based on habit
	match Global.current_habit:
		"brush_teeth":
			instructions.text = "Time to brush your teeth!\nClick the button 5 times to brush thoroughly!"
			target_progress = 100.0
		"clean_toys":
			instructions.text = "Let's clean up the toys!\nClick the button 8 times to put all toys away!"
			target_progress = 100.0
		"help_parents":
			instructions.text = "Help your parents with a task!\nClick the button 10 times to complete the help!"
			target_progress = 100.0
	
	progress_bar.value = 0
	progress_bar.max_value = target_progress

func _connect_buttons():
	complete_button.pressed.connect(_on_complete_pressed)
	back_button.pressed.connect(_on_back_pressed)
	close_button.pressed.connect(_on_close_pressed)
	
	# Style buttons
	_style_button(complete_button, "Do the Habit!", Color(0.2, 0.8, 0.2))
	_style_button(back_button, "Back", Color(0.5, 0.5, 0.8))
	_style_button(close_button, "Close Game", Color(0.8, 0.2, 0.2))

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

func start_activity():
	is_active = true
	complete_button.disabled = false
	current_progress = 0.0
	progress_bar.value = current_progress

func _on_complete_pressed():
	if not is_active:
		return
	
	# Add progress based on habit
	var progress_amount = 0.0
	match Global.current_habit:
		"brush_teeth":
			progress_amount = 20.0  # 5 clicks
		"clean_toys":
			progress_amount = 12.5  # 8 clicks
		"help_parents":
			progress_amount = 10.0  # 10 clicks
	
	current_progress = min(current_progress + progress_amount, target_progress)
	progress_bar.value = current_progress
	
	# Visual feedback
	_animate_progress()
	
	# Check if completed
	if current_progress >= target_progress:
		_complete_habit()

func _animate_progress():
	# Simple animation effect
	var tween = create_tween()
	tween.tween_property(complete_button, "scale", Vector2(1.1, 1.1), 0.1)
	tween.tween_property(complete_button, "scale", Vector2(1.0, 1.0), 0.1)

func _complete_habit():
	is_active = false
	complete_button.disabled = true
	
	# Complete the habit and get stars
	Global.complete_habit(Global.current_habit)
	var habit_data = Global.HABITS[Global.current_habit]
	var stars_earned = habit_data.stars
	
	# Show completion message
	_show_completion_message(habit_data.name, stars_earned)
	
	# Wait then go to victory
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/VictoryScreen.tscn")

func _show_completion_message(habit_name: String, stars: int):
	habit_title.text = "Great job!"
	instructions.text = "You completed " + habit_name + "!\nYou earned " + str(stars) + " stars! ⭐"
	
	# Celebration animation
	var tween = create_tween()
	tween.tween_property(habit_icon, "scale", Vector2(1.5, 1.5), 0.5)
	tween.tween_property(habit_icon, "scale", Vector2(1.0, 1.0), 0.5)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_close_pressed():
	get_tree().quit()