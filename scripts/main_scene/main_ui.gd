extends Control
class_name MainUI

@onready var enemy_ui: Control = $bottom_bar/MarginContainer/HBoxContainer/enemy_ui

func hide_enemy():
	enemy_ui.visible = false
