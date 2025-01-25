extends Button

var tween: Tween
var original_position: Vector2
var is_hovering: bool = false

func _ready() -> void:
	# Conecta la señal del botón
	pressed.connect(_on_button_pressed)
	
	# Guarda la posición original del botón
	original_position = position
	
	# Conecta las señales de mouse enter/exit
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func start_animation() -> void:
	if tween:
		tween.kill() # Detiene cualquier tween anterior
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	
	# Mover hacia la derecha (sobrepasando un poco)
	tween.tween_property(self, "position:x", original_position.x + 20, 0.5)
	
	# Rebote hacia la izquierda
	tween.tween_property(self, "position:x", original_position.x - 10, 0.3)
	
	# Regresar a la posición original
	tween.tween_property(self, "position:x", original_position.x, 0.2)

func _on_mouse_entered() -> void:
	is_hovering = true
	# Inicia el loop de animación
	animate_loop()

func _on_mouse_exited() -> void:
	is_hovering = false
	# Regresa el botón a su posición original
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "position:x", original_position.x, 0.2)

func animate_loop() -> void:
	while is_hovering:
		start_animation()
		await tween.finished
		await get_tree().create_timer(1.0).timeout
		# Si ya no está en hover, sale del loop
		if not is_hovering:
			break

func _on_button_pressed() -> void:
	get_tree().quit()
