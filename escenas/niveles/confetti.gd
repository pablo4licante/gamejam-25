@tool
extends Node2D
"""
Draw-based 2D confetti particles emitter.
"""
 
# If `true`, particles are being emitted.
@export var emitting: bool = false : set = _set_emitting 
# The type of particles: 0 (Square), 1 (Circle).
@export var type: int = 0
# The number of particles.
@export var amount: int = 150
# If `true`, the number of particles can be a random number between `amount / 2` and `amount * 2`.
@export var random_amount: bool = true
# The size of the particles.
@export var size: float = 3.0
# If `true`, the size of the particles can be random between `size / 2` and `size * 2`.
@export var random_size: bool = true
# Controls the visibility of the particles.
@export var visibility_rect: Rect2 = Rect2(Vector2.ZERO, Vector2(1024, 600))
# The color/s of the particles.
@export var colors: Array[Color] = [
	Color("#008751"),
	Color("#00e436"),
	Color("#29adff"),
	Color("#7e2553"),
	Color("#83769c"),
	Color("#ff004d"),
	Color("#ff77a8"),
	Color("#ffa300"),
	Color("#ffec27")
]
# If `true`, the initial position of the particles can be random within `visibility_rect`.
@export var random_position: bool = true
# If `true`, only one emission cycle occurs.
@export var one_shot: bool = false
# If `true`, the particles will gradually fade.
@export var fade: bool = true
# The duration (in seconds) of the emission cycle.
@export var timer_wait_time: float = 1.0

var particles: Array[Dictionary] = []
var particles_amount: int
var particles_position: Vector2
var timer: float = 0.0

func _ready() -> void:
	set_process(true)  
	


func _process(delta: float) -> void: 
	timer += delta

	if timer > timer_wait_time:
		timer = 0.0

		if one_shot:
			emitting = false
		else:
			_create_particles()

	_particles_explode(delta)  
	queue_redraw()


func _draw() -> void:
	for particle in particles:
		if type == 0:
			draw_rect(Rect2(particle["position"], particle["size"]), particle["color"])
		elif type == 1:
			draw_circle(
				particle["position"], ((particle["size"].x + particle["size"].y) / 2) / 2, particle["color"]
			)


func _create_particles() -> void:
	particles.clear()

	particles_amount = _get_random_amount() if random_amount else amount
	particles_position = _get_random_position() if random_position else Vector2.ZERO

	for _i in particles_amount:
		var particle = {
			"color": _get_random_color(),
			"gravity": _get_random_gravity(),
			"position": particles_position,
			"size": _get_random_size() if random_size else Vector2(size, size),
			"velocity": _get_random_velocity()
		}

		particles.append(particle)


func _particles_explode(delta: float) -> void:
	for particle in particles:
		if fade:
			particle["color"].a -= 0.6 * delta

		particle["velocity"].x *= 0.999
		particle["velocity"].y *= 0.991

		particle["position"] += (particle["velocity"] + particle["gravity"]) * delta


func _get_random_color() -> Color:
	return colors[randi() % colors.size()]


func _get_random_gravity() -> Vector2:
	return Vector2(randf_range(-200, 200), randf_range(400, 800))


func _get_random_amount() -> int:
	return int(randf_range(amount / 2.0, amount * 2.0))


func _get_random_position() -> Vector2:
	var x = randf_range(0, visibility_rect.size.x)
	var y = randf_range(0, visibility_rect.size.y)

	return Vector2(x, y)


func _get_random_size() -> Vector2:
	var min_size = ceil(size / 2.0)
	var max_size = ceil(size * 2.0)
	var random_min_max_size = randi() % int(max_size - min_size + 1) + int(min_size)

	return Vector2(random_min_max_size, random_min_max_size)


func _get_random_velocity() -> Vector2:
	return Vector2(randf_range(-200, 200), randf_range(-600, -800))


func _set_emitting(new_value: bool) -> void:
	if new_value != emitting:
		emitting = new_value

		if emitting:
			set_process(true)
			_create_particles()
		else: 
			timer = 0.0  
			notify_property_list_changed()
