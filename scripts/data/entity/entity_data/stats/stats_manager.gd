extends RefCounted
class_name StatsManager

# Stats
var health: Stat = Stat.new(StatType.HEALTH_PTS)
var light: Stat = Stat.new(StatType.LIGHT_PTS, true)
var attack_speed: Stat = Stat.new(StatType.ATTACK_SPD)
var critical_chance: Stat = Stat.new(StatType.CRITICAL_CHA)

# Resistances
var physical_armor: Stat = Stat.new(StatType.PHYSICAL_ARM, true)
var magic_armor: Stat = Stat.new(StatType.MAGIC_ARM, true)

# Damages
var physical_damage: Stat = Stat.new(StatType.PHYSICAL_DMG)
var magic_damage: Stat = Stat.new(StatType.MAGIC_DMG)
var true_damage: Stat = Stat.new(StatType.TRUE_DMG)

# Penetrations

var physical_penetration: Stat = Stat.new(StatType.PHYSICAL_PEN, true)
var magic_penetration: Stat = Stat.new(StatType.MAGIC_PEN, true)

# Stat Management
var statVariator: StatVariator
var statsList: Array[Stat] = []

func _init():
	statsList = [
		health,
		light,
		attack_speed,
		physical_armor,
		magic_armor,
		physical_damage,
		magic_damage,
		true_damage,
		physical_penetration,
		magic_penetration,
		critical_chance
	]
	statVariator = StatVariator.new(statsList)

func alterStat(statVariation: StatVariation):
	statVariator.alterStat(statVariation)

func set_initial_player_stats():
	# TODO completar
	pass

func randomizeStats():
	var randomized_variations = [
		StatVariation.new(StatType.HEALTH_PTS, randi_range(GlobalConstants.ENTTITYGEN_MIN_RANDOM_HP, GlobalConstants.ENTTITYGEN_MAX_RANDOM_HP), false),
		StatVariation.new(StatType.PHYSICAL_DMG, randi_range(GlobalConstants.ENTTITYGEN_MIN_RANDOM_PHY_DMG, GlobalConstants.ENTTITYGEN_MAX_RANDOM_PHY_DMG), false),
		StatVariation.new(StatType.MAGIC_DMG, randi_range(GlobalConstants.ENTTITYGEN_MIN_RANDOM_MAG_DMG, GlobalConstants.ENTTITYGEN_MAX_RANDOM_MAG_DMG), false),
		StatVariation.new(StatType.PHYSICAL_ARM, randi_range(GlobalConstants.ENTTITYGEN_MIN_RANDOM_PHY_ARM, GlobalConstants.ENTTITYGEN_MAX_RANDOM_PHY_ARM), false),
		StatVariation.new(StatType.MAGIC_ARM, randi_range(GlobalConstants.ENTTITYGEN_MIN_RANDOM_MAG_ARM, GlobalConstants.ENTTITYGEN_MAX_RANDOM_MAG_ARM), false),
		StatVariation.new(StatType.PHYSICAL_PEN, randi_range(GlobalConstants.ENTTITYGEN_MIN_RANDOM_PHY_PEN, GlobalConstants.ENTTITYGEN_MAX_RANDOM_PHY_PEN), false),
		StatVariation.new(StatType.MAGIC_PEN, randi_range(GlobalConstants.ENTTITYGEN_MIN_RANDOM_MAG_PEN, GlobalConstants.ENTTITYGEN_MAX_RANDOM_MAG_PEN), false),
		StatVariation.new(StatType.ATTACK_SPD, randi_range(GlobalConstants.ENTTITYGEN_MIN_RANDOM_ATK_SPD, GlobalConstants.ENTTITYGEN_MAX_RANDOM_ATK_SPD), false)
	]	
	for variation in randomized_variations:
		statVariator.alterStat(variation)

func get_stat_value(stat_type: int) -> float:
	match stat_type:
		StatType.HEALTH_PTS:
			return health.value
		StatType.PHYSICAL_DMG:
			return physical_damage.value
		StatType.PHYSICAL_PEN:
			return physical_penetration.value
		StatType.PHYSICAL_ARM:
			return physical_armor.value
		StatType.ATTACK_SPD:
			return attack_speed.value
		StatType.MAGIC_DMG:
			return magic_damage.value
		StatType.MAGIC_PEN:
			return magic_penetration.value
		StatType.MAGIC_ARM:
			return magic_armor.value
		StatType.CRITICAL_CHA:
			return critical_chance.value
		_:
			return -1
