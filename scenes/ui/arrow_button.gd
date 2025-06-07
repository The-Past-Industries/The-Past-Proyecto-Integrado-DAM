extends Button

@export var is_right: bool = false

var normal_style := preload("res://scenes/ui/menu_textures/arrow_button_normal.tres")
var focus_style := preload("res://scenes/ui/menu_textures/arrow_button_focus.tres")

func _ready():
	focus_mode = Control.FOCUS_NONE

func _unhandled_input(event: InputEvent) -> void:
	if is_right and event.is_action_pressed("arrow_right"):
		simulate_press_visual()
		emit_signal("pressed")
	elif not is_right and event.is_action_pressed("arrow_left"):
		simulate_press_visual()
		emit_signal("pressed")

func simulate_press_visual() -> void:
	add_theme_stylebox_override("normal", focus_style)
	await get_tree().create_timer(0.1).timeout  # Espera 0.1 segundos
	add_theme_stylebox_override("normal", normal_style)
