extends OmniLight3D

var t: float = 0.0
var noise := FastNoiseLite.new()

func _ready():
	noise.seed = randi()
	noise.frequency = 1.5

func _process(delta):
	t += delta
	var n = noise.get_noise_1d(t)
	self.light_energy = 2.0 + n * 0.5
