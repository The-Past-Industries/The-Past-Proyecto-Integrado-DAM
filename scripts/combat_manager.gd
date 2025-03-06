extends Node
class_name Combat_Manager

var player_turn: bool = true
var player:Player
var enemy: Enemy
var is_covered:bool = false
var combat_ended = false

func _process(delta):
	print("Vida enemigo: ", EnemyDataManager.health)
	if EnemyDataManager.health <= 0:
		end_combat()
		
	if PlayerDataManager.health <= 0:
		player.animation_death()
		end_combat()

func set_player(new_player: Player):
	player = new_player

func set_enemy(new_enemy: Enemy):
	enemy = new_enemy

func start_combat():
	player_turn = true
	init_turns()
	MenuManager.actions_menu.open_menu()
	player.is_locked = true

func end_combat():
	combat_ended = true
	player.is_locked = false
	player.hide_indicator()
	if enemy != null:
		enemy.hide_indicator()
	MenuManager.actions_menu.close_menu()

func init_turns():
	if !combat_ended:
		player.show_indicator(!player_turn)
		enemy.show_indicator(player_turn)

func swap_turn():
	player_turn = !player_turn

func btn_phys_attack_pressed():
	player.animations_attack(true)
	enemy.set_animation("hit")
	await player.anim_tree.animation_finished
	EnemyDataManager.alterHealth(PlayerDataManager.physical_damage * (-1))
	enemy_turn()

func btn_magic_attack_pressed():
	player.animations_attack(false)
	enemy.set_animation("hit")
	await player.anim_tree.animation_finished
	EnemyDataManager.alterHealth(PlayerDataManager.magic_damage * (-1))
	enemy_turn()

func btn_cover_pressed():
	is_covered = true
	enemy_turn()

func enemy_turn():
	swap_turn()
	init_turns()
	await get_tree().create_timer(2.0).timeout
	enemy_action()
	swap_turn()
	init_turns()

func enemy_action():
	if EnemyDataManager.health > 0:
		enemy.animated_sprite_2d.stop()
		enemy.set_animation("attack")
		player.animation_hit()
		if is_covered:
			if not EnemyDataManager.physical_damage - PlayerDataManager.physical_armor <= 0:
				PlayerDataManager.alterHealth((EnemyDataManager.physical_damage - PlayerDataManager.physical_armor) * (-1))
		else:
			PlayerDataManager.alterHealth(EnemyDataManager.physical_damage * (-1))
	else:
		enemy.die()
	is_covered = false
		
