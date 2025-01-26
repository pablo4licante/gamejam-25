extends Node2D

const JUMP_POWER = -1000
 
@onready var bridge = $"../Bridge"
 
func _ready():
	$Area2D.body_entered.connect(on_body_entered)
	
func on_body_entered(player: Node):
	player.velocity.y = -1200
	bridge.play_sound("acierto")
	queue_free()
