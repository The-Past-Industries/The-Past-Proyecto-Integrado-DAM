extends Node
class_name CombatManagerOLD

var player_turn_count: int
var enemy_turn_count: int
var boss_turn_count: int

var player_turn: bool = true
var enemy_is_boss: bool = false
var combat_is_over: bool = false
var turn_indicator: TurnIndicator

var combat_stablished: bool = false
var entity_agains: Entity

signal enemy_choose_option
signal boss_choose_option
signal entity_died

func start_combat(is_boss: bool = false):
	MenuManagerGlobal.enable_all_buttons()
	enemy_is_boss = is_boss
	if is_boss:
		entity_agains = EntityManagerGlobal.boss
	else:
		entity_agains = EntityManagerGlobal.enemy
	Logger.info("========= CombatManager: COMBAT STARTED. BOSS: %s =========" % is_boss)
	EntityManagerGlobal.player.get_body().is_locked = true
	turn_indicator = WorldManagerGlobal.cur_cell_instance.turn_indicator as TurnIndicator
	turn_indicator.visible = true

	_combat_round()
	
func _combat_round():
	if combat_is_over:
		Logger.info("Combat is over, ending combat")
		end_combat()
		return
	
	_launch_round()

	

func end_combat():
	await get_tree().create_timer(GlobalConstants.COMBAT_TIME_BEFORE_CORPSE_DESPAWNS).timeout
	if !enemy_is_boss:
		await entity_agains.body_instance.despawn_node_translation()
		WorldManagerGlobal.remove_enemy_from_instance()
	else:
		WorldManagerGlobal.remove_boss_from_instance()
		
	await get_tree().create_timer(1).timeout
	EntityManagerGlobal.player.get_body().is_locked = false
	EntityManagerGlobal.player.stats_manager.release_temporal_stats()
	turn_indicator.despawn_pop()
	PhaseManagerGlobal.change_phase(PhaseType.TRAVEL)
	MenuManagerGlobal.refresh_cur_phase_buttons()
	if enemy_is_boss:
		(WorldManagerGlobal.cur_cell_instance as RoomControllerBoss).exit_combat_state()
	else:
		(WorldManagerGlobal.cur_cell_instance as RoomControllerCommon).exit_combat_state()
	MenuManagerGlobal.update_visors()

func _launch_round():
	await get_tree().create_timer(GlobalConstants.COMBAT_TIME_BETWEEN_TURNS).timeout
	Logger.info("STARTING ROUND")
	if player_turn:
		await _player_turn()
		_check_deaths()
		if combat_is_over:
			Logger.info("Combat ended after player turn")
			_combat_round()
			return
		turn_indicator.spin_180()
		player_turn = false
	else:
		if !enemy_is_boss:
			await _enemy_turn()
		else:
			await _boss_turn()
		_check_deaths()
		if combat_is_over:
			Logger.info("Combat ended after enemy/boss turn")
			_combat_round()
			return
		turn_indicator.spin_180()
		player_turn = true
	_combat_round()

				

func _check_deaths() -> bool:
	var player_death: bool = EntityManagerGlobal.player.stats_manager.get_stat_value(StatType.HEALTH_PTS) <= 0
	var entity_death: bool

	var entity: Entity

	if !enemy_is_boss:
		entity = EntityManagerGlobal.enemy
	else:
		entity = EntityManagerGlobal.boss

	entity_death = entity.stats_manager.get_stat_value(StatType.HEALTH_PTS) <= 0

	return player_death || entity_death
		
	
	
	if player_death:
		EntityManagerGlobal.player.body_instance.death_animation()
	elif entity_death:
		EntityManagerGlobal.entity.body_instance.death()

	Logger.info("CombatManager: Player death check [true]")
	combat_is_over = true
		
		
	# ENEMY DIE
	if !enemy_is_boss:
		if combat_stablished and EntityManagerGlobal.enemy.stats_manager.get_stat_value(StatType.HEALTH_PTS) <= 0:
			Logger.info("CombatManager: Enemy death check [true]")
			combat_is_over = true
		
	# BOSS DIE
	else:
		if combat_stablished and EntityManagerGlobal.boss.stats_manager.get_stat_value(StatType.HEALTH_PTS) <= 0:
			Logger.info("CombatManager: Boss death check [true]")
			combat_is_over = true
	

func _player_turn():
	combat_stablished = true
	Logger.info("CombatManager: PLAYER TURN. WAITING FOR OPTION")
	await MenuManagerGlobal.player_choose_option


func _enemy_turn():
	Logger.info("CombatManager: ENEMY TURN. WAITING FOR OPTION")
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
	await EntityManagerGlobal.damage_from_to(EntityManagerGlobal.enemy, EntityManagerGlobal.player, dmg_type, dmg)
	EntityManagerGlobal.player.body_instance.hit_animation()
	VFXManagerGlobal.vfx_player.scale.x *= -1
	VFXManagerGlobal.vfx_player.launch_animation("holy_11_light_hit_pop")
	await get_tree().process_frame
	emit_signal("enemy_choose_option")

func _boss_turn():
	Logger.info("CombatManager: BOSS TURN. WAITING FOR OPTION")
	await get_tree().create_timer(GlobalConstants.COMBAT_TIME_BETWEEN_TURNS).timeout
	_boss_choose_option()
	MenuManagerGlobal.enable_all_buttons()
	
func _boss_choose_option():
	
	match (entity_agains as EntityBoss).boss_type:
		BossType.GORGON:
			_boss_gorgon_choose()
		BossType.MINOTAUR:
			_boss_monoattack_choose()
		BossType.VAMPIRE:
			_boss_monoattack_choose()
		BossType.WEREWOLF:
			_boss_monoattack_choose()
		BossType.WIZARD_1:
			_boss_wizard_1_choose()
		BossType.WIZARD_2:
			_boss_wizard_2_choose()
		BossType.WIZARD_3:
			_boss_wizard_3_choose()
		BossType.YOKAI:
			_boss_yokais_choose()
		BossType.YOKAI_3:
			_boss_yokai_3_choose()
		
	await get_tree().process_frame
	emit_signal("enemy_choose_option")

func calc_hit(base_stat: float):
	var is_phys_dmg = randi() % 2 == 0
	
	var dmg_type
	var pen_type
	
	if is_phys_dmg:
		dmg_type = StatType.PHYSICAL_DMG
		pen_type = StatType.PHYSICAL_PEN
		
	else:
		dmg_type = StatType.MAGIC_DMG
		pen_type = StatType.MAGIC_PEN
		
	var dmg = EntityManagerGlobal.boss.stats_manager.get_stat_value(dmg_type) + base_stat
	var pen = EntityManagerGlobal.boss.stats_manager.get_stat_value(pen_type)
	EntityManagerGlobal.damage_from_to(EntityManagerGlobal.boss, EntityManagerGlobal.player, dmg_type, dmg)
	EntityManagerGlobal.player.body_instance.hit_animation()
	VFXManagerGlobal.vfx_player.launch_animation("holy_11_light_hit_pop")
	await get_tree().process_frame
	emit_signal("enemy_choose_option")

func _boss_monoattack_choose():
	var boss: EntityBoss = entity_agains
	var boss_body = boss.body_instance
	boss_body.attack_1()
	
func _boss_gorgon_choose():
	var boss: EntityBoss = entity_agains
	var boss_body: AnimationHostGorgon = boss.body_instance
	
	var rand_value = _random_skill_from_list(3)
	
	if rand_value == 0:
		boss_body.attack_1()
	elif rand_value == 1:
		boss_body.attack_2()
	elif rand_value == 2:
		boss_body.attack_3()

func _boss_wizard_1_choose():
	var boss: EntityBoss = entity_agains
	var boss_body: AnimationHostWizrd1 = boss.body_instance
	var rand_value = _random_skill_from_list(4)
	if rand_value  == 0:
		boss_body.attack_1()
	elif rand_value == 1:
		boss_body.attack_2()
	elif rand_value == 2:
		boss_body.attack_charge()
	elif rand_value == 3:
		boss_body.attack_charge()

func _boss_wizard_2_choose():
	var boss: EntityBoss = entity_agains
	var boss_body: AnimationHostWizrd2 = boss.body_instance
	
	var rand_value = _random_skill_from_list(4)
	
	if rand_value  == 0:
		boss_body.attack_1()
	elif rand_value == 1:
		boss_body.attack_2()
	elif rand_value == 2:
		boss_body.attack_arrow()
	elif rand_value == 3:
		boss_body.attack_sphere()

func _boss_wizard_3_choose():
	var boss: EntityBoss = entity_agains
	var boss_body: AnimationHostWizrd3 = boss.body_instance
	
	var rand_value = _random_skill_from_list(3)
	
	if rand_value  == 0:
		boss_body.attack_1()
	elif rand_value == 1:
		boss_body.attack_charge()
	elif rand_value == 2:
		boss_body.attack_ray()

func _boss_yokais_choose():
	var boss: EntityBoss = entity_agains
	var boss_body: AnimationHostYokai1 = boss.body_instance
	
	var rand_value = _random_skill_from_list(2)
	
	if rand_value  == 0:
		boss_body.attack_1()
	elif rand_value == 1:
		boss_body.attack_2()

func _boss_yokai_3_choose():
	var boss: EntityBoss = entity_agains
	var boss_body: AnimationHostYokai3 = boss.body_instance
	
	var rand_value = _random_skill_from_list(2)
	
	if rand_value  == 0:
		boss_body.attack_1()
	elif rand_value == 1:
		boss_body.attack_2()

func _random_skill_from_list(lenght: int) -> int:
	return randi_range(0, lenght - 1)
