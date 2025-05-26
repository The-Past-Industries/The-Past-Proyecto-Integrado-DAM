extends RefCounted
class_name ItemEffectDetail

# TODO Extender 

var effect_id: int
var effect_name: String
var effect_description: String

# ItemEffectProcType
var proc_type: int

# ItemEffectType
var effect_type: int

func _init(
	effect_id: int,
	effect_name: String,
	effect_description: String,
	proc_type: int,
	effect_type: int
):
	self.effect_id = effect_id
	self.effect_name = effect_name
	self.effect_description = effect_description
	self.proc_type = proc_type
	self.effect_type = effect_type
