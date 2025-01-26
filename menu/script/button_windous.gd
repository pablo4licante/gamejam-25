extends Button

# Variable para rastrear el estado de pantalla completa
var is_fullscreen = true

func _ready():
	# Configuración inicial del texto del botón
	_update_button_text()
	# Conectar la señal pressed del botón a la función _on_button_pressed
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	# Alternar entre pantalla completa y modo ventana
	is_fullscreen = !is_fullscreen
	
	# Usar if normal en lugar del operador ternario
	if is_fullscreen:
		SrcMenu.modo_ventana = DisplayServer.WINDOW_MODE_FULLSCREEN 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		SrcMenu.modo_ventana = DisplayServer.WINDOW_MODE_WINDOWED
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	# Actualizar el texto del botón
	_update_button_text()

func _update_button_text():
	# Cambiar el texto según el estado
	if is_fullscreen:
		text = "FULL"
	else:
		text = "VENTANA"
