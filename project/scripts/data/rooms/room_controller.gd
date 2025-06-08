extends Node3D
class_name RoomController

var cur_position: Vector2i
var room_data: RoomData

func setup(cur_position: Vector2i, room_data: RoomData):
	self.cur_position = cur_position
	self.room_data = room_data
	_load_door_by_room_connections()

func _move_to_room(player_body: Node3D, room_connections: Array[Vector2i], move_direction: Vector2i):
	if player_body.is_in_group("doors_tp_proc") and room_connections.has(move_direction):
		Logger.info("TELEPORTING IN %s DIRECTION" % move_direction)	
		EntityManagerGlobal.player.body_instance.global_position = Vector3(0,-20,0)
		WorldManagerGlobal.move_to_cell(move_direction)

func _on_area_custom_entered(body: Node3D, direction: Vector2i):
	Logger.info("AREA 3D: %s AREA ENTERED." % direction)
	_move_to_room(body, room_data.connections, direction)

func _load_door_by_room_connections():
	pass
