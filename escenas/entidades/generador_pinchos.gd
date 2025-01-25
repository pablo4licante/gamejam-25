extends Node2D

# Carga la escena del pincho
@export var spike_scene: PackedScene
@export var spawn_area_width: float = 150.0 # Ancho del área de spawn
@export var spawn_height: float = -30.0 # Altura inicial de los pinchos (fuera de la pantalla)
@export var spike_count = 10

@onready var gp = $"../GeneradorPinchos"

@onready var bridge = $"../Bridge"

@onready var personaje = $"../personaje_1"

var timer = 0.0

func _process(delta: float) -> void:
	var spawn_interval = bridge.tiempo_de_juego/10
	if(bridge.in_game):
		timer += delta 
		if timer >= (spawn_interval):
			print(spawn_interval)
			timer = 0.0
			spawn_spike()

func spawn_spike() -> void:
	# Instanciar un nuevo pincho
	var spike = spike_scene.instantiate()
	
	# Posicionar el pincho en una posición aleatoria dentro del área de spawn
	var random_x = randf_range(0.0, spawn_area_width)
	var direction = randi_range(0, 1)
	if(personaje != null):
		
		print(personaje.position.x)
		if(direction == 0):
			spike.position.x = personaje.position.x - random_x
		if(direction == 1):
			spike.position.x = personaje.position.x + random_x
			
		spike.position.y = spawn_height
		bridge.play_sound("chincheta")
		# Añadirlo como hijo de este nodo
		gp.add_child(spike)
