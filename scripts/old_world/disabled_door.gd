extends Area2D
class_name DisabledDoor

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	animated_sprite_2d.play("close")

func un_lock_player(player: Player):
	player.is_locked = false
