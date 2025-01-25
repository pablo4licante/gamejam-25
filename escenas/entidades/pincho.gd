extends CharacterBody2D	

const GRAVITY = 30 

@export var pincho_azul : Texture2D
@export var pincho_verde : Texture2D
@export var pincho_rosa : Texture2D
@onready var sprite_2d = $Sprite2D as Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var textures = [pincho_azul, pincho_verde, pincho_rosa]
	sprite_2d.texture = textures[randi() % textures.size()]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity.y += GRAVITY
	move_and_slide()
