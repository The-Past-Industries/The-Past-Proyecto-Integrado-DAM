extends Node3D
class_name VFXPlayer

const PARAMETER_PATH := "parameters/conditions/"

@onready var animated_sprite_3d = $AnimatedSprite3D
@onready var animation_tree = $AnimationTree
@onready var omni_light_3d = $OmniLight3D

var projectile_active := false
var projectile_animation_name := ""
var projectile_start_pos := 0.0
var projectile_target_pos := 0.0
var projectile_duration := 0.8
var projectile_elapsed := 0.0

signal translation_finished

func _ready():
	Logger.info("VFXPlayer: Initialized!")
	animation_tree.active = true
	VFXManagerGlobal.vfx_player = self
	animation_tree.set(PARAMETER_PATH + "empty", true)
	global_position.y = 2

func _process(delta):
	if EntityManagerGlobal.player:
		animated_sprite_3d.flip_h = !EntityManagerGlobal.player.body_instance.is_facing_left
		

	if projectile_active:
		projectile_elapsed += delta
		var t :float = clamp(projectile_elapsed / projectile_duration, 0.0, 1.0)
		global_position.x = lerp(projectile_start_pos, projectile_target_pos, t)
		if t >= 1.0:
			animation_tree.set(PARAMETER_PATH + projectile_animation_name, false)
			projectile_active = false
			emit_signal("translation_finished")

func launch_animation(animation_name: String = "empty", loop: bool = false):
	if VFXManagerGlobal.is_on_animation:
		return

	Logger.info("VFXPlayer: Playing %s animation" % animation_name)

	var custom_launch: bool = false
	omni_light_3d.visible = true
	omni_light_3d.light_energy = 3
	_disable_all_animations()
	back_to_origin()

	Logger.info("VFXPlayer: Animation [%s] tried." % animation_name)
	match animation_name:
		"holy_1_projectile_normal":
			custom_launch = true
			global_position.y -= 0.5
			launch_projectile_to_enemy("holy_1_projectile_normal")
		"holy_2_light_pilar":
			custom_launch = true
			animation_tree.set(PARAMETER_PATH + "holy_3_summon_sword", true)
			await animation_tree.animation_finished
			animation_tree.set(PARAMETER_PATH + "holy_3_summon_sword", false)
			tp_to_enemy()
			global_position.y -= 0.5
			animation_tree.set(PARAMETER_PATH + animation_name, true)
			await animation_tree.animation_finished
			animation_tree.set(PARAMETER_PATH + "holy_3_summon_sword", false)
			animation_tree.set(PARAMETER_PATH + animation_name, false)
		"holy_6_bells_aura":
			custom_launch = true
			global_position.y -= 0.5
			animation_tree.set(PARAMETER_PATH + animation_name, true)
			await animation_tree.animation_finished
			animation_tree.set(PARAMETER_PATH + animation_name, false)
			tp_to_enemy()
			animation_tree.set(PARAMETER_PATH + "holy_12_light_diamond", true)
			await animation_tree.animation_finished
			animation_tree.set(PARAMETER_PATH + "holy_12_light_diamond", false)
		"holy_7_ball_random":
			custom_launch = true
			global_position.y -= 1
			launch_projectile_to_enemy("holy_7_ball_random")
			await animation_tree.animation_finished
			animation_tree.set(PARAMETER_PATH + "holy_9_little_implosion", true)
			animation_tree.set(PARAMETER_PATH + "holy_9_little_implosion", false)
		"holy_7_light_pop":
			tp_to_enemy()
		"holy_8_suriken":
			custom_launch = true
			launch_projectile_to_enemy("holy_1_projectile_normal")
			await animation_tree.animation_finished
			animation_tree.set(PARAMETER_PATH + "holy_1_light_explosion", true)
			animation_tree.set(PARAMETER_PATH + "holy_1_light_explosion", false)
		"holy_10_light_cast":
			custom_launch = true
			global_position.y -= 0.5
			animation_tree.set(PARAMETER_PATH + animation_name, true)
			await get_tree().create_timer(2).timeout
			animation_tree.set(PARAMETER_PATH + animation_name, false)
			tp_to_enemy()
			animation_tree.set(PARAMETER_PATH + "holy_12_light_diamond", true)
			await animation_tree.animation_finished
			animation_tree.set(PARAMETER_PATH + "holy_12_light_diamond", false)
		"holy_11_light_hit_pop":
			animated_sprite_3d.flip_h = !animated_sprite_3d.flip_h 
			global_position.x += 0.7
		_:
			pass

	if !custom_launch:
		animation_tree.set(PARAMETER_PATH + animation_name, true)
		await animation_tree.animation_finished
		animation_tree.set(PARAMETER_PATH + animation_name, false)
	
	omni_light_3d.visible = false

func tp_to_enemy():
	var entity
	if EntityManagerGlobal.enemy != null:
		entity = EntityManagerGlobal.enemy
	elif EntityManagerGlobal.boss != null:
		entity = EntityManagerGlobal.boss
	global_position.x = entity.body_instance.global_position.x

func back_to_origin():
	global_position.x = EntityManagerGlobal.player.body_instance.global_position.x
	global_position.z = 1.5
	global_position.y = 0.8

func launch_projectile_to_enemy(animation_name: String, duration: float = 0.8) -> void:
	if EntityManagerGlobal.enemy == null:
		return

	_disable_all_animations()

	global_position.x = EntityManagerGlobal.player.body_instance.global_position.x
	var entity = EntityManagerGlobal.enemy if EntityManagerGlobal.enemy else EntityManagerGlobal.boss

	projectile_start_pos = global_position.x
	projectile_target_pos = entity.body_instance.global_position.x
	projectile_elapsed = 0.0
	projectile_duration = duration
	projectile_animation_name = animation_name
	projectile_active = true

	animation_tree.set(PARAMETER_PATH + animation_name, true)
	await translation_finished
	animation_tree.set(PARAMETER_PATH + animation_name, false)

func _disable_all_animations():
	var animation_names = [
		"holy_1_light_explosion",
		"holy_1_projectile_normal",
		"holy_1_projectile_small",
		"holy_2_light_pilar",
		"holy_3_summon_sword",
		"holy_4_light_parry",
		"holy_5_light_delayed_exposion",
		"holy_6_bells_aura",
		"holy_7_ball_random",
		"holy_7_light_pop",
		"holy_7_little_explosion",
		"holy_8_suriken",
		"holy_9_little_implosion",
		"holy_10_light_cast",
		"holy_11_light_hit_pop",
		"holy_12_light_diamond",
	]
	for animation in animation_names:
		animation_tree.set(PARAMETER_PATH + animation, false)
