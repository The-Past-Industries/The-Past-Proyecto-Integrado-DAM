extends Entity
class_name EntityPlayer

var scene = load("res://scenes/characters/main/main_character_king.tscn")

func _init() -> void:
	_init_body()

func _init_body():
	if !self.body_instance:
		self.body_instance = scene.instantiate()

func _close_body():
	self.body_instance = null

func refresh_body():
	_close_body()
	_init_body()
