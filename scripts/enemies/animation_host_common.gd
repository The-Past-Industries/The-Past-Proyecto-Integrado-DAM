extends AnimationHost
class_name AnimationHostCommon

@onready var aux_animations: AuxAnimations = $aux_animations
@onready var animated_sprite_3d = $AnimatedSprite3D
@onready var animation_tree = $AnimationTree
var sprite_frames

func _ready():
	animated_sprite_3d.sprite_frames = sprite_frames
	animation_tree.set("parameters/conditions/idle", true)
	Logger.info("AnimationHostCommon: Animation started")

func set_sprite_frames(sprite_frames: SpriteFrames):
	Logger.info("AnimationHostCommon: SpriteFrames setted")
	self.sprite_frames = sprite_frames

func _launch_animation(animation_name: String):
	Logger.info("AnimationHost: Enemy animation set to %s" % animation_name)
	var str = "parameters/conditions/%s" % animation_name
	animation_tree.set("parameters/conditions/idle", false)
	animation_tree.set(str, true)
	await animation_tree.animation_finished
	animation_tree.set(str, false)
	animation_tree.set("parameters/conditions/idle", true)

func flip_to_right():
	animated_sprite_3d.flip_h = true
	aux_animations.aux_animations.flip_h = true

func attack():
	_launch_animation("attack")

func magic():
	_launch_animation("magic")

func skill():
	_launch_animation("skill")

func victory():
	_launch_animation("victory")

func hit():
	_launch_animation("hit")
	aux_animations.hit_pop()

func death():
	_launch_animation("death")
	_launch_animation("hit")
	await get_tree().create_timer(GlobalConstants.COMBAT_TIME_BEFORE_CORPSE_DESPAWNS).timeout
	aux_animations.despawn_pop()
	call_deferred("queue_free")

func defend():
	_launch_animation("defend")

func woozy():
	_launch_animation("woozy")

func item():
	_launch_animation("item")
