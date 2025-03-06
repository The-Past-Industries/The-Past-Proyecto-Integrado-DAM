extends Control

#UI Components
@onready var animated_sprite_2d = $HBoxContainer/char_visor/PanelContainer/AnimatedSprite2D
@onready var hbox_container = $HBoxContainer
@onready var char_visor = $HBoxContainer/char_visor
@onready var stats_card = $HBoxContainer/stats_card

#Class variables
var flipped_to_right = false
var enemies = ["goblin", "mush", "bat", "skeleton"]

func _ready():
	animated_sprite_2d.play(enemies[LevelManagerGlobal.actual_room - 1] + "_idle")

func hide_ui():
	visible = false
