extends OmniLight3D

@export var base_energy: float = 1.0
@export var wave_amplitude: float = 0.3
@export var noise_amplitude: float = 0.2
@export var wave_speed: float = 2.0
@export var noise_speed: float = 0.8

var _time_passed: float = 0.0
var _noise := FastNoiseLite.new()
var _noise_seed_offset: float

func _ready():
	light_energy = base_energy
	_noise_seed_offset = randi() % 10000
	_noise.seed = int(_noise_seed_offset)
	_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	_noise.frequency = 0.5

func _process(delta: float) -> void:
	_time_passed += delta
	var wave = sin(_time_passed * wave_speed) * wave_amplitude
	var noise_val = _noise.get_noise_1d(_time_passed * noise_speed) * noise_amplitude
	light_energy = base_energy + wave + noise_val
