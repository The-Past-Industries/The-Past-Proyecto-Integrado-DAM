extends CharacterBody2D
class_name Enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var indicator = $Indicator_Sprite2D

var type: String = ""

func set_type(new_type: String):
	type = new_type
	animated_sprite_2d.play(type + "_idle")

func set_animation(animation: String):
	animated_sprite_2d.stop
	match animation:
		"idle": animated_sprite_2d.play(type + "_idle")
		"attack":
			animated_sprite_2d.play(type + "_attack")
		"hit":
			animated_sprite_2d.play(type + "_hit")
		"death":
			animated_sprite_2d.play(type + "_death")
			await animated_sprite_2d.animation_finished
			queue_free()
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play(type + "_idle")


#Indicator
func show_indicator(target: bool):
	indicator.visible = true
	set_indicator_animation(target)

func set_indicator_animation(target: bool):
	if !target:
		indicator.set_selected_animation()
	else:
		indicator.set_target_animation()

func hide_indicator():
	indicator.visible = false

func die():
	set_animation(type + "_death")
