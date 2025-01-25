extends Node2D
 
@onready var bridge = $BridgeDouble
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	if bridge.is_pressed("up", 1):
		get_node("CanvasLayer/Panel/MeshInstance2D").position.y += 1
		print("moviendo jugador 1")
		bridge.puntuacion1 += 1;

	if bridge.is_pressed("up", 2):
		get_node("CanvasLayer/Panel/MeshInstance2D2").position.y += 1
		print("moviendo jugador 2")
		bridge.puntuacion2 += 1;

	pass
