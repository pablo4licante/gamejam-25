extends Node

@onready var burbujas = $Burbujas
@onready var cursor_dispara = $Cursor_dispara
 
@onready var bridge = $Bridge
@onready var confetti = $Confetti
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	cursor_dispara.burbuja_died.connect(on_burbuja_died) 
	animated_sprite.play("default")
		
func on_burbuja_died():
	if burbujas.get_child_count()-1 == 0:
		print("HAS GANADO")
		confetti.emitting = true
		cursor_dispara.queue_free() #quitar
		bridge.finished = true
