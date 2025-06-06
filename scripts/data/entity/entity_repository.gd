extends Node
class_name EntityRepository

var entity_populator := EntityPopulator.new()
var enemy_list : Array[EntityEnemy]

func _init() -> void:
	enemy_list = entity_populator.load_enemies_from_json()
	if enemy_list.is_empty():
		Logger.error("EntityRepository: Empty enemy list")
