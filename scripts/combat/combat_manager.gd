extends Node
class_name CombatManager

var player_turn_count: int
var enemy_turn_count: int
var boss_turn_count: int

var player_turn: bool = true
var enemy_is_boss: bool = false
var combat_is_over: bool = false
var turn_indicator: TurnIndicator

signal enemy_choose_option
signal boss_choose_option

func _process(_delta):
	pass
	#if PhaseManagerGlobal.cur_phase_type == PhaseType.COMBAT:
		#
		# PLAYER DIE
		# if EntityManagerGlobal.player.stats_manager.get_stat_value(StatType.HEALTH_PTS) <= 0:
		#	EntityManagerGlobal.player.body_instance.death_animation()
		#	combat_is_over = true
		#	return
		
		# ENEMY DIE
		#elif !enemy_is_boss:
		#	if EntityManagerGlobal.enemy.stats_manager.get_stat_value(StatType.HEALTH_PTS) <= 0:
		#		(EntityManagerGlobal.enemy.body_instance as AnimationHostCommon).death()
		#		combat_is_over = true
		#		return
		
		# BOSS DIE
		#else:
			#if EntityManagerGlobal.boss.stats_manager.get_stat_value(StatType.HEALTH_PTS) <= 0:
			#	combat_is_over = true
			#	return
		
		#combat_is_over = false

func start_combat(is_boss: bool = false):
	# TODO ACTUALIZAR INTERFAZ A COMBATE
	enemy_is_boss = is_boss
	Logger.info("========= CombatManager: COMBAT STARTED. BOSS: %s =========" % is_boss)
	EntityManagerGlobal.player.get_body().is_locked = true
	turn_indicator = WorldManagerGlobal.cur_cell_instance.turn_indicator as TurnIndicator
	
	while !combat_is_over:
		await _launch_round()
	
	await end_combat(enemy_is_boss)
	

func end_combat(is_boss: bool = false):
	await get_tree().create_timer(GlobalConstants.COMBAT_TIME_BETWEEN_TURNS).timeout
	EntityManagerGlobal.player.get_body().is_locked = false
	PhaseManagerGlobal.change_phase(PhaseType.TRAVEL)

func update_turns():
	player_turn_count = int(EntityManagerGlobal.player.stats_manager.get_stat_value(StatType.ATTACK_SPD))
	if !enemy_is_boss:
		enemy_turn_count = int(EntityManagerGlobal.enemy.stats_manager.get_stat_value(StatType.ATTACK_SPD))
	else:
		boss_turn_count = int(EntityManagerGlobal.boss.stats_manager.get_stat_value(StatType.ATTACK_SPD))

func _launch_round():
	update_turns()
	if combat_is_over:
		return

	if player_turn:
		for i in player_turn_count:
			Logger.info("CombatManager: PLAYER TURN %d OF %d" % [i, player_turn_count])
			await _player_turn()
			if i == player_turn_count - 1:
				turn_indicator.spin_180()
				player_turn = false
			else:
				turn_indicator.spin_360()
				pass
	elif !enemy_is_boss:
		for i in enemy_turn_count:
			Logger.info("CombatManager: ENEMY TURN %d OF %d" % [i, enemy_turn_count])
			await _enemy_turn()
			if i == enemy_turn_count - 1:
				turn_indicator.spin_180()
				player_turn = true
			else:
				turn_indicator.spin_360()
				pass
	else:
		for i in boss_turn_count:
			Logger.info("CombatManager: BOSS TURN %d OF %d" % [i, boss_turn_count])
			await _boss_turn()
			if i == boss_turn_count - 1:
				turn_indicator.spin_180()
				player_turn = false
			else:
				turn_indicator.spin_360()
				pass

func _player_turn():
	Logger.info("CombatManager: PLAYER TURN. WAITING FOR OPTION")
	await MenuManagerGlobal.player_choose_option

func _enemy_turn():
	Logger.info("CombatManager: ENEMY TURN. WAITING FOR OPTION")
	await get_tree().create_timer(GlobalConstants.COMBAT_TIME_BETWEEN_TURNS).timeout
	
	_enemy_choose_option()

func _enemy_choose_option():
	# TODO CAMBIAR POR PERSONALIZADO
	(EntityManagerGlobal.enemy.body_instance as AnimationHostCommon).attack()
	
	var is_phys_dmg = randi() % 2 == 0
	
	var dmg_type
	var pen_type
	
	if is_phys_dmg:
		dmg_type = StatType.PHYSICAL_DMG
		pen_type = StatType.PHYSICAL_PEN
		
	else:
		dmg_type = StatType.MAGIC_DMG
		pen_type = StatType.MAGIC_PEN
		
	var dmg = EntityManagerGlobal.enemy.stats_manager.get_stat_value(dmg_type)
	var pen = EntityManagerGlobal.enemy.stats_manager.get_stat_value(pen_type)
	EntityManagerGlobal.damage_from_to(EntityManagerGlobal.enemy, EntityManagerGlobal.player, dmg_type, dmg)
	emit_signal("enemy_choose_option")

func _boss_turn():
	pass
