extends CharacterBody2D

const GRAVITY = 30
const JUMP_POWER = -1000
const WALK_SPEED = 450
const ACCELETARION_SMOOTHING = 20

func _process(_delta):
	velocity.y += GRAVITY
	if Input.is_action_just_pressed("p1_up") && is_on_floor():
		velocity.y = JUMP_POWER
	var x_movement = Input.get_action_strength("p1_right") - Input.get_action_strength("p1_left")
	velocity.x = x_movement * WALK_SPEED
	move_and_slide()
