extends Entity
class_name EntityEnemy

var abilities_list: Array
var body_instance: AnimationHostCommon
var sprite_name: String

func _init():
	self.type = EntityType.ENEMY
