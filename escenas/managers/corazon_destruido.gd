extends TextureRect

@export var texturas : Array[Texture]
var texture_id = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
 
var timer = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer > 0:
		timer -= delta * 300
	else:
		if texturas.size() - 1 > texture_id:
			texture_id += 1
			texture = texturas[texture_id]
			timer = 10 
		else:
			visible = false
