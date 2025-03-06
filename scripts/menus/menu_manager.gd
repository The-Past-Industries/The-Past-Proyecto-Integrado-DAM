extends Control

@onready var actions_menu: ActionsMenu = preload("res://scenes/ui/actions_menu.tscn").instantiate()

func _ready():
	add_child(actions_menu)
