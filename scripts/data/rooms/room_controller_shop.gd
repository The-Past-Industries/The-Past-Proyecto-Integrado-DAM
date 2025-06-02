extends RoomController
class_name RoomControllerShop


# Left wall
@onready var door_left = $walls/left_walls/Wall_Door_toggleable
@onready var window_bars_left = $walls/left_walls/Wall_Window_toggleable

# Right wall
@onready var door_right = $walls/right_walls/Wall_Door_toggleable
@onready var window_bars_right = $walls/right_walls/Wall_Window_toggleable

func _ready():
	_load_door_by_room_connections()

func _load_door_by_room_connections():
	for direction in self.room_data.connections:
		
		# Left walls toggle
		var is_left = direction == Vector2i.LEFT
		door_left.visible = is_left
		window_bars_left.visible = not is_left
		
		# Right walls toggle
		var is_right = direction == Vector2i.RIGHT
		door_right.visible = is_right
		window_bars_right.visible = not is_right
		
