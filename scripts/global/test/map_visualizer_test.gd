extends Node2D
class_name MapVisualizer2D

@export var world_generator: WorldGenerator

const CELL_SIZE := 100

const ROOM_COLORS := {
	RoomType.INITIAL: Color.GREEN,
	RoomType.COMMON: Color.CORNFLOWER_BLUE,
	RoomType.CORRIDOR: Color.GRAY,
	RoomType.BOSS: Color.RED,
	RoomType.SHOP: Color.ORANGE,
	RoomType.TREASURE: Color.GOLD,
	RoomType.LIMBO: Color.DARK_SLATE_GRAY,
	RoomType.STAIRS: Color.PURPLE,
	RoomType.CAMPUS: Color.CYAN,
	RoomType.IMANERROR: Color.DEEP_PINK
}

func _ready():
	if world_generator == null:
		Logger.error("MapVisualizer2D: No se ha asignado WorldGenerator.")
		return
	set_process_input(true)
	_generate_and_visualize()


func _input(event):
	if event.is_action_pressed("ui_accept"):
		Logger.info("\n\n=====================NEW MAP_DATA GENERATED=====================\n")
		_generate_and_visualize()

func _generate_and_visualize():
	clear_level()
	await get_tree().process_frame

	world_generator.generate_level(GlobalConstants.WORLDGEN_DEBUG_DEFAULT_SEED, 3)

	Logger.info("GENERATED CELLS: %d" % world_generator.map_data.size())
	visualize_map(world_generator.map_data)



func clear_level():
	for child in get_children():
		child.queue_free()
	world_generator.map_data.clear()
	world_generator.visited_cells.clear()
	world_generator.last_direction = Vector2i.ZERO


func _flush_children():
	await get_tree().process_frame
	for child in get_children():
		child.queue_free()
	world_generator.map_data.clear()
	world_generator.visited_cells.clear()
	world_generator.last_direction = Vector2i.ZERO


func visualize_map(map_data: Dictionary) -> void:
	for cell_pos in map_data.keys():
		var room_data: RoomData = map_data[cell_pos]
		var room_type: int = room_data.type
		var base_color: Color = ROOM_COLORS.get(room_type, Color.BLACK)

		var base_pos: Vector2 = Vector2(cell_pos.x * CELL_SIZE, cell_pos.y * CELL_SIZE)
		var center: Vector2 = base_pos + Vector2(CELL_SIZE / 2, CELL_SIZE / 2)

		var rect = ColorRect.new()
		rect.color = base_color
		rect.size = Vector2(CELL_SIZE, CELL_SIZE)
		rect.position = base_pos
		add_child(rect)

		for dir in room_data.connections:
			var line = ColorRect.new()
			line.color = Color.WHITE
			var thickness = 6
			var length = CELL_SIZE / 2

			match dir:
				Vector2i.UP:
					line.size = Vector2(thickness, length)
					line.position = center + Vector2(-thickness / 2, -length)
				Vector2i.DOWN:
					line.size = Vector2(thickness, length)
					line.position = center + Vector2(-thickness / 2, 0)
				Vector2i.LEFT:
					line.size = Vector2(length, thickness)
					line.position = center + Vector2(-length, -thickness / 2)
				Vector2i.RIGHT:
					line.size = Vector2(length, thickness)
					line.position = center + Vector2(0, -thickness / 2)

			add_child(line)

		var label = Label.new()
		label.text = world_generator.get_room_type_name(room_type)
		label.size = Vector2(CELL_SIZE, CELL_SIZE)
		label.position = base_pos
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_color_override("font_color", Color.BLACK)
		label.scale = Vector2(0.8, 0.8)
		add_child(label)
