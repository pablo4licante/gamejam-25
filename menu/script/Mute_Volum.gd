extends Button

signal volume_changed(value: float)
var master_bus = AudioServer.get_bus_index("Master")

func _ready():
	_update_button_text()
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	var current_volume = AudioServer.get_bus_volume_db(master_bus)
	var new_volume = -30.0 if current_volume > -30 else 0.0
	
	AudioServer.set_bus_volume_db(master_bus, new_volume)
	volume_changed.emit(new_volume)
	_update_button_text()

func _update_button_text():
	var current_volume = AudioServer.get_bus_volume_db(master_bus)
	text = "MUTE" if current_volume <= -30 else "VOLUME"

func update_from_slider(volume):
	_update_button_text()
