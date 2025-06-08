extends Control
class_name PlayerUI

#UI Components
@onready var animated_sprite_2d = $HBoxContainer/char_visor/PanelContainer/AnimatedSprite2D
@onready var hbox_container = $HBoxContainer
@onready var char_visor = $HBoxContainer/char_visor
@onready var stats_card = $HBoxContainer/stats_card

#Class variables
var flipped_to_right = false

func _ready():
	animated_sprite_2d.play("default")

func _process(_delta):
	update_player_data()

#UI
func turn_ui(player_on_left: bool):
	animated_sprite_2d.flip_h = !player_on_left
	if player_on_left and flipped_to_right:
		hbox_container.move_child(char_visor, 0)
		animated_sprite_2d.position.x += 10
		flipped_to_right = false
	elif not player_on_left and not flipped_to_right:
		hbox_container.move_child(char_visor, 1)
		animated_sprite_2d.position.x -= 10
		flipped_to_right = true

#Data
func update_player_data():
	#Health
	$HBoxContainer/stats_card/health_card/health_label.text = str(PlayerDataManager.health)
	#Phys dmg
	$HBoxContainer/stats_card/phy_dmg_card/phy_dmg_label.text = str(PlayerDataManager.physical_damage)
	#Magic dmg
	$HBoxContainer/stats_card/mag_dmg_card/mag_dmg_label.text = str(PlayerDataManager.magic_damage)
	#Phys arm
	$HBoxContainer/stats_card/phy_arm_card/phy_arm_label.text = str(PlayerDataManager.physical_armor)
	#Magic arm
	$HBoxContainer/stats_card/mag_arm_card/mag_arm_label.text = str(PlayerDataManager.magic_armor)
	#Attack spd
	$HBoxContainer/stats_card/atck_spd_card/atck_spd_label.text = str(PlayerDataManager.attack_speed)
