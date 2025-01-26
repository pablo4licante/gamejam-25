extends Node2D

@onready var anim_player : AnimationPlayer = $AnimationPlayer
 
var com = false
var jugador = 0

func play(j) -> void:
	if not com:
		if j == 0:
			anim_player.play("empate")
		else:
			anim_player.play("player_"+str(j)+"_wins")
		
		jugador = j
		com = true
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if com and not anim_player.is_playing():
		if jugador != 0: 
			anim_player.play("continue_p"+str(jugador)+"_win")
		
