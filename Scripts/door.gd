extends Area2D
@export var next_scene : PackedScene

func _ready() -> void:
	$AnimatedSprite2D.play("idle")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		#get_tree().call_group("Player")
		print("MOVING TO SCENE:", next_scene)
		AudioManager.success_sfx.play()
		GameManager.lastLevel = "Area2"
		SceneTransition.load_scene(next_scene)
