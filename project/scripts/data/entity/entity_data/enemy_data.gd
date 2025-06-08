extends Node
class_name EnemyData

#Stats
@export var health: float = 100.0

#Damages
@export var physical_damage: float = 10.0

func alterHealth(value: float):
	health += value

func resetHealth():
	health = 100.0
