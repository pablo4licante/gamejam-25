extends Node2D

var tipo_interfaz = 0

@export var puntuacion = 0 
@export var action_map = {
	"up": false,
	"down": false,
	"left": false,
	"right": false,
	"action": false,
}

func is_pressed(key) -> bool:
    if action_map.has(key): 
        return action_map[key]
    else:
        printerr("is_pressed: No se ha podido encontrar el control " + key)

    return false
 