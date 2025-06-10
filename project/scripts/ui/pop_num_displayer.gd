extends Node3D
class_name PopNumDisplayer

const POP_NUM = preload("res://scenes/vfx/pop_num.tscn")

func launch_pop_num(pop_num_type: int, value: float):
	Logger.info("PopNumDisplayer: Pop launched type [%d] value [%f]" % [pop_num_type, value])
	var pop_num: PopNum = POP_NUM.instantiate()
	await get_tree().process_frame
	pop_num.set_data(pop_num_type, value)
	add_child(pop_num)
