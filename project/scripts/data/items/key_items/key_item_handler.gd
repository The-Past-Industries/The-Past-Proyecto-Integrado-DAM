extends Node

func apply_key_item_effect(key_item_id: int):
	
	match key_item_id:
		0:
			heal_percentage(GlobalConstants.KEY_ITEM_0_HP_PERCENTAGE_TO_HEAL)
		
		1:
			heal_percentage(GlobalConstants.KEY_ITEM_1_HP_PERCENTAGE_TO_HEAL)
		
		2:
			heal_percentage(GlobalConstants.KEY_ITEM_2_HP_PERCENTAGE_TO_HEAL)
			
		
		3:
			heal_percentage(GlobalConstants.KEY_ITEM_3_HP_PERCENTAGE_TO_HEAL)
			
		
		4:
			heal_percentage(GlobalConstants.KEY_ITEM_4_HP_PERCENTAGE_TO_HEAL)
			
		
		5:
			heal_percentage(GlobalConstants.KEY_ITEM_5_HP_PERCENTAGE_TO_HEAL)
		
		6:
			heal_percentage(GlobalConstants.KEY_ITEM_6_HP_PERCENTAGE_TO_HEAL)
			alter_stat_temporal(StatVariation.new(StatType.PHYSICAL_DMG, _get_stat_percentage(StatType.PHYSICAL_DMG, GlobalConstants.KEY_ITEM_6_PHY_DMG_PERCENTAGE_DOWN_TEMP), false))
		
		7:
			heal_percentage(GlobalConstants.KEY_ITEM_7_HP_PERCENTAGE_TO_HEAL)
			alter_stat_temporal(StatVariation.new(StatType.PHYSICAL_DMG, _get_stat_percentage(StatType.PHYSICAL_DMG, GlobalConstants.KEY_ITEM_7_PHY_DMG_PERCENTAGE_DOWN_TEMP), false))
		
		8:
			heal_percentage(GlobalConstants.KEY_ITEM_8_HP_PERCENTAGE_TO_HEAL)
			alter_stat_temporal(StatVariation.new(StatType.MAGIC_DMG, _get_stat_percentage(StatType.MAGIC_DMG, GlobalConstants.KEY_ITEM_8_MAG_DMG_PERCENTAGE_DOWN_TEMP), false))
		
		9:
			EntityManagerGlobal.player.stats_manager.alterStat(StatVariation.new(StatType.MAGIC_ARM, GlobalConstants.KEY_ITEM_9_MAG_ARM_UP, false))
		
		10:
			EntityManagerGlobal.player.stats_manager.alterStat(StatVariation.new(StatType.MAGIC_ARM, GlobalConstants.KEY_ITEM_10_PHY_ARM_UP, false))
		
		11:
			EntityManagerGlobal.player.stats_manager.alterStat(StatVariation.new(StatType.MAGIC_ARM, GlobalConstants.KEY_ITEM_11_MAG_ARM_UP, false))
		
		12:
			EntityManagerGlobal.player.stats_manager.alterStat(StatVariation.new(StatType.MAGIC_ARM, GlobalConstants.KEY_ITEM_12_PHY_ARM_UP, false))
		
		13:
			EntityManagerGlobal.player.stats_manager.alterStat(StatVariation.new(StatType.HEALTH_PTS, GlobalConstants.KEY_ITEM_13_HP_TO_HEAL, false))
			EntityManagerGlobal.player.stats_manager.alterStat(StatVariation.new(StatType.CRITICAL_CHA, GlobalConstants.KEY_ITEM_13_CRI_CHA_PERCENTAGE_DOWN, false))
		
		14:
			if _fifty_fifty_chance():
				heal_percentage(GlobalConstants.KEY_ITEM_14_HP_MAX_PERCENTAGE_DOWN_UP)
			else:
				EntityManagerGlobal.player.stats_manager.alterStat(StatVariation.new(StatType.HEALTH_PTS, -_get_stat_percentage(StatType.HEALTH_PTS, GlobalConstants.KEY_ITEM_14_HP_MAX_PERCENTAGE_DOWN_UP), false))
		
		15:
			heal_percentage(GlobalConstants.KEY_ITEM_15_HP_PERCENTAGE_TO_HEAL)
			if _calculate_chance(GlobalConstants.KEY_ITEM_15_POISON_CHANCE):
				poison_effect(GlobalConstants.KEY_ITEM_15_POISON_MAX_HP_PERCENTAGE)
		
		16:
			heal_percentage(GlobalConstants.KEY_ITEM_16_HP_PERCENTAGE_TO_HEAL)
			if _calculate_chance(GlobalConstants.KEY_ITEM_16_POISON_CHANCE):
				poison_effect(GlobalConstants.KEY_ITEM_16_POISON_MAX_HP_PERCENTAGE)
		
		17:
			heal_percentage(GlobalConstants.KEY_ITEM_17_HP_PERCENTAGE_TO_HEAL)
			if _calculate_chance(GlobalConstants.KEY_ITEM_17_POISON_CHANCE):
				poison_effect(GlobalConstants.KEY_ITEM_17_POISON_MAX_HP_PERCENTAGE)
		
		18:
			heal_percentage(GlobalConstants.KEY_ITEM_18_HP_PERCENTAGE_TO_HEAL)
			if _calculate_chance(GlobalConstants.KEY_ITEM_18_POISON_CHANCE):
				poison_effect(GlobalConstants.KEY_ITEM_18_POISON_MAX_HP_PERCENTAGE)
		
		19:
			EntityManagerGlobal.player.stats_manager.alterStat(StatVariation.new(StatType.HEALTH_MAX, GlobalConstants.KEY_ITEM_19_HP_MAX_UP, false))
		
		20:
			EntityManagerGlobal.player.player_gold += randi_range(GlobalConstants.KEY_ITEM_20_MIN_GOLD_RANGE, GlobalConstants.KEY_ITEM_20_MAX_GOLD_RANGE)
		
		21:
			# DOBLE DINERO % PERDER
			EntityManagerGlobal.player.player_gold *= 2
			if _calculate_chance(GlobalConstants.KEY_ITEM_21_LOSE_CHANCE):
				EntityManagerGlobal.player.player_gold = 0
			
		
		22:
			EntityManagerGlobal.player.player_gold += GlobalConstants.KEY_ITEM_22_GOLD_GIVEN
		
		23:
			EntityManagerGlobal.player.player_gold += GlobalConstants.KEY_ITEM_23_GOLD_GIVEN
		
		24:
			EntityManagerGlobal.player.player_gold += GlobalConstants.KEY_ITEM_24_GOLD_GIVEN
		
		25:
			if _fifty_fifty_chance():
				EntityManagerGlobal.player.player_gold += GlobalConstants.KEY_ITEM_25_GOLD_GIVEN
			else:
				EntityManagerGlobal.player.player_keys += GlobalConstants.KEY_ITEM_25_KEYS_GIVEN
		
		26:
			alter_stat_temporal(StatVariation.new(StatType.PHYSICAL_DMG, _get_stat_percentage(StatType.PHYSICAL_DMG, GlobalConstants.KEY_ITEM_26_PHY_DMG_PERCENTAGE_UP_TEMP), false))
		
		27:
			alter_stat_temporal(StatVariation.new(StatType.PHYSICAL_ARM, _get_stat_percentage(StatType.PHYSICAL_ARM, GlobalConstants.KEY_ITEM_27_PHY_ARM_PERCENTAGE_UP_TEMP), false))
		
		28:
			alter_stat_temporal(StatVariation.new(StatType.MAGIC_DMG, _get_stat_percentage(StatType.MAGIC_DMG, GlobalConstants.KEY_ITEM_28_MAG_DMG_PERCENTAGE_UP_TEMP), false))
		
		29:
			alter_stat_temporal(StatVariation.new(StatType.MAGIC_ARM, _get_stat_percentage(StatType.MAGIC_ARM, GlobalConstants.KEY_ITEM_29_MAG_ARM_PERCENTAGE_UP_TEMP), false))
		
		30:
			WorldManagerGlobal.teleport_player_to_boss()
		
		31:
			alter_stat_temporal(StatVariation.new(StatType.HEALTH_MAX, _get_stat_percentage(StatType.HEALTH_MAX, GlobalConstants.KEY_ITEM_31_HP_MAX_PERCENTAGE_UP_TEMP), false))
		
		32:
			EntityManagerGlobal.player.stats_manager.is_inmortal = true
		
		33:
			EntityManagerGlobal.player.stats_manager.alterStat(StatVariation.new(StatType.HEALTH_MAX, GlobalConstants.KEY_ITEM_19_HP_MAX_UP, false))

func poison_effect(max_hp_percentage: float):
	EntityManagerGlobal.player.stats_manager.alterStat(StatVariation.new(StatType.HEALTH_PTS, _get_stat_percentage(StatType.HEALTH_PTS, max_hp_percentage), false))

func heal_percentage(percentage: float):
	var max_hp = EntityManagerGlobal.player.stats_manager.get_stat_value(StatType.HEALTH_MAX)
	var hp_to_heal = max_hp * (percentage/100)
	EntityManagerGlobal.heal_entity(EntityManagerGlobal.player,  hp_to_heal)

func alter_stat_temporal(stat_variation: StatVariation):
	EntityManagerGlobal.player.stats_manager.alter_stat_temporal(stat_variation)
	
func _get_stat_percentage(stat_type: int, percentage: float) -> float:
	var stat_value = EntityManagerGlobal.player.stats_manager.get_stat_value(stat_type)
	return stat_type * (percentage/100)

func _calculate_chance(chance_percentage: float) -> bool:
	return randf() < float(chance_percentage) / 100.0

func _fifty_fifty_chance() -> bool:
	return randi() % 2 == 0
