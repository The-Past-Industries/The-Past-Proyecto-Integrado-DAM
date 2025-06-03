extends Node
class_name EntityGenerator

func generate_entity(type: int):
	var entity: Entity
	match type:
		EntityType.PLAYER:
			entity = EntityPlayer.new()
		EntityType.ENEMY:
			entity = EntityEnemy.new()
		EntityType.BOSS:
			entity = EntityBoss.new()
	
