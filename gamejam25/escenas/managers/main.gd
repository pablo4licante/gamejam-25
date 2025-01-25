extends Node2D

@export var viewport_juego1 : Viewport
@export var viewport_juego2 : Viewport
@export var viewport_compartido : Viewport
  
var nivel_actual = ""
var nivel_seleccionado = "test2"

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
				puente.action_map["up"] = Input.is_action_pressed(cont+"_up") 
				puente.action_map["down"] = Input.is_action_pressed(cont+"_down") 
				puente.action_map["left"] = Input.is_action_pressed(cont+"_left") 
				puente.action_map["right"] = Input.is_action_pressed(cont+"_right") 
				puente.action_map["action"] = Input.is_action_pressed(cont+"_action")  
			1: 
				puente.action_map[jugador]["up"] = Input.is_action_pressed(cont+"_up") 
				puente.action_map[jugador]["down"] = Input.is_action_pressed(cont+"_down") 
				puente.action_map[jugador]["left"] = Input.is_action_pressed(cont+"_left") 
				puente.action_map[jugador]["right"] = Input.is_action_pressed(cont+"_right") 
				puente.action_map[jugador]["action"] = Input.is_action_pressed(cont+"_action")  

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

	

	print("Puntos 1:", puntuacion_1)
	print("Puntos 2:", puntuacion_2)
	 
	pass

func cargar_nivel(nombre) -> void: 
	var path = "res://escenas/niveles/"+nombre+".tscn" 
	var status = ResourceLoader.load_threaded_request(path) 
	print("Cargando... " + error_string(status))  
	if status == Error.OK: 
		var scene = ResourceLoader.load_threaded_get(path)
		var game_scene = scene.instantiate() 
		puente_juego1 = game_scene.get_node("Bridge") 
		if puente_juego1 == null: 
			puente_juego1 = game_scene.get_node("BridgeDouble")

		puntos_juego1_actual = 0
 
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
			puente_juego2 = game_scene2.get_node("Bridge")
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	cuantificar_puntos()
	actualizar_controles(1) 
	actualizar_controles(2)

	if nivel_actual == nivel_seleccionado:
		return

	cargar_nivel(nivel_seleccionado)

	
	 
