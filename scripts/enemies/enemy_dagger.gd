extends CharacterBody3D

@onready var animated_sprite_3d = $AnimatedSprite3D

func _physics_process(delta):
	
	# Caída por gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()


# ACCIONES DE ENTRADA DE RATÓN
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			animated_sprite_3d.play("attack_short")
		if event.button_index == MOUSE_BUTTON_RIGHT:
			animated_sprite_3d.play("attack_long")
	await(animated_sprite_3d.animation_finished)
	animated_sprite_3d.play("idle")
