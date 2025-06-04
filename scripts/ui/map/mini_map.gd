extends Node

@onready var map_visualizer_2d = $MapVisualizer2D

# En el script del Minimap o el Panel
func _process(_delta: float) -> void:
	var cell_size = map_visualizer_2d.CELL_SIZE
	var player_pos = WorldManagerGlobal.cur_position
	
	# Tamaño del panel (visualmente)
	var panel_size = self.get_parent().size
	
	# Offset para centrar la vista en la posición actual del jugador
	var offset = Vector2(player_pos.x, player_pos.y) * -cell_size
	offset += panel_size / 2
	
	map_visualizer_2d.position = offset
