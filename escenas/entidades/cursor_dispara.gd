extends CharacterBody2D

signal burbuja_died

const WALK_SPEED = 450
const ACCELETARION_SMOOTHING = 20

var colliding_bodies : Array[Node2D] = []

@onready var area_2d = $Area2D as Area2D

#@onready var bridge = $"../Bridge"

func _input(ev):
	if Input.is_action_pressed("1_action"):
		check_bubble()
		
func _ready():
	area_2d.body_entered.connect(on_body_entered)
	area_2d.body_exited.connect(on_body_exited)


func _process(delta):
	var x_movement = Input.get_action_strength("1_right") - Input.get_action_strength("1_left")
	var y_movement = Input.get_action_strength("1_down") - Input.get_action_strength("1_up")
	velocity.x = x_movement * WALK_SPEED 
	velocity.y = y_movement * WALK_SPEED 
	move_and_slide()
	
func on_body_entered(body):
	colliding_bodies.append(body)

func on_body_exited(body):
	colliding_bodies.erase(body)

func check_bubble():
	print("miro")
	if colliding_bodies.size() > 0:
		colliding_bodies[0].queue_free()
		burbuja_died.emit()
