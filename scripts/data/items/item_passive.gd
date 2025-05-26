extends Item
class_name ItemPassive

var passive_effect_list: Array[ItemEffectPassive]

func _init(item_detail: ItemDetail, sprite_file: String, passive_effect_list: Array[ItemEffectPassive]):
		super(item_detail, sprite_file)
		self.passive_effect_list = passive_effect_list
