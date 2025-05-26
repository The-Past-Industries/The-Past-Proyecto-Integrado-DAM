extends Node
class_name Item

var item_detail: ItemDetail
var sprite_file: String

func _init(item_detail: ItemDetail, sprite_file: String):
	self.item_detail = item_detail
	self.sprite_file = sprite_file
