extends RefCounted
class_name StatVariation

var stat_type: int
var variation_value: float
var is_multiplying: bool

func _init(stat_type: int, variation_value: float, is_multiplying: bool):
	self.stat_type = stat_type
	self.variation_value = variation_value
	self.is_multiplying = is_multiplying
