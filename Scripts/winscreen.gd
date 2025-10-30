extends Control

@onready var main_menu = $VBoxContainer/MainMenu
@onready var quitbutton = $VBoxContainer/Quit

func _ready():

	main_menu.pressed.connect(_on_main_pressed)
	quitbutton.pressed.connect(_on_quit_pressed)

func _on_quit_pressed():
	get_tree().quit()

func _on_main_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")
