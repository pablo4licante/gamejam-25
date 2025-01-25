extends Node2D

var tipo_interfaz = 0
var jugador = 0

@export var finished = false
@export var puntuacion = 0 
@export var dificultad = 1 
@export var action_map = { 
	"up": [0.0, false, false, false], # strength pressed just_pressed just_released
	"down": [0.0, false, false, false], 
	"left": [0.0, false, false, false],
	"right": [0.0, false, false, false],
	"action": [0.0, false, false, false],
}

func just_released(key) -> bool:
	if action_map.has(key): 
		return action_map[key][3]
	else:
		printerr("just_released: No se ha podido encontrar el control " + key)

	return false

func just_pressed(key) -> bool:
	if action_map.has(key): 
		return action_map[key][2]
	else:
		printerr("just_pressed: No se ha podido encontrar el control " + key)

	return false

func is_pressed(key) -> bool:
	if action_map.has(key): 
		return action_map[key][1]
	else:
		printerr("is_pressed: No se ha podido encontrar el control " + key)

	return false

func get_strength(key) -> float:
	if action_map.has(key): 
		return action_map[key][0]
	else:
		printerr("get_strength: No se ha podido encontrar el control " + key)

	return 0.0
 
