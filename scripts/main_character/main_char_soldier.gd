class_name Player extends CharacterBody2D

var data : PlayerData = PlayerDataManager

#Animation
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

#Menu & Indicators
@onready var indicator = $Indicator_Sprite2D

#Motion
const SPEED = 200.0
const JUMP_VELOCITY = -300.0

var is_locked: bool = false
var is_on_combat_place: bool = true
var is_in_combat: bool = false

func _process(delta: float) -> void:
	
	#Animations
	var is_moving: bool = velocity.x != 0
	var is_facing_left: bool = velocity.x < 0
	var is_jumping: bool = velocity.y < 0
	var is_falling: bool = velocity.y > 0
	var is_idle: bool = !is_moving and !is_jumping and !is_falling
	var is_moving_vert: bool = is_jumping or is_falling
	
	var is_taking_hit = false
	var is_dead = data.health <= 0
	
	if is_moving:
		sprite.flip_h = is_facing_left
	
	anim_tree.set("parameters/conditions/jumping", is_jumping)
	anim_tree.set("parameters/conditions/falling", is_falling)
	anim_tree.set("parameters/conditions/idle", is_idle)
	anim_tree.set("parameters/conditions/running", is_moving and !is_moving_vert)

func animations_attack(physical: bool):
	anim_tree.set("parameters/conditions/attacking1", physical)
	anim_tree.set("parameters/conditions/attacking2", !physical)
	await(anim_tree.animation_finished)
	anim_tree.set("parameters/conditions/attacking1", false)
	anim_tree.set("parameters/conditions/attacking2", false)

func animation_hit():
	anim_tree.set("parameters/conditions/hit", true)
	await(anim_tree.animation_finished)
	anim_tree.set("parameters/conditions/hit", false)

func animation_death():
	anim_tree.set("parameters/conditions/death", true)
	await(anim_tree.animation_finished)
	get_tree().quit()

#Motion
func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_locked:
		if is_on_combat_place:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		else:
			walk_to_combat(delta)
	else:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()

#Status Actions
func die():
	pass

func walk_to_combat(delta):
	var target_position = 170
	velocity.x = move_toward(position.x, target_position, SPEED/2 * delta)
	if abs(position.x - target_position) < 1.0:
		position.x = target_position
		is_on_combat_place = true

#Input Actions
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			pass
		if event.button_index == MOUSE_BUTTON_RIGHT:
			pass


#Indicator
func show_indicator(target: bool):
	indicator.visible = true
	set_indicator_animation(target)

func set_indicator_animation(target: bool):
	if !target:
		indicator.set_selected_animation()
	else:
		indicator.set_target_animation()

func hide_indicator():
	indicator.visible = false
