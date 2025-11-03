extends Control

var MainMenu
var SaveGame
var LoadGame
var NextLevel
var QuitGame

func _ready():
	# Assign buttons manually
	MainMenu = $MainMenuButton
	SaveGame = $SaveGameButton
	LoadGame = $LoadGameButton
	NextLevel = $NextLevelButton
	QuitGame = $QuitGameButton


	
	# Connect button signals
	MainMenu.pressed.connect(_on_main_menu_pressed)
	LoadGame.pressed.connect(_on_load_game_pressed)
	SaveGame.pressed.connect(_on_save__game_pressed)
	QuitGame.pressed.connect(_on_quit_pressed)
	NextLevel.pressed.connect(_on_next_level_pressed)

func _on_next_level_pressed() -> void:
	$"/root/EscMenu".hide()
	GameManager.pause_toggle()
	get_tree().change_scene_to_file("res://Scenes/Levels/controls.tscn")

func _on_main_menu_pressed():
	$"/root/EscMenu".hide()
	GameManager.pause_toggle()
	get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")

func _on_load_game_pressed():
	$"/root/EscMenu".hide()
	GameManager.pause_toggle()
	match GameManager.lastLevel:
		"Main":
			get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")
		"Area1":
			get_tree().change_scene_to_file("res://Scenes/Levels/DemoLevel.tscn")
		"Area2":
			get_tree().change_scene_to_file("res://Scenes/Levels/level2.tscn")

func _on_save__game_pressed():
	$"/root/EscMenu".hide()
	GameManager.pause_toggle()
	get_tree().change_scene_to_file("res://Scenes/Levels/settings.tscn")

func _on_quit_pressed():
	get_tree().quit()
