extends RoomController
class_name RoomControllerCampus

func setup(cur_position: Vector2i, room_data: RoomData):
	super.setup(cur_position, room_data)
	_spawn_player_by_dir_connection(Vector2i.ZERO)


func _on_area_3d_elevator_body_entered(body: Node3D) -> void:
	EntityManagerGlobal.player.is_on_elevator = true


func _on_area_3d_elevator_body_exited(body: Node3D) -> void:
	EntityManagerGlobal.player.is_on_elevator = false


func _input(event: InputEvent) -> void:
	if EntityManagerGlobal.player.is_on_elevator:
		if event.is_action_pressed("control_down"):
			EntityManagerGlobal.player.get_body().start_flat_transition("teleport")
			await EntityManagerGlobal.player.get_body().transition_teleport_finished
			_move_to_room(EntityManagerGlobal.player.body_instance, room_data.connections, Vector2i.DOWN)

func _spawn_player_by_dir_connection(dir_comming: Vector2i):
	EntityManagerGlobal.spawn_player_in_pos(self, Vector3i(0,0,1))
