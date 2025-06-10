extends AnimationHost
class_name AnimationHostWerewolf

@onready var animated_sprite_3d = $AnimatedSprite3D
@onready var animation_tree = $AnimationTree



func _ready():
	animated_sprite_3d.sprite_frames = sprite_frames
	animation_tree.set("parameters/conditions/idle", true)
	Logger.info("AnimationHostWerewolf: Animation started")

func set_sprite_frames(sprite_frames: SpriteFrames):
	Logger.info("AnimationHostWerewolf: SpriteFrames setted")
	self.sprite_frames = sprite_frames

func _launch_animation(animation_name: String):
	Logger.info("AnimationHost: Enemy animation set to %s" % animation_name)
	var str = "parameters/conditions/%s" % animation_name
	animation_tree.set(str, true)
	await animation_tree.animation_finished
	animation_tree.set(str, false)

func flip_to_right():
	animated_sprite_3d.flip_h = true

func attack_1():
	_launch_animation("attack_1")

func hit():
	_launch_animation("hit")

func death():
	_launch_animation("death")
	_launch_animation("hit")

func _disable_all_animations():
	var animations = [
		"attack_1",
		"death",
		"hit",
		"idle",
		"jump",
		"run",
		"run_attack",
		"walk"
	]
	
	for animation_name in animations:
		var str = "parameters/conditions/%s" % animation_name
		animation_tree.set(str, false)
