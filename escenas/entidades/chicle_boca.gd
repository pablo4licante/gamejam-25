extends Node2D
@onready var sprite_boca_a: Sprite2D = $SpriteBocaA
@onready var sprite_boca_c: Sprite2D = $SpriteBocaC
var wait = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_boca_c.show()
	sprite_boca_a.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		sprite_boca_c.hide()
		sprite_boca_a.show()
		wait = 0
	else:
		wait += delta
		if wait > 1:
			sprite_boca_c.show()
			sprite_boca_a.hide()
