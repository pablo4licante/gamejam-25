extends CharacterBody2D

signal burbuja_died

const WALK_SPEED = 450
const ACCELETARION_SMOOTHING = 20

var colliding_bodies : Array[Node2D] = []

@onready var area_2d = $Area2D as Area2D

@onready var bridge = $"../Bridge"

func _input(_ev):
	if bridge.is_pressed("action"):
		check_bubble()
		
func _ready():
	area_2d.body_entered.connect(on_body_entered)
	area_2d.body_exited.connect(on_body_exited)


func _process(_delta):
	var x_movement = bridge.get_strength("right") - bridge.get_strength("left")
	var y_movement = bridge.get_strength("down") - bridge.get_strength("up")
	velocity.x = x_movement * WALK_SPEED 
	velocity.y = y_movement * WALK_SPEED 
	move_and_slide()
	
func on_body_entered(body):
	colliding_bodies.append(body)

func on_body_exited(body):
	colliding_bodies.erase(body)

func check_bubble():
	if colliding_bodies.size() > 0:
		colliding_bodies[0].queue_free()
		burbuja_died.emit()
