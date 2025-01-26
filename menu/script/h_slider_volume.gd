extends Slider

var master_bus = AudioServer.get_bus_index("Master")
@onready var volume_label = $Label  # Asegúrate de tener un Label como hijo del slider

func _ready():
	min_value = -30
	max_value = 0
	step = 0.5
	
	value = AudioServer.get_bus_volume_db(master_bus)
	_update_volume_label(value)
	
	value_changed.connect(_on_value_changed)

func _on_value_changed(new_value):
	AudioServer.set_bus_volume_db(master_bus, new_value)
	_update_volume_label(new_value)

func _update_volume_label(vol):
	if volume_label:
		volume_label.text = "Volumen: %d dB" % vol
