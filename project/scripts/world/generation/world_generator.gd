extends Node
class_name WorldGenerator

const START_CELL_POSITION = Vector2i.ZERO

# Current in game level
var level: int
# RNG instance and map data structures
var rng = RandomNumberGenerator.new()
# Seed for number generation
var seed: int
# Stores room data by position
var map_data: Dictionary = {}
# Track visited cells for pathing
var visited_cells: Array[Vector2i]
# Last movement direction used
var last_direction: Vector2i = Vector2i.ZERO


func generate_level(seed: int = GlobalConstants.WORLDGEN_DEBUG_DEFAULT_SEED, level: int = 0, max_population: int = GlobalConstants.WORLDGEN_MAX_INSTANCES_PER_POPULATION, max_target_secundary_branch: int = GlobalConstants.WORLDGEN_MAX_TARGET_SECUNDARY_BRANCH, treasure_count: int = GlobalConstants.WORLDGEN_MAX_TREASURE_ROOMS_PER_LEVEL, campus_chance: float = GlobalConstants.WORLDGEN_CAMPUS_ROOM_CHANCE) -> void:
	self.seed = seed
	self.level = level
	_generate_path(max_population)
	if GlobalConstants.WORLDGEN_ENABLE_ENSURE_MINIMUN_COMMON_ROOMS:
		_ensure_minimum_common_rooms(GlobalConstants.WORLDGEN_MIN_COMMON_ROOMS_PER_LEVEL)
	if GlobalConstants.WORLDGEN_ENABLE_ENSURE_INSTANCES_RANGE:
		_ensure_instances_range()
	if GlobalConstants.WORLDGEN_ENABLE_PLACE_BOSS_ROOM:
		_place_boss_room()
	if GlobalConstants.WORLDGEN_ENABLE_PLACE_SPECIAL_ROOMS:
		_place_special_rooms(treasure_count, campus_chance)
	if GlobalConstants.WORLDGEN_ENABLE_CONNECT_CORRIDORS_TO_ADJACENT:
		_connect_corridors_to_adjacent_rooms()
	if GlobalConstants.WORLDGEN_ENABLE_CLEAN_ISOLATED_CORRIDORS:
		_clean_isolated_corridors()
	if GlobalConstants.WORLDGEN_ENABLE_EXPAND_DEAD_CORRIDORS:
		_expand_dead_end_corridors_with_common_rooms()

func _generate_path(max_population: int) -> void:
	rng.seed = seed
	map_data.clear()
	_generate_main_branch(rng)
	_populate_branches(visited_cells, max_population)
	_generate_secondary_branches(max_population)

func _generate_main_branch(rng: RandomNumberGenerator):
	var boss_matching_boost: int = 0
	var MAX_LENGTH_FROM_INIT = GlobalConstants.WORLDGEN_MAX_LENGTH_FROM_INIT + (level * GlobalConstants.WORLDGEN_MAX_LENGTH_LEVEL_MULTLIPIER)
	var distance_from_origin = 0
	var last_pos = 0
	var current_pos = START_CELL_POSITION
	var current_instance_type = RoomType.INITIAL
	var vertical_corridors_counter = 0
	var backtrack_attempts = 0

	visited_cells = [current_pos]

	var init_room_direction: Vector2i = _random_room_direction(rng)
	# Logger.info("Init room direction: %s" % [init_room_direction])
	map_data[START_CELL_POSITION] = _create_initial_room()
	distance_from_origin += 1

	while distance_from_origin <= MAX_LENGTH_FROM_INIT + boss_matching_boost:
		var adjacent_directions_available = _get_adjacent(current_instance_type, current_pos, init_room_direction)
		if adjacent_directions_available.is_empty():
			if backtrack_attempts >= GlobalConstants.WORLDGEN_MAX_BACKTRACK_ATTEMPTS:
				# Logger.warning("Max backtrack attempts reached. Stopping generation.")
				break
			# Logger.warning("WorldGenerator: Blocked at %s, attempting backtrack..." % current_pos)
			last_pos = current_pos
			current_pos = _backtrack(visited_cells, last_pos)
			last_pos = current_pos
			current_instance_type = map_data.get(current_pos).type
			backtrack_attempts += 1
			continue

		backtrack_attempts = 0


		var new_cell_direction = _get_random_available_direction(rng, adjacent_directions_available)
		# Logger.info("NEW DIRECTION: %s" % [get_direction_name(new_cell_direction)])

		var new_cell_type = _get_new_cell_type(current_instance_type)
		var is_vertical = new_cell_direction == Vector2i.DOWN || new_cell_direction == Vector2i.UP
		if current_instance_type == RoomType.CORRIDOR and is_vertical:
			new_cell_type = RoomType.CORRIDOR
			vertical_corridors_counter += 1

		if vertical_corridors_counter > GlobalConstants.WORLDGEN_MAX_VERTICAL_CORRIDORS and rng.randf() < GlobalConstants.WORLDGEN_VERTICAL_CORRIDOR_TURN_CHANCE:
			new_cell_direction = _random_horizontal_direction()
			vertical_corridors_counter = 0

		if distance_from_origin >= MAX_LENGTH_FROM_INIT + boss_matching_boost:
			boss_matching_boost += 1
			new_cell_type = RoomType.CORRIDOR


		var new_cell_pos = current_pos + new_cell_direction

		if not (new_cell_type == RoomType.CORRIDOR && (new_cell_direction == Vector2i.UP || new_cell_direction == Vector2i.DOWN)):
			distance_from_origin += 1

		_create_instance(current_pos, new_cell_pos, distance_from_origin, new_cell_type)
		visited_cells.append(new_cell_pos)

		current_instance_type = new_cell_type
		last_pos = current_pos
		current_pos = new_cell_pos

# POPULATE BRANCHES

func _populate_branches(candidates: Array[Vector2i], max_new_rooms: int):
	var new_rooms = 0
	for pos in candidates:
		if new_rooms >= max_new_rooms:
			break
		var data = map_data.get(pos) as RoomData
		if data == null or data.type != RoomType.CORRIDOR:
			continue
		for dir in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
			if new_rooms >= max_new_rooms:
				break
			var side_pos = pos + dir
			if map_data.has(side_pos):
				continue
			if rng.randf() > GlobalConstants.WORLDGEN_BRANCHING_ROOM_CHANCE:
				continue
			var horizontal = dir == Vector2i.LEFT or dir == Vector2i.RIGHT
			var new_type = RoomType.COMMON if horizontal else RoomType.CORRIDOR
			if new_type == RoomType.COMMON and not horizontal:
				continue
			_create_instance(pos, side_pos, data.distance + 1, new_type)
			new_rooms += 1

# GENERATE SECONDARY BRANCHES

func _generate_secondary_branches(target_total_rooms: int):
	var existing_keys = map_data.keys()
	var current_total = existing_keys.size()
	while current_total < target_total_rooms:
		if existing_keys.is_empty():
			# Logger.error("No cells available to branch from.")
			return
		var origin_pos = existing_keys[rng.randi_range(0, existing_keys.size() - 1)]
		var origin_data = map_data.get(origin_pos) as RoomData
		if origin_data == null:
			continue
		var origin_type = origin_data.type
		if origin_type != RoomType.COMMON and origin_type != RoomType.CORRIDOR:
			continue
		var available_dirs = _get_adjacent_directions_available(origin_pos, [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT])
		if available_dirs.is_empty():
			continue
		var current_pos = origin_pos
		var current_type = origin_type
		var branch_length = rng.randi_range(GlobalConstants.WORLDGEN_BRANCH_LENGTH_MIN, GlobalConstants.WORLDGEN_BRANCH_LENGTH_MAX)
		var direction = available_dirs[rng.randi_range(0, available_dirs.size() - 1)]
		for i in range(branch_length):
			var new_pos = current_pos + direction
			if map_data.has(new_pos):
				break
			var new_type = RoomType.CORRIDOR if current_type != RoomType.CORRIDOR else RoomType.COMMON
			var is_vertical = direction == Vector2i.UP or direction == Vector2i.DOWN
			if new_type == RoomType.COMMON and is_vertical:
				var side_dirs = [Vector2i.LEFT, Vector2i.RIGHT]
				for side_dir in side_dirs:
					var side_pos = current_pos + side_dir
					if not map_data.has(side_pos):
						new_pos = side_pos
						direction = side_dir
						break
			var distance = origin_data.distance + i + 1
			_create_instance(current_pos, new_pos, distance, new_type)
			current_pos = new_pos
			current_type = new_type
			current_total += 1
			if current_total >= target_total_rooms:
				return
			if direction == Vector2i.ZERO:
				break

# CREATE INSTANCE

func _create_instance(current_cell_pos: Vector2i, new_cell_pos: Vector2i, distance_from_origin: int, instance_type: int):
	var room_data: RoomData

	match instance_type:
		RoomType.INITIAL:
			room_data = RoomDataInitial.new(level, distance_from_origin)
		RoomType.COMMON:
			room_data = RoomDataCommon.new(level, distance_from_origin)
		RoomType.CORRIDOR:
			room_data = RoomDataCorridor.new(level, distance_from_origin)
		RoomType.BOSS:
			room_data = RoomDataBoss.new(level, distance_from_origin)
		RoomType.SHOP:
			room_data = RoomDataShop.new(level, distance_from_origin)
		RoomType.TREASURE:
			room_data = RoomDataTreasure.new(level, distance_from_origin)
		RoomType.CAMPUS:
			room_data = RoomDataCampus.new(level, distance_from_origin)
		_:
			room_data = RoomData.new(level, RoomType.IMANERROR, distance_from_origin)

	map_data[new_cell_pos] = room_data

	# Logger.info("INSTANCE [POS: %s][DIS.ORIG: %d][TYPE: %s]" % [new_cell_pos, room_data.distance, get_room_type_name(room_data.type)])

	if current_cell_pos != new_cell_pos:
		_link_cells_connections(current_cell_pos, new_cell_pos)
	elif instance_type in [RoomType.CAMPUS, RoomType.SHOP, RoomType.TREASURE, RoomType.BOSS]:
		pass





func _link_cells_connections(current_cell_pos: Vector2i, new_cell_pos: Vector2i):
	var delta1: Vector2i = new_cell_pos - current_cell_pos
	var delta2: Vector2i = current_cell_pos - new_cell_pos
	var connections1: Array[Vector2i] = [delta1]
	var connections2: Array[Vector2i] = [delta2]
	map_data[current_cell_pos].add_connections(connections1)
	map_data[new_cell_pos].add_connections(connections2)

# CREATE INITIAL ROOM

func _create_initial_room() -> RoomData:
	var init_room = RoomDataInitial.new(level, 0)
	map_data[START_CELL_POSITION] = init_room
	# Logger.info("INSTANCE [POS: %s][DIS.ORIG: %d][TYPE: INITIAL]" % [START_CELL_POSITION, init_room.distance])
	return init_room


# GETTING ADJACENT AVAILABLE DATA

func _get_adjacent(current_instance_type, current_pos, init_room_direction, exclude_dir = Vector2i.ZERO) -> Array[Vector2i]:
	var adjacent_directions_available: Array[Vector2i]

	match (current_instance_type):
		RoomType.INITIAL:
			adjacent_directions_available = [init_room_direction]
		RoomType.CORRIDOR:
			adjacent_directions_available = _get_adjacent_directions_available(current_pos, [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT])
		RoomType.COMMON:
			adjacent_directions_available = _get_adjacent_directions_available(current_pos, [Vector2i.LEFT, Vector2i.RIGHT])

	if exclude_dir != Vector2i.ZERO:
		adjacent_directions_available = adjacent_directions_available.filter(func(d): return d != -exclude_dir)

	return adjacent_directions_available

func _get_adjacent_directions_available(pos: Vector2i, directions_available: Array[Vector2i]) -> Array[Vector2i]:
	return directions_available.filter(func(dir: Vector2i) -> bool:
		var new_pos = pos + dir
		return not map_data.has(new_pos)
	)

# NEW CELL TYPE SELECTION

func _get_new_cell_type(current_instance_type):
	match (current_instance_type):
		RoomType.COMMON:
			return RoomType.CORRIDOR
		RoomType.INITIAL:
			return RoomType.CORRIDOR
		RoomType.CORRIDOR:
			return RoomType.COMMON
		_:
			# Logger.error("Error in WorldGenerator._generate_main_branch: Invalid current cell type")
			return RoomType.IMANERROR

# RANDOMS

func _random_room_direction(rng: RandomNumberGenerator) -> Vector2i:
	rng.randomize()
	var options = [Vector2i.LEFT, Vector2i.RIGHT]
	return options[rng.randi_range(0, options.size() - 1)]

func _random_horizontal_direction() -> Vector2i:
	return [Vector2i.LEFT, Vector2i.RIGHT][rng.randi_range(0, 1)]

func _get_random_available_direction(rng: RandomNumberGenerator, available_dirs: Array[Vector2i]) -> Vector2i:
	if last_direction != Vector2i.ZERO:
		var filtered = available_dirs.filter(func(d): return d != last_direction)
		if !filtered.is_empty():
			available_dirs = filtered
	var chosen = available_dirs[rng.randi_range(0, available_dirs.size() - 1)]
	last_direction = chosen
	return chosen

func _connect_corridors_to_adjacent_rooms() -> void:
	for pos in map_data.keys():
		var data = map_data[pos]
		if data.type != RoomType.CORRIDOR:
			continue

		for dir in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
			var neighbor_pos = pos + dir
			if not map_data.has(neighbor_pos):
				continue

			var neighbor = map_data[neighbor_pos]
			if neighbor.type != RoomType.CORRIDOR:
				continue

			if not data.connections.has(dir):
				data.add_connections([dir] as Array[Vector2i])
			if not neighbor.connections.has(-dir):
				neighbor.add_connections([-dir] as Array[Vector2i])
			# Logger.info("CONNECTED CORRIDOR %s <--> %s %s" % [pos,get_room_type_name(neighbor.type),neighbor_pos])


# BACKTRACK FOR PATHING


# --- Backtracking when blocked ---
func _backtrack(visited_cells: Array[Vector2i], last_pos) -> Vector2i:
	if visited_cells.size() <= 1:
		# Logger.error("Backtracking failed: only initial room remains.")
		return START_CELL_POSITION

	var last_type: int = (map_data.get(last_pos) as RoomData).type
	if last_type == RoomType.CORRIDOR:
		visited_cells.pop_back()
		# Logger.info("Removing dead-end corridor at %s" % last_pos)

	return visited_cells.back()

func _ensure_instances_range():
	var room_count := map_data.size()

	var max_rooms = (
		GlobalConstants.WORLDGEN_MAX_LENGTH_FROM_INIT + (level * GlobalConstants.WORLDGEN_MAX_LENGTH_LEVEL_MULTLIPIER)
		+ GlobalConstants.WORLDGEN_MAX_TARGET_SECUNDARY_BRANCH * GlobalConstants.WORLDGEN_BRANCH_LENGTH_MAX
	)

	if room_count > max_rooms:
		# Logger.warning("Room count (%d) out of max (%d). Retrying..." % [room_count, max_rooms])
		map_data.clear()
		visited_cells.clear()
		last_direction = Vector2i.ZERO
		generate_level(seed, level)


func _ensure_minimum_common_rooms(min_required: int) -> void:
	var current_common_count := 0
	for data in map_data.values():
		if data.type == RoomType.COMMON:
			current_common_count += 1

	if current_common_count >= min_required:
		return

	# Logger.warning("Insufficient common rooms (%d/%d). Adding more..." % [current_common_count, min_required])

	# First, expand from corridors
	var corridors = map_data.keys().filter(func(pos):
		var data = map_data[pos]
		return data.type == RoomType.CORRIDOR
	)

	for pos in corridors:
		if current_common_count >= min_required:
			break
		for dir in [Vector2i.LEFT, Vector2i.RIGHT]:
			var corridor_pos = pos + dir
			var room_pos = corridor_pos + dir
			if map_data.has(corridor_pos) or map_data.has(room_pos):
				continue
			_create_instance(pos, corridor_pos, map_data[pos].distance + 1, RoomType.CORRIDOR)
			_create_instance(corridor_pos, room_pos, map_data[pos].distance + 2, RoomType.COMMON)
			current_common_count += 1
			break

	# If still not enough, expand from any room
	if current_common_count < min_required:
		# Logger.warning("Retrying with all rooms as origin...")
		var all_rooms = map_data.keys()
		for pos in all_rooms:
			if current_common_count >= min_required:
				break
			for dir in [Vector2i.LEFT, Vector2i.RIGHT]:
				var corridor_pos = pos + dir
				var room_pos = corridor_pos + dir
				if map_data.has(corridor_pos) or map_data.has(room_pos):
					continue
				_create_instance(pos, corridor_pos, map_data[pos].distance + 1, RoomType.CORRIDOR)
				_create_instance(corridor_pos, room_pos, map_data[pos].distance + 2, RoomType.COMMON)
				current_common_count += 1
				break



# SPECIAL ROOMS


# Place rooms with special roles
func _place_special_rooms(treasure_count: int, campus_chance: float) -> void:
	_place_shop()
	_place_treasure_rooms(treasure_count)
	_place_campus(campus_chance)


# Look for suitable COMMON to become SHOP
func _place_shop() -> void:
	for pos in map_data.keys():
		var room: RoomData = map_data[pos]
		if room.type != RoomType.COMMON:
			continue

		if room.connections.size() != 1:
			continue

		var dir = room.connections[0]
		if dir != Vector2i.LEFT and dir != Vector2i.RIGHT:
			continue

		var connections = room.connections.duplicate()
		var distance = room.distance
		_create_instance(pos, pos, distance, RoomType.SHOP)
		map_data[pos].add_connections(connections)
		# Logger.info("SHOP PLACED at %s" % [pos])
		return



# N TREASURE rooms placement
func _place_treasure_rooms(max_count: int) -> void:
	var count = 0
	for pos in map_data.keys():
		if count >= max_count:
			return

		var room: RoomData = map_data[pos]
		if room.type != RoomType.COMMON:
			continue

		if room.connections.size() != 1:
			continue

		var dir = room.connections[0]
		if dir != Vector2i.LEFT and dir != Vector2i.RIGHT:
			continue

		var connections = room.connections.duplicate()
		var distance = room.distance
		_create_instance(pos, pos, distance, RoomType.TREASURE)
		map_data[pos].add_connections(connections)
		# Logger.info("TREASURE PLACED at %s" % [pos])
		count += 1


# CAMPUS room placement
func _place_campus(probability: float) -> void:
	if rng.randf() > probability:
		return

	# Prevent duplicate CAMPUS
	for data in map_data.values():
		if data.type == RoomType.CAMPUS:
			# Logger.warning("Campus already exists. Skipping placement.")
			return

	for corridor_pos in map_data.keys():
		var corridor = map_data[corridor_pos]
		if corridor.type != RoomType.CORRIDOR:
			continue

		var campus_pos = corridor_pos + Vector2i.UP
		if map_data.has(campus_pos):
			continue

		# Create the campus room above the corridor and connect them
		_create_instance(corridor_pos, campus_pos, corridor.distance + 1, RoomType.CAMPUS)
		# Logger.info("CAMPUS PLACED at %s" % [campus_pos])
		return



func _place_boss_room():
	# Check if a BOSS room already exists
	for data in map_data.values():
		if data.type == RoomType.BOSS:
			# Logger.warning("Boss room already exists. Skipping placement.")
			return

	var attempts := 0
	var boss_placed := false

	while attempts < GlobalConstants.WORLDGEN_MAX_BOSS_ATTEMPTS:
		var furthest_pos: Vector2i = START_CELL_POSITION
		var max_distance := -1

		for pos in map_data.keys():
			var data = map_data[pos]
			if data.type != RoomType.COMMON:
				continue
			if data.connections.size() != 1:
				continue
			var dir = data.connections[0]
			if dir != Vector2i.LEFT and dir != Vector2i.RIGHT:
				continue
			if data.distance > max_distance:
				max_distance = data.distance
				furthest_pos = pos

		if max_distance > -1:
			var original = map_data[furthest_pos]
			var connections = original.connections.duplicate()
			_create_instance(
				furthest_pos,
				furthest_pos,
				original.distance,
				RoomType.BOSS
			)
			map_data[furthest_pos].add_connections(connections)
			# Logger.info("BOSS PLACED at %s" % furthest_pos)
			boss_placed = true
			break

		attempts += 1
		# Logger.warning("Boss placement attempt #%d failed" % attempts)

	if not boss_placed:
		# Logger.error("Boss placement failed after %d attempts. Regenerating level..." % attempts)
		map_data.clear()
		visited_cells.clear()
		last_direction = Vector2i.ZERO
		generate_level(seed, level)


	if not boss_placed:
		# Logger.error("Boss placement failed after %d attempts. Regenerating level..." % attempts)
		# Limpia todo y vuelve a empezar
		map_data.clear()
		visited_cells.clear()
		last_direction = Vector2i.ZERO
		generate_level(seed, level)


# Intenta expandir pasillos muertos con habitaciones comunes
func _expand_dead_end_corridors_with_common_rooms() -> void:
	for pos in map_data.keys():
		var data = map_data[pos]
		if data.type != RoomType.CORRIDOR:
			continue

		# Aquí va tu lógica para detectar si es un pasillo "muerto"
		if true:
			# Intenta colocar una habitación común a la izquierda o derecha
			for dir in [Vector2i.LEFT, Vector2i.RIGHT]:
				var new_pos = pos + dir
				if map_data.has(new_pos):
					continue  # Ya hay algo ahí

				_create_instance(pos, new_pos, data.distance + 1, RoomType.COMMON)
				# Logger.info("COMMON ROOM EXPANSION at %s from corridor %s" % [new_pos, pos])
				break  # Sólo colocamos una


# CLEANING LEVEL

# Remove corridors connected to only one cell
func _clean_isolated_corridors():
	var to_remove := []

	for pos in map_data.keys():
		var data = map_data[pos]
		if data.type != RoomType.CORRIDOR:
			continue

		var occupied_neighbors := 0

		for dir in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
			var neighbor_pos = pos + dir
			if map_data.has(neighbor_pos):
				occupied_neighbors += 1

		if occupied_neighbors == 1:
			to_remove.append(pos)

	for pos in to_remove:
		_remove_corridor_and_cleanup_neighbors(pos)

func _remove_corridor_and_cleanup_neighbors(pos: Vector2i) -> void:
	for dir in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
		var neighbor_pos = pos + dir
		if not map_data.has(neighbor_pos):
			continue

		var neighbor = map_data[neighbor_pos]
		if neighbor.connections.has(-dir):
			neighbor.connections.erase(-dir)
			# Logger.info("Removed connection from %s to %s" % [neighbor_pos, pos])

	map_data.erase(pos)
	# Logger.info("Removed isolated corridor at %s" % pos)




# UTILS

# Return string for room type enum
func get_room_type_name(value: int) -> String:
	match value:
		RoomType.IMANERROR: return "IMANERROR"
		RoomType.INITIAL: return "INITIAL"
		RoomType.COMMON: return "COMMON"
		RoomType.CORRIDOR: return "CORRIDOR"
		RoomType.BOSS: return "BOSS"
		RoomType.SHOP: return "SHOP"
		RoomType.TREASURE: return "TREASURE"
		RoomType.LIMBO: return "LIMBO"
		RoomType.STAIRS: return "STAIRS"
		RoomType.CAMPUS: return "CAMPUS"
		_: return "UNKNOWN"

# Return string for direction
func get_direction_name(dir: Vector2i) -> String:
	match dir:
		Vector2i.LEFT: return "LEFT"
		Vector2i.RIGHT: return "RIGHT"
		Vector2i.UP: return "UP"
		Vector2i.DOWN: return "DOWN"
		_: return "UNKNOWN"
