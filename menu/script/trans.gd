extends CanvasLayer

@onready var anim: AnimationPlayer = $ColorRect/trans_anim
@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	if not anim:
		push_error("AnimationPlayer 'trans_anim' no encontrado")
		return
	
	if not color_rect:
		push_error("ColorRect no encontrado")
		return
	
	if not anim.has_animation("TransAnimation"):
		push_error("Animación 'TransAnimation' no encontrada")
		return
	
	color_rect.visible = false

func change_screen(path: String) -> void:
	if not anim or not color_rect:
		push_error("No se puede realizar la transición: Nodos no encontrados")
		get_tree().change_scene_to_file(path)
		return
	
	# Mostrar el ColorRect
	color_rect.visible = true
	
	# Cambiar la escena y reproducir la animación simultáneamente
	get_tree().change_scene_to_file(path)
	anim.play("TransAnimation")
	
	# Esperar a que termine la animación
	await anim.animation_finished
	
	# Ocultar el ColorRect
	color_rect.visible = false
