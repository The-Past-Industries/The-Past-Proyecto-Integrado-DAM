extends Node
class_name PhaseManager

var cur_room: RoomController
var cur_phase_type: int

func _ready():
	change_phase(PhaseType.TRAVEL)

func change_phase(phase_type: int):
	cur_phase_type = phase_type
	MenuManagerGlobal.set_ui_by_phase(phase_type)
	match phase_type:
		PhaseType.MENU:
			pass
		PhaseType.TRAVEL:
			pass
		PhaseType.COMBAT:
			_init_combat_phase()
		PhaseType.END:
			pass
		_:
			pass

func _init_combat_phase():
	CombatManagerGlobal.start_combat()
