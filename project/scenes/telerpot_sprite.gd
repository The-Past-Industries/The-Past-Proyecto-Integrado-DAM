extends Node3D

@onready var animated_sprite = $AnimatedSprite3D

func _ready():
	# animated_sprite.connect("playing", self, "_on_animated_sprite_playing")
	pass

func _on_animated_sprite_playing():
	_create_teleport_cylinder()

func _create_teleport_cylinder():
	# Create a CylinderMesh to act as the glowing teleport pillar
	var cylinder = MeshInstance3D.new()
	var mesh = CylinderMesh.new()
	mesh.top_radius = 0.5
	mesh.bottom_radius = 0.5
	mesh.height = 3.0
	mesh.radial_segments = 32
	cylinder.mesh = mesh

	# Create a new SpatialMaterial with emissive white color
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(1, 1, 1, 0.8)
	mat.emission_enabled = true
	mat.emission = Color(1, 1, 1)
	mat.emission_energy = 2.5
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.flags_unshaded = true
	mat.flags_transparent = true
	mat.flags_albedo_from_vertex_color = false
	cylinder.material_override = mat

	# Position it slightly above the node base
	cylinder.translation = Vector3(0, mesh.height / 2, 0)

	# Add a slight upward animation via a Tween
	add_child(cylinder)

	var tween = create_tween()
	tween.set_speed_scale(1.0)
	tween.tween_property(cylinder, "scale", Vector3(1, 1.3, 1), 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(cylinder, "scale", Vector3(1, 1, 1), 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.set_loops()
