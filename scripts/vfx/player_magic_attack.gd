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
	EntityManagerGlobal.player.body_instance.add_child(self)
	position = Vector3.ZERO
	animation_tree.set(PARAMETER_PATH + "empty", true)

func _process(_delta):
	var flip_h := EntityManagerGlobal.player.body_instance.is_facing_left
	
	

func launch_animation2(animation_name: String, loop: bool = false):
	if loop:
		animation_tree.set(PARAMETER_PATH + "empty", false)
	animation_tree.set(PARAMETER_PATH + animation_name, true)
	await animation_tree.animation_finished
	animation_tree.set(PARAMETER_PATH + animation_name, false)
	animation_tree.set(PARAMETER_PATH + "empty", true)


func launch_animation(animation_name: String, loop: bool = false):
	disable_all_animations()
	animation_tree.set(PARAMETER_PATH + "empty", !loop)
	match animation_name:
		"empty":
			pass
		"holy_1_light_explosion":
			pass
		"holy_1_projectile_normal":
			pass
		"holy_1_projectile_small":
			pass
		"holy_2_light_pilar":
			pass
		"holy_3_summon_sword":
			pass
		"holy_4_light_parry":
			pass
		"holy_5_light_delayed_exposion":
			pass
		"holy_6_bells_aura":
			pass
		"holy_7_ball_random":
			pass
		"holy_7_light_pop":
			pass
		"holy_7_little_explosion":
			pass
		"holy_8_suriken":
			pass
		"holy_9_little_implosion":
			pass
		"holy_10_light_cast":
			pass
		"holy_11_light_hit_pop":
			pass
		"holy_12_light_diamond":
			pass
		_:
			pass
	animation_tree.set(PARAMETER_PATH + animation_name, true)
	await animation_tree.animation_finished
	animation_tree.set(PARAMETER_PATH + animation_name, false)
	animation_tree.set(PARAMETER_PATH + "empty", true)

func disable_all_animations():
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
