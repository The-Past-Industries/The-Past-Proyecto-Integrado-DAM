extends Node

var item_repository: ItemRepository
var world_generator: WorldGenerator


# Ready
func _ready():
	# load_item_repository()
	# show_items()
	# load_path_level()
	pass
	
func input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		_move_input(Vector2i.UP)
	elif event.is_action_pressed("ui_down"):
		_move_input(Vector2i.DOWN)
	elif event.is_action_pressed("ui_left"):
		_move_input(Vector2i.LEFT)
	elif event.is_action_pressed("ui_right"):
		_move_input(Vector2i.RIGHT)

func _move_input(direction: Vector2i) -> void:
	WorldManagerGlobal.move_to_cell(direction)


# World generation
func load_path_level():
	world_generator = WorldGenerator.new()
	#world_generator.generate_level(1, 0)

# Load items
func load_item_repository():
	Logger.info("Repository cargado")
	item_repository = ItemRepository.new()

# Show items
func show_items():
	Logger.info("Mostrando items")
	var item_list = item_repository.get_item_list()
	if item_list == null:
		Logger.warning("Item_list es null")
	else:
		Logger.info("Item_list no es null")
		for item in item_list:
			if item is ItemActive:
				Logger.info("Es un item activo: %s" % item)
			elif item is ItemPassive:
				Logger.info("Es un item pasivo: %s" % item)
			elif item is ItemMultieffect:
				Logger.info("Es un item multiefecto: %s" % item)
			else:
				Logger.warning("Tipo de item desconocido")
