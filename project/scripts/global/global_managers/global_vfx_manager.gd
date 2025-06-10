extends Node
class_name VFXManager

var is_on_animation: bool = false
var vfx_player: VFXPlayer

func set_vfx_player(vfx_player):
	self.vfx_player = vfx_player
	Logger.info("VFXManager: VFXPlayer setted")

func _input(event: InputEvent) -> void:
	if !vfx_player:
		return
		
	if event.is_action_pressed("debug_0"):
		await vfx_player.launch_animation("holy_2_light_pilar")
	#elif event.is_action_pressed("debug_1"):
		#await vfx_player.launch_animation("holy_2_light_pilar")
	#elif event.is_action_pressed("debug_2"):
		#await vfx_player.launch_animation("holy_6_bells_aura")
	#elif event.is_action_pressed("debug_3"):
		#await vfx_player.launch_animation("holy_7_ball_random")
	#elif event.is_action_pressed("debug_4"):
		#await vfx_player.launch_animation("holy_7_light_pop")
	#elif event.is_action_pressed("debug_5"):
		#await vfx_player.launch_animation("holy_8_suriken")
	#elif event.is_action_pressed("debug_6"):
		#await vfx_player.launch_animation("holy_10_light_cast")
	#elif event.is_action_pressed("debug_7"):
		#await vfx_player.launch_animation("holy_11_light_hit_pop")
