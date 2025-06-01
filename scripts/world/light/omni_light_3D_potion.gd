extends OmniLight3D

@export var base_energy := 1.5
@export var twinkle_amplitude := 0.5
@export var twinkle_speed := 1.0
@export var twinkle_noise := true

var time := 0.0
var time_offset := 0.0
var noise := FastNoiseLite.new()

func _ready():
	# Desfase aleatorio único por nodo
	time_offset = randf() * TAU  # entre 0 y 2π
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.5

func _process(delta):
	time += delta * twinkle_speed
	var flicker := sin(time + time_offset)

	if twinkle_noise:
		flicker += noise.get_noise_1d(time + time_offset)

	light_energy = base_energy + flicker * twinkle_amplitude
