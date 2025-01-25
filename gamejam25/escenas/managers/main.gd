extends Node2D

@export var viewport1 : Viewport
@export var viewport2 : Viewport
  
var nivel_actual = ""
var nivel_seleccionado = "test"

var puntuacion_1 = 0
var puntuacion_2 = 0

var puente_juego1 : Node2D
var puente_juego2 : Node2D

var puntos_juego1_actual = 0
var puntos_juego2_actual = 0

func actualizar_controles(jugador) -> void:
	var puente : Node2D = null

	match jugador:
		1:
			puente = puente_juego1 
		2:
			puente = puente_juego2 
		_:
			printerr("actualizar_controles: Jugador no valido! " + str(jugador))

	if puente != null: 
		var cont = str(jugador) 
		puente.action_map["up"] = Input.is_action_pressed(cont+"_up") 
		puente.action_map["down"] = Input.is_action_pressed(cont+"_down") 
		puente.action_map["left"] = Input.is_action_pressed(cont+"_left") 
		puente.action_map["right"] = Input.is_action_pressed(cont+"_right") 
		puente.action_map["action"] = Input.is_action_pressed(cont+"_action")  

func cuantificar_puntos() -> void:
	if puente_juego1 == null or puente_juego2 == null:
		return

	if puente_juego1.puntuacion > puntos_juego1_actual:
		puntuacion_1 += (puente_juego1.puntuacion - puntos_juego1_actual)

	if puente_juego2.puntuacion > puntos_juego2_actual:
		puntuacion_2 += (puente_juego2.puntuacion - puntos_juego2_actual)

	print("Puntos 1:", puntuacion_1)
	print("Puntos 2:", puntuacion_2)
	 
	pass

func cargar_nivel(nombre) -> void: 
	var path = "res://escenas/niveles/test.tscn" 
	var status = ResourceLoader.load_threaded_request(path) 
	print("Cargando... " + error_string(status))  
	if status == Error.OK: 
		var scene = ResourceLoader.load_threaded_get(path)
		var game_scene = scene.instantiate() 
		puente_juego1 = game_scene.get_node("Bridge")
		puntos_juego1_actual = 0
		viewport1.add_child(game_scene)
		
		var game_scene2 = scene.instantiate()
		puente_juego2 = game_scene2.get_node("Bridge")
		puntos_juego2_actual = 0
		viewport2.add_child(game_scene2)

		nivel_actual = nombre
		print("Se ha cargado el nivel " + nombre)
	else:
		print(status)

	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	cuantificar_puntos()
	actualizar_controles(1) 
	actualizar_controles(2)

	if nivel_actual == nivel_seleccionado:
		return

	cargar_nivel(nivel_seleccionado)

	
	 
