extends RefCounted
class_name RoomData

var level: int
var type: int	# RoomType enum
var distance: int
var connections: Array[Vector2i]
var shown: bool

func _init(
	level: int,
	type: int,
	distance: int = -1,
	shown: bool = false
):
	self.level = level
	self.type = type
	self.distance = distance
	self.shown = shown
	connections =[]

func add_connections(connections: Array[Vector2i]):
	self.connections.append_array(connections)
