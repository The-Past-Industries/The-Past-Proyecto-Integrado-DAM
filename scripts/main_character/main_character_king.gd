extends CharacterBody3D
class_name PlayerBody

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

# Transitions
var player_on_transition: bool = false
var transition_is_teleporting: bool = false
var transition_original_position: Vector3
var transition_elapsed_time: float = 0.0
var transition_phase := "idle"
signal transition_teleport_finished

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
	if transition_is_teleporting:
		animate_teleport_jump(delta)
	
	# Caída por gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Bloqueo del movimiento del Player
	if is_locked || player_on_transition:
		velocity = Vector3.ZERO
	
	else:
		
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		if direction != Vector3.ZERO:
			velocity.x = sign(direction.x) * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	
	move_and_slide()


# INPUT ACTIONS
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			attack_animation()
		if event.button_index == MOUSE_BUTTON_RIGHT:
			pass

# IN GAME TRANSITIONS
func start_transition(name: String):
	player_on_transition = true
	match name:
		"teleport":
			transition_is_teleporting = true
		_:
			player_on_transition = false

func animate_teleport_jump(delta: float) -> void:
	var total_duration := 0.7
	var wait_duration := 0.5
	var target_position := Vector3(0, 0, 1)

	if transition_phase == "idle":
		transition_original_position = global_position
		transition_elapsed_time = 0.0
		transition_phase = "moving"
		return

	if transition_phase == "moving":
		transition_elapsed_time += delta
		var t: float = clamp(transition_elapsed_time / total_duration, 0.0, 1.0)
		var eased_t: float = t * t * (3.0 - 2.0 * t) # smoothstep
		global_position = transition_original_position.lerp(target_position, eased_t)

		if t >= 1.0:
			transition_elapsed_time = 0.0
			transition_phase = "wait"
		return

	if transition_phase == "wait":
		transition_elapsed_time += delta
		global_position = target_position
		if transition_elapsed_time >= wait_duration:
			transition_phase = "idle"
			player_on_transition = false
			transition_is_teleporting = false
			set_physics_process(true)
			emit_signal("transition_teleport_finished")
