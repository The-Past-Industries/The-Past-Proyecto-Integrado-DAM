extends Sprite2D

@onready var animation = $AnimationPlayer

func set_selected_animation():
	animation.play("selected")
func set_target_animation():
	animation.play("target")
