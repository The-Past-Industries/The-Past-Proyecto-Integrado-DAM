extends MeshInstance3D

@export var wave_speed: float = 2.0
@export var brightness_boost: float = 0.3
@export var emission_on: bool = false

var mat_instance: StandardMaterial3D
var base_color: Color
var time := 0.0

func _ready():
	var material := get_surface_override_material(0)
	if material == null:
		Logger.error("No override material on surface 0.")
		set_process(false)
		return

	mat_instance = material.duplicate() as StandardMaterial3D
	set_surface_override_material(0, mat_instance)

	base_color = mat_instance.emission
	mat_instance.emission_enabled = true

func _process(delta: float):
	if emission_on:
		time += delta * wave_speed
		var brightness := (sin(time) + 1.0) / 2.0 * brightness_boost
		var light_color := base_color.lightened(brightness)
		mat_instance.emission = light_color
