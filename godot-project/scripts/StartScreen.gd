extends Control

@onready var player_name_input: LineEdit = $VBoxContainer/PlayerNameInput
@onready var high_score_label: Label = $VBoxContainer/HighScoreLabel
@onready var start_button: Button = $VBoxContainer/StartButton
@onready var close_button: Button = $VBoxContainer/CloseButton
@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var instructions_label: Label = $VBoxContainer/InstructionsLabel

func _ready():
	# Set up UI
	title_label.text = "Good Habits Hero!"
	title_label.add_theme_font_size_override("font_size", 32)
	
	instructions_label.text = "Earn stars by completing good habits!\n🦷 Brush Teeth (3 stars)\n🧸 Clean Toys (5 stars)\n🤝 Help Parents (7 stars)"
	
	# Initialize high score display to 0 first
	high_score_label.text = "High Score: 0"
	high_score_label.visible = true
	
	# Load saved player name and high score
	if Global.player_name:
		player_name_input.text = Global.player_name
	
	if Global.total_stars > 0:
		high_score_label.text = "High Score: " + str(Global.total_stars) + " ⭐"
	
	# Connect buttons
	start_button.pressed.connect(_on_start_pressed)
	close_button.pressed.connect(_on_close_pressed)
	
	# Style buttons
	_style_button(start_button, "Start Adventure", Color(0.2, 0.8, 0.2))
	_style_button(close_button, "Close Game", Color(0.8, 0.2, 0.2))

func _style_button(button: Button, text: String, color: Color):
	button.text = text
	button.add_theme_color_override("font_color", Color.WHITE)
	button.add_theme_color_override("font_hover_color", Color(1, 1, 0.8))
	button.add_theme_stylebox_override("normal", _create_button_stylebox(color))
	button.add_theme_stylebox_override("hover", _create_button_stylebox(color.lightened(0.2)))
	button.add_theme_stylebox_override("pressed", _create_button_stylebox(color.darkened(0.2)))

func _create_button_stylebox(color: Color) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	style.content_margin_left = 20
	style.content_margin_right = 20
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	return style

func _on_start_pressed():
	var player_name = player_name_input.text.strip()
	if player_name.is_empty():
		player_name = "Hero"
	
	Global.player_name = player_name
	Global.save_game_data()
	
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_close_pressed():
	get_tree().quit()