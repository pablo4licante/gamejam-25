extends Node

@onready var destiny_area_2d = $Destiny/Area2D
#@onready var bridge = $"../Bridge"
@onready var label = $Label

func _ready():
	destiny_area_2d.body_entered.connect(on_body_entered)
	label.text = ""
	
func on_body_entered(_a):
	print("HAS GANADO")
	label.text = "¡Ganaste!"
	#bridge.finished = true
	
