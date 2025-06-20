extends Node
class_name MenuManager

const NORMAL_BUTTON = preload("res://scenes/ui/normal_button.tscn")
const TRAVEL_BUTTON = preload("res://scenes/ui/travell_button.tscn")

var player_action_called: bool = false
var ui_blocked: bool = false
var main_ui: MainUIController

signal player_choose_option

# Control
var bottom_panel_container: BottomContainer
var menu_panel_scroll: ScrollContainer
var container
var enemy_visor_sprite: EnemyVisor

func set_bottom_panel_container(bottom_panel_container: BottomContainer):
	self.bottom_panel_container = bottom_panel_container
	
# VISORS

func update_visors():
	hide_all_side_visors()
	if PhaseManagerGlobal.cur_phase_type == PhaseType.COMBAT:
		match WorldManagerGlobal.get_comming_direction():
			Vector2i.LEFT:
				bottom_panel_container.enemy_panel_right.visible = true
				bottom_panel_container.enemy_panel_left.visible = false
				bottom_panel_container.player_panel_left.visible = true
				bottom_panel_container.player_panel_right.visible = false
			Vector2i.RIGHT:
				bottom_panel_container.enemy_panel_right.visible = false
				bottom_panel_container.enemy_panel_left.visible = true
				bottom_panel_container.player_panel_left.visible = false
				bottom_panel_container.player_panel_right.visible = true
			_:
				bottom_panel_container.enemy_panel_right.visible = true
				bottom_panel_container.enemy_panel_left.visible = false
				bottom_panel_container.player_panel_left.visible = true
				bottom_panel_container.player_panel_right.visible = false
	else:
		match WorldManagerGlobal.get_comming_direction():
			Vector2i.LEFT:
				bottom_panel_container.travel_panel_right.visible = true
				bottom_panel_container.travel_panel_left.visible = false
				bottom_panel_container.player_panel_left.visible = true
				bottom_panel_container.player_panel_right.visible = false
			Vector2i.RIGHT:
				bottom_panel_container.travel_panel_right.visible = false
				bottom_panel_container.travel_panel_left.visible = true
				bottom_panel_container.player_panel_left.visible = false
				bottom_panel_container.player_panel_right.visible = true
			_:
				bottom_panel_container.travel_panel_right.visible = true
				bottom_panel_container.travel_panel_left.visible = false
				bottom_panel_container.player_panel_left.visible = true
				bottom_panel_container.player_panel_right.visible = false

func hide_all_side_visors():
	bottom_panel_container.enemy_panel_left.visible = false
	bottom_panel_container.player_panel_left.visible = false
	bottom_panel_container.travel_panel_left.visible = false
	bottom_panel_container.enemy_panel_right.visible = false
	bottom_panel_container.player_panel_right.visible = false
	bottom_panel_container.travel_panel_right.visible = false

func set_enemy_data_in_visor():
	enemy_visor_sprite.set_enemy_sprite()
	

func remove_enemy_data_from_visor():
	enemy_visor_sprite.sprite_frames = SpriteFrames.new()

# ACTION MENU

func refresh_cur_phase_buttons():
	set_ui_by_phase(PhaseManagerGlobal.cur_phase_type)

func set_ui_by_phase(phase_type: int) -> void:
	await get_tree().process_frame
	container = menu_panel_scroll.items_container
	main_ui.score_panel_visibility(false)
	if container != null:
		_clear_menu()
		match phase_type:
			PhaseType.MENU:
				pass
			PhaseType.SCORE:
				set_score_button()
			PhaseType.TRAVEL:
				container.add_child(TRAVEL_BUTTON.instantiate())
				remove_enemy_data_from_visor()
				Logger.info("MenuManager: Travel button loaded")
			PhaseType.COMBAT:
				set_combat_buttons()
				set_enemy_data_in_visor()
			PhaseType.LOOT_DROP:
				pass
			PhaseType.LOOT_CHEST:
				pass
			PhaseType.TALK:
				pass
	menu_panel_scroll.refresh_items()

func set_combat_buttons():
	
	# PHY ATTACK
	var btn_phy_atk: = NORMAL_BUTTON.instantiate() as NormalButton
	btn_phy_atk.normal_button_type = NormalButtonType.ATTACK_PHY
	btn_phy_atk.text = "ATAQUE FÍSICO"
	container.add_child(btn_phy_atk)
	
	# SKILLS LIST
	var btn_skl_lst : = NORMAL_BUTTON.instantiate() as NormalButton
	btn_skl_lst.normal_button_type = NormalButtonType.SKILLS
	btn_skl_lst.text = "HABILIDADES"
	container.add_child(btn_skl_lst)
	
	# COVER
	# var btn_cover : = NORMAL_BUTTON.instantiate() as NormalButton
	# btn_cover.normal_button_type = NormalButtonType.COVER
	# btn_cover.text = "PROTECCIÓN"
	# container.add_child(btn_cover)

func set_skills_buttons():
	menu_panel_scroll.refresh_items()
	_clear_menu()
	var skills_list = [
		NormalButtonType.SKL_SWORD_PILAR,
		NormalButtonType.SKL_BELLS_AURA,
		NormalButtonType.SKL_PROJECTILE,
		NormalButtonType.SKL_LIGHT_CAST,
		NormalButtonType.SKL_BALL_RANDOM,
		NormalButtonType.SKL_SURIKEN,
	]
	for i in WorldManagerGlobal.level + 1:
		
		var btn: = NORMAL_BUTTON.instantiate() as NormalButton
		var type = skills_list[i]
		btn.normal_button_type = type
		
		match type:
			NormalButtonType.SKL_PROJECTILE:
				btn.text = "DISPARO DE LUZ"
			NormalButtonType.SKL_SWORD_PILAR:
				btn.text = "JUSTICIA DIVINA"
			NormalButtonType.SKL_BELLS_AURA:
				btn.text = "REDENCIÓN"
			NormalButtonType.SKL_LIGHT_CAST:
				btn.text = "CONCENTRACIÓN"
			NormalButtonType.SKL_BALL_RANDOM:
				btn.text = "DISPARO CAOS"
			NormalButtonType.SKL_SURIKEN:
				btn.text = "SURIKEN DE LUZ"
		container.add_child(btn)
	
	# EXIT
	var btn_exit : = NORMAL_BUTTON.instantiate() as NormalButton
	btn_exit.normal_button_type = NormalButtonType.EXIT
	btn_exit.text = "VOLVER"
	container.add_child(btn_exit)
	
	menu_panel_scroll.refresh_items()

func _clear_menu():
	for item in menu_panel_scroll.items_container.get_children():
		item.call_deferred("queue_free")

func set_menu_panel(menu_panel: Panel):
	self.menu_panel = menu_panel

func btn_on_action(normal_button_type: int):
	var keep_in_menu: bool = false
	
	if player_action_called:
		return
	
	match normal_button_type:
		NormalButtonType.EXIT:
			keep_in_menu = true
			refresh_cur_phase_buttons()
		
		NormalButtonType.SCORE:
			ui_blocked = true
			keep_in_menu = true
			main_ui.score_panel_visibility(true)
			
		NormalButtonType.ATTACK_PHY:
			start_phys_attack()

		NormalButtonType.SKILLS:
			keep_in_menu = true
			set_skills_buttons()

		NormalButtonType.SKL_PROJECTILE:
			pass

		NormalButtonType.COVER:
			pass

		NormalButtonType.SKL_SWORD_PILAR:
			start_sword_pilar()

		NormalButtonType.SKL_BELLS_AURA:
			start_bell_aura()

		NormalButtonType.SKL_LIGHT_CAST:
			pass

		NormalButtonType.SKL_BALL_RANDOM:
			pass

		NormalButtonType.SKL_SURIKEN:
			pass

		NormalButtonType.LOOT_DROP:
			pass

		NormalButtonType.OPEN_CHEST:
			pass

		NormalButtonType.LOOT_CHEST:
			pass

		NormalButtonType.TALK:
			pass

		NormalButtonType.BUY_1:
			pass

		NormalButtonType.BUY_2:
			pass

		NormalButtonType.BUY_3:
			pass

		NormalButtonType.CAMPUS_1:
			pass

		NormalButtonType.CAMPUS_2:
			pass

		NormalButtonType.CAMPUS_3:
			pass

		NormalButtonType.CAMPUS_4:
			pass

		NormalButtonType.CAMPUS_5:
			pass
		_:
			Logger.warning("MenuManager: Unknown button type: %s" % normal_button_type)
	if !keep_in_menu:
		player_action_called = true
		disable_all_buttons()
		emit_signal("player_choose_option")

func start_phys_attack():
	
	EntityManagerGlobal.player.body_instance.attack_animation()	
	var player_dmg = EntityManagerGlobal.player.stats_manager.get_stat_value(StatType.PHYSICAL_DMG)
	var base_dmg = GlobalConstants.PLAYER_BASE_DMG_PHYSICAL_ATTACK
	
	EntityManagerGlobal.damage_from_to(EntityManagerGlobal.player, CombatManagerGlobal.entity_agains, StatType.PHYSICAL_DMG, base_dmg + player_dmg)
	await CombatManagerGlobal.entity_agains.stats_manager.stat_variation_finished
	emit_signal("player_choose_option")

func start_sword_pilar():
	
	await VFXManagerGlobal.vfx_player.launch_animation("holy_2_light_pilar")
	var player_dmg = EntityManagerGlobal.player.stats_manager.get_stat_value(StatType.PHYSICAL_DMG)
	var base_dmg = GlobalConstants.PLAYER_BASE_DMG_SKILL_PILAR
	
	EntityManagerGlobal.damage_from_to(EntityManagerGlobal.player, CombatManagerGlobal.entity_agains, StatType.PHYSICAL_DMG, base_dmg + player_dmg)
	await CombatManagerGlobal.entity_agains.stats_manager.stat_variation_finished
	
	emit_signal("player_choose_option")

func start_bell_aura():
	var player_dmg = EntityManagerGlobal.player.stats_manager.get_stat_value(StatType.MAGIC_DMG)
	var base_dmg = GlobalConstants.PLAYER_BASE_DMG_SKILL_BELLS
	
	await VFXManagerGlobal.vfx_player.launch_animation("holy_6_bells_aura")
	
	EntityManagerGlobal.damage_from_to(EntityManagerGlobal.player, CombatManagerGlobal.entity_agains, StatType.MAGIC_PEN, base_dmg + player_dmg)
	await CombatManagerGlobal.entity_agains.stats_manager.stat_variation_finished
	emit_signal("player_choose_option")
	
# SCORE
func set_score_button():
	var btn: = NORMAL_BUTTON.instantiate() as NormalButton
	btn.normal_button_type = NormalButtonType.SCORE
	btn.text = "TOP DE HÉROES"
	container.add_child(btn)
	
func set_score_close_button():
	var btn: = NORMAL_BUTTON.instantiate() as NormalButton
	btn.normal_button_type = NormalButtonType.SCORE_CLOSE
	btn.text = "CERRAR TOP"
	container.add_child(btn)

func disable_all_buttons():
	for button in container.get_children():
		if button != null:
			button.disabled = true

func enable_all_buttons():
	player_action_called = false
	for button in container.get_children():
		if button != null:
			button.disabled = false
