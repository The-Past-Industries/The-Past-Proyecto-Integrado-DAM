extends Node3D
class_name PopNum

@onready var label_3d = $Label3D
@onready var sprite_3d = $Sprite3D

var velocity := Vector3(0, 1.5, 0)
var duration := 0.8
var elapsed := 0.0
var start_pos := Vector3.ZERO

var data_set: bool = false

var pop_num_type: int
var value: float

var texture
var color

func _process(delta: float) -> void:
	
	elapsed += delta
	var t := elapsed / duration
	if t >= 1.0:
		queue_free()
		return

	global_position = start_pos + velocity * t
	
	var alpha = lerp(1.0, 0.0, t)

	if sprite_3d:
		sprite_3d.texture = self.texture
		sprite_3d.modulate.a = alpha
	
	if label_3d:
		label_3d.text = "%.0f" % self.value
		label_3d.modulate = color
		label_3d.modulate.a = alpha


func set_data(pop_num_type: int, value: float):
	self.pop_num_type = pop_num_type
	self.value = value
	auto_color_and_icon()
	data_set = true
	start_pos = global_position


func auto_color_and_icon():
	match pop_num_type:
		PopNumType.PHY_DMG:
			texture = PopNumManagerGlobal.POP_NUM_PHY
			color = Color("#e3735d")
		PopNumType.MAG_DMG:
			texture = PopNumManagerGlobal.POP_NUM_MAG
			color = Color("#59b4fb")
		PopNumType.PHY_ARM:
			texture = PopNumManagerGlobal.POP_NUM_PHY_ARM
			color = Color("#c65640")
		PopNumType.MAG_ARM:
			texture = PopNumManagerGlobal.POP_NUM_MAG_ARM
			color = Color("#91ccfe")
		PopNumType.PHY_PEN:
			sprite_3d.rotation.z = 90
			texture = PopNumManagerGlobal.POP_NUM_PHY_PEN
			color = Color("#c65640")
		PopNumType.MAG_PEN:
			sprite_3d.rotation.z = 90
			texture = PopNumManagerGlobal.POP_NUM_MAG_PEN
			color = Color("#0f81c8")
		PopNumType.GOLD:
			texture = PopNumManagerGlobal.POP_NUM_GOLD
			color = Color("#feab48")
		PopNumType.KEY:
			texture = PopNumManagerGlobal.POP_NUM_KEY
			color = Color("#ffefdf")
		PopNumType.HEAL:
			texture = PopNumManagerGlobal.POP_NUM_HEAL
			color = Color("#5dc833")
