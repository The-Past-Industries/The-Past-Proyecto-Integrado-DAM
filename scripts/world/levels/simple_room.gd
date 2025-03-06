extends Node2D

@onready var current_scene_file_num: int = get_tree().current_scene.scene_file_path.to_int()
@onready var character_body_2d: Player = $CharacterBody2D
@onready var change_level_door = $change_level_door
@onready var enemy = $Enemy


var enemies = ["goblin", "mush", "bat", "skeleton"]

func _ready():
	character_body_2d.is_locked = true
	character_body_2d.is_in_combat = true
	character_body_2d.is_on_combat_place = false
	change_level_door.set_player(character_body_2d)
	init_enemy()
	CombatManager.set_player(character_body_2d)
	CombatManager.set_enemy(enemy)
	CombatManager.start_combat()

func init_enemy():
	enemy.set_type(enemies[LevelManagerGlobal.actual_room - 1])
