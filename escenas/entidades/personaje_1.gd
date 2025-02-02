extends CharacterBody2D
@onready var area_2d: Area2D = $Area2D 
@onready var bridge = $"../Bridge"

const SPEED = 400.0
var acceleration = 300.0
var previous_direction = 0 

var float_amplitude = 20.0 # Altura del movimiento (cuánto sube y baja)
var float_speed = 2.0 # Velocidad de oscilación
var start_y = 0.0 # Posición inicial en Y para evitar que se salga del mapa
var time = 0
func _ready():
	# Guarda la posición inicial en Y
	start_y = position.y
	if bridge.in_game:
		area_2d.body_entered.connect(reventar)
	

func _physics_process(_delta: float) -> void:
	
	time = Time.get_ticks_msec()

	position.y = start_y + sin(time / 1000.0 * float_speed) * float_amplitude

	var direction = bridge.get_strength("right") - bridge.get_strength("left")
	if previous_direction != direction:
		previous_direction = direction
		acceleration = 300
		
	if direction:
		velocity.x = direction * (SPEED + acceleration)
		acceleration = max(acceleration / 1.1, 0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func reventar(_a):
	bridge.play_sound("explosion")
	bridge.puntuacion = -100  
	queue_free()
