extends HBoxContainer
class_name BottomContainer

@onready var player_panel_left = $left_MarginContainer/player_panel
@onready var enemy_panel_left = $left_MarginContainer/enemy_panel
@onready var menu_panel = $menu_MarginContainer/menu_panel
@onready var player_panel_right = $right_MarginContainer/player_panel
@onready var enemy_panel_right = $right_MarginContainer/enemy_panel
@onready var travel_panel_left = $left_MarginContainer/travel_panel
@onready var travel_panel_right = $right_MarginContainer/travel_panel


func _ready():
	MenuManagerGlobal.bottom_panel_container = self
