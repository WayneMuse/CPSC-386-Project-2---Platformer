extends Control

@onready var sfx_slider = $VBoxContainer/SFXSlider
@onready var music_slider = $VBoxContainer/MusicSlider
@onready var main_menu = $VBoxContainer/MainMenu

func _ready():
	sfx_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
	music_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	main_menu.pressed.connect(_on_main_pressed)
	
	sfx_slider.value_changed.connect(_on_sfx_slider_changed)
	music_slider.value_changed.connect(_on_music_slider_changed)



func _on_main_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")

func _on_sfx_slider_changed(value: float) -> void:
	var sfx_bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(sfx_bus, value)
	print("SFX BUS:", value)

func _on_music_slider_changed(value: float) -> void:
	var music_bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_bus, value)
	print("MUSIC BUS:", value)
