extends Node3D
class_name RoomController

var cur_position: Vector2i
var room_data: RoomData

func setup(cur_position: Vector2i, room_data: RoomData):
	self.cur_position = cur_position
	self.room_data = room_data

func _load_door_by_room_connections():
	pass
