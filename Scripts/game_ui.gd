extends Control

var score_label: Label

func _ready():
	score_label = get_node_or_null("ScoreLabel")

func _process(_delta):
	if score_label:
		score_label.text = "x %d" % GameManager.score
