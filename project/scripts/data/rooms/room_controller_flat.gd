extends RoomController
class_name RoomControllerFlat

# DOOR HIDDING

# Left wall
@onready var door_left
@onready var window_bars_left

# Right wall
@onready var door_right
@onready var window_bars_right

# Door teleport
@onready var door_left_marker: Marker3D
@onready var door_right_marker: Marker3D

# Combat teleport
@onready var combat_left_marker: Marker3D
@onready var combat_right_marker: Marker3D

func setup(cur_position: Vector2i, room_data: RoomData):
	super.setup(cur_position, room_data)
	spawn_player()

func spawn_player():
	Logger.info("----SPAWN PLAYER CALLED. ROOM SHOWN: %s ----" % room_data.shown)
	if room_data.type == RoomType.INITIAL  && !room_data.shown:
		Logger.info("----SPAWN PLAYER INITIAL----")
		room_data.shown = true
		EntityManagerGlobal.spawn_player_in_pos(self, Vector3i(0,0,1))
	else:
		Logger.info("----SPAWN PLAYER DIRECTIONAL----")
		_spawn_player_by_dir_connection(WorldManagerGlobal.get_comming_direction())

func _init_room_components(components: Array[Node3D]):
	# Left wall
	door_left = components[0]
	window_bars_left = components[1]

	# Right wall
	door_right = components[2]
	window_bars_right = components[3]

	# Markers
	# Door teleport
	door_left_marker = components[4]
	door_right_marker = components[5]

	# Combat teleport
	if components.size() >= 8:
		combat_left_marker = components[6]
		combat_right_marker = components[7]

func _load_door_by_room_connections():
	_close_room()
	for direction in self.room_data.connections:
		
		match direction:
			
			# Left walls toggle
			Vector2i.LEFT:
				door_left.visible = true
				window_bars_left.visible = false
		
			# Right walls toggle
			Vector2i.RIGHT:
				door_right.visible = true
				window_bars_right.visible = false

func _close_room():
		door_left.visible = false
		window_bars_left.visible = true
		door_right.visible = false
		window_bars_right.visible = true

func _spawn_player_by_dir_connection(dir_comming: Vector2i):
	var new_position
	match dir_comming:
		Vector2i.LEFT:
			new_position = door_left_marker.global_position
		Vector2i.RIGHT:
			new_position = door_right_marker.global_position
		Vector2i.UP:
			new_position = Vector3i(0,0,1)
		Vector2i.DOWN:
			new_position = Vector3i(0,0,1)
		_:
			new_position = Vector3i(0,0.5,1)
			Logger.error("RoomControllerFlat: Invalid comming direction.")		
	Logger.info("RoomControllerFlat: Spawn player at %s" % new_position)
	EntityManagerGlobal.spawn_player_in_pos(self, new_position)
