extends ItemEffect
class_name ItemEffectActive

var effect_function

func _init(effect_details: Array[ItemEffectDetail]):
	super(effect_details)

func set_effect_function(function):
	self.effect_function = function

func applyEffect():
	effect_function.call()
