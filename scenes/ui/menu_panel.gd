extends Panel
class_name MenuPanel

@onready var scroll_container = $MarginContainer/ScrollContainer

func _ready():
	MenuManagerGlobal.menu_panel_scroll = scroll_container
