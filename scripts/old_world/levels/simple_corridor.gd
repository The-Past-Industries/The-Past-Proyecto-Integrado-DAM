extends Node2D

@onready var disabled_door: DisabledDoor= $disabled_door
@onready var character_body_2d:Player = $CharacterBody2D
@onready var change_level_door: ChangeLevelDoor = $change_level_door
@onready var main_ui = $main_ui

func _ready():
	character_body_2d.is_locked = false
	change_level_door.set_player(character_body_2d)
	main_ui.hide_enemy()
	EnemyDataManager.resetHealth()
	MenuManager.actions_menu.close_menu()
