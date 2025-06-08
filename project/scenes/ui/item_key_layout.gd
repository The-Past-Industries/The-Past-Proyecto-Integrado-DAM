extends PanelContainer

@onready var texture_rect = $TextureRect
@onready var label_empty_container = $CenterContainer

func hide_item():
	texture_rect.visible = false
	label_empty_container.visible = true

func show_item():
	texture_rect.visible = true
	label_empty_container.visible = false

func set_item(texture: Texture2D):
	texture_rect.texture = texture
