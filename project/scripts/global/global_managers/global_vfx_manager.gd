extends Node
class_name VFXManager

var player_special_animation := VFXPlayer.new()

func manage_player_special_animation(animation_name):
	player_special_animation.launch_animation(animation_name)
