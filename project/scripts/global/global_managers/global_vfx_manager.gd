extends Node
class_name VFXManager

const vfx_player_resource = preload("res://scenes/vfx/vfx_player.tscn")

var player_special_animation

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_1"):
		manage_player_special_animation("holy_7_light_pop")

func manage_player_special_animation(animation_name):
	if !is_instance_valid(player_special_animation):
		player_special_animation = (vfx_player_resource.instantiate() as VFXPlayer)
	WorldManagerGlobal.cur_cell_instance.add_child(player_special_animation)
	player_special_animation.launch_animation(animation_name)
