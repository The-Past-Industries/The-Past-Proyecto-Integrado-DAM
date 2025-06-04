extends Node
class_name EntityManager

# ENTITIES

var generator := EntityGenerator.new()

var player: EntityPlayer

var enemy: EntityEnemy

var boss: EntityBoss

func _ready():
	player = generator.generate_entity(EntityType.PLAYER)

func spawn_player_in_pos(root: Node3D, position: Vector3):
	Logger.info("PLAYER SPAWNS IN: (%s)" % position)
	root.add_child(player)
	player.global_position = position
