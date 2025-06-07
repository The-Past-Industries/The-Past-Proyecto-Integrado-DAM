extends RefCounted
class_name CombatManager

var player_turn: bool = true


func start_combat():
	# ACTUALIZAR INTERFAZ A COMBATE
	EntityManagerGlobal.player.get_body().is_locked = true
	_launch_turn()

func _launch_turn():
	if player_turn:
		pass
	else:
		pass

func _player_turn():
	pass

func _enemy_turn():
	pass
