extends Area2D

@onready var game_manager = %GameManager
@onready var animation_player = $AnimationPlayer
@export var value = 1

func _on_body_entered(body) -> void:
	game_manager.add_point(value)
	animation_player.play("pickup")
