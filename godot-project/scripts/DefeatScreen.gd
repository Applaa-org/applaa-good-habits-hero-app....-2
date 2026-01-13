extends Control

@onready var defeat_title: Label = $VBoxContainer/DefeatTitle
@onready var message_label: Label = $VBoxContainer/MessageLabel
@onready var total_stars_label: Label = $VBoxContainer/TotalStarsLabel
@onready var restart_button: Button = $VBoxContainer/RestartButton
@onready var main_menu_button: Button = $VBoxContainer/MainMenuButton
@onready var close_button: Button = $VBoxContainer/CloseButton

func _ready():
	# Set up defeat message (though this game doesn't really have defeat)
	defeat_title.text = "Game Over"
	defeat_title.add_theme_font_size_override("font_size", 28)
	
	message_label.text = "Don't give up, " + Global.player_name + "!\nKeep practicing good habits!"
	total_stars_label.text = "Stars Earned: " + str(Global.total_stars) + " ⭐"
	
	# Connect buttons
	restart_button.pressed.connect(_on_restart_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	close_button.pressed.connect(_on_close_pressed)
	
	# Style buttons
	_style_button(restart_button, "Try Again", Color(0.2, 0.8, 0.2))
	_style_button(main_menu_button, "Main Menu", Color(0.5, 0.5, 0.8))
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

func _on_restart_pressed():
	Global.reset_progress()
	get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")

func _on_close_pressed():
	get_tree().quit()