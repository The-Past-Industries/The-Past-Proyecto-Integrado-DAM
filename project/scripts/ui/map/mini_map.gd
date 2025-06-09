extends Panel

@onready var map_visualizer = $MapVisualizer

func _ready() -> void:
	await get_tree().process_frame  # Espera un frame para asegurar que el size esté bien
	refresh()

func _process(_delta: float) -> void:
	_center_map()

func refresh() -> void:
	map_visualizer._refresh_map()
	_center_map()

func _center_map() -> void:
	if WorldManagerGlobal == null or map_visualizer == null:
		return

	var cell_size = map_visualizer.cell_size
	var player_pos = WorldManagerGlobal.cur_position
	var panel_center = size / 2

	var player_cell_center = Vector2(player_pos.x + 0.5, player_pos.y + 0.5) * cell_size

	map_visualizer.position = panel_center - player_cell_center
