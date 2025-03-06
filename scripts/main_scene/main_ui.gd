extends Control
class_name MainUI

@onready var enemy_ui = $bottom_bar/MarginContainer/HBoxContainer/enemy_ui
@onready var menu_manager = $bottom_bar/MarginContainer/HBoxContainer/MarginContainer/CenterContainer/Menu_Manager

func hide_enemy():
	enemy_ui.visible = false
