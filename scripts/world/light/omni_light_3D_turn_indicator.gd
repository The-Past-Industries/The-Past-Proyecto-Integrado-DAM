extends OmniLight3D

@export var base_energy: float = 1.5
@export var wave_amplitude: float = 0.5
@export var wave_speed: float = 1.0

var time: float = 0.0

func _process(delta: float) -> void:
	time += delta * wave_speed
	light_energy = base_energy + sin(time) * wave_amplitude
