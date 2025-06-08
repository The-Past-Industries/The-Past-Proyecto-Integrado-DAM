extends Node
class_name ItemEffect

var effect_details: Array[ItemEffectDetail]

func _init(effect_details: Array[ItemEffectDetail]):
	self.effect_details = effect_details
