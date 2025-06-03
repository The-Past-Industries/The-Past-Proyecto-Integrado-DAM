extends Node
class_name EntitySpawner

func spawn_entity(entity_type: int, position: Vector3, root: Node3D):
	var entity: Entity
	match entity_type:
		EntityType.PLAYER:
			entity = EntityPlayer.new()
		EntityType.ENEMY:
			entity = EntityEnemy.new()
		EntityType.BOSS:
			entity = EntityBoss.new()
	
