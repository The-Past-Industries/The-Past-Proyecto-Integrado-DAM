extends RoomData
class_name RoomDataCorridor

func _init(
	level: int,
	distance: int = -1,
	shown: bool = false
):
	super(level, RoomType.CORRIDOR, distance, shown)

func add_connections(connections: Array[Vector2i]):
	self.connections.append_array(connections)
