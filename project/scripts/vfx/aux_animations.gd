extends Node3D
class_name AuxAnimations

@onready var aux_animations : AnimatedSprite3D = $aux_animations

func despawn_pop():
	aux_animations.play("smoke_center")
	await aux_animations.animation_finished
	aux_animations.play("empty")

func hit_pop():
	aux_animations.play("hit_pop")
	await aux_animations.animation_finished
	aux_animations.play("empty")
