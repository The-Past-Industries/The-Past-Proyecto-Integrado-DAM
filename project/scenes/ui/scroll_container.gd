extends ScrollContainer

@onready var items_container := $MarginContainer/VBoxContainer

var current_index := 0
var item_count := 0


func _ready():
	item_count = items_container.get_child_count()
	await get_tree().process_frame
	if item_count > 0:
		_focus_item(current_index)

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("arrow_up") && !MenuManagerGlobal.ui_blocked:
		_step_focus(-1)
	elif event.is_action_pressed("arrow_down")&& !MenuManagerGlobal.ui_blocked:
		_step_focus(+1)
	elif event.is_action_pressed("control_accept"):
		var node := items_container.get_child(current_index)
		if node.has_signal("pressed"):
			node.emit_signal("pressed")

func _step_focus(direction: int) -> void:
	if item_count == 0:
		return
	current_index = (current_index + direction + item_count) % item_count
	_focus_item(current_index)

func _focus_item(index: int) -> void:
	var node := items_container.get_child(index)
	if node is Control:
		node.grab_focus()
		ensure_control_visible(node)

func refresh_items():
	await get_tree().process_frame
	item_count = items_container.get_child_count()
	current_index = 0
	if item_count > 0:
		_focus_item(current_index)
