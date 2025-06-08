extends Node
class_name EntityRepository

var entity_populator := EntityPopulator.new()
var common_enemy_list : Array[EntityEnemy]

func _init() -> void:
	common_enemy_list = entity_populator.load_common_enemies()
	if common_enemy_list.is_empty():
		Logger.error("EntityRepository: Empty common enemy list")

func get_random_common_enemy() -> EntityEnemy:
	return common_enemy_list.pop_at(randi_range(0, common_enemy_list.size() - 1))
