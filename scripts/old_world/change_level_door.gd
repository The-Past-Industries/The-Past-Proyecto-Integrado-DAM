extends Area2D
class_name ChangeLevelDoor

const PREFIX = "res://scenes/world/levels/"

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var current_scene_file = get_tree().current_scene.scene_file_path
var player: Player

func _ready():
	animated_sprite_2d.stop()

func _on_body_entered(body):
	if body.is_in_group("Physic"):
		animated_sprite_2d.play("default")
		stop_player()
		await(animated_sprite_2d.animation_finished)
		load_instance()

func set_player(player: Player):
	self.player = player

func stop_player():
	player.is_locked = true

func load_instance():
	get_tree().change_scene_to_file(PREFIX + LevelManagerGlobal.next_instance() + ".tscn")
