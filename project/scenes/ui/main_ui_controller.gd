extends Control
class_name MainUIController

@onready var gold_label = $top_panel/HBoxContainer/gold/HBoxContainer/VBoxContainer/gold_label
@onready var keys_label = $top_panel/HBoxContainer/keys/HBoxContainer/VBoxContainer/keys_label
@onready var level_name_label = $top_panel/HBoxContainer/instance_indicator/HBoxContainer/level_name_label
@onready var level_label = $top_panel/HBoxContainer/instance_indicator/HBoxContainer/level_label
@onready var score_panel = $floating_panels/score_panel

func _ready():
	MenuManagerGlobal.main_ui = self

func _process(_delta):
	gold_label.text = "%d" % EntityManagerGlobal.player.player_gold
	keys_label.text = "%d" % EntityManagerGlobal.player.player_keys
	level_label.text = "%d" % WorldManagerGlobal.level

func score_panel_visibility(show: bool):
	score_panel.visible = show
	if show:
		Logger.info("MainUi: API CALLED")
		ApiManagerGlobal.write_data()
