extends Area2D
func _ready() -> void:
	$AnimatedSprite2D.play("idle")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		AudioManager.collect_sfx.play()
		GameManager.add_score(1)
		print("Players Coins:", GameManager.score)
		#print("Player Score:", GameManager.printscore())
		queue_free()
