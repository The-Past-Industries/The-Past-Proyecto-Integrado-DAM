extends Node
class_name EntityManager

# ENTITIES

var generator := EntityGenerator.new()

var player: EntityPlayer = generator.generate_entity(EntityType.PLAYER)

var enemy: EntityEnemy

var boss: EntityBoss

func _ready():
	player.body_instance.add_to_group("doors_tp_proc", true)

func spawn_player_in_pos(root: Node3D, position: Vector3):
	if player != null:
		Logger.info("PLAYER SPAWNS IN: (%s)" % position)
		
		player.init_body()
		
		if !root.get_parent().is_ancestor_of(player):
			root.get_parent().add_child(player)
		player.global_position = position
	else:
		Logger.error("PLAYER IS NULL AND CAN NOT SPAWN")
		player = generator.generate_entity(EntityType.PLAYER)
		spawn_player_in_pos(root, position)
