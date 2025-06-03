extends Node
class_name ActionMenuTest

var is_active = false

var options: Array[String] = []
var target_index: int = 0

func _ready() -> void:
	# _refresh_menu()
	pass

func _refresh_menu():
	Logger.info("-------ACTION BAR:-------")
	for i in options.size():
		var prefix := "→ " if i == target_index else "  "
		Logger.info("%s%d: %s" % [prefix, i, options[i]])

func _add_door_option(direction: Vector2i):
	var str = "Atravesar puerta"
	if not options.has(str):
		options.append(str)

func _remove_door_option():
	pass

func _input(event: InputEvent) -> void:
		if event.is_action_pressed("ui_up"):
			_move_index(false)
		elif event.is_action_pressed("ui_down"):
			_move_index(true)
		_refresh_menu()

func _move_index(positive: bool):
	if positive:
		target_index += 1
	else:
		target_index -= 1
		
	if target_index >= options.size() || target_index < 0:
		target_index = 0
