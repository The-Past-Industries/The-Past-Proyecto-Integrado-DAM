extends Node
class_name PhaseManager

var cur_room: RoomController
var cur_phase_type: int

func _ready():
	change_phase(PhaseType.TRAVEL)

func change_phase(phase_type: int, is_boss: bool = false):
	cur_phase_type = phase_type
	MenuManagerGlobal.set_ui_by_phase(phase_type)
	match phase_type:
		PhaseType.MENU:
			pass
		PhaseType.TRAVEL:
			pass
		PhaseType.COMBAT:
			_init_combat_phase(is_boss)
		PhaseType.END:
			pass
		_:
			pass

func _init_combat_phase(is_boss: bool):
	CombatManagerGlobal.start_combat(is_boss)
