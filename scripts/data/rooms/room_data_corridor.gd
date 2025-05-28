extends RoomData
class_name RoomDataCorridor

func _init(
	level: int,
	distance: int = -1,
	shown: bool = false
):
	super(level, RoomType.CORRIDOR, distance, shown)
