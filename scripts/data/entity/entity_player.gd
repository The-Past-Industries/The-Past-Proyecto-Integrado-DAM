extends Entity
class_name EntityPlayer

var scene = load("res://scenes/characters/main/main_character_king.tscn")

func _init() -> void:
	init_body()

func init_body():
	self.body_instance = scene.instantiate()
