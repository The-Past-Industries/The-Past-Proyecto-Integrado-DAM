extends CharacterBody3D

@onready var animated_sprite_3d = $AnimatedSprite3D

func _physics_process(delta):
	animated_sprite_3d.play("idle")
	# Caída por gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	pass
