extends RoomControllerFlat
class_name RoomControllerCorridor

@onready var wall_left_door_toggleable = $walls/left_walls/Wall_Door_toggleable
@onready var wall_left_window_bars_toggleable = $walls/left_walls/Wall_Window_Bars_toggleable
@onready var wall_right_door_toggleable = $walls/right_walls/Wall_Door_toggleable
@onready var wall_right_window_bars_toggleable = $walls/right_walls/Wall_Window_Bars_toggleable
@onready var door_left_marker_aux = $position_markers/door_left
@onready var door_right_marker_aux = $position_markers/door_right

var player_in_elevator: bool = false

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


func _on_area_3d_left_body_entered(body: Node3D) -> void:
	_on_area_custom_entered(body, Vector2i.LEFT)


func _on_area_3d_right_body_entered(body: Node3D) -> void:
	_on_area_custom_entered(body, Vector2i.RIGHT)


func _on_area_3d_elevator_body_entered(body: Node3D) -> void:
	player_in_elevator = true


func _on_area_3d_elevator_body_exited(body: Node3D) -> void:
	player_in_elevator = false


func _input(event: InputEvent) -> void:
	if player_in_elevator:
		if event.is_action_pressed("ui_up"):
			Logger.info("UP ------------ PULSADO")
			_move_to_room(EntityManagerGlobal.player.body_instance, room_data.connections, Vector2i.UP)
		elif event.is_action_pressed("ui_down"):
			Logger.info("DOWN ------------ PULSADO")
			_move_to_room(EntityManagerGlobal.player.body_instance, room_data.connections, Vector2i.DOWN)
