extends Node

@onready var destiny_area_2d = $Destiny/Area2D

func _ready():
	destiny_area_2d.body_entered.connect(on_body_entered)
	
func on_body_entered(_a):
	print("HAS GANADO")
