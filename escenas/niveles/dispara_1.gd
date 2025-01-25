extends Node

@onready var burbujas = $Burbujas
@onready var cursor_dispara = $Cursor_dispara
@onready var label = $Label

func _ready():
	cursor_dispara.burbuja_died.connect(on_burbuja_died)
	label.text = ""
		
func on_burbuja_died():
	if burbujas.get_child_count()-1 == 0:
		print("HAS GANADO")
		label.text = "¡Ganaste!"
		cursor_dispara.queue_free() #quitar
		pass #bridge.finished = true
