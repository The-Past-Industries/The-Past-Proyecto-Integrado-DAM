extends Node

var item_repository: ItemRepository

# Ready
func _ready():
	load_item_repository()
	show_items()

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
