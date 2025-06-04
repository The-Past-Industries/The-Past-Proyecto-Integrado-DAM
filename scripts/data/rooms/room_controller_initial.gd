extends RoomControllerFlat
class_name RoomControllerInitial

# SPAWN POINT
@onready var spawn_point_marker: Marker3D = $position_markers/spawn_point

func setup(cur_position: Vector2i, room_data: RoomData):
	super.setup(cur_position, room_data)
	self._init_room_components([
		$walls/left_walls/Wall_Door_toggleable,
		$walls/left_walls/Wall_Window_Bars_toggleable,
		$walls/right_walls/Wall_Door_toggleable,
		$walls/right_walls/Wall_Window_Bars_toggleable,
		$position_markers/door_left,
		$position_markers/door_right,
		$position_markers/combat_left,
		$position_markers/combat_right
	])

func _ready():
	_load_door_by_room_connections()
	_spawn_player()

func _spawn_player():
	EntityManagerGlobal.spawn_player_in_pos(self, spawn_point_marker.global_position)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_spawn_player()
