extends Node2D
 
@onready var bridge = $"../Bridge"

# Factor por el cual aumentará la escala
var scale_factor: float = 1.0
var scale_multiplier: float = 1
var times_pressed: int = 0
var delay = 0
var L = 1
var k = 0.1076
var tension = 0.5
var off = 0.1
var puntuation = 0
var i = 0

# Llamado cada frame
func _process(delta: float) -> void:

	if scale_factor < 1.0:
		scale_factor = 1.0
		
	delay += delta
	
		
	if bridge.just_pressed("action") && i == 0:
		times_pressed += 1
		scale_multiplier = L / (1 + exp(-k * -times_pressed))
		scale_factor += 0.02 + (scale_factor-0.9)*scale_multiplier 
		i = 3
		delay = 0
	if (i > 0): i -= 1
	
	if bridge.just_released("action"):
		puntuation = 0
		puntuation += tension - scale_multiplier
		puntuation -= scale_multiplier - off
		bridge.puntuacion = floor(puntuation/6 * 1000)
	
	if scale[0] >= 28:
		queue_free();
		
	delay += 1
	if (delay > 12 && scale_factor > 1.0):
		scale_factor -= 0.04
		
	scale = Vector2(scale_factor, scale_factor)  # Aumentar el tamaño del objeto
