extends Node3D

@onready var camera = $Camera3D

func _ready():
	WorldManagerGlobal.init_in_root_scene(self)
