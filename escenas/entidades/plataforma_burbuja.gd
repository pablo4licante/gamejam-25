extends Node2D

const JUMP_POWER = -1200
 
@onready var bridge = $"../Bridge"
 
func _ready():
	$Area2D.body_entered.connect(on_body_entered)
	
func on_body_entered(player: Node):
	print("entro")
	player.velocity.y = -1200
	bridge.finished = true
	queue_free()
