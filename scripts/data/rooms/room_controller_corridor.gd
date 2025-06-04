extends RoomControllerFlat
class_name RoomControllerCorridor

@onready var wall_left_door_toggleable = $walls/left_walls/Wall_Door_toggleable
@onready var wall_left_window_bars_toggleable = $walls/left_walls/Wall_Window_Bars_toggleable
@onready var wall_right_door_toggleable = $walls/right_walls/Wall_Door_toggleable
@onready var wall_right_window_bars_toggleable = $walls/right_walls/Wall_Window_Bars_toggleable
@onready var door_left_marker_aux = $position_markers/door_left
@onready var door_right_marker_aux = $position_markers/door_right

func setup(cur_position: Vector2i, room_data: RoomData):
	super._init_room_components([
		wall_left_door_toggleable,
		wall_left_window_bars_toggleable,
		wall_right_door_toggleable,
		wall_right_window_bars_toggleable,
		door_left_marker_aux,
		door_right_marker_aux
	])
	super.setup(cur_position, room_data)
	
	spawn_player()

func _on_area_3d_left_body_entered(body: Node3D) -> void:
	super._on_area_3d_left_body_entered(body)


func _on_area_3d_right_body_entered(body: Node3D) -> void:
	super._on_area_3d_right_body_entered(body)
