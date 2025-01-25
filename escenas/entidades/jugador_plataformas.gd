extends CharacterBody2D

const GRAVITY = 3000
const JUMP_POWER = -900
const WALK_SPEED = 450
const ACCELETARION_SMOOTHING = 20

@onready var bridge = $"../Bridge"
@onready var sprite = $AnimatedSprite2D

func _process(_delta):
	velocity.y += GRAVITY * _delta
	
	var x_movement = bridge.get_strength("right") - bridge.get_strength("left")
	
	if x_movement != 0:
		sprite.flip_h = x_movement >= 0

	if is_on_floor():
		if x_movement != 0:
			sprite.play("walk")
		else:
			sprite.play("idle")
	
	if bridge.is_pressed("up") && is_on_floor():
		velocity.y = JUMP_POWER
		sprite.play("jump")


	velocity.x = x_movement * WALK_SPEED
	move_and_slide()
	
#func _process(delta):
	#velocity.y += GRAVITY * delta
	#if Input.is_action_just_pressed("1_up") && is_on_floor():
	#	velocity.y = JUMP_POWER
	#var x_movement = Input.get_action_strength("1_right") - Input.get_action_strength("1_left")
	#velocity.x = x_movement * WALK_SPEED
#	move_and_slide()
