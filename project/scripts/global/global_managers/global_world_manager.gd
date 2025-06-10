extends Node
class_name WorldManager

# World
var world_generator := WorldGenerator.new()
var map_data: Dictionary
var map_repository: Array[Dictionary] = []
var cur_cell_instance: RoomController
var cur_position
var last_position = cur_position
var level: int = 1

# Room scenes
var INITIAL_ROOM_NODE := preload("res://scenes/world/rooms/initial_room.tscn")
var COMMON_ROOM_NODE := preload("res://scenes/world/rooms/common_room.tscn")
var CORRIDOR_ROOM_NODE := preload("res://scenes/world/rooms/corridor_room.tscn")
var BOSS_ROOM_NODE := preload("res://scenes/world/rooms/boss_room.tscn")
var SHOP_ROOM_NODE := preload("res://scenes/world/rooms/shop_room.tscn")
var TREASURE_ROOM_NODE := preload("res://scenes/world/rooms/treasure_room.tscn")
var CAMPUS_ROOM_NODE := preload("res://scenes/world/rooms/campus_room.tscn")

# game_root scene containing instance/clear process
var game_root: Node3D

func set_game_root(game_root: Node3D):
	self.game_root = game_root
func _ready():
	cur_position = Vector2i(0,0)
	last_position = cur_position
	ApiManagerGlobal.request_score()
	_generate_level()
	
	
func _generate_level():
	world_generator.generate_level(GlobalConstants.WORLDGEN_DEBUG_DEFAULT_SEED, level)
	map_data = world_generator.map_data.duplicate(true)
	map_repository.append(map_data)
	_change_cell(map_data[cur_position])

func _change_cell(room_data: RoomData):
	if cur_cell_instance && cur_cell_instance.room_data:
		cur_cell_instance.room_data.shown = true
	_clear_tree()
	await get_tree().process_frame
	_instance_cell(room_data)

func _instance_cell(room_data: RoomData):
	var cell_instantiated
	match room_data.type:
		RoomType.INITIAL:
			cell_instantiated = INITIAL_ROOM_NODE.instantiate() as RoomControllerInitial
		RoomType.COMMON:
			cell_instantiated = COMMON_ROOM_NODE.instantiate() as RoomControllerCommon
		RoomType.CORRIDOR:
			cell_instantiated = CORRIDOR_ROOM_NODE.instantiate() as RoomControllerCorridor
		RoomType.BOSS:
			cell_instantiated = BOSS_ROOM_NODE.instantiate() as RoomControllerBoss
		RoomType.SHOP:
			cell_instantiated = SHOP_ROOM_NODE.instantiate() as RoomControllerShop
		RoomType.TREASURE:
			cell_instantiated = TREASURE_ROOM_NODE.instantiate() as RoomControllerTreasure
		RoomType.CAMPUS:
			cell_instantiated = CAMPUS_ROOM_NODE.instantiate() as RoomControllerCampus
		_:
			Logger.error("The instantiated cell type does not exist")
	cur_cell_instance = cell_instantiated
	_load_cell_on_tree(cell_instantiated)
	cell_instantiated.setup(cur_position, room_data)
	if room_data.type == RoomType.COMMON && !room_data.shown:
		Logger.info("WorldManager: Common room not shown entered. Starting combat.")
		EntityManagerGlobal.choose_random_enemy()
		cell_instantiated.spawn_enemy(EntityManagerGlobal.enemy)
		cell_instantiated.prepare_combat_state()
	if room_data.type == RoomType.BOSS && !room_data.shown:
		Logger.info("WorldManager: Common room not shown entered. Starting combat.")
		EntityManagerGlobal.choose_random_boss()
		cell_instantiated.spawn_boss(EntityManagerGlobal.boss)
		(EntityManagerGlobal.boss.body_instance as AnimationHost)
		cell_instantiated.prepare_combat_state()
	MenuManagerGlobal.update_visors()

func _load_cell_on_tree(cell_instantiated: RoomController):
	if game_root == null:
		Logger.error("WorldManager: game_root is null")
	else:
		Logger.info("WorldManager: adding cell to game_root: %s" % game_root)
		game_root.add_child(cell_instantiated)
		for child in game_root.get_children(true):
			# Logger.info("WorldManager: END OF ROOM LOAD. game_root CHILD: %s" % child)
			pass


func move_to_cell(direction: Vector2i):
	var new_pos = cur_position + direction
	if map_data.has(new_pos) and map_data[new_pos] is RoomData:
		last_position = cur_position
		cur_position = new_pos
		_change_cell(map_data[new_pos])
	else:
		Logger.warning("Invalid movement. No room in direction: %s" % [direction])


func _clear_tree():
	if cur_cell_instance != null:
		game_root.remove_child(cur_cell_instance)
		cur_cell_instance.call_deferred("queue_free")
		cur_cell_instance = null

	await get_tree().process_frame

	if game_root:
		for child in game_root.get_children():
			if not child is CharacterBody3D:
				game_root.remove_child(child)
				child.call_deferred("queue_free")

# Utils

# Return string for room type enum
func get_room_type_name(value: int) -> String:
	match value:
		RoomType.IMANERROR: return "IMANERROR"
		RoomType.INITIAL: return "INITIAL"
		RoomType.COMMON: return "COMMON"
		RoomType.CORRIDOR: return "CORRIDOR"
		RoomType.BOSS: return "BOSS"
		RoomType.SHOP: return "SHOP"
		RoomType.TREASURE: return "TREASURE"
		RoomType.LIMBO: return "LIMBO"
		RoomType.STAIRS: return "STAIRS"
		RoomType.CAMPUS: return "CAMPUS"
		_: return "UNKNOWN"

func get_comming_direction() -> Vector2i:
	Logger.info("WorldManager: Getting comming direction for spawn on new instance")
	if last_position != null && cur_position != null:
		var dif: Vector2i = last_position - cur_position
		var comming_direction: Vector2i = dif.snapped(Vector2.ONE)
		# Logger.info("WorldManager: CUR_POSITION:%s LAST_POSITION:%s COMMING_DIR:%s" % [cur_position, last_position, comming_direction])
		return Vector2i(dif)
	else:
		Logger.error("WRONG COMMING DIRECTION. Last position is NULL")
		return Vector2i.ZERO

func remove_enemy_from_instance():
	cur_cell_instance.remove_child(EntityManagerGlobal.enemy.body_instance)

func remove_boss_from_instance():
	cur_cell_instance.remove_child(EntityManagerGlobal.boss.body_instance)

func teleport_player_to_boss():
	var new_pos = _search_boss_room_position()
	if map_data.has(new_pos) and map_data[new_pos] is RoomDataBoss:
		last_position = cur_position
		cur_position = new_pos
		_change_cell(map_data[new_pos])

func _search_boss_room_position() -> Vector2i:
	for room_position in map_data.keys():
		var room: RoomData = map_data[room_position]
		if room.type == RoomType.BOSS:
			return room_position
	return Vector2i.ZERO

# Debug rooms position and comming direction
#func _process(delta: float) -> void:
	#Logger.info("CUR_POS:%s" % cur_position)
	#Logger.info("LAST_POS:%s" % last_position)
	#Logger.info("COMMING_DIR:%s" % get_comming_direction())
	#await get_tree().create_timer(1.5).timeout
