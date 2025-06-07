extends Node
class_name PhaseManager

var cur_room: RoomController
var cur_phase_type: int
var combat_manager: CombatManager

func _ready():
	cur_phase_type = PhaseType.MENU

func change_phase(phase_type: int):
	cur_phase_type = phase_type
	
	match phase_type:
		PhaseType.MENU:
			pass
		PhaseType.TRAVEL:
			pass
		PhaseType.COMBAT:
			_init_combat_phase()
		PhaseType.LOOT:
			pass

func _init_combat_phase():
	combat_manager = CombatManager.new()
	combat_manager.start_combat()
