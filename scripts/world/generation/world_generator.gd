extends Node
class_name WorldGenerator

const START_CELL_POSITION = Vector2i.ZERO

var rng = RandomNumberGenerator.new()
var map_data: Dictionary = {}

func _generate_path(seed: int, level: int) -> void:
	rng.seed = seed
	map_data.clear()
	
	# Main branch
	_generate_main_branch(rng, level)
	


func _generate_main_branch(rng: RandomNumberGenerator, level: int):
	var MAX_LENGTH_FROM_INIT = GlobalConstants.WORLDGEN_MAX_LENGTH_FROM_INIT + (level * GlobalConstants.WORLDGEN_MAX_LENGTH_LEVEL_MULTIPIER)
	var distance_from_origin = 0
	var current_pos = START_CELL_POSITION
	var visited_cells: Array[Vector2i] = [current_pos]
	var current_instance_type = RoomType.INITIAL
	var boss_matching_boost: int = 0
	
	# Initial room
	var init_room_direction: Vector2i = _random_room_direction(rng)
	_create_initial_room(level, [init_room_direction])
	
	while distance_from_origin <= MAX_LENGTH_FROM_INIT + boss_matching_boost:
		
		var adjacent_cells: Array[Vector2i]
		
		match (current_instance_type):
			
			# INITIAL ROOM
			RoomType.INITIAL:
				adjacent_cells = [init_room_direction]
			
			# CORRIDOR
			RoomType.CORRIDOR:
				adjacent_cells = _obtain_adjacent_available(current_pos, visited_cells, [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT])
			
			# COMMON ROOM
			RoomType.COMMON:
				adjacent_cells = _obtain_adjacent_available(current_pos, visited_cells, [Vector2i.LEFT, Vector2i.RIGHT])

		# Error case
		if adjacent_cells.is_empty():
			Logger.error("Error in WorldGenerator._generate_path: Path blocked, no valid exit")
			break
		
		var next_cell_pos: Vector2i = adjacent_cells[rng.randi_range(0, adjacent_cells.size() - 1)]
		var next_cell_type
		
		# FROM [ROOMS] TO [CORRIDOR]
			
		# NEW INSTANCE TYPE SET
		match (current_instance_type):
			
			# FROM [ROOMS] TO [CORRIDOR]
			RoomType.INITIAL || RoomType.COMMON:
				next_cell_type = RoomType.CORRIDOR
			
			# FROM [CORRIDOR] TO [COMMON ROOM]
			# TODO: Setting special room type
			RoomType.CORRIDOR:
				next_cell_type = RoomType.COMMON
		
		distance_from_origin += 1
		
		# CHECK BOSS TYPE
		if distance_from_origin == MAX_LENGTH_FROM_INIT:
			if current_instance_type != RoomType.CORRIDOR:
				boss_matching_boost += 1
			else:
				next_cell_type = RoomType.BOSS
		
		# Crear habitación común en 'next'
		_create_instance(current_pos, next_cell_pos, distance_from_origin, RoomType.COMMON)

# CREATE INITIAL ROOM

func _create_initial_room(level: int, connections: Array[Vector2i]):
	var init_room = RoomDataInitial.new()
	init_room.level = level
	init_room.distance = 0
	init_room.connections = connections
	map_data[START_CELL_POSITION] = init_room

# OBTAIN ADJACENT AVIABLE

func _obtain_adjacent_available(pos: Vector2i, blocked: Array[Vector2i], directions_aviable: Array[Vector2i]) -> Array[Vector2i]:
	return directions_aviable.filter(func(p):
		not map_data.has(p) and not blocked.has(p)
	)

# RANDOM ROOM DIRECTION

func _random_room_direction(rng: RandomNumberGenerator) -> Vector2i:
	var options = [Vector2i.LEFT, Vector2i.RIGHT]
	return options[rng.randi_range(0, options.size() - 1)]

# DIRECTION UTILS

func _direction_between(from: Vector2i, to: Vector2i) -> Vector2i:
	var dir = to - from
	
	if dir == Vector2i.LEFT:
		return Vector2i.LEFT
	elif dir == Vector2i.UP:
		return Vector2i.UP
	elif dir == Vector2i.RIGHT:
		return Vector2i.RIGHT
	elif dir == Vector2i.DOWN:
		return Vector2i.DOWN
	
	# Error case
	Logger.error("Error in WorldGenerator._direction_between: Direction between intances not valid [%s]" % [str(Vector2i.ZERO)])
	return Vector2i.ZERO

# CREATE INSTANCE

func _create_instance(current_pos: Vector2i, next_cell_pos: Vector2i, distance_from_origin: int, intance_type: int):
	pass








# CREATE CORRIDOR

func _create_corridor(from: Vector2i, to: Vector2i) -> void:
	# Esta función necesita ser implementada para crear el pasillo.
	# Actualmente, tu código tiene una función `create_corridor` pero la he renombrado a `_create_corridor`
	# para seguir la convención de funciones internas en GDScript.
	var corridor_pos = from + ((to - from) / 2) # Punto medio

	var corridor = RoomData.new()
	corridor.type = RoomType.CORRIDOR # Asegúrate de que tienes un RoomType.Type.CORRIDOR
	corridor.connections = [
		_direction_between(corridor_pos, from),
		_direction_between(corridor_pos, to),
	]
	map_data[corridor_pos] = corridor

	# Agregar conexión a sala actual
	if map_data.has(from):
		map_data[from].connections.append(_direction_between(from, corridor_pos))









# CREATE ROOM

func _create_room(distance_from_origin: int, next_cell_pos: Vector2i, current_instance_type: RoomType):
	var room = RoomData.new()
	room.type = RoomType.COMMON
	room.distance = distance_from_origin + 1
	room.connections = [_direction_between]
	map_data[next_cell_pos] = room
	
	# Actualizar el tipo de la habitación actual para la próxima iteración
	# Esto asume que la habitación 'next' será la 'current_room' en la siguiente iteración
	current_instance_type = room.type
	
	# current_pos = next_cell_pos
	# visited_cells.append(current_pos)
	distance_from_origin += 1
