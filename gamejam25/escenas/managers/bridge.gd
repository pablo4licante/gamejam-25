extends Node2D

@export var puntuacion = 0
@export var action_map = {
	"up": false,
	"down": false,
	"left": false,
	"right": false,
	"action": false,
}

func is_pressed(name) -> bool:
    if action_map.has(name): 
        return action_map[name]
    else:
        printerr("is_pressed: No se ha podido encontrar el control " + name)

    return false
 