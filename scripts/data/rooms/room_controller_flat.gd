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
	combat_left_marker = components[6]
	combat_right_marker = components[7]

func _load_door_by_room_connections():
	await get_tree().process_frame
	for direction in self.room_data.connections:
		
		# Left walls toggle
		var is_left = direction == Vector2i.LEFT
		door_left.visible = is_left
		window_bars_left.visible = not is_left
		
		# Right walls toggle
		var is_right = direction == Vector2i.RIGHT
		door_right.visible = is_right
		window_bars_right.visible = not is_right

func _spawn_player_by_dir_connection(dir_comming: Vector2i):
	var new_position
	if dir_comming == Vector2i.LEFT:
		new_position = door_left_marker.global_position
	elif dir_comming == Vector2i.RIGHT:
		new_position = door_right_marker.global_position
	EntityManagerGlobal.spawn_player_in_pos(self, new_position)

func _on_area_3d_left_body_entered(body: Node3D) -> void:
	if body.is_in_group("doors_tp_proc") and room_data.connections.has(Vector2i.LEFT):
		WorldManagerGlobal.move_to_cell(Vector2i.LEFT)


func _on_area_3d_right_body_entered(body: Node3D) -> void:
	if body.is_in_group("doors_tp_proc") and room_data.connections.has(Vector2i.RIGHT):
		WorldManagerGlobal.move_to_cell(Vector2i.RIGHT)
