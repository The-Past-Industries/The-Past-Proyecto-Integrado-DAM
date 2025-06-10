extends RoomControllerFlat
class_name RoomControllerCorridor

@onready var wall_left_door_toggleable = $walls/left_walls/Wall_Door_toggleable
@onready var wall_left_window_bars_toggleable = $walls/left_walls/Wall_Window_Bars_toggleable
@onready var wall_right_door_toggleable = $walls/right_walls/Wall_Door_toggleable
@onready var wall_right_window_bars_toggleable = $walls/right_walls/Wall_Window_Bars_toggleable
@onready var door_left_marker_aux = $position_markers/door_left
@onready var door_right_marker_aux = $position_markers/door_right
@onready var elevator_fence_toggleable = $elevator_fence_toggleable
@onready var floor_bottom_toggleable = $platform/floor_bottom_toggleable
@onready var teleport_ray_toggleable = $teleport_ray_toggleable
@onready var animated_sprite_3d = $teleport_sprite/AnimatedSprite3D



func setup(cur_position: Vector2i, room_data: RoomData):
	super._init_room_components([
		wall_left_door_toggleable,
		wall_left_window_bars_toggleable,
		wall_right_door_toggleable,
		wall_right_window_bars_toggleable,
		door_left_marker_aux,
		door_right_marker_aux
	])
	super.setup(cur_position, room_data)


func _on_area_3d_left_body_entered(body: Node3D) -> void:
	_on_area_custom_entered(body, Vector2i.LEFT)


func _on_area_3d_right_body_entered(body: Node3D) -> void:
	_on_area_custom_entered(body, Vector2i.RIGHT)



func _on_area_3d_elevator_body_entered(body: Node3D) -> void:
	EntityManagerGlobal.player.is_on_elevator = true


func _on_area_3d_elevator_body_exited(body: Node3D) -> void:
	EntityManagerGlobal.player.is_on_elevator = false


func _input(event: InputEvent) -> void:
	if MenuManagerGlobal.ui_blocked:
		return
	
	if EntityManagerGlobal.player.is_on_elevator:
		if event.is_action_pressed("control_up"):
			_vertical_move(Vector2i.UP)
		elif event.is_action_pressed("control_down"):
			_vertical_move(Vector2i.DOWN)

func _vertical_move(move_direction: Vector2i):
	if EntityManagerGlobal.player.body_instance.is_in_group("doors_tp_proc") and room_data.connections.has(move_direction):
		EntityManagerGlobal.player.get_body().start_flat_transition("teleport")
		animated_sprite_3d.play("default")
		await EntityManagerGlobal.player.get_body().transition_teleport_finished
		
		_move_to_room(EntityManagerGlobal.player.body_instance, room_data.connections, move_direction)


func _load_door_by_room_connections():
	super._load_door_by_room_connections()
	await get_tree().process_frame
	_close_vert_room()
	for direction in self.room_data.connections:
		
		match direction:
			
			# Elevator fence toggle
			Vector2i.UP:
				elevator_fence_toggleable.visible = true
				teleport_ray_toggleable.visible = true
		
			# Platform tile toggle
			Vector2i.DOWN:
				floor_bottom_toggleable.visible = false
				teleport_ray_toggleable.visible = true

func _close_vert_room():
		elevator_fence_toggleable.visible = false
		floor_bottom_toggleable.visible = true
		teleport_ray_toggleable.visible = false
