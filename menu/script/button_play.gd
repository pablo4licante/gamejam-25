extends Button

func _ready() -> void:
	pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	# Llamar a la función change_screen del nodo de transición
	Trans.change_screen("res://escenas/managers/main.tscn")
