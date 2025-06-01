extends MeshInstance3D

@export var emission_color := Color(1, 1, 1) 
@export var breath_speed := 2.0
@export var breath_intensity := 1.0

var time := 0.0

func _process(delta):
	time += delta * breath_speed
	var factor := (sin(time) * 0.5 + 0.5)
	var final_color := emission_color.lerp(Color.WHITE, factor) * breath_intensity

	var mat := get_active_material(0)
	if mat and mat is StandardMaterial3D:
		mat.emission = final_color
