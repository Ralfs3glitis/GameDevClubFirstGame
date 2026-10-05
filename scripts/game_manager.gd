extends Node

var score = 0

@onready var score_label = $ScoreLabel

func add_point(value : int) -> void:
	score += value
	score_label.text = "You collected " + str(score) + " coins."
