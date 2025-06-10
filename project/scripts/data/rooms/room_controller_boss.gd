extends RoomControllerFlat
class_name RoomControllerBoss

@onready var wall_left_door_toggleable = $door

@onready var wall_right_door_toggleable = $door2

@onready var door_left_marker_aux = $position_markers/door_left
@onready var door_right_marker_aux = $position_markers/door_right

@onready var combat_right = $position_markers/combat_right
@onready var combat_left = $position_markers/combat_left

@onready var turn_indicator: TurnIndicator = $turn_indicator_3d

@onready var left_white_spot_light_3d = $lights/SpotLight3D_left
@onready var right_white_spot_light_3d = $lights/SpotLight3D_right

@onready var vfx_player = $vfx/vfx_player

@onready var pop_num_displayer_left: PopNumDisplayer = $pop_num_displayer_left
@onready var pop_num_displayer_right: PopNumDisplayer = $pop_num_displayer_right

@onready var beacon_1 = $Pedestal_1/beacon_1
@onready var beacon_2 = $Pedestal_2/beacon_2
@onready var beacon_3 = $Pedestal_3/beacon_3
@onready var beacon_4 = $Pedestal_4/beacon_4

var player_position: Vector3
var boss_position: Vector3

var tp_on_left: bool

var boss_flip_h := false

func setup(cur_position: Vector2i, room_data: RoomData):
	super._init_room_components([
		wall_left_door_toggleable,
		null,
		wall_right_door_toggleable,
		null,
		door_left_marker_aux,
		door_right_marker_aux,
		combat_left,
		combat_right
	])
	super.setup(cur_position, room_data)
	_load_beacons_by_level()
	if room_data.shown:
		turn_indicator.visible = false
		door_left.visible = false
		door_right.visible = false
		_load_beacons_by_level(1)
		pass

func _get_boss_position() -> Vector3:
	match WorldManagerGlobal.get_comming_direction():
		Vector2i.LEFT:
			return combat_right.global_position
		Vector2i.RIGHT:
			boss_flip_h = true
			return  combat_left.global_position
		_:
			var pos = Vector3(0,0,1)
			Logger.error("RoomControllerBoss: Invalid comming direction. Boss spawns in %s" % pos)
			return pos

func _load_door_by_room_connections():
	door_left.visible = false
	door_right.visible = false
	
	if room_data.connections.has(Vector2i.LEFT):
		tp_on_left = false
	elif room_data.connections.has(Vector2i.RIGHT):
		tp_on_left = true
	else:
		Logger.error("RoomControllerBoss: Invalid comming direction for level tp door setting")
		tp_on_left = false

func _load_beacons_by_level(desfase: int = 0):
	
	if (WorldManagerGlobal.level + desfase) >= 2:
		beacon_1.visible = false
	if WorldManagerGlobal.level + desfase >= 3:
		beacon_2.visible = false
	if WorldManagerGlobal.level + desfase >= 4:
		beacon_2.visible = false

func spawn_boss(boss: EntityBoss):
	self.add_child(boss.body_instance)
	boss_position = _get_boss_position()
	boss.body_instance.global_position = boss_position
	Logger.info("RoomControllerCommon: boss spawn")
	if !boss_flip_h:
		(boss.body_instance as AnimationHost).flip_to_right()

func prepare_combat_state():
	var new_position
	match WorldManagerGlobal.get_comming_direction():
		Vector2i.LEFT:
			new_position = combat_left.global_position
			PopNumManagerGlobal.displayer_player = pop_num_displayer_left
			PopNumManagerGlobal.displayer_enemy = pop_num_displayer_right
		Vector2i.RIGHT:
			new_position = combat_right.global_position
			PopNumManagerGlobal.displayer_player = pop_num_displayer_right
			PopNumManagerGlobal.displayer_enemy = pop_num_displayer_left
		_:
			new_position = combat_left.global_position
			PopNumManagerGlobal.displayer_player = pop_num_displayer_left
			PopNumManagerGlobal.displayer_enemy = pop_num_displayer_right
	player_position = new_position
	vfx_player.global_position = new_position + Vector3(0,0,0.2)
	EntityManagerGlobal.player.move_to(new_position)
	
	if turn_indicator:
		turn_indicator.visible = true
	PhaseManagerGlobal.change_phase(PhaseType.COMBAT, true)

func exit_combat_state():
	_combat_lights_off()
	_load_beacons_by_level(1)
	door_right.visible = true
	door_left.visible = true

func _combat_lights_off():
	left_white_spot_light_3d = 0
	right_white_spot_light_3d = 0

func spawn_player():
	super.spawn_player()

func _on_area_3d_left_body_entered(body: Node3D) -> void:
	if body.is_in_group("doors_tp_proc") && door_left.visible:
		if !tp_on_left:
			_on_area_custom_entered(body, Vector2i.LEFT)
		else:
			_change_level()

func _on_area_3d_right_body_entered(body: Node3D) -> void:
	if body.is_in_group("doors_tp_proc") && door_right.visible:
		if tp_on_left:
			_on_area_custom_entered(body, Vector2i.RIGHT)
		else:
			_change_level()

func _change_level():
	WorldManagerGlobal._generate_level()
