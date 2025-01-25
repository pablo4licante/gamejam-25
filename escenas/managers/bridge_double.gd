extends Node2D

var tipo_interfaz = 1

@export var finished = false
@export var puntuacion1 = 0
@export var puntuacion2 = 0
@export var dificultad = 1 

@export var action_map = { 
	1: {
		"up": [0.0, false],
		"down": [0.0, false],
		"left": [0.0, false],
		"right": [0.0, false],
		"action": [0.0, false]
	},
	2: {
		"up": [0.0, false],
		"down": [0.0, false],
		"left": [0.0, false],
		"right": [0.0, false],
		"action": [0.0, false]
	} 
}

func is_pressed(key, player) -> bool:
	var map
	if action_map.has(player):
		map = action_map[player]  
	else:
		printerr("is_pressed: No se ha podido encontrar jugador " + player)
		return false

	if map.has(key): 
		return map[key][1]
	else:
		printerr("is_pressed: No se ha podido encontrar el control " + key)

	return false
  
func get_strength(key, player) -> float:
	var map
	if action_map.has(player):
		map = action_map[player]  
	else:
		printerr("get_strength: No se ha podido encontrar jugador " + player)
		return 0.0

	if map.has(key): 
		return map[key][0]
	else:
		printerr("get_strength: No se ha podido encontrar el control " + key)

	return 0.0
