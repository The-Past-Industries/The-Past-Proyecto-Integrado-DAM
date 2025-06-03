extends Node
class_name EntityManager

# ENTITIES

var generator := EntityGenerator.new()

var player: EntityPlayer

var enemy: EntityEnemy

var boss: EntityBoss

func _ready():
	generator.generate_entity(EntityType.PLAYER)

func spawn_player_in_pos(position:Vector3, root: Node3D):
	root.add_child(player)
	player.global_position = position
