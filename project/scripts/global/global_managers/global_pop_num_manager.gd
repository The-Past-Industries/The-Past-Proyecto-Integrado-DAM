extends Node
class_name PopNumManager

const POP_NUM_GOLD = preload("res://scenes/vfx/pop_num_gold.tres")
const POP_NUM_HEAL = preload("res://scenes/vfx/pop_num_heal.tres")
const POP_NUM_KEY = preload("res://scenes/vfx/pop_num_key.tres")
const POP_NUM_MAG = preload("res://scenes/vfx/pop_num_mag.tres")
const POP_NUM_MAG_ARM = preload("res://scenes/vfx/pop_num_mag_arm.tres")
const POP_NUM_MAG_PEN = preload("res://scenes/vfx/pop_num_mag_pen.tres")
const POP_NUM_PHY = preload("res://scenes/vfx/pop_num_phy.tres")
const POP_NUM_PHY_ARM = preload("res://scenes/vfx/pop_num_phy_arm.tres")
const POP_NUM_PHY_PEN = preload("res://scenes/vfx/pop_num_phy_pen.tres")

var displayer_player: PopNumDisplayer
var displayer_enemy: PopNumDisplayer

func _input(event: InputEvent) -> void:
	if displayer_player && displayer_player:
		if event.is_action_pressed("debug_0"):
			Logger.info("PopNumDisplayer: HI =================")
			displayer_player.launch_pop_num(PopNumType.PHY_DMG, 444)
			#WorldManagerGlobal.teleport_player_to_boss()
		if !displayer_player || !displayer_enemy:
			Logger.info("PopNumDisplayer: displayers not setted")
			return
			
		if event.is_action_pressed("debug_1"):
			displayer_enemy.launch_pop_num(PopNumType.MAG_DMG, 12)
