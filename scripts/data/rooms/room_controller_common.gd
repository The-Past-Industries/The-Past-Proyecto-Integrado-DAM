extends RoomControllerFlat
class_name RoomControllerCommon

func setup(cur_position: Vector2i, room_data: RoomData):
	super.setup(cur_position, room_data)
	self._init_doors([
		$walls/left_walls/Wall_Door_toggleable,
		$walls/left_walls/Wall_Window_Bars_toggleable,
		$walls/right_walls/Wall_Door_toggleable,
		$walls/right_walls/Wall_Window_Bars_toggleable
	])
