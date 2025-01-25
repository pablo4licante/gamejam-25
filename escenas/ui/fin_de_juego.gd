extends Node2D

@onready var anim_player : AnimationPlayer = $AnimationPlayer
 
var com = false
var jugador = 0

func play(j) -> void:
	if not com:
		jugador = j
		anim_player.play("player_"+str(j)+"_wins")
		com = true
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if com and not anim_player.is_playing():
		anim_player.play("continue_p"+str(jugador)+"_win")
		
