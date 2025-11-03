extends Control

@onready var MainMenu = $MainMenuButton
@onready var SaveGame = $SaveGameButton
@onready var LoadGame = $LoadGameButton
@onready var NextLevel = $NextLevelButton
@onready var QuitGame = $QuitGameButton


func _ready():
	MainMenu.pressed.connect(_on_main_menu_pressed)
	LoadGame.pressed.connect(_on_load_game_pressed)
	SaveGame.pressed.connect(_on_save__game_pressed)
	QuitGame.pressed.connect(_on_quit_pressed)
	NextLevel.pressed.connect(_on_next_level_pressed)

func _on_next_level_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/controls.tscn")

func _on_main_menu_pressed():
	GameManager.score = 0
	GameManager.lastLevel = "Area1"
	get_tree().change_scene_to_file("res://Scenes/Levels/DemoLevel.tscn")

func _on_load_game_pressed():
	if GameManager.lastLevel == "Main":
		get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")
	if GameManager.lastLevel == "Area1":
		get_tree().change_scene_to_file("res://Scenes/Levels/DemoLevel.tscn")
	if GameManager.lastLevel == "Area2":
		get_tree().change_scene_to_file("res://Scenes/Levels/level2.tscn")

func _on_save__game_pressed():

	get_tree().change_scene_to_file("res://Scenes/Levels/settings.tscn")

func _on_quit_pressed():
	get_tree().quit()
