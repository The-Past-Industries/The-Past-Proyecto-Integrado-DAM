extends CharacterBody3D
class_name Player3D

@onready var animated_sprite_3d = $AnimatedSprite3D
@onready var animation_tree = $AnimationTree

const SPEED = 3.0

# Gameplay conditions
var is_locked: bool = false
var is_hitting: bool = false
var is_dying: bool = false

# Physics conditions
var is_attacking: bool
var is_moving: bool
var is_facing_left: bool
var is_jumping: bool
var is_falling: bool
var is_idle: bool
var is_moving_vert: bool

func _process(_delta):
	#Animations
	is_moving = velocity.x != 0
	is_facing_left= velocity.x < 0
	is_jumping = velocity.y < 0
	is_falling = velocity.y > 0
	is_idle = !is_moving and !is_jumping and !is_falling
	is_moving_vert = is_jumping or is_falling
	if is_moving:
		animated_sprite_3d.flip_h = is_facing_left
	
	updateAnimation()

func updateAnimation():
	animation_tree.set("parameters/conditions/death", is_dying)
	animation_tree.set("parameters/conditions/hit", is_hitting)
	animation_tree.set("parameters/conditions/jump", is_jumping)
	animation_tree.set("parameters/conditions/fall", is_falling)
	animation_tree.set("parameters/conditions/idle", is_idle)
	animation_tree.set("parameters/conditions/run", is_moving and !is_moving_vert)
	animation_tree.set("parameters/conditions/attack", is_attacking)

func attack_animation():
	is_attacking = true
	is_idle = false
	await animation_tree.animation_finished
	is_attacking = false
	is_idle = true

func hit_animation():
	is_hitting = true
	is_idle = false
	await animation_tree.animation_finished
	is_hitting = false
	is_idle = true

func _physics_process(delta):
	
	
	# Caída por gravedad
	#if not is_on_floor():
	#	velocity += get_gravity() * delta
	
	
	# Bloqueo del movimiento del Player
	if is_locked:
		velocity = Vector3.ZERO
	
	else:
		
		# ACCIONES DE ENTRADA DE TECLADO
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	
	# Inicio de la física del Player
	move_and_slide()


# ACCIONES DE ENTRADA DE RATÓN
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			pass
		if event.button_index == MOUSE_BUTTON_RIGHT:
			pass
