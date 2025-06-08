extends AnimatedSprite2D
class_name EnemyVisor

func _ready():
	MenuManagerGlobal.enemy_visor_sprite = self

func set_enemy_sprite():
	sprite_frames = EntityManagerGlobal.enemy.body_instance.sprite_frames
	play("idle")
