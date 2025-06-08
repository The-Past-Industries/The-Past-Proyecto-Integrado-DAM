extends SpotLight3D

@export var noise_speed := 1.0
@export var intensity_variation := 1
@export var base_energy := 7.0
@export var noise_scale := 1.0

var time_accum := 0.0
var noise := FastNoiseLite.new()

func _ready():
	# Configura el tipo de ruido si quieres un patrón más suave o caótico
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.5

func _process(delta):
	time_accum += delta * noise_speed
	var n = noise.get_noise_1d(time_accum * noise_scale)
	
	# Oscila la energía del foco con ruido
	light_energy = base_energy + (n * intensity_variation)
