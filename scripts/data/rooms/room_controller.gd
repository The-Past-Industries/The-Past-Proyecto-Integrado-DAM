extends Node3D
class_name RoomController

var cur_position: Vector2i
var room_data: RoomData

func setup(cur_position: Vector2i, room_data: RoomData):
	self.cur_position = cur_position
	self.room_data = room_data

func _move_to_room(player_body: Node3D, room_connections: Array[Vector2i], move_direction: Vector2i):
	if player_body.is_in_group("doors_tp_proc") and room_connections.has(move_direction):
		Logger.info("AREA 3D: AREA TELEPORTING TO %s" % move_direction)
		WorldManagerGlobal.move_to_cell(move_direction)

func _on_area_3d_left_body_entered(body: Node3D) -> void:
	Logger.info("AREA 3D: LEFT AREA ENTERED. ACCESS: %s" % body.is_in_group("doors_tp_proc"))
	_move_to_room(body, room_data.connections, Vector2i.LEFT)

func _on_area_3d_right_body_entered(body: Node3D) -> void:
	Logger.info("AREA 3D: RIGHT AREA ENTERED. ACCESS: %s" % body.is_in_group("doors_tp_proc"))
	_move_to_room(body, room_data.connections, Vector2i.RIGHT)
