extends Node
class_name WorldGeneratorOld

# === Initialization Constants ===
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


# === Entry point for generation ===
# Main method to generate entire level
func generate_level(seed: int, level: int, max_population: int, treasure_count: int, campus_chance: float) -> void:
	self.seed = seed
	self.level = level
	_generate_path(max_population)
	_place_special_rooms(treasure_count, campus_chance)
	_clean_isolated_corridors()


# --- Main path and branches ---
func _generate_path(max_population: int) -> void:
	rng.seed = seed
	map_data.clear()
	_generate_main_branch(rng)
	_populate_branches(visited_cells, max_population)
	_generate_secondary_branches(max_population)

# GENERATE MAIN BRANCH


# === Main Branch Generation ===
func _generate_main_branch(rng: RandomNumberGenerator):
	var boss_matching_boost: int = 0
	var MAX_LENGTH_FROM_INIT = GlobalConstants.WORLDGEN_MAX_LENGTH_FROM_INIT + (level * GlobalConstants.WORLDGEN_MAX_LENGTH_LEVEL_MULTIPIER)
	var distance_from_origin = 0
	var last_pos = 0
	var current_pos = START_CELL_POSITION
	var current_instance_type = RoomType.INITIAL
	var vertical_corridors_counter = 0
	visited_cells = [current_pos]

	var init_room_direction: Vector2i = _random_room_direction(rng)
	Logger.info("Init room direction: %s" % [init_room_direction])
	map_data[START_CELL_POSITION] = _create_initial_room([init_room_direction])
	distance_from_origin += 1

	while distance_from_origin <= MAX_LENGTH_FROM_INIT + boss_matching_boost:
		var adjacent_directions_available = _get_adjacent(current_instance_type, current_pos, init_room_direction)
		if adjacent_directions_available.is_empty():
			Logger.warning("WorldGenerator: Blocked at %s, attempting backtrack..." % current_pos)
			current_pos = _backtrack(visited_cells, last_pos)
			current_instance_type = map_data.get(current_pos).type
			continue

		var new_cell_direction = _get_random_available_direction(rng, adjacent_directions_available)
		Logger.info("NEW DIRECTION: %s" % [get_direction_name(new_cell_direction)])

		var new_cell_type = _get_new_cell_type(current_instance_type)
		var is_vertical = new_cell_direction == Vector2i.DOWN || new_cell_direction == Vector2i.UP
		if current_instance_type == RoomType.CORRIDOR and is_vertical:
			new_cell_type = RoomType.CORRIDOR
			vertical_corridors_counter += 1

		if vertical_corridors_counter > GlobalConstants.WORLDGEN_MAX_VERTICAL_CORRIDORS and rng.randf() < GlobalConstants.WORLDGEN_VERTICAL_CORRIDOR_TURN_CHANCE:
			new_cell_direction = _random_horizontal_direction()
			vertical_corridors_counter = 0

		if distance_from_origin >= MAX_LENGTH_FROM_INIT + boss_matching_boost:
			if current_instance_type == RoomType.CORRIDOR and !is_vertical:
				new_cell_type = RoomType.BOSS
			else:
				boss_matching_boost += 1
				new_cell_type = RoomType.CORRIDOR

		var new_cell_pos = current_pos + new_cell_direction
		distance_from_origin += 1
		_create_instance(current_pos, new_cell_pos, distance_from_origin, new_cell_type)
		visited_cells.append(new_cell_pos)

		current_instance_type = new_cell_type
		last_pos = current_pos
		current_pos = new_cell_pos

# POPULATE BRANCHES

# POPULATE BRANCHES


# === Fill corridors with branches ===
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

# GENERATE SECONDARY BRANCHES


# === Extra rooms beyond the main path ===
func _generate_secondary_branches(target_total_rooms: int):
	var existing_keys = map_data.keys()
	var current_total = existing_keys.size()
	while current_total < target_total_rooms:
		if existing_keys.is_empty():
			Logger.error("No cells available to branch from.")
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


# === Instantiate room at given position ===
func _create_instance(current_cell_pos: Vector2i, new_cell_pos: Vector2i, distance_from_origin: int, instance_type: int):
	
	var room_data: RoomData
	var backwards_door: bool = false
	
	match instance_type:
		RoomType.INITIAL:
			room_data = RoomDataInitial.new(level,distance_from_origin)
		RoomType.COMMON:
			room_data = RoomDataCommon.new(level,distance_from_origin)
			backwards_door = true
		RoomType.CORRIDOR:
			room_data = RoomDataCorridor.new(level, distance_from_origin)
			backwards_door = true
		RoomType.BOSS:
			room_data = RoomDataBoss.new(level, distance_from_origin)
			backwards_door = true
		RoomType.SHOP:
			room_data = RoomDataShop.new(level, distance_from_origin)
			backwards_door = true
		RoomType.TREASURE:
			room_data = RoomDataTreasure.new(level, distance_from_origin)
			backwards_door = true
		RoomType.LIMBO:
			pass
		RoomType.STAIRS:
			pass
		RoomType.CAMPUS:
			room_data = RoomDataCampus.new(level, distance_from_origin)
			backwards_door = true
		RoomType.IMANERROR:
			room_data = RoomData.new(level, RoomType.IMANERROR, distance_from_origin)
		_:
			room_data = RoomData.new(level, RoomType.IMANERROR, distance_from_origin)
	
	map_data[new_cell_pos] = room_data
	Logger.info("INSTANCE [POS: %s][DIS.ORIG: %d][TYPE: %s][CLASS: %s]" % [new_cell_pos, room_data.distance, get_room_type_name(room_data.type), room_data.get_script().get_class()])

	
	if backwards_door:
		_link_cells_connections(current_cell_pos, new_cell_pos)

func _link_cells_connections(current_cell_pos: Vector2i, new_cell_pos: Vector2i):
	# Current cell connection add
	map_data[current_cell_pos].add_connections([new_cell_pos - current_cell_pos] as Array[Vector2i])

	# New cell connection add
	map_data[new_cell_pos].add_connections([current_cell_pos - new_cell_pos] as Array[Vector2i])


# CREATE INITIAL ROOM

# === Setup initial room manually ===
func _create_initial_room(connections: Array[Vector2i]) -> RoomData:
	# TODO: Connections
	var init_room = RoomDataInitial.new(level, 0)
	init_room.add_connections(connections)
	_create_instance(START_CELL_POSITION, START_CELL_POSITION, init_room.distance, init_room.type)
	return init_room

# GETTING ADJACENT AVAILABLE


# --- Adjacent Cells by Type ---
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

# Return directions with free neighbor cells
func _get_adjacent_directions_available(pos: Vector2i, directions_available: Array[Vector2i]) -> Array[Vector2i]:
	return directions_available.filter(func(dir: Vector2i) -> bool:
		var new_pos = pos + dir
		return not map_data.has(new_pos)
	)

# GETTING NEW CELL TYPE


# --- Cell type transition logic ---
func _get_new_cell_type(current_instance_type):
	match (current_instance_type):
		RoomType.COMMON:
			return RoomType.CORRIDOR
		RoomType.INITIAL:
			return RoomType.CORRIDOR
		RoomType.CORRIDOR:
			return RoomType.COMMON
		_:
			Logger.error("Error in WorldGenerator._generate_main_branch: Invalid current cell type")
			return RoomType.IMANERROR

# RANDOMS


# Randomly choose LEFT or RIGHT
func _random_room_direction(rng: RandomNumberGenerator) -> Vector2i:
	rng.randomize()
	var options = [Vector2i.LEFT, Vector2i.RIGHT]
	return options[rng.randi_range(0, options.size() - 1)]

# Get horizontal direction randomly
func _random_horizontal_direction() -> Vector2i:
	return [Vector2i.LEFT, Vector2i.RIGHT][rng.randi_range(0, 1)]

# Pick direction avoiding repeats
func _get_random_available_direction(rng: RandomNumberGenerator, available_dirs: Array[Vector2i]) -> Vector2i:
	if last_direction != Vector2i.ZERO:
		var filtered = available_dirs.filter(func(d): return d != last_direction)
		if !filtered.is_empty():
			available_dirs = filtered
	var chosen = available_dirs[rng.randi_range(0, available_dirs.size() - 1)]
	last_direction = chosen
	return chosen

# BACKTRACK FOR PATHING


# --- Backtracking when blocked ---
func _backtrack(visited_cells: Array[Vector2i], last_pos) -> Vector2i:
	if visited_cells.size() <= 1:
		Logger.error("Backtracking failed: only initial room remains.")
		return START_CELL_POSITION

	var last_type: int = (map_data.get(last_pos) as RoomData).type
	if last_type == RoomType.CORRIDOR:
		visited_cells.pop_back()
		Logger.info("Removing dead-end corridor at %s" % last_pos)

	return visited_cells.back()

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
		if room.type == RoomType.COMMON:
			var corridor_count = 0
			for dir in [Vector2i.LEFT, Vector2i.RIGHT]:
				var neighbor = pos + dir
				if map_data.has(neighbor) and map_data[neighbor].type == RoomType.CORRIDOR:
					corridor_count += 1
			if corridor_count == 1:
				room.type = RoomType.SHOP
				Logger.info("SHOP PLACED at %s" % [pos])
				return

# N TREASURE rooms placement
func _place_treasure_rooms(max_count: int) -> void:
	var count = 0
	for pos in map_data.keys():
		if count >= max_count:
			return
		var room: RoomData = map_data[pos]
		if room.type == RoomType.COMMON:
			var corridor_count = 0
			for dir in [Vector2i.LEFT, Vector2i.RIGHT]:
				var neighbor = pos + dir
				if map_data.has(neighbor) and map_data[neighbor].type == RoomType.CORRIDOR:
					corridor_count += 1
			if corridor_count == 1:
				room.type = RoomType.TREASURE
				Logger.info("TREASURE PLACED at %s" % [pos])
				count += 1

# CAMPUS room placement
func _place_campus(probability: float) -> void:
	if rng.randf() > probability:
		return

	for pos in map_data.keys():
		var room: RoomData = map_data[pos]
		if room.type == RoomType.COMMON:
			var below = pos + Vector2i.DOWN
			if map_data.has(below) and map_data[below].type == RoomType.CORRIDOR:
				room.type = RoomType.CAMPUS
				Logger.info("CAMPUS PLACED at %s" % [pos])
				return

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
		map_data.erase(pos)
		Logger.info("Removed corridor with only one neighbor at %s" % [pos])


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
