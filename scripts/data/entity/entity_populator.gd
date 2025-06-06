extends Node
class_name EntityPopulator


func load_enemies_from_json() -> Array:
	
	# Data from JSON
	var file = FileAccess.open(GlobalConstants.ITEMS_LIST_JSON_PATH, FileAccess.READ)
	var content = file.get_as_text()
	var data = JSON.parse_string(content)
	
	# Null check
	if data == null:
		Logger.error("EntityPopulator: Invalid items list JSON")
		return []
	
	# Enemies from dictionary loop
	var enemies: Array = []
	for enemy_dict in data["enemies"]:
		var enemy = _populate_enemy(enemy_dict)
		enemies.append(enemy)
	
	return enemies

func _populate_enemy(item_dict: Dictionary) -> Item:
	
	# Common attributes
	
	var detail_dict = item_dict["item_detail"]
	var stat_variations: Array[StatVariation] = []
	for stat_variation_dict in detail_dict["stat_variations"]:
		var stat_variation: StatVariation = StatVariation.new(
			stat_variation_dict["stat_type"],
			stat_variation_dict["variation_value"],
			stat_variation_dict["is_multiplying"]
		)
		stat_variations.append(stat_variation)
	
	var item_detail = ItemDetail.new(
		detail_dict["item_id"],
		detail_dict["item_name"],
		detail_dict["item_alias"],
		detail_dict["item_description"],
		detail_dict["item_tier"],
		stat_variations,
		detail_dict["spawn_ratio"],
		detail_dict.get("item_special_spawn", -1))
		
	
	# Populating item by class type
	
	var clase: int = _item_class_str_to_enum(item_dict.get("item_class", ""))
	match clase:
		ItemType.ACTIVE:
			return ItemActive.new(item_detail, item_dict["sprite_file"], _populate_active_effect_list(item_dict))
		ItemType.PASSIVE:
			return ItemPassive.new(item_detail, item_dict["sprite_file"], _populate_passive_effect_list(item_dict))
		ItemType.MULTI_EFFECT:
			return ItemMultieffect.new(item_detail, item_dict["sprite_file"], _populate_passive_effect_list(item_dict), _populate_active_effect_list(item_dict))
		
		# Error case:
		_:
			push_error("Error in ItemPopulator._item_from_dict. Item class id invalid: %s" % clase)
			return null

func _populate_active_effect_list(item_dict: Dictionary) -> Array[ItemEffectActive]:
	
	# Main list
	var active_effect_list: Array[ItemEffectActive] = []
	
	# Active Effect loop
	for active_effect_dict in item_dict.get("active_effects", []):
		
		# Effect Details loop
		var effect_details: Array[ItemEffectDetail] = []
		for effect_detail_dict in active_effect_dict["effect_details"]:
			var effect_detail = ItemEffectDetail.new(
				effect_detail_dict["effect_id"],
				effect_detail_dict["effect_name"],
				effect_detail_dict["effect_decription"],
				effect_detail_dict["proc_type"],
				effect_detail_dict["effect_type"]
			)
			effect_details.append(effect_detail)
		
		var active_effect = ItemEffectActive.new(effect_details)
		active_effect_list.append(active_effect)
		
	return active_effect_list

func _populate_passive_effect_list(item_dict) -> Array[ItemEffectPassive]:
		
	# Main list
	var passive_effect_list: Array[ItemEffectPassive] = []
	
	# Passive Effect loop
	for passive_effect_dict in item_dict.get("passive_effects", []):
		
		# Effect Details loop
		var effect_details: Array[ItemEffectDetail] = []
		for effect_detail_dict in passive_effect_dict["effect_details"]:
			var effect_detail = ItemEffectDetail.new(
				effect_detail_dict["effect_id"],
				effect_detail_dict["effect_name"],
				effect_detail_dict["effect_decription"],
				effect_detail_dict["proc_type"],
				effect_detail_dict["effect_type"]
			)
			effect_details.append(effect_detail)
		
		var passive_effect = ItemEffectPassive.new(effect_details)
		passive_effect_list.append(passive_effect)
		
	return passive_effect_list
