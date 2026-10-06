extends RigidBody2D
class_name PhysicsCoin

@export var speed : float = 10

@onready var physicscoin: RigidBody2D = $"."
var is_dragging: bool = false
var picked_up_by : CharacterBody2D = null
@onready var pick_up_prompt: Label = $PickUpPrompt
@export var value : int = 1


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		is_dragging = true
		if picked_up_by != null:
			released()

func _input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		is_dragging = false

func _process(delta: float) -> void:
	if is_dragging:
		var distance = get_global_mouse_position() - global_position
		physicscoin.linear_velocity = distance * speed
	else:
		if picked_up_by != null:
			var distance = picked_up_by.global_position - global_position
			physicscoin.linear_velocity = distance * speed

func picked_up(picker_upper : CharacterBody2D) -> void:
	picked_up_by = picker_upper
	collision_layer = 2
	collision_mask = 0
	hide_pickup_prompt()
	
func released():
	picked_up_by.coin_in_range(physicscoin)
	picked_up_by.picked_up_coin_array.erase(physicscoin)
	picked_up_by = null
	collision_mask = 3
	collision_layer = 2
	
func show_pickup_prompt() -> void:
	pick_up_prompt.visible = true
	
func hide_pickup_prompt() -> void:
	pick_up_prompt.visible = false
