extends Item
class_name ItemActive

var active_effect_list: Array[ItemEffectActive]

func _init(item_detail: ItemDetail, sprite_file: String, active_effect_list: Array[ItemEffectActive]):
	super(item_detail, sprite_file)
	self.active_effect_list = active_effect_list
