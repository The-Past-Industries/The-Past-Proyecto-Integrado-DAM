extends Node
class_name WorldGeneratorOld

const MAX_LENGTH_FROM_INIT = GlobalConstants.MAX_LENGTH_FROM_INIT
const START_CELL_POSITION = Vector2i(0,0)

var rng = RandomNumberGenerator.new()

func _generate_path(seed: int, level: int) -> void:
	var map_data: Dictionary = {}
	rng.seed = seed
	map_data.clear()
	
	var current_pos = START_CELL_POSITION
	var visited: Array[Vector2i] = [current_pos]
	var distance = 0
	
	# Initial room
	var init_room = RoomDataInitial.new()
	init_room.level = level
	init_room.distance = 0
	map_data[START_CELL_POSITION] = init_room

func _generate_path(seed: int, level: int) -> void:
	var map_data: Dictionary = {}
	rng.seed = seed
	map_data.clear()

	var current_pos = START_CELL_POSITION
	var visited: Array[Vector2i] = [current_pos]
	var distance = 0

	# Crear sala inicial
	var init_room = RoomDataInitial.new()
	init_room.distance = 0
	map_data[START_CELL_POSITION] = init_room

	while distance < MAX_LENGTH_FROM_INIT + (level * 2):
		var adjacent = _obtain_adjacent_available(current_pos, visited)

		if adjacent.is_empty():
			push_error("Camino bloqueado, sin salidas válidas")
			break

		var next = adjacent[rng.randi_range(0, adjacent.size() - 1)]

		# Crear pasillo entre current y siguiente
		crear_pasillo(current_pos, next)

		# Crear habitación común en siguiente
		var room = RoomData.new()
		room.type = RoomType.Type.COMMON
		room.distance = distance + 1
		room.connections = [_direction_opposite(_direction_between(current_pos, next))]
		map_data[next] = room

		current_pos = next
		visited.append(current_pos)
		distance += 1

func _obtain_adjacent_available(pos: Vector2i, blocked: Array[Vector2i]) -> Array[Vector2i]:
	var possibles = [
		pos + Vector2i(1, 0),
		pos + Vector2i(-1, 0),
		pos + Vector2i(0, 1),
		pos + Vector2i(0, -1),
	]
	return possibles.filter(func(p):
		not map_data.has(p) and not blocked.has(p)
	)

func _direction_between(from: Vector2i, to: Vector2i) -> int:
	var dir = to - from
	if dir == Vector2i(-1, 0): return 0		# Left
	if dir == Vector2i(0, -1): return 1		# Up
	if dir == Vector2i(1, 0): return 2		# Right
	if dir == Vector2i(0, 1): return 3		# Down
	return -1

func _direction_opposite(dir: int) -> int:
	match dir:
		0: return 2
		2: return 0
		1: return 3
		3: return 1
		_: return -1

func create_corridor(from: Vector2i, to: Vector2i) -> void:
	var corridor_pos = from + ((to - from) / 2)  # punto medio

	var corridor = RoomData.new()
	pasillo.tipo = RoomData.RoomType.PASILLO
	pasillo.conexiones = [
		direccion_entre(corridor_pos, from),
		direccion_entre(corridor_pos, to),
	]
	map_data[corridor_pos] = pasillo

	# Agregar conexión a sala actual
	if map_data.has(from):
		map_data[from].conexiones.append(direccion_entre(from, pasillo_pos))
