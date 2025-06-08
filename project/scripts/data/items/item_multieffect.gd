extends Item
class_name ItemMultieffect

var passive_effect_list: Array[ItemEffectPassive]
var active_effect_list: Array[ItemEffectActive]

func _init(item_detail: ItemDetail, sprite_file: String, passive_effect_list: Array[ItemEffectPassive], active_effect_list: Array[ItemEffectActive]):
		super(item_detail, sprite_file)
		self.passive_effect_list = passive_effect_list
		self.active_effect_list = active_effect_list
