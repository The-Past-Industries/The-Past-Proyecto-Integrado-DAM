extends Node2D

@onready var tile_map_layer_corridor: Corridor = $TileMapLayer_corridor
@onready var change_level_door: ChangeLevelDoor = $change_level_door
@onready var character_body_2d: Player = $CharacterBody2D
@onready var main_ui: MainUI = $main_ui


func _ready():
	tile_map_layer_corridor.load_initial_corridor()
	change_level_door.set_player(character_body_2d)
	main_ui.hide_enemy()
	EnemyDataManager.resetHealth()
	MenuManager.actions_menu.close_menu()
