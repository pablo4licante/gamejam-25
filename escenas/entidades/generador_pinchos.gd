extends Node2D

# Carga la escena del pincho
@export var spike_scene: PackedScene
@export var spawn_interval: float = 1.0 # Tiempo entre spawns
@export var spawn_area_width: float = 800.0 # Ancho del área de spawn
@export var spawn_height: float = -250.0 # Altura inicial de los pinchos (fuera de la pantalla)

@onready var bridge = $"../Bridge"

var timer = 0.0

func _process(delta: float) -> void:
	timer += delta
	if timer >= spawn_interval:
		timer = 0.0
		spawn_spike()

func spawn_spike() -> void:
	# Instanciar un nuevo pincho
	var spike = spike_scene.instantiate()
	bridge.play_sound("chincheta")
	# Posicionar el pincho en una posición aleatoria dentro del área de spawn
	var random_x = randf_range(0, spawn_area_width)
	spike.position = Vector2(random_x, spawn_height)
	
	# Añadirlo como hijo de este nodo
	add_child(spike)
