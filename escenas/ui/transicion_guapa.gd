extends Node2D

@onready var anim_player : AnimationPlayer = $AnimationPlayer

@onready var frase_hincha = preload("res://assets/ui/frase_hincha.png")
@onready var frase_corre = preload("res://assets/ui/frase_corre.png")
@onready var frase_dispara = preload("res://assets/ui/frase_explota.png")
@onready var frase_esquiva = preload("res://assets/ui/frase_esquiva.png")

@onready var texto = $TEXTO

func speed(mult) -> void:
	anim_player.speed_scale = mult

func playing() -> bool: 
	return anim_player.current_animation_position < 4

func change_text(mensaje) -> void:
	print("SABES QUE TENGO GANAS DE DORMIR PERO EL NOMBRE DEL NIVEL ES: ", mensaje)
	match mensaje:
		"game_chicle":
			texto.texture = frase_hincha
		"game_pinchos":
			texto.texture = frase_esquiva
		"escena_plataformas_1":
			texto.texture = frase_corre
		"escena_plataformas_2":
			texto.texture = frase_corre
		"dispara_1":
			texto.texture = frase_dispara
			
func play() -> void:
	anim_player.play("count")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
