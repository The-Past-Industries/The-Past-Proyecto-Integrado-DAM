extends Entity
class_name EntityBoss

var boss_type: int
var body_instance: AnimationHost

func _init():
	self.type = EntityType.BOSS
