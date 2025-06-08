extends RefCounted
class_name StatVariator

var statsList: Array[Stat]

func _init(statsList: Array[Stat]):
	self.statsList = statsList

func alterStat(statVariation: StatVariation):
	var stat: Stat = _get_stat_by_type(statVariation.stat_type)
	
	if (statVariation.is_multiplying):
		stat.value *= statVariation.variation_value
	else:
		stat.value += statVariation.variation_value
	
	# Percentages
	if stat.is_percentage:
		if stat.value > 100:
			stat.value = 100
		if stat.value <= 0:
			stat.value = 0
		return
	
	# TODO: Eliminar casos flat comunes
	
	# Flats
	match stat.stat_type:
		StatType.HEALTH_PTS:
			pass
		StatType.LIGHT_PTS:
			pass
		StatType.PHYSICAL_DMG:
			pass
		StatType.MAGIC_DMG:
			pass
		StatType.TRUE_DMG:
			pass
		StatType.ATTACK_SPD:
			pass
		StatType.CRITICAL_CHA:
			pass
		StatType.HEALTH_MAX:
			pass
		
	if stat.value <= 0:
		stat.value = 0
	return

func _get_stat_by_type(stat_type: int) -> Stat:
	for stat in statsList:
		if stat.stat_type == stat_type:
			return stat
	return null
