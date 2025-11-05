extends Control

var MainMenu
var SaveGame
var LoadGame
var NextLevel
var QuitGame
var SaveNameInput

func _ready():
	# Assign buttons manually
	MainMenu 		= $Background/VBoxContainer/MainMenuButton
	SaveGame 		= $Background/VBoxContainer/SaveGameButton
	LoadGame 		= $Background/VBoxContainer/LoadGameButton
	NextLevel 		= $Background/VBoxContainer/NextLevelButton
	QuitGame 		= $Background/VBoxContainer/QuitGameButton
	SaveNameInput 	= $Background/VBoxContainer/SaveNameInput


	
	# Connect button signals
	MainMenu.pressed.connect(_on_main_menu_pressed)
	LoadGame.pressed.connect(_on_load_game_pressed)
	SaveGame.pressed.connect(_on_save__game_pressed)
	QuitGame.pressed.connect(_on_quit_pressed)
	NextLevel.pressed.connect(_on_next_level_pressed)

func _on_next_level_pressed() -> void:
	$"/root/EscMenu".hide()
#	increment level counter by 1 to have "level" + counter + ".tscn" transfer scenes properly

func _on_main_menu_pressed():
	$"/root/EscMenu".hide()
	get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")

func _on_load_game_pressed():
	GameManager.unpause()
	$"/root/EscMenu".hide()
	
	get_tree().change_scene_to_file("res://Scenes/Levels/load_menu.tscn")

func _on_save__game_pressed():	
	var save_name = SaveNameInput.text
	
	# Check if the name is empty
	if save_name.is_empty():
		print("Save name cannot be empty!")
		SaveNameInput.placeholder_text = "!EMPTY"
		return # Stop without saving

	# If the name is valid, proceed with saving
	GameManager.save_game(save_name)
	SaveNameInput.text = ""
	SaveNameInput.placeholder_text = "SAVED!"
	
	#get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
