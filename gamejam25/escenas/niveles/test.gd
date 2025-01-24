extends Node2D
 
@onready var bridge = $Bridge
 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bridge.puntuacion += 1;

	if bridge.is_pressed("up"):
		get_node("CanvasLayer/Panel/MeshInstance2D").position.y += 1
		print("si")

	pass
