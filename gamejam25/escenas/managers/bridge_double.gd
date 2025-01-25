extends Node2D

var tipo_interfaz = 1

@export var puntuacion1 = 0
@export var puntuacion2 = 0
 
@export var action_map = { 
	1: {
		"up": false,
		"down": false,
		"left": false,
		"right": false,
		"action": false 
	},
	2: {
		"up": false,
		"down": false,
		"left": false,
		"right": false,
		"action": false 
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
		return map[key]
	else:
		printerr("is_pressed: No se ha podido encontrar el control " + key)

	return false
 