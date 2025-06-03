extends Entity
class_name EntityPlayer

func _ready():
	self.body_instance = load("res://scenes/characters/main/main_character_king.tscn").instantiate()
