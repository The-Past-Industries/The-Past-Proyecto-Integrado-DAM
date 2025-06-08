extends Node
class_name ItemRepository

var item_populator = ItemPopulator.new()
static var item_list: Array

func _init():
	item_list = item_populator.load_items_from_json()
	if item_list.is_empty():
		Logger.error("ItemRepository: Empty item list")

func get_item_list() -> Array:
	return item_list
