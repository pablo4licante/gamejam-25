extends Control

var modo_ventana = DisplayServer.WINDOW_MODE_FULLSCREEN

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if modo_ventana != DisplayServer.window_get_mode():
		DisplayServer.window_set_mode(modo_ventana)
