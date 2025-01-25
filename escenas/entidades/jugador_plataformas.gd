extends CharacterBody2D

const GRAVITY = 30
const JUMP_POWER = -1000
const WALK_SPEED = 450
const ACCELETARION_SMOOTHING = 20

@onready var bridge = $"../Bridge"

func _process(_delta):
	velocity.y += GRAVITY
	if bridge.is_pressed("up") && is_on_floor():
		velocity.y = JUMP_POWER
	var x_movement = bridge.get_strength("right") - bridge.get_strength("left")
	velocity.x = x_movement * WALK_SPEED
	move_and_slide()
