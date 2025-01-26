extends Button

# Variable para rastrear el estado del sonido
var is_muted = false

# Nodo del bus de audio (asumiendo que usamos el bus "Master")
var master_bus = AudioServer.get_bus_index("Master")

func _ready():
	# Configuración inicial del texto del botón
	_update_button_text()
	# Conectar la señal pressed del botón a la función _on_button_pressed
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	# Cambiar el estado de mute
	is_muted = !is_muted
	
	# Aplicar el mute al bus de audio
	AudioServer.set_bus_mute(master_bus, is_muted)
	
	# Actualizar el texto del botón
	_update_button_text()

func _update_button_text():
	# Cambiar el texto según el estado
	if is_muted:
		text = "MUTE"
	else:
		text = "VOLUME"
