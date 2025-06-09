extends Node2D

@onready var map_visualizer = $MapVisualizer

func _ready() -> void:
	await get_tree().process_frame
	refresh()

func refresh() -> void:
	map_visualizer._refresh_map(WorldManagerGlobal.world_generator.map_data)
