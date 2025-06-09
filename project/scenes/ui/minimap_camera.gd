extends Camera2D

var player_position = WorldManagerGlobal.cur_position

@onready var map_visualizer = $MapVisualizer

func _ready() -> void:
	pass
	# await get_tree().process_frame
	# refresh()

func _process(_delta: float) -> void:
	position = Vector2(player_position) + Vector2(0.5,0.5)
	

func refresh() -> void:
	map_visualizer._refresh_map(WorldManagerGlobal.world_generator.map_data)
