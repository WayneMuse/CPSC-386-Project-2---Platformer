extends Control

var MainMenu
var SaveGame
var LoadGame
var NextLevel
var QuitGame
var SaveNameInput

func _ready():
	# Assign buttons manually
	MainMenu 		= $VBoxContainer/MainMenuButton
	SaveGame 		= $VBoxContainer/SaveGameButton
	LoadGame 		= $VBoxContainer/LoadGameButton
	NextLevel 		= $VBoxContainer/NextLevelButton
	QuitGame 		= $VBoxContainer/QuitGameButton
	SaveNameInput 	= $VBoxContainer/SaveNameInput


	
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
	$"/root/EscMenu".hide()
	
	GameManager.load_game()
	
	match GameManager.lastLevel:
		"Main":
			get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")
		"Area1":
			get_tree().change_scene_to_file("res://Scenes/Levels/level1.tscn")
		"Area2":
			get_tree().change_scene_to_file("res://Scenes/Levels/level2.tscn")
		#"Area3":
			#get_tree().change_scene_to_file("res://Scenes/Levels/level3.tscn")
	
	GameManager.unpause()

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
