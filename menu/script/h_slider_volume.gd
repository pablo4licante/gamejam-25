extends HSlider

var master_bus = AudioServer.get_bus_index("Master")
@onready var mute_button = $"../Button_volume"
@onready var volume_label = $Label

func _ready():
	min_value = 0
	max_value = 100
	step = 1
	
	# Convertir el volumen de dB a porcentaje (0-100)
	var db_value = AudioServer.get_bus_volume_db(master_bus)
	value = db_to_percent(db_value)
	
	value_changed.connect(_on_value_changed)
	
	if mute_button:
		mute_button.volume_changed.connect(_on_button_volume_changed)
	
	_update_volume_label(value)

func _on_value_changed(new_value):
	# Convertir el porcentaje (0-100) a dB
	var db_value = percent_to_db(new_value)
	AudioServer.set_bus_volume_db(master_bus, db_value)
	
	if mute_button:
		mute_button.update_from_slider(db_value)
	
	_update_volume_label(new_value)

func _on_button_volume_changed(new_value):
	value = db_to_percent(new_value)
	_update_volume_label(value)

func _update_volume_label(vol):
	if volume_label:
		volume_label.text = ": %d%%" % vol

# Función para convertir dB a porcentaje
func db_to_percent(db):
	if db <= -30:
		return 0
	return round((db + 30) * (100.0 / 30.0))

# Función para convertir porcentaje a dB
func percent_to_db(percent):
	if percent <= 0:
		return -30
	return (percent * 30.0 / 100.0) - 30
