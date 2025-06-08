extends Node3D
class_name GameRoot

func _init():
	WorldManagerGlobal.set_game_root(self)
