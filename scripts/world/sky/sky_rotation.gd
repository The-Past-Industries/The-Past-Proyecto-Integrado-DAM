extends WorldEnvironment

@export var rotation_speed_deg: float = 10.0

var current_rotation: float = 0.0

func _process(delta: float) -> void:
	current_rotation += rotation_speed_deg * delta
	current_rotation = fmod(current_rotation, 360.0)
	environment.sky_rotation = Vector3(0, deg_to_rad(current_rotation), 0)
