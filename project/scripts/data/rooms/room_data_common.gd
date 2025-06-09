extends RoomData
class_name RoomDataCommon

func _init(
	level: int,
	distance: int = -1,
	shown: bool = false
):
	super(level, RoomType.COMMON, distance, shown)
	self.has_loot = true

func add_connections(connections: Array[Vector2i]):
# Check only two horizontal directions
	for d in [Vector2i.LEFT, Vector2i.RIGHT]:
		if connections.has(d):
			self.connections.append(d)
