extends PanelContainer

@onready var phy_dmg_label = $GridContainer/phy_dmg_container/CenterContainer/VBoxContainer/phy_dmg_label
@onready var phy_pen_label = $GridContainer/phy_pen_container/CenterContainer/VBoxContainer/phy_pen_label
@onready var phy_arm_label = $GridContainer/phy_arm_container/CenterContainer/VBoxContainer/phy_arm_label
@onready var atk_spd_label = $GridContainer/atk_spd_container/CenterContainer/VBoxContainer/atk_spd_label
@onready var mag_dmg_label = $GridContainer/mag_dmg_container/CenterContainer/VBoxContainer/mag_dmg_label
@onready var mag_pen_label = $GridContainer/mag_pen_container/CenterContainer/VBoxContainer/mag_pen_label
@onready var mag_arm_label = $GridContainer/mag_arm_container/CenterContainer/VBoxContainer/mag_arm_label
@onready var cri_cha_label = $GridContainer/cri_cha_container/CenterContainer/VBoxContainer/cri_cha_label
var entity
	

func _process(_delta):
	if !entity:
		if WorldManagerGlobal.cur_cell_instance.room_data.type == RoomType.COMMON:
			entity = EntityManagerGlobal.enemy
		elif WorldManagerGlobal.cur_cell_instance.room_data.type == RoomType.BOSS:
			entity = EntityManagerGlobal.boss
		return
	
	phy_dmg_label.text = "%.0f" % entity.stats_manager.get_stat_value(StatType.PHYSICAL_DMG)
	# Logger.info("StatsContainer: Showing phys dmg: " + "%.0f" % entity.stats_manager.get_stat_value(StatType.PHYSICAL_DMG))
	
	phy_pen_label.text = "%.0f%%" % entity.stats_manager.get_stat_value(StatType.PHYSICAL_PEN)
	# Logger.info("StatsContainer: Showing phys pen: " + "%.0f%%" % entity.stats_manager.get_stat_value(StatType.PHYSICAL_PEN))
	
	phy_arm_label.text = "%.0f" % entity.stats_manager.get_stat_value(StatType.PHYSICAL_ARM)
	# Logger.info("StatsContainer: Showing phys arm: " + "%.0f" % entity.stats_manager.get_stat_value(StatType.PHYSICAL_ARM))
	
	atk_spd_label.text = "%.0f" % entity.stats_manager.get_stat_value(StatType.ATTACK_SPD)
	# Logger.info("StatsContainer: Showing ark spd: " + "%.0f" % entity.stats_manager.get_stat_value(StatType.ATTACK_SPD))
	
	mag_dmg_label.text = "%.0f" % entity.stats_manager.get_stat_value(StatType.MAGIC_DMG)
	# Logger.info("StatsContainer: Showing mag dmg: " + "%.0f" % entity.stats_manager.get_stat_value(StatType.MAGIC_DMG))
	
	mag_pen_label.text = "%.0f%%" % entity.stats_manager.get_stat_value(StatType.MAGIC_PEN)
	# Logger.info("StatsContainer: Showing mag pen: " + "%.0f%%" % entity.stats_manager.get_stat_value(StatType.MAGIC_PEN))
	
	mag_arm_label.text = "%.0f" % entity.stats_manager.get_stat_value(StatType.MAGIC_ARM)
	# Logger.info("StatsContainer: Showing mag arm: " + "%.0f" % entity.stats_manager.get_stat_value(StatType.MAGIC_ARM))
	
	cri_cha_label.text = "%.0f%%" % entity.stats_manager.get_stat_value(StatType.CRITICAL_CHA)
	# Logger.info("StatsContainer: Showing crit cha: " + "%.0f%%" % entity.stats_manager.get_stat_value(StatType.CRITICAL_CHA))
