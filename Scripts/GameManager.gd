extends Node

var score: int = 0
var game_paused: bool = false
var pause_ready: bool = true  
var lastLevel = "Main"

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	print("GameManager ready!")

func _input(event):
	if event.is_action_pressed("Pause") and pause_ready:
		pause_ready = false
		game_paused = !game_paused
		get_tree().paused = game_paused
		print("Pause toggled:", game_paused)

	if event.is_action_released("Pause"):
		pause_ready = true


func add_score(amount):
	score += amount
	print(score)
