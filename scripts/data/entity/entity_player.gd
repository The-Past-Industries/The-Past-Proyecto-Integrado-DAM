extends Entity
class_name EntityPlayer

var scene = preload("res://scenes/characters/main/main_character_king.tscn")

func _enter_tree() -> void:
	self.body_instance = scene.instantiate()
	pass
