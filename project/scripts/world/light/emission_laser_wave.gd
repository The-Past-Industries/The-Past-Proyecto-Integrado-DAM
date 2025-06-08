extends MeshInstance3D

@export var wave_speed: float = 2.0
@export var brightness_boost: float = 0.3

var material: StandardMaterial3D
var base_emission_color: Color
var t: float = 0.0

func _ready():
	material = get_active_material(0)
	if material == null:
		push_error("MeshInstance3D has no material.")
		set_process(false)
		return

	material = material.duplicate() as StandardMaterial3D
	set_surface_override_material(0, material)

	base_emission_color = material.emission
	material.emission_enabled = true

func _process(delta: float) -> void:
	t += delta * wave_speed
	var strength := (sin(t) + 1.0) / 2.0 * brightness_boost
	material.emission = base_emission_color.lightened(strength)
