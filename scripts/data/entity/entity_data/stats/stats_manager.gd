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
