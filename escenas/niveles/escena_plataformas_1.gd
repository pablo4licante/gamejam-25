extends Node

@onready var destiny_area_2d = $Destiny/Area2D

@onready var confetti = $Confetti
@onready var bridge = $Bridge

func _ready():
	destiny_area_2d.body_entered.connect(on_body_entered) 

var meta = false
	
func on_body_entered(_a):
	print("HAS GANADO")
	
	if not meta:
		bridge.play_sound("meta")
		confetti.emitting = true
		bridge.finished = true
		meta = true

	
