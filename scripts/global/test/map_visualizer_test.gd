extends Node2D
class_name MapVisualizer2DO

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
	if event.is_action_pressed("ui_accept"):  # Espacio por defecto
		_generate_and_visualize()

func _generate_and_visualize():
	clear_level()
	await get_tree().process_frame  # Espera a que clear_level termine

	var random_seed = Time.get_ticks_msec() % 100000000
	world_generator.generate_level(random_seed, 0, 50, 4, 0.05)

	Logger.info("Celdas generadas: %d" % world_generator.map_data.size())
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


func visualize_map(map_data: Dictionary):
	for cell_pos in map_data.keys():
		var room_data: RoomData = map_data[cell_pos]
		var room_type: int = room_data.type
		var color: Color = ROOM_COLORS.get(room_type, Color.BLACK)

		var rect := ColorRect.new()
		rect.color = color
		rect.size = Vector2(CELL_SIZE, CELL_SIZE)
		rect.position = Vector2(cell_pos.x * CELL_SIZE, cell_pos.y * CELL_SIZE)
		add_child(rect)

		var label := Label.new()
		label.text = world_generator.get_room_type_name(room_type)
		label.size = rect.size
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.position = rect.position
		label.add_theme_color_override("font_color", Color.BLACK)
		label.scale = Vector2(0.8, 0.8)
		add_child(label)
