extends RoomController
class_name RoomControllerShop


# Left wall
@onready var door_left = $walls/left_walls/Wall_Door_toggleable
@onready var window_bars_left = $walls/left_walls/Wall_Window_toggleable

# Right wall
@onready var door_right = $walls/right_walls/Wall_Door_toggleable
@onready var window_bars_right = $walls/right_walls/Wall_Window_toggleable
