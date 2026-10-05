extends RigidBody2D

@export var speed : float = 10
var is_dragging: bool = false
@onready var physicscoin: RigidBody2D = $"."

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		is_dragging = true

func _input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		is_dragging = false

func _process(delta: float) -> void:
	if is_dragging:
		#var direction = global_position.direction_to(get_global_mouse_position())
		var distance = get_global_mouse_position() - global_position
		#apply_central_impulse(distance)
		physicscoin.linear_velocity = distance * speed
