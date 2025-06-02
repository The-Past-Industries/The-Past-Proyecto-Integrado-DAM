extends CanvasLayer
class_name MapUI

@onready var map_visualizer: MapVisualizer = $SubViewport/MapVisualizer
@onready var texture_rect: TextureRect = $TextureRect
@onready var viewport: SubViewport = $SubViewport

# Singleton instance
static var _instance: MapUI = null

func _ready():
#	texture_rect.texture = viewport.get_texture()
	_instance = self

static func get_instance() -> MapUI:
	return _instance

func get_map_visualizer() -> MapVisualizer:
	return map_visualizer
