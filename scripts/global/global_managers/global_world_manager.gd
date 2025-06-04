extends Node
class_name WorldManager

var is_active = false

# World
var world_generator := WorldGenerator.new()
var map_data: Dictionary
var map_repository: Array[Dictionary] = []
var cur_position := Vector2i(0,0)
var last_position
var level: int = 1

var INITIAL_ROOM_NODE := preload("res://scenes/world/rooms/initial_room.tscn")
var COMMON_ROOM_NODE := preload("res://scenes/world/rooms/common_room.tscn")
var CORRIDOR_ROOM_NODE := preload("res://scenes/world/rooms/corridor_room.tscn")
var BOSS_ROOM_NODE := preload("res://scenes/world/rooms/boss_room.tscn")
var SHOP_ROOM_NODE := preload("res://scenes/world/rooms/shop_room.tscn")
var TREASURE_ROOM_NODE := preload("res://scenes/world/rooms/treasure_room.tscn")
var CAMPUS_ROOM_NODE := preload("res://scenes/world/rooms/campus_room.tscn")

# Root scene containing instance/clear process
var root

func init_in_root_scene(root: Node3D):
	self.root = root
	_generate_level()

func _ready():
	# _generate_level()
	# MapUIBridge.get_instance().get_map_visualizer().visualize_map(world_generator.map_data)
	pass

func _generate_level():
	world_generator.generate_level(GlobalConstants.WORLDGEN_DEBUG_DEFAULT_SEED, level)
	map_data = world_generator.map_data.duplicate(true)
	map_repository.append(map_data)
	_change_cell(map_data[cur_position])

func _change_cell(room_data: RoomData):
	_clear_tree()
	_instance_cell(room_data)

func _instance_cell(room_data: RoomData):
	var cell_instantiated: RoomController
	match room_data.type:
		RoomType.INITIAL:
			cell_instantiated = INITIAL_ROOM_NODE.instantiate() as RoomController
		RoomType.COMMON:
			cell_instantiated = COMMON_ROOM_NODE.instantiate() as RoomController
		RoomType.CORRIDOR:
			cell_instantiated = CORRIDOR_ROOM_NODE.instantiate() as RoomController
		RoomType.BOSS:
			cell_instantiated = BOSS_ROOM_NODE.instantiate() as RoomController
		RoomType.SHOP:
			cell_instantiated = SHOP_ROOM_NODE.instantiate() as RoomController
		RoomType.TREASURE:
			cell_instantiated = TREASURE_ROOM_NODE.instantiate() as RoomController
		RoomType.CAMPUS:
			cell_instantiated = CAMPUS_ROOM_NODE.instantiate() as RoomController
		_:
			Logger.error("The instantiated cell type does not exist")
	cell_instantiated.setup(cur_position, room_data)
	_load_cell_on_tree(cell_instantiated)
	Logger.info("CELL LOADED ON TREE: pos [%s] type [%s]" % [cur_position, get_room_type_name(room_data.type)])

func _load_cell_on_tree(cell_instantiated: RoomController):
	if root == null:
		Logger.error("WorldManager: root is null")
	else:
		Logger.info("WorldManager: adding cell to root: %s" % root.name)
	root.add_child(cell_instantiated)


func move_to_cell(direction: Vector2i):
	var new_pos = cur_position + direction
	Logger.info("MOVING TO: pos [%s]" % new_pos)
	if map_data.has(new_pos) and map_data[new_pos] is RoomData:
		last_position = cur_position
		cur_position += direction
		_change_cell(map_data[cur_position])
	else:
		Logger.warning("Invalid movement. No room in direction: %s" % [direction])

func _clear_tree():
	for child in root.get_children():
		child.queue_free()

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
