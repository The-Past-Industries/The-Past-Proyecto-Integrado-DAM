extends Node
class_name EntityManager

# ENTITIES
var entity_repository := EntityRepository.new()
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

func choose_random_enemy():
	self.enemy = entity_repository.get_random_common_enemy()

func choose_random_boss():
	self.boss = entity_repository.get_random_boss()
	pass

func damage_from_to(sender: Entity, reciver: Entity, stat_type: int, damage_positive_value: float):
	var pen
	if stat_type == StatType.PHYSICAL_DMG:
		pen = sender.stats_manager.get_stat_value(StatType.PHYSICAL_PEN)
	elif stat_type == StatType.MAGIC_DMG:
		pen = sender.stats_manager.get_stat_value(StatType.MAGIC_PEN)
	else:
		Logger.error("EntityManagerGlobal: Damage from to. [%d] is an invalid stat type." % stat_type)
	reciver.stats_manager.take_damage(stat_type, damage_positive_value, pen)

func heal_entity(entity: Entity, heal_value: float):
	entity.stats_manager.heal(heal_value)
