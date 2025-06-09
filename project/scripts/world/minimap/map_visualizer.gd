extends Node2D
class_name MapVisualizer

const BOSS = preload("res://assets/ui/map_icons/boss.png")
const CAMPUS = preload("res://assets/ui/map_icons/campus.png")
const HOME = preload("res://assets/ui/map_icons/home.png")
const SHOP = preload("res://assets/ui/map_icons/shop.png")
const TREASURE = preload("res://assets/ui/map_icons/treasure.png")
const PLAYER = preload("res://assets/ui/map_icons/player.png")
const STAR = preload("res://assets/ui/map_icons/star.png")
const UNSEEN = preload("res://assets/ui/map_icons/unseen.png")

@export var cell_size: int = 100

const COLOR_SEEN := Color("#808898")
const COLOR_UNSEEN := Color("#40444c")
const BORDER_COLOR_DEFAULT := Color("#f3f3f373")
const BORDER_COLOR_BOSS := Color("#80000073")

const ROOM_COLORS := {
	RoomType.INITIAL: Color("#8b8b8b"),
	RoomType.COMMON: Color("#575757"),
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
	_refresh_map()
	set_process(true)

func _process(_delta: float) -> void:
	_refresh_map()



func _refresh_map() -> void:
	for child in get_children():
		child.queue_free()

	for cell_pos in WorldManagerGlobal.world_generator.map_data.keys():
		var room_data: RoomData = WorldManagerGlobal.world_generator.map_data[cell_pos]
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

		var marker = ColorRect.new()
		marker.color = Color("#121212ea")
		marker.size = Vector2(cell_size * 0.6, cell_size * 0.6)
		marker.position = center - marker.size / 2
		add_child(marker)

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
			var border = ColorRect.new()
			border.color = BORDER_COLOR_BOSS if room_type == RoomType.BOSS else BORDER_COLOR_DEFAULT
			border.size = Vector2(cell_size + 8, cell_size + 8)
			border.position = base_pos - Vector2(4, 4)
			add_child(border)

		var icon
		if room_type == RoomType.COMMON:
			if not room_data.shown:
				icon = UNSEEN
			elif room_data.has_loot:
				icon = STAR
		else:
			match room_type:
				RoomType.BOSS:
					icon = BOSS
				RoomType.CAMPUS:
					icon = CAMPUS
				RoomType.SHOP:
					icon = SHOP
				RoomType.TREASURE:
					icon = TREASURE
				RoomType.INITIAL:
					icon = HOME

		if icon != null:
			var icon_node = TextureRect.new()
			icon_node.texture = icon
			icon_node.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			var icon_size := cell_size * 0.01
			icon_node.size = Vector2(icon_size, icon_size)
			icon_node.scale = Vector2(0.15, 0.15)
			icon_node.position = center - (icon_node.size * icon_node.scale) / 2
			add_child(icon_node)
