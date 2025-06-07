extends Entity
class_name EntityPlayer

var body_scene = load("res://scenes/characters/main/main_character_king.tscn")
var body_instance: PlayerBody
var is_on_elevator: bool = false

func _init() -> void:
	_init_body()

func _init_body():
	if !self.body_instance:
		self.body_instance = body_scene.instantiate()

func _close_body():
	self.body_instance = null

func refresh_body():
	_close_body()
	_init_body()

func get_body() -> PlayerBody:
	return self.body_instance

func move_to(target_position: Vector3):
	body_instance.move_to(target_position)
