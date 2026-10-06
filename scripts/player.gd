extends CharacterBody2D


@export var SPEED := 130.0

const JUMP_VELOCITY = -300.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

@onready var player: CharacterBody2D = $"."
var in_range_coin_array : Array[PhysicsCoin]
var picked_up_coin_array : Array[PhysicsCoin]

var can_doublejump : bool = true
func jump():
	velocity.y = JUMP_VELOCITY
func double_jump():
	jump()
	can_doublejump = false
	
func _physics_process(delta):
	# Pick up all coins in in_range array
	if Input.is_action_just_pressed("Interact"):
		pick_up_coins()
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			can_doublejump = true
			jump()
		elif can_doublejump == true:
			double_jump()

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func pick_up_coins() -> void:
	for coin in in_range_coin_array.duplicate():
		coin.picked_up(player)
		picked_up_coin_array.append(coin)
	in_range_coin_array.clear()
		
	for coin in in_range_coin_array:
		coin.picked_up(player)
		picked_up_coin_array.append(coin)
		in_range_coin_array.erase(coin)

func _on_pickup_detection_zone_body_entered(body: Node2D) -> void:
	if body is PhysicsCoin and !picked_up_coin_array.has(body):
		coin_in_range(body)
		
func coin_in_range(coin : PhysicsCoin) -> void:
	in_range_coin_array.append(coin)
	coin.show_pickup_prompt()

func _on_pickup_detection_zone_body_exited(body: Node2D) -> void:
	if body is PhysicsCoin and !picked_up_coin_array.has(body):
		coin_out_of_range(body)
		
func coin_out_of_range(coin : PhysicsCoin) -> void:
	in_range_coin_array.erase(coin)
	coin.hide_pickup_prompt()
