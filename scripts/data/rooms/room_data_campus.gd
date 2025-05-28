extends RoomData
class_name RoomDataCampus

func _init(
	level: int,
	distance: int = -1,
	shown: bool = false
):
	super(level, RoomType.CAMPUS, distance, shown)

func add_connections(connections: Array[Vector2i]):
# Check only one horizontal direction
	if connections.has(Vector2i.DOWN):
		self.connections.append(Vector2i.LEFT)
	else:
		Logger.error("CAMPUS created without DOWN connection")
