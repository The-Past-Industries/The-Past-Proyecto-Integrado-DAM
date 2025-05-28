extends RoomData
class_name RoomDataTreasure

func _init(
	level: int,
	distance: int = -1,
	shown: bool = false
):
	super(level, RoomType.TREASURE, distance, shown)

func set_connections(connections: Array[Vector2i]):
# Check only one horizontal direction
	if connections.has(Vector2i.LEFT):
		self.connections.append(Vector2i.LEFT)
	elif connections.has(Vector2i.RIGHT):
		self.connections.append(Vector2i.RIGHT)
