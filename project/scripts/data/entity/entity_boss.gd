extends Entity
class_name EntityBoss

var abilities_list: Array
var body_instance: AnimationHost

func _init():
	self.type = EntityType.BOSS
