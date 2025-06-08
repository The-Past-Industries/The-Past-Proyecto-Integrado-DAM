extends Node3D
class_name VFXPlayer

const PARAMETER_PATH := "parameters/conditions/"

# -- ANIMATION CONDITION NAMES --
#	"empty"
#	"holy_1_light_explosion"
#	"holy_1_projectile_normal"
#	"holy_1_projectile_small"
#	"holy_2_light_pilar"
#	"holy_3_summon_sword"
#	"holy_4_light_parry"
#	"holy_5_light_delayed_exposion"
#	"holy_6_bells_aura"
#	"holy_7_ball_random"
#	"holy_7_light_pop"
#	"holy_7_little_explosion"
#	"holy_8_suriken"
#	"holy_9_little_implosion"
#	"holy_10_light_cast"
#	"holy_11_light_hit_pop"
#	"holy_12_light_diamond"

@onready var animation_tree = $AnimationTree

func _ready():
	global_position += Vector3(0,1,1)
	animation_tree.set(PARAMETER_PATH + "empty", true)

func _process(_delta):
	if EntityManagerGlobal.player:
		var flip_h := EntityManagerGlobal.player.body_instance.is_facing_left

func launch_animation(animation_name: String = "empty", loop: bool = false):
	Logger.info("VFXPlayer: Playing %s animation" % animation_name)
	var custom_launch: bool = false
	_disable_all_animations()
	animation_tree.set(PARAMETER_PATH + "empty", !loop)
	back_to_origin()
	match animation_name:
		"empty":
			pass
		"holy_1_projectile_normal":
			custom_launch = true
			launch_projectile_to_enemy("holy_1_projectile_normal")
		"holy_2_light_pilar":
			custom_launch = true
			animation_tree.set(PARAMETER_PATH + "holy_3_summon_sword", true)
			# tp_to_enemy()
			# animation_tree.set(PARAMETER_PATH + animation_name, true)
			# animation_tree.set(PARAMETER_PATH + animation_name, false)
		"holy_6_bells_aura":
			custom_launch = true
			animation_tree.set(PARAMETER_PATH + animation_name, true)
			animation_tree.set(PARAMETER_PATH + animation_name, false)
			await animation_tree.animation_finished
			tp_to_enemy()
			animation_tree.set(PARAMETER_PATH + "holy_5_light_delayed_exposion", true)
			animation_tree.set(PARAMETER_PATH + "holy_5_light_delayed_exposion", false)
		"holy_7_ball_random":
			custom_launch = true
			launch_projectile_to_enemy("holy_7_ball_random")
			await animation_tree.animation_finished
			animation_tree.set(PARAMETER_PATH + "holy_9_little_implosion", true)
			animation_tree.set(PARAMETER_PATH + "holy_9_little_implosion", false)
		"holy_7_light_pop":
			pass
		"holy_8_suriken":
			custom_launch = true
			launch_projectile_to_enemy("holy_1_projectile_normal")
			await animation_tree.animation_finished
			animation_tree.set(PARAMETER_PATH + "holy_1_light_explosion", true)
			animation_tree.set(PARAMETER_PATH + "holy_1_light_explosion", false)
		"holy_10_light_cast":
			custom_launch = true
			animation_tree.set(PARAMETER_PATH + animation_name, true)
			animation_tree.set(PARAMETER_PATH + animation_name, false)
			await animation_tree.animation_finished
			tp_to_enemy()
			animation_tree.set(PARAMETER_PATH + "holy_12_light_diamond", true)
			animation_tree.set(PARAMETER_PATH + "holy_12_light_diamond", false)
		"holy_11_light_hit_pop":
			pass
		_:
			pass
			
	if !custom_launch:
		animation_tree.set(PARAMETER_PATH + animation_name, true)
		animation_tree.set(PARAMETER_PATH + animation_name, false)
	
	animation_tree.set(PARAMETER_PATH + "empty", true)
	custom_launch = false

func tp_to_enemy():
	var entity
	if EntityManagerGlobal.enemy != null:
		entity = EntityManagerGlobal.enemy
	elif EntityManagerGlobal.boss != null:
		entity = EntityManagerGlobal.boss
	global_position.x = entity.body_instance.global_position.x

func back_to_origin():
	global_position.x = EntityManagerGlobal.player.body_instance.global_position.x
	global_position.z = 1
	global_position.z = 1

func launch_projectile_to_enemy(animation_name: String, duration: float = 0.4) -> void:
	if EntityManagerGlobal.enemy == null:
		return
	
	_disable_all_animations()
	
	global_position.x = EntityManagerGlobal.player.body_instance.global_position.x
	
	var entity
	if EntityManagerGlobal.enemy != null:
		entity = EntityManagerGlobal.enemy
	elif EntityManagerGlobal.boss != null:
		entity = EntityManagerGlobal.boss
		
	var target_pos = entity.body_instance.global_position.x
	var start_pos = global_position.x
	var elapsed := 0.0
	
	animation_tree.set(PARAMETER_PATH + animation_name, true)
	
	while elapsed < duration:
		elapsed += get_process_delta_time()
		global_position.x = lerp(start_pos, target_pos, elapsed / duration)
		await get_tree().process_frame
	
	animation_tree.set(PARAMETER_PATH + animation_name, false)


func _disable_all_animations():
	var animation_names = [
		"empty",
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
