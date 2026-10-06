extends Node

@onready var score_label = $ScoreLabel

var score : int = 0:
	set(value):
		score = value
		score_label.text = "You collected " + str(score) + " coins."
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PhysicsCoin:
		score += body.value

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is PhysicsCoin:
		score -= body.value
