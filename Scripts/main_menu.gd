extends Control

@onready var new_game_button = $CenterContainer/VBoxContainer/NewGameButton
@onready var load_game_button = $CenterContainer/VBoxContainer/LoadGameButton
@onready var settings_button = $CenterContainer/VBoxContainer/SettingsButton
@onready var controls_button = $CenterContainer/VBoxContainer/ControlsButton
@onready var quit_button = $CenterContainer/VBoxContainer/QuitButton

func _ready():
	new_game_button.pressed.connect(_on_new_game_pressed)
	load_game_button.pressed.connect(_on_load_game_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	controls_button.pressed.connect(_on_controls_pressed)

func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/controls.tscn")

func _on_new_game_pressed():
	GameManager.score = 0
	GameManager.lastLevel = "Area1"
	get_tree().change_scene_to_file("res://Scenes/Levels/level1.tscn")

func _on_load_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/load_menu.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/settings.tscn")

func _on_quit_pressed():
	get_tree().quit()
