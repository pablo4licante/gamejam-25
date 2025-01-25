extends Node2D

@export var viewport_juego1 : Viewport
@export var viewport_juego2 : Viewport
@export var viewport_compartido : Viewport
@export var ui_contador_carga : Label
@export var ui_contador_juego : Range
  
const TIEMPO_JUEGO = 10
const TIEMPO_TRANSICION = 3

var nivel_actual = "" 
var nivel_seleccionado = ""
var nivel_ultimo = ""

var niveles = {			# Tipo Victoria
	"test2": [0],
	"test": [0],
	"escena_plataformas_1": [0]
}
var nivel_tipo_victoria = 0

var empezado = false
var contador_carga = 0.0
var contador_juego = 0.0

var puntuacion_1 = 0
var puntuacion_2 = 0

var puente_juego1 : Node2D
var puente_juego2 : Node2D

var puntos_juego1_actual = 0
var puntos_juego2_actual = 0

func actualizar_controles(jugador) -> void:
	var puente : Node2D = null

	if puente_juego1 == null or puente_juego2 == null:
		return

	if puente_juego1.tipo_interfaz == 1:
		puente = puente_juego1
	else: 
		match jugador:
			1:
				puente = puente_juego1 
			2:
				puente = puente_juego2 
			_:
				printerr("actualizar_controles: Jugador no valido! " + str(jugador))

	if puente != null: 
		var cont = str(jugador) 

		match puente.tipo_interfaz:
			0:
				puente.action_map["up"][1] = Input.is_action_pressed(cont+"_up") 
				puente.action_map["down"][1] = Input.is_action_pressed(cont+"_down") 
				puente.action_map["left"][1] = Input.is_action_pressed(cont+"_left") 
				puente.action_map["right"][1] = Input.is_action_pressed(cont+"_right") 
				puente.action_map["action"][1] = Input.is_action_pressed(cont+"_action")  
 
				puente.action_map["up"][0] = Input.get_action_strength(cont+"_up") 
				puente.action_map["down"][0] = Input.get_action_strength(cont+"_down") 
				puente.action_map["left"][0] = Input.get_action_strength(cont+"_left") 
				puente.action_map["right"][0] = Input.get_action_strength(cont+"_right") 
				puente.action_map["action"][0] = Input.get_action_strength(cont+"_action")  
			1: 
				puente.action_map[jugador]["up"][1] = Input.is_action_pressed(cont+"_up") 
				puente.action_map[jugador]["down"][1] = Input.is_action_pressed(cont+"_down") 
				puente.action_map[jugador]["left"][1] = Input.is_action_pressed(cont+"_left") 
				puente.action_map[jugador]["right"][1] = Input.is_action_pressed(cont+"_right") 
				puente.action_map[jugador]["action"][1] = Input.is_action_pressed(cont+"_action")  
 
				puente.action_map[jugador]["up"][0] = Input.get_action_strength(cont+"_up") 
				puente.action_map[jugador]["down"][0] = Input.get_action_strength(cont+"_down") 
				puente.action_map[jugador]["left"][0] = Input.get_action_strength(cont+"_left") 
				puente.action_map[jugador]["right"][0] = Input.get_action_strength(cont+"_right") 
				puente.action_map[jugador]["action"][0] = Input.get_action_strength(cont+"_action")

func comparar_puntos() -> void:
	if not puente_juego1.finished:
		return

	if puente_juego1 == null or puente_juego2 == null:
		return
 
	match puente_juego1.tipo_interfaz:
		0:
			if puente_juego1.puntuacion >= puente_juego2.puntuacion:
				puntuacion_1 += 1

			if puente_juego2.puntuacion >= puente_juego1.puntuacion:
				puntuacion_2 += 1
		1:
			if puente_juego1.puntuacion1 >= puente_juego2.puntuacion1:
				puntuacion_1 += 1

			if puente_juego1.puntuacion2 >= puente_juego1.puntuacion1:
				puntuacion_2 += 1
	
	puente_juego1 = null
	puente_juego2 = null 

func cuantificar_puntos() -> void:
	if puente_juego1 == null or puente_juego2 == null:
		return

	match puente_juego1.tipo_interfaz:
		0:
			if puente_juego1.puntuacion > puntos_juego1_actual:
				puntuacion_1 += (puente_juego1.puntuacion - puntos_juego1_actual)

			if puente_juego2.puntuacion > puntos_juego2_actual:
				puntuacion_2 += (puente_juego2.puntuacion - puntos_juego2_actual)
		1:
			if puente_juego1.puntuacion1 > puntos_juego1_actual:
				puntuacion_1 += (puente_juego1.puntuacion1 - puntos_juego1_actual)

			if puente_juego2.puntuacion2 > puntos_juego2_actual:
				puntuacion_2 += (puente_juego2.puntuacion2 - puntos_juego2_actual)
	 
	pass
 
func buscar_bridge(node) -> Node2D:
	print(node.name)

	if node.name == "Bridge" or node.name == "BridgeDouble":
		return node
	else:
		for child in node.get_children():
			var result = buscar_bridge(child)
			if result != null:
				return result
		
		return null
  
func cargar_nivel(nombre) -> void: 
	var path = "res://escenas/niveles/"+nombre+".tscn" 
	var status = ResourceLoader.load_threaded_request(path) 
	print("Cargando... " + error_string(status))  
	if status == Error.OK: 
		var scene = ResourceLoader.load_threaded_get(path)
		var game_scene = scene.instantiate() 
	
		# Actualizar propiedades de juego
		nivel_tipo_victoria = niveles[nombre][0]
		contador_juego = TIEMPO_JUEGO
		empezado = true

		# Obtener interfaz de conexion	  
		puente_juego1 = buscar_bridge(game_scene)
		if puente_juego1 == null:
			printerr("Bridge no encontrado para nivel ", nombre)
			return
 
		# Reestablecer puntuacion
		puntos_juego1_actual = 0
		puntos_juego2_actual = 0
		  
		if viewport_juego1.get_child_count() > 0:
			viewport_juego1.remove_child(viewport_juego1.get_child(0))

		if viewport_juego2.get_child_count() > 0:
			viewport_juego2.remove_child(viewport_juego2.get_child(0))

		if viewport_compartido.get_child_count() > 0:
			viewport_compartido.remove_child(viewport_compartido.get_child(0))

		if puente_juego1.tipo_interfaz != 1:    
			# Mostrar dos ventanas de juego
			viewport_juego1.get_parent().visible = true
			viewport_juego2.get_parent().visible = true
			viewport_compartido.get_parent().visible = false

			var game_scene2 = scene.instantiate()
			puente_juego2 = buscar_bridge(game_scene2)
			puntos_juego2_actual = 0

			# Agregar pantalla de juego
			viewport_juego1.add_child(game_scene)
			viewport_juego2.add_child(game_scene2) 
		else:   
			puente_juego2 = puente_juego1

			# Mostrar solo una ventana de juego
			viewport_juego1.get_parent().visible = false
			viewport_juego2.get_parent().visible = false
			viewport_compartido.get_parent().visible = true

			# Agregar pantalla de juego
			viewport_compartido.add_child(game_scene)

		nivel_actual = nombre
		print("Se ha cargado el nivel " + nombre)
	else:
		print(status)

	pass

func seleccionar_nivel() -> String:
	var keys = niveles.keys()
	var random = keys[randi() % keys.size()]

	if random == nivel_ultimo:
		return seleccionar_nivel()

	return random


func _ready():
	viewport_juego1.get_parent().set_stretch(true)
	viewport_juego2.get_parent().set_stretch(true)
	viewport_compartido.get_parent().set_stretch(true)
	contador_carga = TIEMPO_TRANSICION

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if empezado:
		if contador_juego > 0.0:
			contador_juego -= 1 * delta   
			ui_contador_juego.value = contador_juego / TIEMPO_JUEGO * 100
			ui_contador_juego.visible = true
		else:
			ui_contador_juego.visible = false
			empezado = false
			contador_carga = TIEMPO_TRANSICION
			nivel_actual = ""
			nivel_seleccionado = "" 

		match nivel_tipo_victoria:
			0:
				cuantificar_puntos()
			1:
				comparar_puntos()
			 
		actualizar_controles(1) 
		actualizar_controles(2)

	else: 
		contador_carga -= 1 * delta 
		if contador_carga > 0:
			ui_contador_carga.visible = true
			ui_contador_carga.text = str(round(contador_carga))
		else:
			ui_contador_carga.visible = false
			nivel_seleccionado = seleccionar_nivel()
			cargar_nivel(nivel_seleccionado)
			print("Nuevo nivel seleccionado: ", nivel_seleccionado)
 
	if empezado or nivel_actual == nivel_seleccionado:
		return

	cargar_nivel(nivel_seleccionado)
	nivel_ultimo = nivel_seleccionado

	
	 
