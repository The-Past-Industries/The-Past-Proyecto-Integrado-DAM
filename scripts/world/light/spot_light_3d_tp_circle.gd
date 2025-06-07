extends SpotLight3D

@export var intensity_amplitude: float = 2.0
@export var position_amplitude: float = 0.1
@export var frequency: float = 40.0
@export var base_energy: float = 8.0

var origin_position: Vector3
var time := 0.0

func _ready():
	origin_position = global_position
	light_energy = base_energy

func _process(delta):
	time += delta * frequency

	# Luz: agitación rápida de energía
	var energy_noise = sin(time * 7.0) * 0.5 + randf_range(-1.0, 1.0)
	light_energy = base_energy + energy_noise * intensity_amplitude

	# Posición: vibración nerviosa
	var offset = Vector3(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized() * randf() * position_amplitude

	global_position = origin_position + offset
