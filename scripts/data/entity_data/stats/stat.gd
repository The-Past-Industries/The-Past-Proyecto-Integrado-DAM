extends RefCounted
class_name Stat

var stat_type: int
var is_percentage: bool
var value: float

func _init(stat_type: int, is_percentage: bool = false, value: float = 0.0):
	self.stat_type = stat_type
	self.is_percentage = is_percentage
	self.value = value
