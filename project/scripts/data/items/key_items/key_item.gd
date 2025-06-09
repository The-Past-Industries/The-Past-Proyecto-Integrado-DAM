class_name KeyItem

var key_item_id: int
var key_item_name: String
var key_item_type: int

var sprite_host: AnimatedSprite2D

func init_sprite():
	sprite_host.play("%d" % key_item_id)
