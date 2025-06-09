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
signal entity_died


func start_combat(is_boss: bool = false):
	# TODO ACTUALIZAR INTERFAZ A COMBATE
	enemy_is_boss = is_boss
	Logger.info("========= CombatManager: COMBAT STARTED. BOSS: %s =========" % is_boss)
	EntityManagerGlobal.player.get_body().is_locked = true
	turn_indicator = WorldManagerGlobal.cur_cell_instance.turn_indicator as TurnIndicator
	turn_indicator.visible = true
	
	while !combat_is_over:
		await _launch_round()
	
	await end_combat(enemy_is_boss)
	

func end_combat(is_boss: bool = false):
	await get_tree().create_timer(GlobalConstants.COMBAT_TIME_BEFORE_CORPSE_DESPAWNS).timeout
	EntityManagerGlobal.enemy.body_instance.aux_animations.despawn_pop()
	await EntityManagerGlobal.enemy.body_instance.despawn_node_translation()
	WorldManagerGlobal.remove_enemy_from_instance()
	await get_tree().create_timer(1).timeout
	EntityManagerGlobal.player.get_body().is_locked = false
	EntityManagerGlobal.player.stats_manager.release_temporal_stats()
	turn_indicator.despawn_pop()
	PhaseManagerGlobal.change_phase(PhaseType.TRAVEL)
	MenuManagerGlobal.refresh_cur_phase_buttons()
	(WorldManagerGlobal.cur_cell_instance as RoomControllerCommon).exit_combat_state()
	MenuManagerGlobal.update_visors()

func update_turns():
	player_turn_count = int(EntityManagerGlobal.player.stats_manager.get_stat_value(StatType.ATTACK_SPD))
	if !enemy_is_boss:
		enemy_turn_count = int(EntityManagerGlobal.enemy.stats_manager.get_stat_value(StatType.ATTACK_SPD))
	else:
		boss_turn_count = int(EntityManagerGlobal.boss.stats_manager.get_stat_value(StatType.ATTACK_SPD))

func _launch_round():
	update_turns()
	if player_turn:
		for i in player_turn_count:
			_check_deaths()
			if combat_is_over:
				break
			Logger.info("CombatManager: PLAYER TURN %d OF %d" % [i, player_turn_count])
			await _player_turn()
			if combat_is_over:
				break
			if i == player_turn_count - 1:
				turn_indicator.spin_180()
				player_turn = false
			else:
				turn_indicator.spin_360()
	elif !enemy_is_boss:
		for i in enemy_turn_count:
			_check_deaths()
			if combat_is_over:
				break
			Logger.info("CombatManager: ENEMY TURN %d OF %d" % [i, enemy_turn_count])
			await _enemy_turn()
			if combat_is_over:
				break
			if i == enemy_turn_count - 1:
				turn_indicator.spin_180()
				player_turn = true
			else:
				turn_indicator.spin_360()
	else:
		for i in boss_turn_count:
			_check_deaths()
			if combat_is_over:
				break
			Logger.info("CombatManager: BOSS TURN %d OF %d" % [i, boss_turn_count])
			await _boss_turn()
			if combat_is_over:
				break
			if i == boss_turn_count - 1:
				turn_indicator.spin_180()
				player_turn = false
			else:
				turn_indicator.spin_360()

func _check_deaths():
	# PLAYER DIE
	if EntityManagerGlobal.player.stats_manager.get_stat_value(StatType.HEALTH_PTS) <= 0:
		EntityManagerGlobal.player.body_instance.death_animation()
		Logger.info("CombatManager: Player death check [true]")
		combat_is_over = true
		
		
	# ENEMY DIE
	if !enemy_is_boss:
		if EntityManagerGlobal.enemy.stats_manager.get_stat_value(StatType.HEALTH_PTS) <= 0:
			Logger.info("CombatManager: Enemy death check [true]")
			combat_is_over = true
		
	# BOSS DIE
	else:
		if EntityManagerGlobal.boss.stats_manager.get_stat_value(StatType.HEALTH_PTS) <= 0:
			Logger.info("CombatManager: Boss death check [true]")
			combat_is_over = true
	

func _player_turn():
	Logger.info("CombatManager: PLAYER TURN. WAITING FOR OPTION")
	MenuManagerGlobal.enable_all_buttons()
	await MenuManagerGlobal.player_choose_option


func _enemy_turn():
	Logger.info("CombatManager: ENEMY TURN. WAITING FOR OPTION")
	await get_tree().create_timer(GlobalConstants.COMBAT_TIME_BETWEEN_TURNS).timeout
	
	_enemy_choose_option()
	MenuManagerGlobal.enable_all_buttons()

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
		
	var dmg = EntityManagerGlobal.enemy.stats_manager.get_stat_value(dmg_type) + GlobalConstants.ENEMY_BASE_DMG_COMMON_ATTACK
	var pen = EntityManagerGlobal.enemy.stats_manager.get_stat_value(pen_type)
	EntityManagerGlobal.damage_from_to(EntityManagerGlobal.enemy, EntityManagerGlobal.player, dmg_type, dmg)
	EntityManagerGlobal.player.body_instance.hit_animation()
	VFXManagerGlobal.manage_player_special_animation("holy_11_light_hit_pop")
	emit_signal("enemy_choose_option")

func _boss_turn():
	pass
