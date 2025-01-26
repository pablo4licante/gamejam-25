extends Node2D

@export var viewport_juego1 : Viewport
@export var viewport_juego2 : Viewport
@export var viewport_compartido : Viewport 
@export var ui_contador_juego : Range
 
@export var ui_panel_juego : Panel
@export var ui_panel_vidas : Panel

@export var ui_corazon : TextureRect
@export var ui_corazon_destroy : TextureRect

@export var ui_vidas1 : BoxContainer
@export var ui_vidas2 : BoxContainer

@export var ui_resultado : Label

@export var ui_transicion : Node2D
@export var ui_final : Node2D

@export var music_player: AudioStreamPlayer2D

@export var audio_player: AudioStreamPlayer2D
@export var win_music_player: AudioStreamPlayer

@export var sounds : Array[AudioStream]


var sound_links = { 
	"acierto": 0,
	"boton": 1,
	"chincheta": 2,
	"morir": 3,
	"disparo": 4,
	"error": 5,
	"explosion": 6,
	"hinchar": 7,
	"meta": 8,
	"saltar": 9
}

var TIEMPO_JUEGO = 10.0
var TIEMPO_TRANSICION = 6.0
var TIEMPO_TRANSICION_O = 6.0

var nivel_actual = "" 
var nivel_seleccionado = ""
var nivel_precalculado = ""
var nivel_ultimo = ""

var niveles = {			# Tipo Victoria
	#"test2": [0],
	#"test": [0],
	"dispara_1": [1, "dispara"],
	"game_pinchos": [2, "esquiva"],
	"game_chicle": [0, "hincha"],
	"escena_plataformas_1": [1, "corre"],
	#"escena_plataformas_2": [1, "corre"],
	#"escena_plataformas_3": [1, "corre"],
}
var nivel_tipo_victoria = 0

var empezado = false
var contador_carga = 0.0
var contador_juego = 0.0

var vidas_1 = 5
var vidas_2 = 5

var puntuacion_1 = 0
var puntuacion_2 = 0

var puente_juego1 : Node2D
var puente_juego2 : Node2D

var puntos_juego1_actual = 0
var puntos_juego2_actual = 0

var ha_sonado = false

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
				puente.action_map["up"][3] = Input.is_action_just_released(cont+"_up") 
				puente.action_map["down"][3] = Input.is_action_just_released(cont+"_down") 
				puente.action_map["left"][3] = Input.is_action_just_released(cont+"_left") 
				puente.action_map["right"][3] = Input.is_action_just_released(cont+"_right") 
				puente.action_map["action"][3] = Input.is_action_just_released(cont+"_action")

				puente.action_map["up"][2] = Input.is_action_just_pressed(cont+"_up") 
				puente.action_map["down"][2] = Input.is_action_just_pressed(cont+"_down") 
				puente.action_map["left"][2] = Input.is_action_just_pressed(cont+"_left") 
				puente.action_map["right"][2] = Input.is_action_just_pressed(cont+"_right") 
				puente.action_map["action"][2] = Input.is_action_just_pressed(cont+"_action")

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

func borrar_hijos(nodo) -> void:
	if nodo.get_child_count() > 0: 
		for child in nodo.get_children():
			nodo.remove_child(child)

var vidas_1_old = 5
var vidas_2_old = 5

func actualizar_vidas() -> void:
	borrar_hijos(ui_vidas1)
	borrar_hijos(ui_vidas2)
	 
	for i in range(vidas_1):
		var v = ui_corazon.duplicate()
		v.visible = true
		ui_vidas1.add_child(v)
 
	for i in range(vidas_2):
		var v = ui_corazon.duplicate()
		v.visible = true
		ui_vidas2.add_child(v)

	if vidas_1_old != vidas_1:
		var v = ui_corazon_destroy.duplicate()
		v.visible = true
		ui_vidas1.add_child(v)
  
	if vidas_2_old != vidas_2:
		var v = ui_corazon_destroy.duplicate()
		v.visible = true
		ui_vidas2.add_child(v)
	 
	vidas_2_old = vidas_2
	vidas_1_old = vidas_1

func cambiar_vidas() -> void: 
	if puente_juego1 == null or puente_juego2 == null:
		return
 	
	match nivel_tipo_victoria:
		0: # Por puntos mas altos = victoria
			print(puente_juego1.puntuacion, puente_juego2.puntuacion)
			match puente_juego1.tipo_interfaz:
				0:
					if puente_juego1.puntuacion > puente_juego2.puntuacion:
						vidas_2 -= 1 
						print("Pierde 2")
					if puente_juego2.puntuacion > puente_juego1.puntuacion:
						vidas_1 -= 1 
						print("Pierde 1")
				1:
					if puente_juego1.puntuacion1 > puente_juego1.puntuacion2:
						vidas_2 -= 1
						print("Pierde 2")
					if puente_juego1.puntuacion2 > puente_juego1.puntuacion1:
						vidas_1 -= 1
						print("Pierde 1")
		1: # Llegar a una meta = victoria
			if not puente_juego1.finished:
				vidas_1 -= 1
				print("Pierde 1")
			if not puente_juego2.finished:
				vidas_2 -= 1
				print("Pierde 2")
		2: # Sobrevivir obstaculos
			match puente_juego1.tipo_interfaz:
				0:
					if puente_juego1.puntuacion < 0:
						vidas_1 -= 1
						print("Pierde 1")
					if puente_juego2.puntuacion < 0:
						vidas_2 -= 1
						print("Pierde 2")
				1:
					if puente_juego1.puntuacion1 < 0:
						vidas_1 -= 1
						print("Pierde 1")
					if puente_juego1.puntuacion2 < 0:
						vidas_2 -= 1
						print("Pierde 2")



func buscar_bridge(node) -> Node2D:
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
		   
		borrar_hijos(viewport_juego1)
		borrar_hijos(viewport_juego2)
		borrar_hijos(viewport_compartido)

		if puente_juego1.tipo_interfaz != 1:    
			# Mostrar dos ventanas de juego
			viewport_juego1.get_parent().visible = true
			viewport_juego2.get_parent().visible = true
			viewport_compartido.get_parent().visible = false

			var game_scene2 = scene.instantiate()
			puente_juego2 = buscar_bridge(game_scene2)
			puntos_juego2_actual = 0
			
			puente_juego1.audio_player = audio_player
			puente_juego2.audio_player = audio_player
			
			puente_juego1.in_game = true
			puente_juego2.in_game = true
			
			puente_juego1.sounds = sound_links
			puente_juego2.sounds = sound_links
			
			
			puente_juego1.tiempo_de_juego = TIEMPO_JUEGO
			puente_juego2.tiempo_de_juego = TIEMPO_JUEGO

			puente_juego1.jugador = 1
			puente_juego2.jugador = 2

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

	music_player.pitch_scale += (0.1/TIEMPO_JUEGO)
	if keys.size() > 1:  
		keys.erase(nivel_ultimo)
		
	var random = keys[randi() % keys.size()] 
	return random
	
 
func _ready(): 
	actualizar_vidas()
	viewport_juego1.get_parent().set_stretch(true) 
	viewport_juego2.get_parent().set_stretch(true)
	viewport_compartido.get_parent().set_stretch(true)
	contador_carga = TIEMPO_TRANSICION
	music_player = $MusicStreamPlayer2D
	music_player.play() 
	ui_final.visible = false
	for key in sound_links:
		sound_links[key] = sounds[sound_links[key]]

var loading_next = false
var contador_buff = 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
					
	if empezado:
		if contador_juego > 0.0:
			contador_juego -= 1 * delta   
			ui_contador_juego.value = contador_juego / TIEMPO_JUEGO * 100
			ui_contador_juego.visible = true
		else: 
			cambiar_vidas()
			actualizar_vidas()

			# Reducir el tiempo
			TIEMPO_JUEGO *= 0.9
			TIEMPO_TRANSICION *= 0.965
			 
			ui_contador_juego.visible = false
			empezado = false
			contador_carga = TIEMPO_TRANSICION
			contador_buff = 0.5
			nivel_actual = ""
			nivel_seleccionado = "" 
			
			if puente_juego1 != null or puente_juego2 != null:
				if puente_juego1.tipo_interfaz == 0:
					puente_juego1.in_game = false
					puente_juego2.in_game = false
   
		actualizar_controles(1) 
		actualizar_controles(2)

	else: 

		if vidas_1 == 0 or vidas_2 == 0:
			music_player.stop()
			win_music_player = $WinMusicPlayer
			if(!win_music_player.playing and !ha_sonado):
				ha_sonado = true
				win_music_player.play()
			ui_resultado.visible = true
			ui_final.visible = true
			
			if vidas_1 > vidas_2:
				ui_resultado.text = "El jugador 1 ha ganado!";
				ui_final.play(1)
				
			elif vidas_2 > vidas_1: 
				ui_resultado.text = "El jugador 2 ha ganado!";
				ui_final.play(2)
				
			else: 
				ui_resultado.text = "Empate!";
				ui_final.play(0)
				
				
			
		else: 
			contador_buff -= 1 * delta 
			contador_carga -= 1 * delta 
			 
			if contador_buff <= 0 and contador_carga < 4:
				if not loading_next: 
					print(TIEMPO_TRANSICION_O/TIEMPO_TRANSICION)
					
					nivel_precalculado = seleccionar_nivel()
					ui_transicion.change_text(nivel_precalculado)
					ui_transicion.speed(TIEMPO_TRANSICION_O/TIEMPO_TRANSICION)
					ui_transicion.play()
					loading_next = true
				 
				if loading_next:
					if ui_transicion.playing():
						ui_panel_juego.visible = false
						ui_panel_vidas.visible = true
						ui_transicion.visible = true
					else:
						contador_carga = 0
						loading_next = false 
						ui_panel_juego.visible = true
						ui_panel_vidas.visible = false
						nivel_seleccionado = nivel_precalculado
						nivel_ultimo = nivel_seleccionado
						cargar_nivel(nivel_seleccionado)
						print("Nuevo nivel seleccionado: ", nivel_seleccionado)
			else:
				ui_panel_juego.visible = false
				ui_panel_vidas.visible = true
				ui_transicion.visible = false
 
	if empezado or nivel_actual == nivel_seleccionado:
		return 

	cargar_nivel(nivel_seleccionado)

	
	 
