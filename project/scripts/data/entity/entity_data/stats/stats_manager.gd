extends RefCounted
class_name StatsManager

var is_inmortal: bool = false

# Stats
var health: Stat = Stat.new(StatType.HEALTH_PTS)
var health_max: Stat = Stat.new(StatType.HEALTH_MAX)
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

var temp_stat_variations: Array[StatVariation] = []

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
		critical_chance,
		health_max
	]
	statVariator = StatVariator.new(statsList)

func alterStat(statVariation: StatVariation):
	statVariator.alterStat(statVariation)

func set_initial_player_stats():
	var randomized_variations = [
		StatVariation.new(StatType.PHYSICAL_DMG, GlobalConstants.PLAYER_INITIAL_STAT_PHYSICAL_DAMAGE, false),
		StatVariation.new(StatType.PHYSICAL_PEN, GlobalConstants.PLAYER_INITIAL_STAT_PHYSICAL_PENETRATION, false),
		StatVariation.new(StatType.PHYSICAL_ARM, GlobalConstants.PLAYER_INITIAL_STAT_PHYSICAL_ARMOR, false),
		StatVariation.new(StatType.MAGIC_DMG, GlobalConstants.PLAYER_INITIAL_STAT_MAGICAL_DAMAGE, false),
		StatVariation.new(StatType.MAGIC_PEN, GlobalConstants.PLAYER_INITIAL_STAT_MAGICAL_PENETRATION, false),
		StatVariation.new(StatType.MAGIC_ARM, GlobalConstants.PLAYER_INITIAL_STAT_MAGICAL_ARMOR, false),
		StatVariation.new(StatType.ATTACK_SPD, GlobalConstants.PLAYER_INITIAL_STAT_PHYSICAL_ATTACK_SPEED, false),
		StatVariation.new(StatType.CRITICAL_CHA, GlobalConstants.PLAYER_INITIAL_STAT_CRITICAL_CHANCE, false),
		StatVariation.new(StatType.HEALTH_MAX, GlobalConstants.PLAYER_INITIAL_STAT_HEALTH_MAX, false),
		StatVariation.new(StatType.HEALTH_PTS, GlobalConstants.PLAYER_INITIAL_STAT_HEALTH_MAX, false)
	]
	for variation in randomized_variations:
		statVariator.alterStat(variation)

func randomizeStats():
	randomize()
	
	var hp_variation = StatVariation.new(StatType.HEALTH_MAX, randi_range(GlobalConstants.ENTTITYGEN_MIN_RANDOM_HP, GlobalConstants.ENTTITYGEN_MAX_RANDOM_HP), false)
	
	var randomized_variations = [
		hp_variation,
		StatVariation.new(StatType.HEALTH_PTS, hp_variation.variation_value, false),
		StatVariation.new(StatType.PHYSICAL_DMG, randi_range(GlobalConstants.ENTTITYGEN_MIN_RANDOM_PHY_DMG, GlobalConstants.ENTTITYGEN_MAX_RANDOM_PHY_DMG), false),
		StatVariation.new(StatType.PHYSICAL_PEN, randi_range(GlobalConstants.ENTTITYGEN_MIN_RANDOM_PHY_PEN, GlobalConstants.ENTTITYGEN_MAX_RANDOM_PHY_PEN), false),
		StatVariation.new(StatType.PHYSICAL_ARM, randi_range(GlobalConstants.ENTTITYGEN_MIN_RANDOM_PHY_ARM, GlobalConstants.ENTTITYGEN_MAX_RANDOM_PHY_ARM), false),
		StatVariation.new(StatType.MAGIC_DMG, randi_range(GlobalConstants.ENTTITYGEN_MIN_RANDOM_MAG_DMG, GlobalConstants.ENTTITYGEN_MAX_RANDOM_MAG_DMG), false),
		StatVariation.new(StatType.MAGIC_PEN, randi_range(GlobalConstants.ENTTITYGEN_MIN_RANDOM_MAG_PEN, GlobalConstants.ENTTITYGEN_MAX_RANDOM_MAG_PEN), false),
		StatVariation.new(StatType.MAGIC_ARM, randi_range(GlobalConstants.ENTTITYGEN_MIN_RANDOM_MAG_ARM, GlobalConstants.ENTTITYGEN_MAX_RANDOM_MAG_ARM), false),
		StatVariation.new(StatType.ATTACK_SPD, randi_range(GlobalConstants.ENTTITYGEN_MIN_RANDOM_ATK_SPD, GlobalConstants.ENTTITYGEN_MAX_RANDOM_ATK_SPD), false),
		StatVariation.new(StatType.CRITICAL_CHA, randi_range(GlobalConstants.ENTTITYGEN_MIN_RANDOM_CRI_CHA, GlobalConstants.ENTTITYGEN_MAX_RANDOM_CRI_CHA), false)
	]	
	for variation in randomized_variations:
		statVariator.alterStat(variation)

func take_damage(stat_type: int, damage_positive_value: float, pen_stat: float):
	var armor_value: float
	match stat_type:
		StatType.PHYSICAL_DMG:
			armor_value = physical_armor.value
			armor_value *= (1.0 - clamp(pen_stat / 100.0, 0.0, 1.0))
			
		StatType.MAGIC_DMG:
			armor_value = magic_armor.value
			armor_value *= (1.0 - clamp(pen_stat / 100.0, 0.0, 1.0))
		
		StatType.TRUE_DMG:
			Logger.warning("StatsManager: TRUE DAMAGE used and is not implemented yet")
			armor_value = 0.0
		
		_:
			Logger.error("StatsManager: Invalid taken damage type")
			return

	var final_damage: float = max(damage_positive_value - armor_value / 2, 0.0)
	Logger.info("StatsManager: Final damage taken = %.2f (base: %.2f, reduced by armor: %.2f)" % [final_damage, damage_positive_value, armor_value])
	alterStat(StatVariation.new(StatType.HEALTH_PTS, -final_damage, false))

func heal(heal_value: float):
	alterStat(StatVariation.new(StatType.HEALTH_PTS, heal_value, false))

func alter_stat_temporal(stat_variation: StatVariation):
	alterStat(stat_variation)
	temp_stat_variations.append(stat_variation)

func release_temporal_stats():
	EntityManagerGlobal.player.stats_manager.is_inmortal = false
	for stat_variation in temp_stat_variations:
		stat_variation.variation_value = -stat_variation.variation_value
		alterStat(stat_variation)

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
		StatType.HEALTH_MAX:
			return health_max.value
		_:
			return -1
