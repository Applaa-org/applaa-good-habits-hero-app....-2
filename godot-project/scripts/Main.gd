extends Control

@onready var welcome_label: Label = $VBoxContainer/WelcomeLabel
@onready var stars_label: Label = $VBoxContainer/StarsLabel
@onready var habits_container: VBoxContainer = $VBoxContainer/HabitsContainer
@onready var back_button: Button = $VBoxContainer/BackButton
@onready var close_button: Button = $VBoxContainer/CloseButton

func _ready():
	# Update welcome message
	welcome_label.text = "Hello, " + Global.player_name + "! ⭐"
	
	# Update stars display
	_update_stars_display()
	
	# Create habit buttons
	_create_habit_buttons()
	
	# Connect navigation buttons
	back_button.pressed.connect(_on_back_pressed)
	close_button.pressed.connect(_on_close_pressed)
	
	# Style buttons
	_style_button(back_button, "Back to Menu", Color(0.5, 0.5, 0.8))
	_style_button(close_button, "Close Game", Color(0.8, 0.2, 0.2))

func _update_stars_display():
	stars_label.text = "Your Stars: " + str(Global.total_stars) + " ⭐"

func _create_habit_buttons():
	# Clear existing buttons
	for child in habits_container.get_children():
		if child is Button:
			child.queue_free()
	
	# Create habit buttons
	for habit_id in Global.HABITS:
		var habit_data = Global.HABITS[habit_id]
		var button = Button.new()
		button.text = habit_data.icon + " " + habit_data.name + " (+" + str(habit_data.stars) + " ⭐)"
		button.custom_minimum_size = Vector2(300, 60)
		button.pressed.connect(_on_habit_selected.bind(habit_id))
		habits_container.add_child(button)
		
		# Style the habit button
		_style_habit_button(button, habit_data.icon)

func _style_habit_button(button: Button, icon: String):
	button.add_theme_font_size_override("font_size", 18)
	button.add_theme_color_override("font_color", Color.WHITE)
	button.add_theme_color_override("font_hover_color", Color(1, 1, 0.8))
	
	var normal_style = StyleBoxFlat.new()
	normal_style.bg_color = Color(0.3, 0.6, 0.9)
	normal_style.corner_radius_top_left = 15
	normal_style.corner_radius_top_right = 15
	normal_style.corner_radius_bottom_left = 15
	normal_style.corner_radius_bottom_right = 15
	normal_style.content_margin_left = 20
	normal_style.content_margin_right = 20
	normal_style.content_margin_top = 15
	normal_style.content_margin_bottom = 15
	
	var hover_style = StyleBoxFlat.new()
	hover_style.bg_color = Color(0.4, 0.7, 1.0)
	hover_style.corner_radius_top_left = 15
	hover_style.corner_radius_top_right = 15
	hover_style.corner_radius_bottom_left = 15
	hover_style.corner_radius_bottom_right = 15
	hover_style.content_margin_left = 20
	hover_style.content_margin_right = 20
	hover_style.content_margin_top = 15
	hover_style.content_margin_bottom = 15
	
	button.add_theme_stylebox_override("normal", normal_style)
	button.add_theme_stylebox_override("hover", hover_style)

func _on_habit_selected(habit_id: String):
	Global.current_habit = habit_id
	get_tree().change_scene_to_file("res://scenes/HabitActivity.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")

func _on_close_pressed():
	get_tree().quit()

func _notification(what):
	if what == NOTIFICATION_WM_WINDOW_FOCUS_IN:
		_update_stars_display()