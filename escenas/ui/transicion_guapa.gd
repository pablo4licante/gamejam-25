extends Node2D

@onready var anim_player : AnimationPlayer = $AnimationPlayer

func speed(mult) -> void:
	anim_player.speed_scale = mult

func playing() -> bool: 
	return anim_player.current_animation_position < 4

func play() -> void:
	anim_player.play("count")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
