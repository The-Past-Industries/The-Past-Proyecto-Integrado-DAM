extends CharacterBody3D
class_name AnimationHost

var sprite_frames: SpriteFrames

func despawn_node_translation():
	var shrink_time := 0.1
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector3.ZERO, shrink_time).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_callback(queue_free)

func flip_to_right():
	pass
