extends Control
class_name MainUIController

@onready var gold_label = $top_panel/HBoxContainer/gold/HBoxContainer/VBoxContainer/gold_label
@onready var keys_label = $top_panel/HBoxContainer/keys/HBoxContainer/VBoxContainer/keys_label
@onready var level_name_label = $top_panel/HBoxContainer/instance_indicator/HBoxContainer/level_name_label
@onready var level_label = $top_panel/HBoxContainer/instance_indicator/HBoxContainer/level_label

func _process(_delta):
	gold_label.text = "%d" % EntityManagerGlobal.player.player_gold
	keys_label.text = "%d" % EntityManagerGlobal.player.player_keys
	level_label.text = "%d" % WorldManagerGlobal.level
