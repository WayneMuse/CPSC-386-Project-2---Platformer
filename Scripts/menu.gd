extends Control
@onready var quit_button = $Menu/Quit

func _ready():
	for child in get_children():
		print(child.name)
	print(quit_button)


	#quit_button.pressed.connect(_on_quit_pressed)

func _on_quit_pressed():
	get_tree().quit()
