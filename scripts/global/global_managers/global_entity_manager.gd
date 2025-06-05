extends Node
class_name EntityManager

# ENTITIES

var generator := EntityGenerator.new()
var is_player_ready: bool = false

var player: EntityPlayer = generator.generate_entity(EntityType.PLAYER)

var enemy: EntityEnemy

var boss: EntityBoss

func _ready():
	player.body_instance.add_to_group("doors_tp_proc", true)

func add_player_to_node(root: Node3D):
	if player:
		root.add_child(player)

func dispach_player():
	if player.get_parent():
		player.get_parent().remove_child(player)

func spawn_player_in_pos(root: Node3D, position: Vector3):
	var gamme_root: Node3D = root.get_parent()
	if player != null:
		if !gamme_root.get_children().has(player.body_instance):
			gamme_root.add_child(player.body_instance)
			Logger.info("PLAYER BODY ADDED: (%s)")
		Logger.info("PLAYER SPAWNS IN: (%s)" % position)
		player._init_body()
		player.body_instance.global_position = position
	else:
		Logger.error("PLAYER IS NULL AND CAN NOT SPAWN")
