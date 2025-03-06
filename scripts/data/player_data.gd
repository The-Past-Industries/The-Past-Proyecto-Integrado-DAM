extends Node2D
class_name PlayerData

const StatEffect = preload("res://scripts/stats/stat_effect.gd")
@export var player: bool = true

#Stats
@export var health: float = 200.0
@export var attack_speed: float = 1.0

#Resistances
@export var physical_armor: float = 5.0
@export var magic_armor: float = 5.0

#Damages
@export var physical_damage: float = 100.0
@export var magic_damage: float = 15.0
@export var true_damage: float = 0.0

#Alter stats
func alterStat(stat_effect: int, value: float):
	match stat_effect:
		StatEffect.HP:
			alterHealth(value)
		StatEffect.P_DMG:
			alterPhysicalDamage(value)
		StatEffect.M_DMG:
			alterMagicDamage(value)
		StatEffect.P_ARM:
			alterPhysicalArmor(value)
		StatEffect.M_ARM:
			alterMagicArmor(value)
		StatEffect.AS:
			alterAttackSpeed(value)

func alterHealth(value: float):
	health += value
	
func alterPhysicalDamage(value: float):
	physical_damage += value

func alterMagicDamage(value: float):
	magic_damage += value

func alterPhysicalArmor(value: float):
	physical_armor += value

func alterMagicArmor(value: float):
	magic_armor += value

func alterAttackSpeed(value: float):
	attack_speed += value
