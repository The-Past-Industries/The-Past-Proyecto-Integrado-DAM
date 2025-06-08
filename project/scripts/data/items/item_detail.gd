extends RefCounted
class_name ItemDetail

var item_id: int
var item_name: String
var item_alias: String
var item_description: String
var item_tier: int
var stat_variations: Array[StatVariation]
var special_spawn_id: int
var spawn_ratio: float

func _init(
	item_id: int,
	item_name: String,
	item_alias: String,
	item_description: String,
	item_tier: int,
	stat_variations: Array[StatVariation],
	spawn_ratio: float,
	special_spawn_id: int = 0
):
	self.item_id = item_id
	self.item_name = item_name
	self.item_alias = item_alias
	self.item_description = item_description
	self.item_tier = item_tier
	self.stat_variations = stat_variations
	self.spawn_ratio = spawn_ratio

# TODO: Enum special spawn y lógica
func is_special_spawn() -> bool:
	return special_spawn_id != 0
