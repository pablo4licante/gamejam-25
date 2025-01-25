extends Label

var time: float = 0
var shake_strength: float = 1.5
var original_position: Vector2
var original_scale: Vector2
var tween: Tween

func _ready() -> void:
	original_position = position
	original_scale = scale
	start_animations()

func start_animations() -> void:
	tween = create_tween().set_loops()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	# Secuencia de escala más elaborada
	var sequence = [
		original_scale * 1.25,  # 25% más grande
		original_scale * 0.95,  # 5% más pequeño
		original_scale * 1.15,  # 15% más grande
		original_scale * 0.98,  # Casi normal
		original_scale * 1.1    # 10% más grande
	]
	
	for target_scale in sequence:
		tween.tween_property(self, "scale", target_scale, 1.5)  # 1.5 segundos cada cambio
	
	# Rotación ondulante
	tween.tween_property(self, "rotation_degrees", 4, 3.0)
	tween.chain().tween_property(self, "rotation_degrees", -4, 3.0)
	tween.chain().tween_property(self, "rotation_degrees", 0, 3.0)

func _process(delta: float) -> void:
	time += delta * 2.0  # Muy lento
	
	# Movimiento ondulante más complejo
	var shake_offset = Vector2(
		sin(time) * cos(time * 0.5) * shake_strength,
		cos(time * 0.7) * sin(time * 0.3) * shake_strength
	)
	
	position = original_position + shake_offset

# Efecto adicional de color (opcional)
func _add_color_effect() -> void:
	var color_tween = create_tween().set_loops()
	
	# Cambia sutilmente el brillo
	color_tween.tween_property(self, "modulate", Color(1.1, 1.1, 1.1, 1), 2.0)
	color_tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 2.0)
