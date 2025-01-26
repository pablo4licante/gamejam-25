extends Node2D

@onready var bridge = $"../Bridge"

# Configuración inicial
var scale_factor: float = 1.0  # Escala inicial de la burbuja
var scale_increment: float = 0.8  # Incremento por cada pulsación
var max_scale: float = 28.0  # Tamaño máximo antes de explotar
var min_scale: float = 1.0  # Tamaño mínimo (cuando está completamente desinflada)
var times_pressed: int = 0  # Veces que se ha inflado
var delay: float = 0.0  # Tiempo acumulado para manejar la desinflación
var desinflation_rate: float = 20.0  # Velocidad de desinflación por frame
var puntuation: int = 0	

# Llamado cada frame
func _process(delta: float) -> void:
	# Asegurar que la escala no sea menor a 1.0
	if scale_factor < min_scale:
		scale_factor = min_scale

	# Incrementar delay
	delay += delta

	# Manejar la acción de inflar
	if bridge.just_pressed("action"):
		times_pressed += 1
		scale_factor += scale_increment  # Incremento lineal
		delay = 0  # Resetea el tiempo de inactividad


	# Acción al soltar el botón
	if bridge.just_released("action"):
		puntuation += 1
		bridge.play_sound("hinchar")
		bridge.puntuacion = puntuation

	# Desinflar gradualmente si no se interactúa
	if delay > 0.5 and scale_factor > min_scale:  # Espera un tiempo antes de empezar a desinflar
		scale_factor -= desinflation_rate * delta  # Desinflado proporcional al tiempo
		puntuation -= 1
		scale_factor = max(min_scale, scale_factor)  # Evitar que sea menor a min_scale

	# Explosión si la escala supera el límite
	if scale_factor >= max_scale:
		bridge.puntuacion = 0
		bridge.play_sound("explosion")
		queue_free()  # Elimina el nodo (la burbuja explota)

	# Aplicar la escala al nodo
	scale = Vector2(scale_factor, scale_factor)
