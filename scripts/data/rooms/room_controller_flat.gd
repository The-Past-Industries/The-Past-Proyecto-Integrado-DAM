extends RoomController
class_name RoomControllerFlat


# Left wall
@onready var door_left
@onready var window_bars_left

# Right wall
@onready var door_right
@onready var window_bars_right

func setup(cur_position: Vector2i, room_data: RoomData):
	super.setup(cur_position, room_data)

func _init_doors(components: Array[Node3D]):
	door_left = components[0]
	window_bars_left = components[1]

# Right wall
	door_right = components[2]
	window_bars_right = components[3]

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
		

func _on_area_3d_left_body_entered(body: Node3D) -> void:
	if body.is_in_group("doors_tp_proc") and room_data.connections.has(Vector2i.LEFT):
		# ActionMenu._add_door_option(Vector2i.LEFT)
		WorldManagerGlobal.move_to_cell(Vector2i.LEFT)


func _on_area_3d_right_body_entered(body: Node3D) -> void:
	if body.is_in_group("doors_tp_proc") and room_data.connections.has(Vector2i.RIGHT):
		# ActionMenu._add_door_option(Vector2i.RIGHT)
		WorldManagerGlobal.move_to_cell(Vector2i.RIGHT)
