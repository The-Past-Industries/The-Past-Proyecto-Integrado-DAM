extends Node2D
class_name MapVisualizerOLD

const DOWN = preload("res://assets/ui/map_icons/down.png")
const UP = preload("res://assets/ui/map_icons/up.png")
const BOSS = preload("res://assets/ui/map_icons/boss.png")
const CAMPUS = preload("res://assets/ui/map_icons/campus.png")
const HOME = preload("res://assets/ui/map_icons/home.png")
const SHOP = preload("res://assets/ui/map_icons/shop.png")
const TREASURE = preload("res://assets/ui/map_icons/treasure.png")

@export var cell_size: int = 150

const COLOR_SEEN := Color("#808898")
const COLOR_UNSEEN := Color("#40444c")
const BORDER_COLOR_DEFAULT := Color("#f3f3f373")
const BORDER_COLOR_BOSS := Color("#80000073")

const ROOM_COLORS := {
	RoomType.INITIAL: Color("#8b8b8b"),
	RoomType.COMMON: Color("#575757"),
	#RoomType.CORRIDOR: Color("121212ea"),
	RoomType.CORRIDOR: Color.TRANSPARENT,
	RoomType.BOSS: Color.RED,
	RoomType.SHOP: Color.ORANGE,
	RoomType.TREASURE: Color.GOLD,
	RoomType.CAMPUS: Color.CYAN,
	RoomType.IMANERROR: Color.DEEP_PINK
}

func _ready():
	if WorldManagerGlobal.world_generator == null:
		Logger.error("MapVisualizer: world_generator not set.")
		return
	set_process(true)

func _process(_delta: float) -> void:
	_refresh_map(WorldManagerGlobal.world_generator.map_data)

func _refresh_map(map_data: Dictionary) -> void:
	for child in get_children():
		child.queue_free()

	for cell_pos in map_data.keys():
		var room_data: RoomData = map_data[cell_pos]
		var room_type: int = room_data.type

		var base_color: Color
		match room_type:
			RoomType.INITIAL:
				base_color = COLOR_SEEN
			RoomType.COMMON:
				base_color = COLOR_SEEN if room_data.shown else COLOR_UNSEEN
			RoomType.SHOP, RoomType.TREASURE, RoomType.CAMPUS, RoomType.BOSS:
				base_color = ROOM_COLORS.get(room_type)
			RoomType.CORRIDOR:
				base_color = ROOM_COLORS.get(room_type)
			_:
				base_color = ROOM_COLORS.get(room_type)

		var base_pos = Vector2(cell_pos.x * cell_size, cell_pos.y * cell_size)
		var center = base_pos + Vector2(cell_size / 2, cell_size / 2)

		var rect = ColorRect.new()
		rect.color = base_color
		rect.size = Vector2(cell_size, cell_size)
		rect.position = base_pos
		add_child(rect)
		

		if room_type == RoomType.CORRIDOR:
			for dir in room_data.connections:
				var thickness = 20
				var length = cell_size / 2
				var segments = 5

				var is_vertical = dir == Vector2i.UP or dir == Vector2i.DOWN

				if is_vertical:
					var segment_length = length / float(segments * 2 - 1)
					for i in range(segments):
						var segment = ColorRect.new()
						segment.color = Color(1, 1, 1, 0.5)
						segment.size = Vector2(thickness, segment_length)
						var y_offset = -length + i * segment_length * 2 if dir == Vector2i.UP else i * segment_length * 2
						segment.position = center + Vector2(-thickness / 2, y_offset)
						add_child(segment)
				else:
					var line = ColorRect.new()
					line.color = Color.WHITE
					match dir:
						Vector2i.LEFT:
							line.size = Vector2(length, thickness)
							line.position = center + Vector2(-length, -thickness / 2)
						Vector2i.RIGHT:
							line.size = Vector2(length, thickness)
							line.position = center + Vector2(0, -thickness / 2)
					add_child(line)
		else:
			var label = Label.new()
			label.text = WorldManagerGlobal.world_generator.get_room_type_name(room_type)
			label.size = Vector2(cell_size, cell_size)
			label.position = base_pos
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			label.add_theme_color_override("font_color", Color.BLACK)
			label.scale = Vector2(0.8, 0.8)
			add_child(label)
			
			var border = ColorRect.new()
			border.color = BORDER_COLOR_BOSS if room_type == RoomType.BOSS else BORDER_COLOR_DEFAULT
			border.size = Vector2(cell_size + 8, cell_size + 8)
			border.position = base_pos - Vector2(4, 4)
			add_child(border)
		
		var center_marker = ColorRect.new()
		center_marker.color = Color("#121212ea")
		center_marker.size = Vector2(cell_size * 0.5, cell_size * 0.5)
		center_marker.position = center - center_marker.size / 2
		add_child(center_marker)
