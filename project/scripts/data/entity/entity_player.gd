extends Entity
class_name EntityPlayer

var body_scene = load("res://scenes/characters/main/main_character_king.tscn")
var body_instance: PlayerBody
var is_on_elevator: bool = false
var player_gold: int = 0
var player_keys: int = 0
var player_special_animation
var key_item_list: Array[KeyItem] = []

func _ready():
	add_child(VFXManagerGlobal.player_special_animation)

func _init() -> void:
	_init_body()
	self.type = EntityType.PLAYER
	self.stats_manager.set_initial_player_stats()

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
