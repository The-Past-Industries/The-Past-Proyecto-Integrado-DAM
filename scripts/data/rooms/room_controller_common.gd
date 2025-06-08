extends RoomControllerFlat
class_name RoomControllerCommon

@onready var wall_left_door_toggleable = $walls/left_walls/Wall_Door_toggleable
@onready var wall_left_window_bars_toggleable = $walls/left_walls/Wall_Window_Bars_toggleable
@onready var wall_right_door_toggleable = $walls/right_walls/Wall_Door_toggleable
@onready var wall_right_window_bars_toggleable = $walls/right_walls/Wall_Window_Bars_toggleable
@onready var door_left_marker_aux = $position_markers/door_left
@onready var door_right_marker_aux = $position_markers/door_right
@onready var combat_right = $position_markers/combat_right
@onready var combat_left = $position_markers/combat_left
@onready var turn_indicator: TurnIndicator = $turn_indicator


var player_position: Vector3
var enemy_position: Vector3

var enemy_flip_h := false

func setup(cur_position: Vector2i, room_data: RoomData):
	super._init_room_components([
		wall_left_door_toggleable,
		wall_left_window_bars_toggleable,
		wall_right_door_toggleable,
		wall_right_window_bars_toggleable,
		door_left_marker_aux,
		door_right_marker_aux,
		combat_left,
		combat_right
	])
	super.setup(cur_position, room_data)

func _get_enemy_position() -> Vector3:
	match WorldManagerGlobal.get_comming_direction():
		Vector2i.LEFT:
			return combat_right.global_position
		Vector2i.RIGHT:
			enemy_flip_h = true
			return  combat_left.global_position
		_:
			var pos = Vector3(0,0,1)
			Logger.error("RoomControllerCommon: Invalid comming direction. Enemy spawns in %s" % pos)
			return pos
		

func spawn_enemy(enemy: EntityEnemy):
	self.add_child(enemy.body_instance)
	enemy_position = _get_enemy_position()
	enemy.body_instance.global_position = enemy_position
	Logger.info("RoomControllerCommon: Enemy spawn")
	if enemy_flip_h:
		(enemy.body_instance as AnimationHostCommon).flip_to_right()

func prepare_combat_state():
	var new_position
	match WorldManagerGlobal.get_comming_direction():
		Vector2i.LEFT:
			new_position = combat_left.global_position
		Vector2i.RIGHT:
			new_position = combat_right.global_position
	player_position = new_position
	EntityManagerGlobal.player.move_to(new_position)
	PhaseManagerGlobal.change_phase(PhaseType.COMBAT)

func _on_area_3d_left_body_entered(body: Node3D) -> void:
	_on_area_custom_entered(body, Vector2i.LEFT)


func _on_area_3d_right_body_entered(body: Node3D) -> void:
	_on_area_custom_entered(body, Vector2i.RIGHT)
